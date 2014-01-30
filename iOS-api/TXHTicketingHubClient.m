//
//  TXHTicketingHubClient.m
//  iOS-api
//
//  Created by Abizer Nasir on 23/10/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

// Base URLs and endpoints.
static NSString * const kAPIBaseURL = @"https://api.ticketinghub.com/";
static NSString * const kSuppliersEndPoint = @"suppliers";
static NSString * const kUserEndPoint = @"user";
static NSString * const kVenuesEndpoint = @"venues";

#import "TXHTicketingHubClient.h"
#import <DCTCoreDataStack/DCTCoreDataStack.h>

#import "AFNetworkActivityIndicatorManager.h"
#import "AFNetworking.h"
#import "TXHAPIError.h"
#import "TXHAvailability.h"
#import "TXHProduct.h"
#import "TXHSupplier.h"
#import "TXHUser.h"

@interface TXHTicketingHubClient ()

@property (strong, nonatomic) DCTCoreDataStack *coreDataStack;
@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@property (strong, nonatomic) NSManagedObjectContext *importContext;

@end

@implementation TXHTicketingHubClient

#pragma mark - Set up and tear down

- (id)initWithStoreURL:(NSURL *)storeURL {
    if (!(self = [super init])) {
        return nil; // Bail!
    }

    NSString *storeType;
    if (storeURL) {
        storeType = NSSQLiteStoreType;
    } else {
        storeType = NSInMemoryStoreType;
    }

    NSDictionary *options = @{DCTCoreDataStackExcludeFromBackupStoreOption : @YES,
                              NSMigratePersistentStoresAutomaticallyOption : @YES,
                              NSInferMappingModelAutomaticallyOption : @YES};

    _coreDataStack = [[DCTCoreDataStack alloc] initWithStoreURL:storeURL storeType:storeType storeOptions:options modelConfiguration:nil modelURL:[[self class] coreDataModelURL]];

    _sessionManager = [[self class] configuredSessionManager];

    return self;
}

- (id)init {
    return [self initWithStoreURL:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:_importContext];
}

#pragma mark - Public

- (void)setDefaultAcceptLanguage:(NSString *)identifier {
    [self.sessionManager.requestSerializer setValue:identifier forHTTPHeaderField:@"Accept-Language"];
}

- (void)fetchSuppliersForUsername:(NSString *)username password:(NSString *)password withCompletion:(void (^)(NSArray *, NSError *))completion {
    NSParameterAssert(username);
    NSParameterAssert(password);
    NSParameterAssert(completion);

    if (!username || !password || !completion) {
        return;
    }

    [self.sessionManager.requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];
    [self.sessionManager GET:kSuppliersEndPoint parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        // No need to check for empty response as you can't have a user without any suppliers
        NSArray *suppliers = [self suppliersFromResponseArray:responseObject inManagedObjectContext:self.importContext];

        // Create a TXHUser object with the email address and add it to the suppliers we are still in the import context
        TXHUser *user = [TXHUser updateWithDictionaryCreateIfNeeded:@{@"email" : username} inManagedObjectContext:self.importContext];
        user.suppliers = [NSSet setWithArray:suppliers];

        NSError *error;
        BOOL success = [self.importContext save:&error];

        if (!success) {
            completion(nil, error);
            return;
        }

        [self updateUser:user completion:^(TXHUser *user, NSError *error) {
            if (error) {
                NSLog(@"Unable to update the user because: %@", error);
            }
        }]; 

        completion([self objectsInMainManagedObjectContext:suppliers], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Unable to get suppliers because: %@", error);
        completion(nil, error);
    }];
}

- (void)updateUser:(TXHUser *)user completion:(void (^)(TXHUser *, NSError *))completion {
    NSParameterAssert(user);
    NSParameterAssert(completion);
    
    TXHSupplier *anySupplier = [user.suppliers anyObject];
    TXHUser *updatedUser = (TXHUser *)[self.importContext existingObjectWithID:user.objectID error:NULL];

    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@", anySupplier.accessToken];
    [self.sessionManager.requestSerializer setAuthorizationHeaderFieldWithToken:tokenString];
    [self.sessionManager GET:kUserEndPoint parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [updatedUser updateWithDictionary:responseObject];

        NSError *error;
        BOOL success = [self.importContext save:&error];

        if (!success) {
            completion(nil, error);
            return;
        }

        completion([[self objectsInMainManagedObjectContext:@[updatedUser]] firstObject], nil);

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Unable to get the user because: %@", error);
        completion(nil, error);
    }];
}

- (void)availabilitiesForProduct:(TXHProduct *)product from:(NSString *)from to:(NSString *)to completion:(void (^)(NSArray *, NSError *))completion {
    NSParameterAssert(product);
    NSParameterAssert(completion);

    NSManagedObjectContext *moc = self.importContext;

    TXHProduct *localProduct = (TXHProduct *)[moc existingObjectWithID:product.objectID error:NULL];

    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@", localProduct.supplier.accessToken];
    [self.sessionManager.requestSerializer setAuthorizationHeaderFieldWithToken:tokenString];

    NSDictionary *params;

    if (!from && !to) {
        params = nil;
    } else if (from) {
        params = @{@"date": from};
    } else if (to) {
        params = @{@"to": to};
    } else {
        params = @{@"from": from,
                   @"to": to};
    }

    NSString *endpoint = [NSString stringWithFormat:@"products/%@/availability", localProduct.productId];

    [self.sessionManager GET:endpoint parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // For a single date this is an array of dictionaries, each dictionary being an availability with tiers
        // For a range of dates, this is a dictionary of key values where key is the date and the value is an array of simple availabilities.
        // If the array is empty, there is no availability for that date.

        NSArray *availabilities; // This is the list of updated availabilities.

        if ([responseObject isKindOfClass:[NSArray class]]) {
            availabilities = [self updateAvailabilitiesForDate:from fromArray:responseObject inProductID:product.objectID];
        } else {
            availabilities = [self updateAvailabilitiesFromDictionary:responseObject inProductID:product.objectID];
        }

        NSError *error;
        BOOL success = [moc save:&error];

        if (!success) {
            completion(nil, error);
            return;
        }

        completion([self objectsInMainManagedObjectContext:availabilities], nil);

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Unable to get the user because: %@", error);
        completion(nil, error);
    }];

    
}

#pragma mark - Custom accessors


- (NSManagedObjectContext *)managedObjectContext {
    return self.coreDataStack.managedObjectContext;
}

- (void)setShowNetworkActivityIndicatorAutomatically:(BOOL)showNetworkActivityIndicatorAutomatically {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = showNetworkActivityIndicatorAutomatically;
}

- (NSManagedObjectContext *)importContext {
    if (!_importContext) {
        _importContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_importContext setPersistentStoreCoordinator:[self.managedObjectContext persistentStoreCoordinator]];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:_importContext];
    }

    return _importContext;
}

#pragma mark - Notification handlers

- (void)managedObjectContextDidSave:(NSNotification *)notification {
    [self.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
};

#pragma mark - Private methods

+ (AFHTTPSessionManager *)configuredSessionManager {
    NSURL *baseURL = [NSURL URLWithString:kAPIBaseURL];
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [sessionManager.requestSerializer setValue:[[NSLocale preferredLanguages] firstObject] forHTTPHeaderField:@"Accept-Language"];

    return sessionManager;
}

+ (NSURL *)coreDataModelURL {
    NSBundle *bundle;
    NSString *bundleName = @"iOS-api-Model.bundle";
    NSDirectoryEnumerator *enumerator = [[NSFileManager new] enumeratorAtURL:[[NSBundle bundleForClass:[self class]] bundleURL] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:nil];

    for (NSURL *url in enumerator) {
        if ([[url lastPathComponent] isEqualToString:bundleName]) {
            bundle = [NSBundle bundleWithURL:url];
        }
    }

    return [bundle URLForResource:@"CoreDataModel" withExtension:@"momd"];
}

- (NSArray *)suppliersFromResponseArray:(NSArray *)responseArray inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSMutableArray *suppliers = [NSMutableArray arrayWithCapacity:[responseArray count]];
    for (NSDictionary *supplierDictionary in responseArray) {
        TXHSupplier *supplier = [TXHSupplier createWithDictionary:supplierDictionary inManagedObjectContext:managedObjectContext];
        [suppliers addObject:supplier];
    }

    return [suppliers copy];
}

// Update the availabilities when the API returns an array
- (NSArray *)updateAvailabilitiesForDate:(NSString *)date fromArray:(NSArray *)array inProductID:(TXHProductID *)productId {
    NSUInteger numberOfAvailabilities = [array count];

    // If the array is empty, there are not availibilities, so delete any stored values for this date and return an empty array
    if (!numberOfAvailabilities) {
        [TXHAvailability deleteForDateIfExists:date productId:productId fromManagedObjectContext:self.importContext];
        return @[];
    }

    NSMutableArray *availabilities = [[NSMutableArray alloc] initWithCapacity:numberOfAvailabilities];

    for (NSDictionary *dict in array) {
        TXHAvailability *availability = [TXHAvailability updateForDateCreateIfNeeded:date withDictionary:dict productId:productId inManagedObjectContext:self.importContext];
        [availabilities addObject:availability];
    }

    return availabilities;
}

// Update the availabilities when the API returns a dictionary
- (NSArray *)updateAvailabilitiesFromDictionary:(NSDictionary *)dictionary inProductID:(TXHProductID *)productId {
    NSMutableArray *availabilities = [[NSMutableArray alloc] initWithCapacity:[dictionary count]];

    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *date = key;
        if ([obj count]) {
            for (NSDictionary *dict in obj) {
                TXHAvailability *availability = [TXHAvailability updateForDateCreateIfNeeded:date withDictionary:dict productId:productId inManagedObjectContext:self.importContext];
                [availabilities addObject:availability];
            }
        } else {
            [TXHAvailability deleteForDateIfExists:date productId:productId fromManagedObjectContext:self.importContext];
        }
    }];

    return availabilities;

}

- (NSArray *)objectsInMainManagedObjectContext:(NSArray *)managedObjects {
    if (![managedObjects count]) {
        return @[];
    }
    
    NSMutableArray *mainContextObjects = [NSMutableArray arrayWithCapacity:[managedObjects count]];
    NSArray *objectIDs = [managedObjects valueForKey:@"objectID"];

    for (NSManagedObjectID *objectID in objectIDs) {
        NSManagedObject *object = [self.managedObjectContext existingObjectWithID:objectID error:NULL];
        [mainContextObjects addObject:object];
    }

    return [mainContextObjects copy];
};

@end
