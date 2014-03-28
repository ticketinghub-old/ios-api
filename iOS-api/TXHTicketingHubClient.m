//
//  TXHTicketingHubClient.m
//  iOS-api
//
//  Created by Abizer Nasir on 23/10/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

// Base URLs and endpoints.
static NSString * const kAPIBaseURL        = @"https://api.ticketinghub.com/";
static NSString * const kSuppliersEndPoint = @"suppliers";
static NSString * const kUserEndPoint      = @"user";
static NSString * const kVenuesEndpoint    = @"venues";

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
#import "TXHTicketTemplate.h"
#import "TXHUpgrade.h"
#import "TXHField.h"


#import "NSDate+ISO.h"
#import "TXHDefines.h"

@interface TXHTicketingHubClient ()

@property (strong, nonatomic) DCTCoreDataStack *coreDataStack;
@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@property (strong, nonatomic) NSManagedObjectContext *importContext;

@end

@implementation TXHTicketingHubClient

#pragma mark - Set up and tear down

- (id)initWithStoreURL:(NSURL *)storeURL
{
    if (!(self = [super init]))
        return nil; // Bail!

    [self setupCoreDataStackWithStoreURL:storeURL];

    _sessionManager = [[self class] configuredSessionManager];

    return self;
}

- (id)init
{
    return [self initWithStoreURL:nil];
}

- (void)dealloc
{
    [self unregisterForImportContextDidSaveNotifications];
}

- (void)setupCoreDataStackWithStoreURL:(NSURL *)storeURL
{
    NSString *storeType = (storeURL == nil) ? NSInMemoryStoreType : NSSQLiteStoreType;
   
    NSDictionary *options = @{DCTCoreDataStackExcludeFromBackupStoreOption : @YES,
                              NSMigratePersistentStoresAutomaticallyOption : @YES,
                              NSInferMappingModelAutomaticallyOption       : @YES};
    
    _coreDataStack = [[DCTCoreDataStack alloc] initWithStoreURL:storeURL storeType:storeType storeOptions:options modelConfiguration:nil modelURL:[[self class] coreDataModelURL]];
}



#pragma mark - Custom accessors

- (NSManagedObjectContext *)managedObjectContext
{
    return self.coreDataStack.managedObjectContext;
}

- (void)setShowNetworkActivityIndicatorAutomatically:(BOOL)showNetworkActivityIndicatorAutomatically
{
    [AFNetworkActivityIndicatorManager sharedManager].enabled = showNetworkActivityIndicatorAutomatically;
}

- (void)setDefaultAcceptLanguage:(NSString *)identifier
{
    [self.sessionManager.requestSerializer setValue:identifier forHTTPHeaderField:@"Accept-Language"];
}





#pragma mark - Notifications
#pragma mark   Import context

- (void)registerForImportContextDidSaveNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:_importContext];
}

- (void)unregisterForImportContextDidSaveNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:_importContext];
}

- (void)managedObjectContextDidSave:(NSNotification *)notification
{
    [self.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
}




#pragma mark - Private methods

+ (AFHTTPSessionManager *)configuredSessionManager
{
    NSURL *baseURL = [NSURL URLWithString:kAPIBaseURL];

    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    sessionManager.responseSerializer = [JSONResponseSerializerWithData serializer];
    sessionManager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    [sessionManager.requestSerializer setValue:[[NSLocale preferredLanguages] firstObject]
                            forHTTPHeaderField:@"Accept-Language"];
    
    return sessionManager;
}

+ (NSURL *)coreDataModelURL
{
    NSBundle *bundle;
    NSString *bundleName = @"iOS-api-Model.bundle";
    NSURL *bundleURL = [[NSBundle bundleForClass:[self class]] bundleURL];
    
    NSDirectoryEnumerator *enumerator = [[NSFileManager new] enumeratorAtURL:bundleURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:nil];
    
    for (NSURL *url in enumerator)
        if ([[url lastPathComponent] isEqualToString:bundleName])
            bundle = [NSBundle bundleWithURL:url];
    
    
    return [bundle URLForResource:@"CoreDataModel" withExtension:@"momd"];
}

- (NSManagedObjectContext *)importContext
{
    if (!_importContext)
    {
        _importContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_importContext setPersistentStoreCoordinator:[self.managedObjectContext persistentStoreCoordinator]];
        
        [self registerForImportContextDidSaveNotifications];
    }
    
    return _importContext;
}

- (TXHUser *)currentUser
{
    NSFetchRequest *userRequest = [NSFetchRequest fetchRequestWithEntityName:[TXHUser entityName]];
    
    NSError *error;
    NSArray *users = [self.managedObjectContext executeFetchRequest:userRequest error:&error];
    
    if (!users) {
        DLog(@"Unable to fetch users because: %@", error);
    }
    
    return [users firstObject];
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


#pragma mark - Public

#pragma mark - Suppliers, User, Products

- (void)fetchSuppliersForUsername:(NSString *)username password:(NSString *)password withCompletion:(void (^)(NSArray *, NSError *))completion
{
    NSParameterAssert(username);
    NSParameterAssert(password);
    NSParameterAssert(completion);

    [self.sessionManager.requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];
    
    [self.sessionManager GET:kSuppliersEndPoint parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *suppliers = [self suppliersFromResponseArray:responseObject inManagedObjectContext:self.importContext];
        
        TXHUser *user = [TXHUser updateWithDictionaryCreateIfNeeded:@{@"email" : username}
                                             inManagedObjectContext:self.importContext];
        user.suppliers = [NSSet setWithArray:suppliers];

        NSError *error;
        BOOL success = [self.importContext save:&error];

        if (!success)
        {
            completion(nil, error);
            return;
        }
        
        [self updateUser:user completion:^(TXHUser *user, NSError *error) {
            if (error) {
                DLog(@"Unable to update the user because: %@", error);
            }
        }];

        suppliers = [self objectsInMainManagedObjectContext:suppliers];
        completion(suppliers, nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"Unable to get suppliers because: %@", error);
        completion(nil, error);
    }];
}

- (NSArray *)suppliersFromResponseArray:(NSArray *)responseArray inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSMutableArray *suppliers = [NSMutableArray arrayWithCapacity:[responseArray count]];
    
    for (NSDictionary *supplierDictionary in responseArray)
    {
        TXHSupplier *supplier = [TXHSupplier createWithDictionary:supplierDictionary
                                           inManagedObjectContext:managedObjectContext];
        [suppliers addObject:supplier];
    }
    
    return [suppliers copy];
}


- (void)updateUser:(TXHUser *)user completion:(void (^)(TXHUser *, NSError *))completion
{
    NSParameterAssert(user);
    NSParameterAssert(completion);
    
    TXHSupplier *anySupplier = [user.suppliers anyObject];
    NSString *tokenString    = [NSString stringWithFormat:@"Bearer %@", anySupplier.accessToken];
    [self.sessionManager.requestSerializer setAuthorizationHeaderFieldWithToken:tokenString];
    
    [self.sessionManager GET:kUserEndPoint parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        TXHUser *updatedUser = (TXHUser *)[self.importContext existingObjectWithID:user.objectID error:NULL];
        [updatedUser updateWithDictionary:responseObject];

        NSError *error;
        BOOL success = [self.importContext save:&error];

        if (!success)
        {
            completion(nil, error);
            return;
        }

        completion([[self objectsInMainManagedObjectContext:@[updatedUser]] firstObject], nil);

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"Unable to get the user because: %@", error);
        completion(nil, error);
    }];
}



#pragma mark - Tiers

- (void)tiersForProduct:(TXHProduct *)product completion:(void(^)(NSArray *availabilities, NSError *error))completion
{
    NSParameterAssert(product);
    NSParameterAssert(completion);
    
    NSString *endpoint = [NSString stringWithFormat:@"products/%@/tiers", product.productId];
    
    [self.sessionManager GET:endpoint parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *tiers;
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            tiers = [self updateTiersFromArray:responseObject
                                   inProductID:product.objectID];
        } else {
            tiers = [self updateTiresFromDictionary:responseObject
                                        inProductID:product.objectID];
        }
        
        NSError *error;
        BOOL success = [self.importContext save:&error];
        
        if (!success) {
            completion(nil, error);
            return;
        }
        
        tiers = [self objectsInMainManagedObjectContext:tiers];
        
        completion(tiers, nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"Unable to get the user because: %@", error);
        completion(nil, error);
    }];
}

- (NSArray *)updateTiersFromArray:(NSArray *)array inProductID:(TXHProductID *)productId {
    NSUInteger numberOfTiers = [array count];
    
    if (!numberOfTiers)
    {
        [TXHTier deleteTiersForProductId:productId fromManagedObjectContext:self.importContext];
        return @[];
    }
    
    NSMutableArray *tiers = [[NSMutableArray alloc] initWithCapacity:numberOfTiers];
    for (NSDictionary *dict in array)
    {
        TXHTier *tier = [TXHTier updateWithDictionaryCreateIfNeeded:dict
                                             inManagedObjectContext:self.importContext];
        [tiers addObject:tier];
    }
    
    return tiers;
}

- (NSArray *)updateTiresFromDictionary:(NSDictionary *)dictionary inProductID:(TXHProductID *)productId {
    
    NSMutableArray *tiers = [[NSMutableArray alloc] initWithCapacity:[dictionary count]];
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *date = key;
        if ([obj count])
        {
            for (NSDictionary *dict in obj)
            {
                TXHTier *tier = [TXHTier updateWithDictionaryCreateIfNeeded:dict
                                                     inManagedObjectContext:self.importContext];
                [tiers addObject:tier];
            }
        }
        else
        {
            [TXHAvailability deleteForDateIfExists:date
                                         productId:productId
                          fromManagedObjectContext:self.importContext];
        }
    }];
    
    return tiers;
}




#pragma mark - Availabilities

- (void)availabilitiesForProduct:(TXHProduct *)product fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate coupon:(NSString *)coupon completion:(void(^)(NSArray *availabilities, NSError *error))completion;
{
    NSParameterAssert(product);
    NSParameterAssert(completion);

    NSDictionary *params;

    if (!fromDate && !toDate)
        params = nil;
    else if (fromDate && !toDate)
    {
        params = @{@"date": [fromDate isoDateString]};
        if ([coupon length])
        {
            NSMutableDictionary *edit = [params mutableCopy];
            edit[@"coupon"] = coupon;
            params = [edit copy];
        }
    }
    else if (toDate && !fromDate)
        params = @{@"to": [toDate isoDateString]};
    else
        params = @{@"from" : [fromDate isoDateString],
                   @"to"   : [toDate isoDateString]};
    

    NSString *endpoint = [NSString stringWithFormat:@"products/%@/availability", product.productId];

    [self.sessionManager GET:endpoint parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {

        NSArray *availabilities;

        if ([responseObject isKindOfClass:[NSArray class]])
            availabilities = [self updateAvailabilitiesForDate:fromDate
                                                     fromArray:responseObject
                                                   inProductID:product.objectID];
        else
            availabilities = [self updateAvailabilitiesFromDictionary:responseObject
                                                          inProductID:product.objectID];

        NSError *error;
        BOOL success = [self.importContext save:&error];

        if (!success) {
            completion(nil, error);
            return;
        }

        availabilities = [self objectsInMainManagedObjectContext:availabilities];
        
        completion(availabilities, nil);

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"Unable to get the user because: %@", error);
        completion(nil, error);
    }];

    
}

- (NSArray *)updateAvailabilitiesForDate:(NSDate *)date fromArray:(NSArray *)array inProductID:(TXHProductID *)productId
{
    NSUInteger numberOfAvailabilities = [array count];

    if (!numberOfAvailabilities)
    {
        [TXHAvailability deleteForDateIfExists:[date isoDateString]
                                     productId:productId
                      fromManagedObjectContext:self.importContext];
        return @[];
    }

    NSMutableArray *availabilities = [[NSMutableArray alloc] initWithCapacity:numberOfAvailabilities];

    for (NSDictionary *dict in array)
    {
        TXHAvailability *availability = [TXHAvailability updateForDateCreateIfNeeded:[date isoDateString]
                                                                      withDictionary:dict
                                                                           productId:productId
                                                              inManagedObjectContext:self.importContext];
        [availabilities addObject:availability];
    }

    return availabilities;
}

- (NSArray *)updateAvailabilitiesFromDictionary:(NSDictionary *)dictionary inProductID:(TXHProductID *)productId
{
    NSMutableArray *availabilities = [[NSMutableArray alloc] initWithCapacity:[dictionary count]];

    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *date = key;
        if ([obj count]) {
            for (NSDictionary *dict in obj)
            {
                TXHAvailability *availability = [TXHAvailability updateForDateCreateIfNeeded:date
                                                                              withDictionary:dict
                                                                                   productId:productId
                                                                      inManagedObjectContext:self.importContext];
                [availabilities addObject:availability];
            }
        } else {
            [TXHAvailability deleteForDateIfExists:date productId:productId fromManagedObjectContext:self.importContext];
        }
    }];

    return availabilities;

}


#pragma mark - Creating Order

#pragma mark - Tickets

- (void)reserveTicketsWithTierQuantities:(NSDictionary *)tierQuantities availability:(TXHAvailability *)availability isGroup:(BOOL)group shouldNotify:(BOOL)notify completion:(void(^)(TXHOrder *order, NSError *error))completion;
{
    NSParameterAssert(tierQuantities);
    NSParameterAssert(completion);
    
    NSMutableArray *tickets = [NSMutableArray array];
    
    for (NSString *internalTierId in tierQuantities)
    {
        TXHTier *tier = [TXHTier tierWithInternalID:internalTierId inManagedObjectContext:self.managedObjectContext];

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
    
    NSNumber *groupValue  = group ? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO];
    NSNumber *notifyValue = notify ? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO];
    
    NSDictionary *requestPayload = @{@"tickets" : tickets,
                                     @"direct"  : groupValue,
                                     @"notify"  : notifyValue};

    if ([availability.coupon length])
    {
        NSMutableDictionary *temp = requestPayload.mutableCopy;
        temp[@"coupon"]           = availability.coupon;
        requestPayload            = [temp copy];
    }
    
    NSManagedObjectContext *moc = self.importContext;
    
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
                          
                          order = (TXHOrder *)[self.managedObjectContext existingObjectWithID:order.objectID error:&error];
                          
                          completion(order, nil);
                          
                      }
                      failure:^(NSURLSessionDataTask *task, NSError *error) {
                      
                          DLog(@"Unable to reserve tickets because: %@", error);
                          completion(nil, error);
                      }];
}

- (void)removeTickets:(NSArray *)ticketIDs fromOrder:(TXHOrder *)order completion:(void(^)(TXHOrder *order, NSError *error))completion
{
    NSParameterAssert(ticketIDs);
    NSParameterAssert(order);
    NSParameterAssert(completion);

    
    NSMutableArray *tickets = [NSMutableArray array];
    
    for (NSString *ticketID in ticketIDs)
    {
        [tickets addObject:@{@"id"       : ticketID,
                             @"_destory" : @(YES)}];
    }
    
    NSDictionary *requestPayload = @{@"tickets" : tickets};
    
    [self PATHOrder:order withInfo:requestPayload completion:completion];
}


#pragma mark - Upgrades

- (void)upgradesForTicket:(TXHTicket *)ticket completion:(void(^)(NSArray *upgrades, NSError *error))completion
{
    NSParameterAssert(ticket);
    NSParameterAssert(completion);

    NSString *endpoint = [NSString stringWithFormat:@"tickets/%@/upgrades", ticket.ticketId];
    NSManagedObjectContext *moc = self.importContext;

    [self.sessionManager GET:endpoint parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSMutableArray *upgrades = [NSMutableArray array];
        
        for (NSDictionary *dic in responseObject)
        {
            TXHUpgrade *upgrade = [TXHUpgrade updateWithDictionaryCreateIfNeeded:dic
                                                          inManagedObjectContext:moc];
            if (upgrade)
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
        DLog(@"Unable to get the user because: %@", error);
        completion(nil, error);
    }];
}

- (void)updateOrder:(TXHOrder *)order withUpgradesInfo:(NSDictionary *)upgradesInfo completion:(void(^)(TXHOrder *order, NSError *error))completion
{
    NSParameterAssert(order);
    NSParameterAssert(upgradesInfo);
    NSParameterAssert(completion);
    
    NSMutableArray *tickets = [NSMutableArray array];
    
    for (NSString *ticketId in upgradesInfo) {
        NSDictionary *dic = @{ @"id"       : ticketId,
                               @"upgrades" : upgradesInfo[ticketId]};
        if (dic)
            [tickets addObject:dic];
    }
    
    NSDictionary *requestPayload = @{@"tickets" : tickets};
    
    [self PATHOrder:order withInfo:requestPayload completion:completion];
}


#pragma mark - Fields

- (void)fieldsForTicket:(TXHTicket *)ticket completion:(void(^)(NSArray *fields, NSError *error))completion
{
    NSParameterAssert(ticket);
    NSParameterAssert(completion);
    
    NSString *endpoint = [NSString stringWithFormat:@"tickets/%@/fields", ticket.ticketId];
    
    [self.sessionManager GET:endpoint parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSMutableArray *fields = [NSMutableArray array];
        
        for (NSDictionary *fieldDic in responseObject)
        {
            TXHField *field = [[TXHField alloc] initWithDictionary:fieldDic];
            if (field)
                [fields addObject:field];
        }
        
        completion(fields,nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"Unable to get the user because: %@", error);
        completion(nil, error);
    }];
}


- (void)updateOrder:(TXHOrder *)order withCustomersInfo:(NSDictionary *)customersInfo completion:(void (^)(TXHOrder *, NSError *))completion
{
    NSParameterAssert(order);
    NSParameterAssert(customersInfo);
    NSParameterAssert(completion);
    
    NSMutableArray *tickets = [NSMutableArray array];
    
    for (NSString *ticketId in customersInfo) {
        NSDictionary *dic = @{ @"id"       : ticketId,
                               @"customer" : customersInfo[ticketId]};
        [tickets addObject:dic];
    }
    
    NSDictionary *requestPayload = @{@"tickets" : tickets};
    
    [self PATHOrder:order withInfo:requestPayload completion:completion];
}


- (void)updateOrder:(TXHOrder *)order withPaymentMethod:(NSString *)paymentMethod completion:(void (^)(TXHOrder *order, NSError *error))completion
{       
    NSParameterAssert(order);
    NSParameterAssert(paymentMethod);
    NSParameterAssert(completion);
    
    NSDictionary *requestPayload = @{@"payment" : @{@"type" : paymentMethod}};
    
    [self PATHOrder:order withInfo:requestPayload completion:completion];
}


- (void)fieldsForOrderOwner:(TXHOrder *)order completion:(void(^)(NSArray *fields, NSError *error))completion
{
    NSParameterAssert(order);
    NSParameterAssert(completion);
    
    NSString *endpoint = [NSString  stringWithFormat:@"orders/%@/fields",order.orderId];
    
    [self.sessionManager GET:endpoint
                  parameters:nil
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         
                         NSMutableArray *fields = [NSMutableArray array];
                         
                         for (NSDictionary *fieldDic in responseObject)
                         {
                             TXHField *field = [[TXHField alloc] initWithDictionary:fieldDic];
                             if (field)
                                 [fields addObject:field];
                         }
                         
                         completion(fields,nil);
                         
                     }
                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                         DLog(@"Unable to get the user because: %@", error);
                         completion(nil, error);
                     }];
}

- (void)updateOrder:(TXHOrder *)order withOwnerInfo:(NSDictionary *)ownerInfo completion:(void (^)(TXHOrder *order, NSError *error))completion
{
    NSParameterAssert(order);
    NSParameterAssert(ownerInfo);
    NSParameterAssert(completion);
    
    NSDictionary *requestPayload = @{@"customer" : ownerInfo};
    
    [self PATHOrder:order withInfo:requestPayload completion:completion];
}

- (void)getOrderUpdated:(TXHOrder *)order completion:(void (^)(TXHOrder *order, NSError *error))completion
{
    NSParameterAssert(order);
    NSParameterAssert(completion);
    
    NSString *endpoint = [NSString  stringWithFormat:@"orders/%@",order.orderId];
    
    NSManagedObjectContext *moc = self.importContext;
    
    [self.sessionManager GET:endpoint
                  parameters:nil
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         TXHOrder *order = [TXHOrder updateWithDictionaryOrCreateIfNeeded:responseObject inManagedObjectContext:moc];
                         
                         NSError *error;
                         BOOL success = [moc save:&error];
                         
                         if (!success) {
                             completion(nil, error);
                             return;
                         }
                         
                         order = (TXHOrder *)[self.managedObjectContext existingObjectWithID:order.objectID error:&error];
                         
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

- (void)confirmOrder:(TXHOrder *)order completion:(void (^)(TXHOrder *, NSError *))completion
{
    NSParameterAssert(order);
    NSParameterAssert(completion);
    
    NSString *endpoint = [NSString  stringWithFormat:@"orders/%@/confirm",order.orderId];
    
    NSManagedObjectContext *moc = self.importContext;
    
    [self.sessionManager POST:endpoint
                   parameters:nil
                      success:^(NSURLSessionDataTask *task, id responseObject) {
                          TXHOrder *order = [TXHOrder updateWithDictionaryOrCreateIfNeeded:responseObject inManagedObjectContext:moc];
                          
                          NSError *error;
                          BOOL success = [moc save:&error];
                          
                          if (!success) {
                              completion(nil, error);
                              return;
                          }
                          
                          order = (TXHOrder *)[self.managedObjectContext existingObjectWithID:order.objectID error:&error];
                          
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


#pragma mark - Universal Order Helper

- (void)PATHOrder:(TXHOrder *)order withInfo:(NSDictionary *)payload completion:(void (^)(TXHOrder *, NSError *))completion
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
                           
                           order = (TXHOrder *)[self.managedObjectContext existingObjectWithID:order.objectID error:&error];
                           
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

#pragma mark - ticket records

- (void)ticketRecordsForProduct:(TXHProduct *)product availability:(TXHAvailability *)availability withQuery:(NSString *)query completion:(void(^)(NSArray *ricketRecords, NSError *error))completion
{
    NSParameterAssert(product);
    NSParameterAssert(availability);
    NSParameterAssert(completion);
    
    NSString *endpoint   = [NSString stringWithFormat:@"products/%@/tickets",product.productId];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (availability.dateString)
        params[@"date"] = availability.dateString;
    if (availability.timeString)
        params[@"time"] = availability.timeString;
    if (query)
        params[@"search"] = query;
    
    NSManagedObjectContext *moc = self.importContext;
    
    [self.sessionManager GET:endpoint
                  parameters:params
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         NSMutableArray *tickets = [NSMutableArray array];
                         
                         for (NSDictionary *ticketdDic in responseObject)
                         {
                             TXHTicket *ticket = [TXHTicket updateWithDictionaryOrCreateIfNeeded:ticketdDic inManagedObjectContext:moc];
                             if (ticket)
                                 [tickets addObject:ticket];
                         }
                         
                         NSError *error;
                         if (![moc save:&error]) {
                             completion(tickets, error);
                             return;
                         };
                         
                         completion([self objectsInMainManagedObjectContext:tickets],nil);
                     }
                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                         completion(nil,error);
                     }];
}

- (void)updateTicketsForProduct:(TXHProduct*)product withAttendedInfo:(NSArray *)ticketsInfo completion:(void(^)(NSError *error))completion
{
    NSParameterAssert(product);
    NSParameterAssert(ticketsInfo);
    NSParameterAssert(completion);
    
    TXHSupplier *anySupplier = [[self currentUser].suppliers anyObject];
    NSString *tokenString    = [NSString stringWithFormat:@"Bearer %@", anySupplier.accessToken];
    
    NSString *endpoint = [NSString stringWithFormat:@"products/%@/tickets",product.productId];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:ticketsInfo
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *body = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSURL *endpointURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kAPIBaseURL,endpoint]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:endpointURL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod:@"PATCH"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: [body dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:[NSString stringWithFormat:@"Token token=\"%@\"", tokenString] forHTTPHeaderField:@"Authorization"];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = self.sessionManager.responseSerializer;
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON responseObject: %@ ",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }];
    [op start];
}

- (void)setTicket:(TXHTicket *)ticket attended:(BOOL)attended withProduct:(TXHProduct *)product completion:(void(^)(TXHTicket *ticket, NSError *error))completion;
{
    NSParameterAssert(ticket);
    NSParameterAssert(product);
    NSParameterAssert(completion);
    
    NSString *actionString = attended ? @"attend" : @"unattend";
    
    NSString *endpoint = [NSString stringWithFormat:@"products/%@/tickets/%@/%@",product.productId, ticket.ticketId, actionString];
    
    NSManagedObjectContext *moc = self.importContext;
    
    [self.sessionManager POST:endpoint
                   parameters:nil
                      success:^(NSURLSessionDataTask *task, id responseObject) {
                          
                          TXHTicket *ticket = [TXHTicket updateWithDictionaryOrCreateIfNeeded:responseObject inManagedObjectContext:moc];
                          
                          NSError *error;
                          BOOL success = [moc save:&error];
                          
                          if (!success) {
                              completion(nil, error);
                              return;
                          }
                          
                          ticket = (TXHTicket *)[self.managedObjectContext existingObjectWithID:ticket.objectID error:&error];
                          
                          completion(ticket, nil);
                      }
                      failure:^(NSURLSessionDataTask *task, NSError *error) {
                          completion(nil, error);
                      }];
}


- (void)searchForTicketWithSeqId:(NSNumber *)seqID withProduct:(TXHProduct *)product completion:(void(^)(TXHTicket *ticket, NSError *error))completion
{
    NSParameterAssert(seqID);
    NSParameterAssert(product);
    NSParameterAssert(completion);
    
    NSString *endpoint = [NSString stringWithFormat:@"products/%@/tickets/%@",product.productId, seqID];
    
    NSManagedObjectContext *moc = self.importContext;
    
    [self.sessionManager GET:endpoint
                  parameters:nil
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         TXHTicket *ticket = [TXHTicket updateWithDictionaryOrCreateIfNeeded:responseObject inManagedObjectContext:moc];
                         
                         NSError *error;
                         BOOL success = [moc save:&error];
                         
                         if (!success) {
                             completion(nil, error);
                             return;
                         }
                         
                         ticket = (TXHTicket *)[self.managedObjectContext existingObjectWithID:ticket.objectID error:&error];
                         
                         completion(ticket, nil);
                     }
                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                         completion(nil, error);
                     }];
}


- (void)getOrderForTicekt:(TXHTicket *)ticket withProduct:(TXHProduct *)product completion:(void(^)(TXHOrder *order, NSError *error))completion
{
    NSParameterAssert(ticket);
    NSParameterAssert(product);
    NSParameterAssert(completion);
    
    NSString *endpoint = [NSString stringWithFormat:@"products/%@/tickets/%@/order",product.productId, ticket.ticketId];
    NSManagedObjectContext *moc = self.importContext;

    [self.sessionManager GET:endpoint
                  parameters:nil
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         TXHOrder *order = [TXHOrder updateWithDictionaryOrCreateIfNeeded:responseObject inManagedObjectContext:moc];
                         
                         NSError *error;
                         BOOL success = [moc save:&error];
                         
                         if (!success) {
                             completion(nil, error);
                             return;
                         }
                         
                         order = (TXHOrder *)[self.managedObjectContext existingObjectWithID:order.objectID error:&error];
                         
                         completion(order, nil);
                     }
                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                         completion(nil, error);
                     }];
}

- (void)getReciptForOrder:(TXHOrder *)order format:(TXHDocumentFormat)format width:(NSUInteger)width dpi:(NSUInteger)dpi completion:(void(^)(NSURL *url,NSError *error))completion
{
    NSString *extension = [self extendionForFormat:format];
    NSString *endpoint  = [NSString stringWithFormat:@"orders/%@/receipt.%@",order.orderId,extension];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,endpoint];
    
    if (width > 0 && dpi > 0)
        urlString = [urlString stringByAppendingFormat:@"?width=%d&dpi=%d",width,dpi];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    NSString *authHeader = self.sessionManager.requestSerializer.HTTPRequestHeaders[@"Authorization"];
    [request setValue:authHeader forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDownloadTask *downloadTask = [self.sessionManager downloadTaskWithRequest:request
                                                                                 progress:nil
                                                                              destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                                                                  NSURL *documentsDirectoryPath = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
                                                                                  return [documentsDirectoryPath URLByAppendingPathComponent:[targetPath lastPathComponent]];
                                                                                  
                                                                              } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                                                                  completion(filePath, error);
                                                                              }];
    
    [downloadTask resume];
}

- (NSString *)extendionForFormat:(TXHDocumentFormat)format
{
    switch (format) {
        case TXHDocumentFormatPDF: return @"pdf";
        case TXHDocumentFormatPS:  return @"ps";
        case TXHDocumentFormatPNG: return @"png";
        default:
            break;
    }
    
    return @"png";
}


- (void)getTicketTemplatesCompletion:(void(^)(NSArray *templates,NSError *error))completion
{
    NSParameterAssert(completion);
    
    NSString *endpoint = @"templates";
    
    [self.sessionManager GET:endpoint
                  parameters:nil
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         
                         NSMutableArray *templates = [NSMutableArray array];
                         
                         for (NSDictionary *templateDic in responseObject)
                         {
                             TXHTicketTemplate *template = [[TXHTicketTemplate alloc] initWithDictionary:templateDic];
                             if (template)
                                 [templates addObject:template];
                         }
                         
                         completion(templates,nil);
                     }
                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                         completion(nil, error);
                     }];
}

@end
