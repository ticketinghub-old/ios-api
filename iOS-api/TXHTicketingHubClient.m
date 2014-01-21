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
    NSAssert(username, @"username parameter cannot be nil");
    NSAssert(password, @"password parameter cannot be nil");
    NSAssert(completion, @"completion handler cannot be nil");

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
    NSAssert(user, @"user cannot be nil");
    NSAssert(completion, @"completion handler cannot be nil");

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

- (NSArray *)objectsInMainManagedObjectContext:(NSArray *)managedObjects {
    NSMutableArray *mainContextObjects = [NSMutableArray arrayWithCapacity:[managedObjects count]];
    NSArray *objectIDs = [managedObjects valueForKey:@"objectID"];

    for (NSManagedObjectID *objectID in objectIDs) {
        NSManagedObject *object = [self.managedObjectContext existingObjectWithID:objectID error:NULL];
        [mainContextObjects addObject:object];
    }

    return [mainContextObjects copy];
};

@end
