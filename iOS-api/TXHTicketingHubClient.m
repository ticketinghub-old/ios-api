//
//  TXHTicketingHubClient.m
//  iOS-api
//
//  Created by Abizer Nasir on 23/10/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHTicketingHubClient.h"
#import <DCTCoreDataStack/DCTCoreDataStack.h>

#import "AFNetworkActivityIndicatorManager.h"
#import "AFNetworking.h"
#import "JSONResponseSerializerWithData.h"

#import "TXHAvailability.h"
#import "TXHField.h"
#import "TXHGateway.h"
#import "TXHOrder.h"
#import "TXHPayment.h"
#import "TXHProduct.h"
#import "TXHSupplier.h"
#import "TXHTicket.h"
#import "TXHTicketTemplate.h"
#import "TXHTier.h"
#import "TXHUpgrade.h"
#import "TXHUser.h"
#import "TXHCoupon.h"
    
#import "NSDate+ISO.h"
#import "NSDateFormatter+TicketingHubFormat.h"
#import "TXHDefines.h"

#import "TXHPartialResponsInfo.h"
#import "TXHEndpointsHelper.h"

#import "NSError+TXHAPIClient.h"

#warning - refactor this shit, for crying out loud!

@interface TXHTicketingHubClient ()

@property (readonly, nonatomic) NSString *baseURL;
@property (strong, nonatomic) DCTCoreDataStack *coreDataStack;
@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@property (strong, nonatomic) NSManagedObjectContext *importContext;

@end

@implementation TXHTicketingHubClient

#pragma mark - Set up and tear down

- (id)initWithStoreURL:(NSURL *)storeURL andBaseServerURL:(NSURL *)serverURL;
{
    if (!(self = [super init]))
        return nil; // Bail!
    
    [self setupCoreDataStackWithStoreURL:storeURL];
    
    _sessionManager = [[self class] configuredSessionManagerWithServerURL:serverURL];

    return self;
}

- (id)init
{
    return [self initWithStoreURL:nil andBaseServerURL:nil];
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

- (NSString *)baseURL
{
    return [self.sessionManager.baseURL absoluteString];
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


// default base url is @"https://api.ticketinghub.com/"
+ (AFHTTPSessionManager *)configuredSessionManagerWithServerURL:(NSURL *)baseURL
{
    if (!baseURL)
        baseURL = [NSURL URLWithString:@"https://api.ticketinghub.com/"];
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    sessionManager.responseSerializer = [JSONResponseSerializerWithData serializer];
    sessionManager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    [sessionManager.requestSerializer setValue:[[NSLocale preferredLanguages] firstObject]
                            forHTTPHeaderField:@"Accept-Language"];
    [sessionManager.requestSerializer setValue:@"v1"
                            forHTTPHeaderField:@"Accept-Version"];
    
    
    return sessionManager;
}

- (void)setDefaultAcceptLanguage:(NSString *)identifier
{
    
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

- (void)setAuthorizationTokenForSupplier:(TXHSupplier *)supplier
{
    if (supplier)
    {
        NSString *tokenString = [NSString stringWithFormat:@"Bearer %@", supplier.accessToken];
        
        [self.sessionManager.requestSerializer setAuthorizationHeaderFieldWithToken:tokenString];
    }
    else
        [self.sessionManager.requestSerializer clearAuthorizationHeader];
}

#pragma mark - Suppliers, User, Products

- (void)generateAccessTokenForUsername:(NSString *)username password:(NSString *)password withCompletion:(void (^)(NSString *, NSError *))completion
{
    if (!username || !password || !completion)
    {
        if (completion) {
            completion(nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }

    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"grant_type"] = @"password";
    params[@"username"]   = username;
    params[@"password"]   = password;
    
    NSString *endpoint = [TXHEndpointsHelper endpointStringForTXHEndpoint:UserTokenEndpoint];
    
    [self.sessionManager POST:endpoint
                   parameters:params
                      success:^(NSURLSessionDataTask *task, id responseObject) {
                          NSDictionary * response = responseObject;
                          NSString * accessToken    = response[@"access_token"];
                          completion(accessToken, nil);
                      } failure:^(NSURLSessionDataTask *task, NSError *error) {
                          DLog(@"Unable to get user token because: %@", error);
                          completion(nil, error);
                      }];
    
}

- (void)fetchSuppliersForUsername:(NSString *)username accessToken:(NSString *)accessToken withCompletion:(void (^)(NSArray *, NSError *))completion
{
    if (!username || !accessToken || !completion)
    {
        if (completion) {
            completion(nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }
    
    NSString *endpoint = [TXHEndpointsHelper endpointStringForTXHEndpoint:SuppliersEndpoint];
    
    [self.sessionManager GET:endpoint parameters:@{@"access_token" : accessToken} success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *suppliers = [self suppliersFromResponseArray:responseObject inManagedObjectContext:self.importContext];
        
        TXHUser *user = [TXHUser updateWithDictionaryCreateIfNeeded:@{@"email" : username}
                                             inManagedObjectContext:self.importContext];
        user.accessToken = accessToken;
        user.suppliers = [NSSet setWithArray:suppliers];

        NSError *error;
        BOOL success = [self.importContext save:&error];

        if (!success)
        {
            completion(nil, error);
            return;
        }
        
        [self updateUser:user accessToken:accessToken completion:^(TXHUser *user, NSError *error) {
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

- (void)productsForSupplier:(TXHSupplier *)supplier withCompletion:(void (^)(TXHSupplier *, NSError *))completion
{
    if (!supplier || !completion)
    {
        if (completion) {
            completion(nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }
    
    NSString *endpoint = [TXHEndpointsHelper endpointStringForTXHEndpoint:ProductsForSupplierEndpointFormat];
    
    [self.sessionManager GET:endpoint parameters:@{@"access_token" : supplier.accessToken} success:^(NSURLSessionDataTask *task, id responseObject) {
        TXHSupplier *updatedSupplier = (TXHSupplier *)[self.importContext existingObjectWithID:supplier.objectID error:NULL];
        
        for (NSDictionary *productDictionary in responseObject) {
            TXHProduct *product = [TXHProduct createWithDictionary:productDictionary inManagedObjectContext:self.importContext];
            product.supplier = updatedSupplier;
        }
        
        NSError *error;
        BOOL success = [self.importContext save:&error];
        
        if (!success)
        {
            completion(nil, error);
            return;
        }
        
        completion([[self objectsInMainManagedObjectContext:@[updatedSupplier]] firstObject], nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"Unable to get the user because: %@", error);
        completion(nil, error);
    }];

}


- (void)updateUser:(TXHUser *)user accessToken:(NSString *)accessToken completion:(void (^)(TXHUser *, NSError *))completion
{
    if (!user || !accessToken || !completion)
    {
        if (completion) {
            completion(nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }

    
    NSString *endpoint = [TXHEndpointsHelper endpointStringForTXHEndpoint:UserEndpoint];
    
    [self.sessionManager GET:endpoint parameters:@{@"access_token" : accessToken} success:^(NSURLSessionDataTask *task, id responseObject) {
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

- (void)tiersForProduct:(TXHProduct *)product couponCode:(NSString *)coupon completion:(void(^)(NSArray *availabilities, NSError *error))completion;
{
    if (!product.productId || !completion)
    {
        if (completion) {
            completion(nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }
    
    NSString *endpoint = [TXHEndpointsHelper endpointStringForTXHEndpoint:ProductTiersEndpointFormat
                                                               parameters:@[product.productId]];
    
    NSDictionary *params;
    if ([coupon length])
        params = @{ @"coupon" : coupon };
    
    [self.sessionManager GET:endpoint parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *tiers;
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            tiers = [self updateTiersFromArray:responseObject];
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

- (void)couponCodesWithCompletion:(void(^)(NSArray *coupons, NSError *error))completion
{
    if (!completion)
        return;
    
    NSString *endpoint = [TXHEndpointsHelper endpointStringForTXHEndpoint:CouponCodesEndpointFormat];
    
    [self.sessionManager GET:endpoint parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSMutableArray *coupons = [NSMutableArray array];
        for (NSDictionary *couponDic in responseObject)
        {
            TXHCoupon *coupon = [[TXHCoupon alloc] initWithDictionary:couponDic];
            if (couponDic)
                [coupons addObject:coupon];
        }

        completion(coupons, nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"Unable to get the coupons because: %@", error);
        completion(nil, error);
    }];
}

- (NSArray *)updateTiersFromArray:(NSArray *)array {
    NSUInteger numberOfTiers = [array count];
    
    if (!numberOfTiers)
    {
        [TXHTier deleteTiersFromManagedObjectContext:self.importContext];
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

- (void)availableDatesForProduct:(TXHProduct *)product startDate:(NSDate *)startDate endDate:(NSDate *)endDate completion:(void(^)(NSArray *availableDates, NSError *error))completion
{
    if (!product.productId || !completion)
    {
        if (completion) {
            completion(nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }

    if (!startDate || !endDate)
    {
        completion(nil, [NSError errorWithDomain:@"" code:1 userInfo:nil]); // TODO: mhmm
        return;
    }
    
    NSDictionary *parameters = @{@"from"    : [startDate isoDateString],
                                 @"to"      : [endDate isoDateString]};
    
    NSString *endpoint = [TXHEndpointsHelper endpointStringForTXHEndpoint:AvailableDatesSearch parameters:@[product.productId]];
    [self.sessionManager POST:endpoint
                   parameters:parameters
                      success:^(NSURLSessionDataTask *task, id responseObject) {
                          
                          NSMutableArray *dates = [NSMutableArray array];
                          for (NSString *dateString in responseObject)
                              [dates addObject:dateString];
                          
                          completion(dates, nil);
                      }
                      failure:^(NSURLSessionDataTask *task, NSError *error) {
                          completion(nil, error);
                      }];
}

- (void)availabilitiesForProduct:(TXHProduct *)product dateString:(NSString *)dateString tickets:(NSArray *)tickets couponCode:(NSString *)coupon completion:(void(^)(NSArray *availabilities, NSError *error))completion
{
    if (!product.productId || !dateString || !completion)
    {
        if (completion) {
            completion(nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }
    
    NSArray *ticketsArray = [NSArray arrayWithArray:tickets];// make sure we have an array;
    
    NSDictionary *parameters = @{@"tickets" : ticketsArray};

    if ([coupon length])
    {
        NSMutableDictionary *edit = [parameters mutableCopy];
        edit[@"coupon"] = coupon;
        parameters = [edit copy];
    }
    
    NSString *endpoint = [TXHEndpointsHelper endpointStringForTXHEndpoint:ProductAvailabilitiesForDateAndTickets
                                                               parameters:@[product.productId, dateString]];
    __weak typeof(self) wself = self;
    
    [self.sessionManager POST:endpoint
                   parameters:parameters
                      success:^(NSURLSessionDataTask *task, id responseObject) {
                         
                          NSManagedObjectContext *moc = wself.importContext;
                          
                          NSMutableArray *availabilities = [NSMutableArray array];
                          
                          for (NSDictionary *dictionary in responseObject)
                          {
                              TXHAvailability *availability = [TXHAvailability createWithDictionary:dictionary
                                                                             inManagedObjectContext:moc];
                              [availabilities addObject:availability];
                          }
                          
                          NSError *error;
                          BOOL success = [self.importContext save:&error];
                          
                          if (!success) {
                              completion(nil, error);
                              return;
                          }
                          
                          completion([self objectsInMainManagedObjectContext:availabilities], nil);
                          
                      } failure:^(NSURLSessionDataTask *task, NSError *error) {
                          completion(nil, error);
                      }];

}

- (void)availabilitiesForProduct:(TXHProduct *)product fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate coupon:(NSString *)coupon completion:(void(^)(NSArray *availabilities, NSError *error))completion;
{
    if (!product.productId || !completion)
    {
        if (completion) {
            completion(nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }

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
    

    NSString *endpoint = [TXHEndpointsHelper endpointStringForTXHEndpoint:ProductAvailabilitiesEndpointForamt
                                                               parameters:@[product.productId]];
    
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

- (void)reserveTicketsWithTierQuantities:(NSDictionary *)tierQuantities availability:(TXHAvailability *)availability coupon:(TXHCoupon *)coupon latitude:(float)latitude longitude:(float)longitude isGroup:(BOOL)group shouldNotify:(BOOL)notify completion:(void(^)(TXHOrder *order, NSError *error))completion
{
    if (!tierQuantities || !completion)
    {
        if (completion) {
            completion(nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }
    
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
        if (latitude && longitude)
            ticketInfo[@"address"] =  @{@"latitude": @(latitude), @"longitude": @(longitude)};

        [tickets addObject:ticketInfo];
    }
    
    NSNumber *groupValue  = group ? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO];
    NSNumber *notifyValue = notify ? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO];
    
    NSDictionary *requestPayload = @{@"tickets" : tickets,
                                     @"direct"  : groupValue,
                                     @"notify"  : notifyValue};

    if ([coupon.code length])
    {
        NSMutableDictionary *temp = requestPayload.mutableCopy;
        temp[@"coupon"]           = coupon.code;
        requestPayload            = [temp copy];
    }
    
    NSString *endpoint = [TXHEndpointsHelper endpointStringForTXHEndpoint:ReserveOrderTicketsEndpoint];
    
    __weak typeof(self) wself = self;
    
    [self.sessionManager POST:endpoint
                   parameters:requestPayload
                      success:^(NSURLSessionDataTask *task, id responseObject) {
                      
                          NSManagedObjectContext *moc = wself.importContext;

                          
                          TXHOrder *order = [TXHOrder updateWithDictionaryOrCreateIfNeeded:responseObject inManagedObjectContext:moc];
                          
                          NSError *error;
                          BOOL success = [moc save:&error];
                          
                          if (!success) {
                              completion(nil, error);
                              return;
                          }
                          
                          order = (TXHOrder *)[wself.managedObjectContext existingObjectWithID:order.objectID error:&error];
                          
                          completion(order, nil);
                          
                      }
                      failure:^(NSURLSessionDataTask *task, NSError *error) {
                      
                          DLog(@"Unable to reserve tickets because: %@", error);
                          completion(nil, error);
                      }];
}

- (void)removeTickets:(NSArray *)ticketIDs fromOrder:(TXHOrder *)order completion:(void(^)(TXHOrder *order, NSError *error))completion
{
    if (!ticketIDs || !order || !completion)
    {
        if (completion) {
            completion(nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }
    
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

- (void)availableUpgradesForTicket:(TXHTicket *)ticket completion:(void(^)(NSArray *upgrades, NSError *error))completion
{
    if (!ticket.ticketId || !completion)
    {
        if (completion) {
            completion(nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }

    NSString *endpoint = [TXHEndpointsHelper endpointStringForTXHEndpoint:TicketAvailableUpgradesEndpointFormat
                                                               parameters:@[ticket.ticketId]];

    
    __weak typeof(self) wself = self;
    
    [self.sessionManager GET:endpoint parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSManagedObjectContext *moc = wself.importContext;

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

- (void)upgradesForTicket:(TXHTicket *)ticket completion:(void(^)(NSArray *upgrades, NSError *error))completion
{
    if (!ticket.ticketId || !completion)
    {
        if (completion) {
            completion(nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }
    
    NSString *endpoint = [TXHEndpointsHelper endpointStringForTXHEndpoint:TicketUpgradesEndpointFormat
                                                               parameters:@[ticket.ticketId]];
    __weak typeof(self) wself = self;
    
    [self.sessionManager GET:endpoint parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    
        NSManagedObjectContext *moc = wself.importContext;

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
    if (!order || !upgradesInfo || !completion)
    {
        if (completion) {
            completion(nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }

    
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
    if (!ticket.ticketId || !completion)
    {
        if (completion) {
            completion(nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }

    NSString *endpoint = [TXHEndpointsHelper  endpointStringForTXHEndpoint:TicketFieldsEndpointFormat
                                                                parameters:@[ticket.ticketId]];
    
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
    if (!order || !customersInfo || !completion)
    {
        if (completion) {
            completion(nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }

    
    NSMutableArray *tickets = [NSMutableArray array];
    
    for (NSString *ticketId in customersInfo) {
        NSDictionary *dic = @{ @"id"       : ticketId,
                               @"customer" : customersInfo[ticketId]};
        [tickets addObject:dic];
    }
    
    NSDictionary *requestPayload = @{@"tickets" : tickets};
    
    [self PATHOrder:order withInfo:requestPayload completion:completion];
}


- (void)updateOrder:(TXHOrder *)order withPayment:(TXHPayment *)payment completion:(void (^)(TXHOrder *order, NSError *error))completion;
{
    if (!order || !payment || !completion)
    {
        if (completion) {
            completion(nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }
    
    NSDictionary *paymentDictionary = [payment dictionaryRepresentation];
    
    NSDictionary *requestPayload = @{@"payment" : paymentDictionary};
    
    [self PATHOrder:order withInfo:requestPayload completion:completion];
}

- (void)fieldsForOrderOwner:(TXHOrder *)order completion:(void(^)(NSArray *fields, NSError *error))completion
{
    if (!order || !completion)
    {
        if (completion) {
            completion(nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }
    
    NSString *endpoint = [TXHEndpointsHelper endpointStringForTXHEndpoint:TicketOwnerFieldsEndpointFormat
                                                               parameters:@[order.orderId]];
    
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
    if (!order || !ownerInfo || !completion)
    {
        if (completion) {
            completion(nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }

    
    NSDictionary *requestPayload = @{@"customer" : ownerInfo};
    
    [self PATHOrder:order withInfo:requestPayload completion:completion];
}

- (void)getOrderUpdated:(TXHOrder *)order completion:(void (^)(TXHOrder *order, NSError *error))completion
{
    if (!order.orderId || !completion)
    {
        if (completion) {
            completion(nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }

    
    NSString *endpoint = [TXHEndpointsHelper endpointStringForTXHEndpoint:OrderEndpointFormat
                                                               parameters:@[order.orderId]];
    
    __weak typeof(self) wself = self;
    
    [self.sessionManager GET:endpoint
                  parameters:nil
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         
                         NSManagedObjectContext *moc = wself.importContext;
                         
                         TXHOrder *order = [TXHOrder updateWithDictionaryOrCreateIfNeeded:responseObject inManagedObjectContext:moc];
                         
                         NSError *error;
                         BOOL success = [moc save:&error];
                         
                         if (!success) {
                             completion(nil, error);
                             return;
                         }
                         
                         order = (TXHOrder *)[wself.managedObjectContext existingObjectWithID:order.objectID error:&error];
                         
                         completion(order, nil);
                     }
                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                         NSManagedObjectContext *moc = wself.importContext;

                         NSDictionary *dic =  error.userInfo[JSONResponseSerializerWithDataKey];
                         TXHOrder *order;
                         if (dic)
                             order = [TXHOrder updateWithDictionaryOrCreateIfNeeded:dic inManagedObjectContext:moc];
                         completion(order, error);
                     }];
}

- (void)confirmOrder:(TXHOrder *)order completion:(void (^)(TXHOrder *, NSError *))completion
{
    if (!order.orderId || !completion)
    {
        if (completion) {
            completion(nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }
    
    NSString *endpoint = [TXHEndpointsHelper endpointStringForTXHEndpoint:ConfirmOrderEndpointFormat
                                                               parameters:@[order.orderId]];
    
    __weak typeof(self) wself = self;
    [self.sessionManager POST:endpoint
                   parameters:nil
                      success:^(NSURLSessionDataTask *task, id responseObject) {
                          NSManagedObjectContext *moc = wself.importContext;

                          TXHOrder *order = [TXHOrder updateWithDictionaryOrCreateIfNeeded:responseObject inManagedObjectContext:moc];
                          
                          NSError *error;
                          BOOL success = [moc save:&error];
                          
                          if (!success) {
                              completion(nil, error);
                              return;
                          }
                          
                          order = (TXHOrder *)[wself.managedObjectContext existingObjectWithID:order.objectID error:&error];
                          
                          completion(order, nil);
                      }
                      failure:^(NSURLSessionDataTask *task, NSError *error) {
                          NSManagedObjectContext *moc = wself.importContext;

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
    NSString *endpoint = [TXHEndpointsHelper endpointStringForTXHEndpoint:UpdateOrderEndpointFormat
                                                               parameters:@[order.orderId]];
    
    __weak typeof(self) wself = self;
    [self.sessionManager PATCH:endpoint
                    parameters:payload
                       success:^(NSURLSessionDataTask *task, id responseObject) {
                           NSManagedObjectContext *moc = wself.importContext;

                           TXHOrder *order = [TXHOrder updateWithDictionaryOrCreateIfNeeded:responseObject inManagedObjectContext:moc];
                           
                           NSError *error;
                           BOOL success = [moc save:&error];
                           
                           if (!success) {
                               completion(nil, error);
                               return;
                           }
                           
                           order = (TXHOrder *)[wself.managedObjectContext existingObjectWithID:order.objectID error:&error];
                           
                           completion(order, nil);
                       }
                       failure:^(NSURLSessionDataTask *task, NSError *error) {
                           NSManagedObjectContext *moc = wself.importContext;

                           NSDictionary *dic =  error.userInfo[JSONResponseSerializerWithDataKey];
                           TXHOrder *order;
                           if (dic)
                               order = [TXHOrder updateWithDictionaryOrCreateIfNeeded:dic inManagedObjectContext:moc];
                           completion(order, error);
                       }];
}

#pragma mark - ticket records

// TODO: Lord have mercy....
- (void)ticketRecordsForProduct:(TXHProduct *)product validFromDate:(NSDate *)date includingAttended:(BOOL)attended query:(NSString *)query paginationInfo:(TXHPartialResponsInfo *)info completion:(void(^)(TXHPartialResponsInfo *info, NSArray *ticketRecords, NSError *error))completion
{
    if (!product.productId || !date || !completion)
    {
        if (completion) {
            completion(nil, nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }
    
    NSString *endpoint = [TXHEndpointsHelper endpointStringForTXHEndpoint:ProductTicketsSearch
                                                               parameters:@[product.productId]];
    
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    
    filters[@"order"]      = @{ @"confirmed" : @YES, @"active" : @YES };
    filters[@"expires_at"] = @{ @"gt" : [NSDateFormatter txh_stringFromDate:date]};
    
    if (!attended)
        filters[@"attended"] = @NO;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"order"]   = @[ @"valid_from" ];
    params[@"filters"] = filters;
    
    if ([query length])
        params[@"search"] = query;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",self.baseURL, endpoint];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    NSString *authHeader = self.sessionManager.requestSerializer.HTTPRequestHeaders[@"Authorization"];
    [request setValue:authHeader forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"v1" forHTTPHeaderField:@"Accept-Version"];
    if (info)
    {
        [request addValue:[NSString stringWithFormat:@"%ld", info.limit] forHTTPHeaderField:@"X-Limit"];
        [request addValue:[NSString stringWithFormat:@"%ld", info.offset] forHTTPHeaderField:@"X-Offset"];
    }
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    [request setHTTPBody:postData];
    [request setHTTPMethod:@"POST"];
    
    __weak typeof(self) wself = self;

    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSManagedObjectContext *moc = wself.importContext;
        
        if(error == nil)
        {
            NSError *e = nil;
            NSArray *responseArray  = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableLeaves error: &e];
            
            if (e)
            {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(info, nil, e);
                });
            }
            else
            {
                TXHPartialResponsInfo *nextInfo = [[TXHPartialResponsInfo alloc] initWithNSURLResponse:response];
                
                NSMutableArray *tickets = [NSMutableArray array];
                
                for (NSDictionary *ticketdDic in responseArray)
                {
                    TXHTicket *ticket = [TXHTicket updateWithDictionaryOrCreateIfNeeded:ticketdDic inManagedObjectContext:moc];
                    if (ticket)
                        [tickets addObject:ticket];
                }
                
                NSError *error;
                if (![moc save:&error]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(info, nil, error);
                    });
                    
                    return;
                };
                
                NSArray *mainContextObjects = [self objectsInMainManagedObjectContext:tickets];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nextInfo , mainContextObjects ,nil);

                });
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(info, nil, error);
            });
        }
    }];
    
    [postDataTask resume];
}

- (void)ticketRecordsForProduct:(TXHProduct *)product availability:(TXHAvailability *)availability withQuery:(NSString *)query completion:(void(^)(NSArray *ricketRecords, NSError *error))completion
{
    if (!product.productId || !availability || !completion)
    {
        if (completion) {
            completion(nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }
    
    NSString *endpoint = [TXHEndpointsHelper endpointStringForTXHEndpoint:TicketsWithParamsEndpointFormat
                                                               parameters:@[product.productId]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (availability.dateString)
        params[@"date"] = availability.dateString;
    if (availability.timeString)
        params[@"time"] = availability.timeString;
    if (query)
        params[@"search"] = query;
    
    __weak typeof(self) wself = self;
    
    [self.sessionManager GET:endpoint
                  parameters:params
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         NSManagedObjectContext *moc = wself.importContext;

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

- (void)getTicketsCountFromValidDate:(NSDate *)date forProduct:(TXHProduct *)product onlyAttendees:(BOOL)attendees completion:(void(^)(NSNumber *count, NSError *error))completion
{
    if (!product.productId || !date || !completion)
    {
        if (completion) {
            completion(nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }
    
    NSString *endpoint = [TXHEndpointsHelper endpointStringForTXHEndpoint:ProductTicketsSearch
                                                               parameters:@[product.productId]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    filters[@"order"] = @{ @"confirmed" : @YES, @"active" : @YES };
    filters[@"valid_from"] = [NSDateFormatter txh_stringFromDate:date];
    if (attendees)
        filters[@"attended"] = @YES;
    params[@"filters"] = filters;
    
    [self.sessionManager POST:endpoint
                   parameters:params
                      success:^(NSURLSessionDataTask *task, id responseObject) {
                          NSMutableArray *objects = responseObject;
                          TXHPartialResponsInfo *info = [[TXHPartialResponsInfo alloc] initWithNSURLResponse:task.response];
                          NSInteger total = info.total;
                          if (!info.hasMore) total = objects.count;
                          completion(@(total), nil);
                      }
                      failure:^(NSURLSessionDataTask *task, NSError *error) {
                          completion(nil,error);
                      }];
}

- (void)getTicketsCountForOrder:(TXHOrder *)order completion:(void (^)(NSNumber *, NSError *))completion
{
    if (!order.orderId || !completion)
    {
        if (completion) {
            completion(nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }
    
    NSString *endpoint = [TXHEndpointsHelper endpointStringForTXHEndpoint:TicketsForOrderEndpointFormat
                                                               parameters:@[order.orderId]];
    
    [self.sessionManager GET:endpoint
                  parameters:@{}
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         NSMutableArray *objects = responseObject;
                         TXHPartialResponsInfo *info = [[TXHPartialResponsInfo alloc] initWithNSURLResponse:task.response];
                         NSInteger total = info.total;
                         if (!info.hasMore) total = objects.count;
                         completion(@(total), nil);
                     }
                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                         completion(nil,error);
                     }];
}

- (void)getAttendeesCountForOrder:(TXHOrder *)order completion:(void (^)(NSNumber *, NSError *))completion
{
    if (!order.orderId || !completion)
    {
        if (completion) {
            completion(nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }
    
    NSString *endpoint = [TXHEndpointsHelper endpointStringForTXHEndpoint:TicketsForOrderEndpointFormat
                                                               parameters:@[order.orderId]];
    NSMutableDictionary * filter = [NSMutableDictionary dictionary];
    filter[@"attended"] = @YES;
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"filters"] = filter;
    [self.sessionManager GET:endpoint
                  parameters:params
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         NSMutableArray *objects = responseObject;
                         TXHPartialResponsInfo *info = [[TXHPartialResponsInfo alloc] initWithNSURLResponse:task.response];
                         NSInteger total = info.total;
                         if (!info.hasMore) total = objects.count;
                         completion(@(total), nil);
                     }
                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                         completion(nil,error);
                     }];
}



- (void)setTicket:(TXHTicket *)ticket attended:(BOOL)attended withProduct:(TXHProduct *)product completion:(void(^)(TXHTicket *ticket, NSError *error))completion;
{
    if (!ticket.ticketId || !product.productId || !completion)
    {
        if (completion) {
            completion(nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }
    
    __weak typeof(self) wself = self;

    void(^successBlock)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
        NSManagedObjectContext *moc = wself.importContext;

        TXHTicket *ticket = [TXHTicket updateWithDictionaryOrCreateIfNeeded:responseObject inManagedObjectContext:moc];
        
        NSError *error;
        BOOL success = [moc save:&error];
        
        if (!success) {
            completion(nil, error);
            return;
        }
        
        ticket = (TXHTicket *)[self.managedObjectContext existingObjectWithID:ticket.objectID error:&error];
        
        completion(ticket, nil);
    };
    
    void (^failureBlock)(NSURLSessionDataTask *task, NSError *error) = ^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    };
    
    if (attended)
    {
        NSString *endpoint = [TXHEndpointsHelper endpointStringForTXHEndpoint:AttendProductTicketEndpointFormat
                                                                   parameters:@[product.productId, ticket.ticketId]];
        
        [self.sessionManager POST:endpoint
                       parameters:nil
                          success:successBlock
                          failure:failureBlock];
    }
    else
    {
        NSString *endpoint = [TXHEndpointsHelper endpointStringForTXHEndpoint:UnattendProductTicketEndpointFormat
                                                                   parameters:@[product.productId, ticket.ticketId]];
        
        [self.sessionManager DELETE:endpoint
                         parameters:nil
                            success:successBlock
                            failure:failureBlock];
        
    }
}

- (void)setAllTicketsAttendedForOrder:(TXHOrder *)order completion:(void(^)(TXHOrder *order, NSError *error))completion
{
    if (!order.orderId || !completion)
    {
        if (completion) {
            completion(nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }
    
    NSString *endpoint = [TXHEndpointsHelper endpointStringForTXHEndpoint:OrderAttenAll parameters:@[order.orderId]];

    __weak typeof(self) wself = self;
    
    [self.sessionManager POST:endpoint
                   parameters:nil
                      success:^(NSURLSessionDataTask *task, id responseObject) {
                          NSManagedObjectContext *moc = wself.importContext;

                          for (NSDictionary * dict in responseObject)
                              [TXHTicket updateWithDictionaryOrCreateIfNeeded:dict inManagedObjectContext:moc];
                          
                          NSError *error;
                          BOOL success = [moc save:&error];
                          
                          if (!success) {
                              completion(nil, error);
                              return;
                          }
                          
                          completion(order, nil);
                          
                      }
                      failure:^(NSURLSessionDataTask *task, NSError *error) {
                          
                          DLog(@"Unable to reserve tickets because: %@", error);
                          completion(nil, error);
                      }];
}


- (void)searchForTicketWithSeqId:(NSNumber *)seqID withProduct:(TXHProduct *)product completion:(void(^)(TXHTicket *ticket, NSError *error))completion
{
    if (!product.productId || !seqID || !completion)
    {
        if (completion) {
            completion(nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }
    
    NSString *endpoint = [TXHEndpointsHelper endpointStringForTXHEndpoint:ProductTicketForSeqIdEndpointFormat
                                                               parameters:@[product.productId, seqID]];
    
    __weak typeof(self) wself = self;
    [self.sessionManager GET:endpoint
                  parameters:nil
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         NSManagedObjectContext *moc = wself.importContext;

                         TXHTicket *ticket = [TXHTicket updateWithDictionaryOrCreateIfNeeded:responseObject inManagedObjectContext:moc];
                         
                         NSError *error;
                         BOOL success = [moc save:&error];
                         
                         if (!success) {
                             completion(nil, error);
                             return;
                         }
                         
                         ticket = (TXHTicket *)[wself.managedObjectContext existingObjectWithID:ticket.objectID error:&error];
                         
                         completion(ticket, nil);
                     }
                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                         completion(nil, error);
                     }];
}


- (void)getOrderForTicket:(TXHTicket *)ticket completion:(void(^)(TXHOrder *order, NSError *error))completion
{
    if (!ticket.ticketId || !completion)
    {
        if (completion) {
            completion(nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }
    
    NSString *endpoint = [TXHEndpointsHelper endpointStringForTXHEndpoint:OrderForTicketProductEndpointFormat
                                                               parameters:@[ticket.ticketId]];
    
    __weak typeof(self) wself = self;
    [self.sessionManager GET:endpoint
                  parameters:nil
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         NSManagedObjectContext *moc = wself.importContext;

                         TXHOrder *order = [TXHOrder updateWithDictionaryOrCreateIfNeeded:responseObject inManagedObjectContext:moc];
                         
                         NSError *error;
                         BOOL success = [moc save:&error];
                         
                         if (!success) {
                             completion(nil, error);
                             return;
                         }
                         
                         order = (TXHOrder *)[wself.managedObjectContext existingObjectWithID:order.objectID error:&error];
                         
                         completion(order, nil);
                     }
                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                         completion(nil, error);
                     }];
}

- (void)getOrdersForCardMSRString:(NSString *)msrInfo paginationInfo:(TXHPartialResponsInfo *)info completion:(void(^)(TXHPartialResponsInfo *info, NSArray *orders, NSError *error))completion
{
    if (!msrInfo || !completion)
    {
        if (completion) {
            completion(nil, nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }
    
    NSDictionary *parameters = @{ @"filters": @{ @"card": @{ @"track_data": msrInfo } } };
    
    [self getOrdersWithParameters:parameters
                   paginationInfo:info
                       completion:completion];
}

- (void)getOrdersForQuery:(NSString *)query paginationInfo:(TXHPartialResponsInfo *)info completion:(void(^)(TXHPartialResponsInfo *info,NSArray *orders, NSError *error))completion
{
    if (!query || !completion)
    {
        if (completion) {
            completion(nil, nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }
    
    NSDictionary *parameters = @{ @"search": query };
    
    [self getOrdersWithParameters:parameters
                   paginationInfo:info
                       completion:completion];
}

- (void)getOrdersWithParameters:(NSDictionary *)parameters paginationInfo:(TXHPartialResponsInfo *)info completion:(void (^)(TXHPartialResponsInfo *info, NSArray *, NSError *))completion
{
    NSString *endpoint = [TXHEndpointsHelper endpointStringForTXHEndpoint:OrdersForMSRCardTrackDataEndpoint];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",self.baseURL, endpoint];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    NSString *authHeader = self.sessionManager.requestSerializer.HTTPRequestHeaders[@"Authorization"];
    [request setValue:authHeader forHTTPHeaderField:@"Authorization"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"v1" forHTTPHeaderField:@"Accept-Version"];
    if (info)
    {
        [request addValue:[NSString stringWithFormat:@"%ld", info.limit] forHTTPHeaderField:@"X-Limit"];
        [request addValue:[NSString stringWithFormat:@"%ld", info.offset] forHTTPHeaderField:@"X-Offset"];
    }
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    [request setHTTPBody:postData];
    [request setHTTPMethod:@"POST"];
    
    __weak typeof(self) wself = self;
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSManagedObjectContext *moc = wself.importContext;
        
        if(error == nil)
        {
            NSError *e = nil;
            NSArray *responseArray  = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableLeaves error: &e];
            
            if (e)
            {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(info, nil, e);
                });
            }
            else
            {
                TXHPartialResponsInfo *nextInfo = [[TXHPartialResponsInfo alloc] initWithNSURLResponse:response];
                
                NSMutableArray *orders = [NSMutableArray array];
                
                for (NSDictionary *orderDic in responseArray)
                {
                    TXHOrder *order = [TXHOrder updateWithDictionaryOrCreateIfNeeded:orderDic
                                                               inManagedObjectContext:moc];
                    if (order)
                        [orders addObject:order];
                }
                
                NSError *error;
                if (![moc save:&error]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(info, nil, error);
                    });
                    
                    return;
                };
                
                NSArray *mainContextObjects = [self objectsInMainManagedObjectContext:orders];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nextInfo , mainContextObjects ,nil);
                });
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(info, nil, error);
            });
        }
    }];
    
    [postDataTask resume];
    
}

- (void)cancelOrder:(TXHOrder *)order completion:(void(^)(TXHOrder *order,NSError *error))completion
{
    if (!order.orderId || !completion)
    {
        if (completion) {
            completion(nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }
    
    NSString *endpoint  = [TXHEndpointsHelper endpointStringForTXHEndpoint:RemoveOrderTicketsEndpointFormat
                                                                parameters:@[order.orderId]];
    
    __weak typeof (self) wself = self;
    
    [self.sessionManager DELETE:endpoint
                     parameters:nil
                        success:^(NSURLSessionDataTask *task, id responseObject) {
                            NSManagedObjectContext *moc = wself.importContext;

                            TXHOrder *order = [TXHOrder updateWithDictionaryOrCreateIfNeeded:responseObject inManagedObjectContext:moc];
                            
                            NSError *error;
                            BOOL success = [moc save:&error];
                            
                            if (!success) {
                                completion(nil, error);
                                return;
                            }
                            
                            order = (TXHOrder *)[wself.managedObjectContext existingObjectWithID:order.objectID error:&error];
                            
                            completion(order, nil);
                            
                        }
                        failure:^(NSURLSessionDataTask *task, NSError *error) {
                            
                            DLog(@"Unable to reserve tickets because: %@", error);
                            completion(nil, error);
                        }];
}

- (void)getReciptForOrder:(TXHOrder *)order format:(TXHDocumentFormat)format width:(NSUInteger)width dpi:(NSUInteger)dpi completion:(void(^)(NSURL *url,NSError *error))completion
{
    if (!order.orderId || !completion)
    {
        if (completion) {
            completion(nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }
    
    NSString *extension = [self extendionForFormat:format];
    NSString *endpoint  = [TXHEndpointsHelper endpointStringForTXHEndpoint:OrderReceiptEndpointFormat
                                                                parameters:@[order.orderId,extension]];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",self.baseURL,endpoint];
    
    if (width > 0 && dpi > 0)
        urlString = [urlString stringByAppendingFormat:@"?size=%lumm&dpi=%lu",(unsigned long)width,(unsigned long)dpi];
    
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
        case TXHDocumentFormatBMP: return @"bmp";
        default:
            break;
    }
    
    return @"png";
}


- (void)getTicketTemplatesCompletion:(void(^)(NSArray *templates,NSError *error))completion
{
    if (!completion)
    {
        if (completion) {
            completion(nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }
    
    NSString *endpoint = [TXHEndpointsHelper endpointStringForTXHEndpoint:TicketTemplatesEndpoint];
    
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

- (void)getTicketToPrintForOrder:(TXHOrder *)order withTemplet:(TXHTicketTemplate *)templet format:(TXHDocumentFormat)format completion:(void(^)(NSURL *url,NSError *error))completion;
{
    if (!order.orderId || !templet.templateId || !completion)
    {
        if (completion) {
            completion(nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }
    
    NSString *extension = [self extendionForFormat:format];
    NSString *endpoint  = [TXHEndpointsHelper endpointStringForTXHEndpoint:OrderTicketsForTemplateEndpoint
                                                                parameters:@[order.orderId,extension,templet.templateId]];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",self.baseURL, endpoint];
    
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

- (void)getTicketImageToPrintForTicket:(TXHTicket *)ticket withTemplet:(TXHTicketTemplate *)templet dpi:(NSUInteger)dpi format:(TXHDocumentFormat)format completion:(void(^)(NSURL *url,NSError *error))completion
{
    if (!ticket.ticketId || !templet.templateId || !completion)
    {
        if (completion) {
            completion(nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }
    
    format = TXHDocumentFormatBMP;
    NSString *extension = [self extendionForFormat:format];
    NSString *endpoint  = [TXHEndpointsHelper endpointStringForTXHEndpoint:TicketImageForTemplateEndpoint
                                                                parameters:@[ticket.ticketId,extension,templet.templateId,@(dpi)]];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",self.baseURL, endpoint];
    
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


- (void)getPaymentGatewaysWithCompletion:(void(^)(NSArray *gateways,NSError *error))completion;
{
    NSString *endpoint = [TXHEndpointsHelper endpointStringForTXHEndpoint:PaymentGatewaysEndpoint];
    
    __weak typeof(self) wself = self;
    
    [self.sessionManager GET:endpoint
                  parameters:nil
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         NSManagedObjectContext *moc = wself.importContext;

                         NSMutableArray *gateways = [NSMutableArray array];
                         
                         for (NSDictionary *gatewayDic in responseObject)
                         {
                             TXHGateway *gateway = [TXHGateway createWithDictionary:gatewayDic inManagedObjectContext:moc];
                             if (gateway)
                                 [gateways addObject:gateway];
                         }
                         
                         NSError *error;
                         if (![moc save:&error]) {
                             completion(nil, error);
                             return;
                         };
                         
                         completion([self objectsInMainManagedObjectContext:gateways],nil);
                     }
                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                         completion(nil, error);
                     }];
}

- (void)getSummaryForUser:(TXHUser *)user format:(TXHDocumentFormat)format width:(NSUInteger)width dpi:(NSUInteger)dpi completion:(void(^)(NSURL *url,NSError *error))completion
{
    if (!user.accessToken || !completion)
    {
        if (completion) {
            completion(nil, [NSError clientErrorWithCode:kTXHAPIClientArgsInconsistencyError]);
        }
        return;
    }
    
    NSString *extension = [self extendionForFormat:format];
    NSString *endpoint  = [TXHEndpointsHelper endpointStringForTXHEndpoint:SummaryEndpointFormat
                                                                parameters:@[extension, user.accessToken]];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",self.baseURL,endpoint];
    
    if (width > 0)
        urlString = [urlString stringByAppendingFormat:@"&size=%lumm",(unsigned long)width];
    if (dpi > 0)
        urlString = [urlString stringByAppendingFormat:@"&dpi=%lu",(unsigned long)dpi];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
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


@end
