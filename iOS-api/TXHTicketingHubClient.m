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
#import "JSONResponseSerializerWithData.h"

#import "TXHAPIError.h"
#import "TXHAvailability.h"
#import "TXHProduct.h"
#import "TXHSupplier.h"
#import "TXHUser.h"
#import "TXHTier.h"
#import "TXHOrder.h"
#import "TXHTicket.h"
#import "TXHUpgrade.h"
#import "TXHField.h"

#import "NSDate+ISO.h"

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

- (void)tiersForProduct:(TXHProduct *)product completion:(void(^)(NSArray *availabilities, NSError *error))completion
{
    NSParameterAssert(product);
    NSParameterAssert(completion);
    
    NSManagedObjectContext *moc = self.importContext;
    
    TXHProduct *localProduct = (TXHProduct *)[moc existingObjectWithID:product.objectID error:NULL];
    
    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@", localProduct.supplier.accessToken];
    [self.sessionManager.requestSerializer setAuthorizationHeaderFieldWithToken:tokenString];

    NSString *endpoint = [NSString stringWithFormat:@"products/%@/tiers", localProduct.productId];
    
    [self.sessionManager GET:endpoint parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *tiers;
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            tiers = [self updateTiersFromArray:responseObject inProductID:product.objectID];
        } else {
            tiers = [self updateTiresFromDictionary:responseObject inProductID:product.objectID];
        }
        
        NSError *error;
        BOOL success = [moc save:&error];
        
        if (!success) {
            completion(nil, error);
            return;
        }
        
        completion([self objectsInMainManagedObjectContext:tiers], nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Unable to get the user because: %@", error);
        completion(nil, error);
    }];
    

}

- (void)availabilitiesForProduct:(TXHProduct *)product fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate completion:(void(^)(NSArray *availabilities, NSError *error))completion
{
    NSParameterAssert(product);
    NSParameterAssert(completion);

    NSManagedObjectContext *moc = self.importContext;

    TXHProduct *localProduct = (TXHProduct *)[moc existingObjectWithID:product.objectID error:NULL];

    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@", localProduct.supplier.accessToken];
    [self.sessionManager.requestSerializer setAuthorizationHeaderFieldWithToken:tokenString];

    NSDictionary *params;

    if (!fromDate && !toDate) {
        params = nil;
    } else if (fromDate && !toDate) {
        params = @{@"date": [fromDate isoDateString]};
    } else if (toDate && !fromDate) {
        params = @{@"to": [toDate isoDateString]};
    } else {
        params = @{@"from": [fromDate isoDateString],
                   @"to": [toDate isoDateString]};
    }

    NSString *endpoint = [NSString stringWithFormat:@"products/%@/availability", localProduct.productId];

    [self.sessionManager GET:endpoint parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // For a single date this is an array of dictionaries, each dictionary being an availability with tiers
        // For a range of dates, this is a dictionary of key values where key is the date and the value is an array of simple availabilities.
        // If the array is empty, there is no availability for that date.

        NSArray *availabilities; // This is the list of updated availabilities.

        if ([responseObject isKindOfClass:[NSArray class]]) {
            availabilities = [self updateAvailabilitiesForDate:fromDate fromArray:responseObject inProductID:product.objectID];
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
    sessionManager.responseSerializer = [JSONResponseSerializerWithData serializer];
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

#pragma mark - updating availabilities (extract)

// Update the availabilities when the API returns an array
- (NSArray *)updateAvailabilitiesForDate:(NSDate *)date fromArray:(NSArray *)array inProductID:(TXHProductID *)productId {
    NSUInteger numberOfAvailabilities = [array count];

    // If the array is empty, there are not availibilities, so delete any stored values for this date and return an empty array
    if (!numberOfAvailabilities) {
        [TXHAvailability deleteForDateIfExists:[date isoDateString] productId:productId fromManagedObjectContext:self.importContext];
        return @[];
    }

    NSMutableArray *availabilities = [[NSMutableArray alloc] initWithCapacity:numberOfAvailabilities];

    for (NSDictionary *dict in array) {
        TXHAvailability *availability = [TXHAvailability updateForDateCreateIfNeeded:[date isoDateString] withDictionary:dict productId:productId inManagedObjectContext:self.importContext];
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

#pragma mark - updating tiers (extract)

// Update the availabilities when the API returns an array
- (NSArray *)updateTiersFromArray:(NSArray *)array inProductID:(TXHProductID *)productId {
    NSUInteger numberOfTiers = [array count];
    
    // If the array is empty, there are not availibilities, so delete any stored values for this date and return an empty array
    if (!numberOfTiers) {
        [TXHTier deleteTiersForProductId:productId fromManagedObjectContext:self.importContext];
        return @[];
    }
    
    NSMutableArray *tiers = [[NSMutableArray alloc] initWithCapacity:numberOfTiers];
    
    for (NSDictionary *dict in array) {
        TXHTier *tier = [TXHTier updateWithDictionaryCreateIfNeeded:dict inManagedObjectContext:self.importContext];
        [tiers addObject:tier];
    }
    
    return tiers;
}

// Update the availabilities when the API returns a dictionary
- (NSArray *)updateTiresFromDictionary:(NSDictionary *)dictionary inProductID:(TXHProductID *)productId {
    NSMutableArray *tiers = [[NSMutableArray alloc] initWithCapacity:[dictionary count]];
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *date = key;
        if ([obj count]) {
            for (NSDictionary *dict in obj) {
                TXHTier *tier = [TXHTier updateWithDictionaryCreateIfNeeded:dict inManagedObjectContext:self.importContext];
                [tiers addObject:tier];
            }
        } else {
            [TXHAvailability deleteForDateIfExists:date productId:productId fromManagedObjectContext:self.importContext];
        }
    }];
    
    return tiers;
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

- (TXHUser *)currentUser
{
    NSFetchRequest *userRequest = [NSFetchRequest fetchRequestWithEntityName:[TXHUser entityName]];
    
    NSError *error;
    NSArray *users = [self.managedObjectContext executeFetchRequest:userRequest error:&error];
    
    if (!users) {
        NSLog(@"Unable to fetch users because: %@", error);
    }
    
    return [users firstObject];
}

- (void)reserveTicketsWithTierQuantities:(NSDictionary *)tierQuantities availability:(TXHAvailability *)availability completion:(void(^)(TXHOrder *order, NSError *error))completion;
{
    NSParameterAssert(tierQuantities);
    NSParameterAssert(completion);
    
    if (![tierQuantities count]) {
        // TODO: make beter errors
        completion(nil, [NSError errorWithDomain:@"" code:1 userInfo:nil]);
        return;
    }
    
    NSMutableArray *tickets = [NSMutableArray array];
    
    for (NSString *internalTierId in tierQuantities)
    {
        TXHTier *tier = [TXHTier tierWithInternalID:internalTierId inManagedObjectContext:self.importContext];

        if (!tier)
            continue;
        
        NSMutableDictionary *ticketInfo = [NSMutableDictionary new];
        
        ticketInfo[@"tier"]     = tier.tierId;
        ticketInfo[@"date"]     = availability.dateString;
        ticketInfo[@"time"]     = availability.timeString;
        ticketInfo[@"product"]  = availability.product.productId;
        ticketInfo[@"quantity"] = tierQuantities[internalTierId];

        [tickets addObject:ticketInfo];
    }
    
    NSDictionary *requestPayload = @{@"tickets" : tickets};
    
    NSManagedObjectContext *moc = self.importContext;
    
//    TXHProduct *localProduct = (TXHProduct *)[moc existingObjectWithID:availability.product.objectID error:NULL];
//    
//    NSString *tokenString = [NSString stringWithFormat:@"Bearer %@", localProduct.supplier.accessToken];
//    [self.sessionManager.requestSerializer setAuthorizationHeaderFieldWithToken:tokenString];
    
    NSString *endpoint = @"orders";
    
    [self.sessionManager POST:endpoint
                   parameters:requestPayload
                      success:^(NSURLSessionDataTask *task, id responseObject) {
                      
                          TXHOrder *order = [TXHOrder updateWithDictionaryOrCreateIfNeeded:responseObject inManagedObjectContext:moc];
                          
                          NSError *error;
                          BOOL success = [moc save:&error];
                          
                          if (!success) {
                              completion(nil, error);
                              return;
                          }
                          
                          completion(order, nil);
                          
                      }
                      failure:^(NSURLSessionDataTask *task, NSError *error) {
                      
                          NSLog(@"Unable to reserve tickets because: %@", error);
                          completion(nil, error);
                      }];
}

- (void)removeTickets:(NSArray *)ticketIDs fromOrder:(TXHOrder *)order completion:(void(^)(TXHOrder *order, NSError *error))completion
{
    NSParameterAssert(ticketIDs);
    NSParameterAssert(order);
    NSParameterAssert(completion);
    
    if (![ticketIDs count]) {
        // TODO: make beter errors
        completion(order, [NSError errorWithDomain:@"" code:1 userInfo:nil]);
        return;
    }
    
    NSMutableArray *tickets = [NSMutableArray array];
    
    for (NSString *ticketID in ticketIDs)
    {
        [tickets addObject:@{@"id" : ticketID,
                             @"_destory" : @(YES)}];
    }
    
    NSDictionary *requestPayload = @{@"tickets" : tickets};
    
    [self PATHOrder:order withInfor:requestPayload completion:completion];
}

- (void)upgradesForTicket:(TXHTicket *)ticket completion:(void(^)(NSArray *upgrades, NSError *error))completion
{
    NSParameterAssert(ticket);
    NSParameterAssert(completion);

    NSString *endpoint = [NSString stringWithFormat:@"tickets/%@/upgrades", ticket.ticketId];
    NSManagedObjectContext *moc = self.importContext;

    [self.sessionManager GET:endpoint parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSMutableArray *upgrades = [NSMutableArray array];
        
        if (![responseObject isKindOfClass:[NSArray class]])
        {
            completion(nil, [NSError errorWithDomain:@"" code:1 userInfo:nil]);
            return;
        }
            
        for (NSDictionary *dic in responseObject) {
            TXHUpgrade *upgrade = [TXHUpgrade createWithDictionary:dic inManagedObjectContext:moc];
            [upgrades addObject:upgrade];
        }
        
        NSError *error;
        BOOL success = [moc save:&error];
        
        if (!success) {
            completion(nil, error);
            return;
        }
        
        NSArray *upgradeArray = [self objectsInMainManagedObjectContext:upgrades];
        completion(upgradeArray,nil);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Unable to get the user because: %@", error);
        completion(nil, error);
    }];
}

- (void)fieldsForTicket:(TXHTicket *)ticket completion:(void(^)(NSArray *fields, NSError *error))completion
{
    NSParameterAssert(ticket);
    NSParameterAssert(completion);
    
    NSString *endpoint = [NSString stringWithFormat:@"tickets/%@/fields", ticket.ticketId];
    
    [self.sessionManager GET:endpoint parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (![responseObject isKindOfClass:[NSArray class]])
        {
            completion(nil, [NSError errorWithDomain:@"" code:1 userInfo:nil]);
            return;
        }
        
        NSMutableArray *fields = [NSMutableArray array];
        
        for (NSDictionary *fieldDic in responseObject)
        {
            TXHField *field = [[TXHField alloc] initWithDictionary:fieldDic];
            if (field)
                [fields addObject:field];
        }
        
        completion(fields,nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Unable to get the user because: %@", error);
        completion(nil, error);
    }];
}

- (void)updateOrder:(TXHOrder *)order withUpgradesInfo:(NSDictionary *)upgradesInfo completion:(void(^)(TXHOrder *order, NSError *error))completion
{
    NSParameterAssert(order);
    NSParameterAssert(upgradesInfo);
    NSParameterAssert(completion);

    if (![upgradesInfo count])
    {
        completion(order, nil);
        return;
    }
    
    NSMutableArray *tickets = [NSMutableArray array];
    
    for (NSString *ticketId in upgradesInfo) {
        NSDictionary *dic = @{ @"id"       : ticketId,
                               @"upgrades" : upgradesInfo[ticketId]};
        [tickets addObject:dic];
    }
    
    NSDictionary *requestPayload = @{@"tickets" : tickets};
    
    [self PATHOrder:order withInfor:requestPayload completion:completion];

}

- (void)updateOrder:(TXHOrder *)order withCustomersInfo:(NSDictionary *)customersInfo completion:(void (^)(TXHOrder *, NSError *))completion
{
    NSParameterAssert(order);
    NSParameterAssert(customersInfo);
    NSParameterAssert(completion);
    
    if (![customersInfo count])
    {
        completion(order, [NSError errorWithDomain:@"" code:1 userInfo:nil]);
        return;
    }
    
    NSMutableArray *tickets = [NSMutableArray array];
    
    for (NSString *ticketId in customersInfo) {
        NSDictionary *dic = @{ @"id"       : ticketId,
                               @"customer" : customersInfo[ticketId]};
        [tickets addObject:dic];
    }
    
    NSDictionary *requestPayload = @{@"tickets" : tickets};
    
    [self PATHOrder:order withInfor:requestPayload completion:completion];
}

- (void)PATHOrder:(TXHOrder *)order withInfor:(NSDictionary *)payload completion:(void (^)(TXHOrder *, NSError *))completion
{
    NSString *endpoint = [NSString stringWithFormat:@"orders/%@", order.orderId];
    
    NSManagedObjectContext *moc = self.importContext;
    
    [self.sessionManager PATCH:endpoint
                    parameters:payload
                       success:^(NSURLSessionDataTask *task, id responseObject) {
                           TXHOrder *order = [TXHOrder updateWithDictionaryOrCreateIfNeeded:responseObject inManagedObjectContext:moc];
                           
                           NSError *error;
                           BOOL success = [moc save:&error];
                           
                           if (!success) {
                               completion(nil, error);
                               return;
                           }
                           
                           completion(order, nil);
                       }
                       failure:^(NSURLSessionDataTask *task, NSError *error) {
                           NSDictionary *dic =  error.userInfo[JSONResponseSerializerWithDataKey];
                           TXHOrder *order;
                           if (dic)
                               order = [TXHOrder updateWithDictionaryOrCreateIfNeeded:dic inManagedObjectContext:moc];
                           completion(order, error);
                       }];
}

@end
