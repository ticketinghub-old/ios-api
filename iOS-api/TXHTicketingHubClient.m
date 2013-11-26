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

#import "AFNetworking.h"
#import "TXHProduct.h"
#import "TXHSupplier.h"
#import "TXHUser.h"

@interface TXHTicketingHubClient ()

@property (strong, nonatomic) DCTCoreDataStack *coreDataStack;
@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

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

    NSURL *modelURL = [[self class] coreDataModelURL];
    _coreDataStack = [[DCTCoreDataStack alloc] initWithStoreURL:storeURL storeType:storeType storeOptions:nil modelConfiguration:nil modelURL:modelURL];

    _sessionManager = [[self class] configuredSessionManager];

    return self;
}

- (id)init {
    return [self initWithStoreURL:nil];
}

#pragma mark - Public

- (void)setDefaultAcceptLanguage:(NSString *)identifier {
    [self.sessionManager.requestSerializer setValue:identifier forHTTPHeaderField:@"Accept-Language"];
}

- (void)fetchSuppliersForUsername:(NSString *)username password:(NSString *)password withCompletion:(void (^)(NSArray *, NSError *))completion {
    NSAssert(username, @"username parameter cannot be nil");
    NSAssert(password, @"password parameter cannot be nil");
    NSAssert(completion, @"completion handler cannot be nil");

    [self.sessionManager.requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];
    [self.sessionManager GET:kSuppliersEndPoint parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        // No need to check for empty response as you can't have a user without any suppliers
        NSArray *suppliers = [self suppliersFromResponseArray:responseObject inManagedObjectContext:self.managedObjectContext];

        // Create a TXHUser object with the email address and add it to the suppliers we are still in the import context
        TXHUser *user = [TXHUser createIfNeededWithDictionary:@{@"email" : username} inManagedObjectContext:self.managedObjectContext];
        user.suppliers = [NSSet setWithArray:suppliers];

        completion(suppliers, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Unable to get suppliers because: %@", error);
        completion(nil, error);
    }];
}

- (void)fetchUserWithToken:(NSString *)accessToken completion:(void (^)(TXHUser *, NSError *))completion {
    NSAssert(accessToken, @"accessToken cannot be nil");
    NSAssert(completion, @"completion handler cannot be nil");

    [self.sessionManager.requestSerializer setAuthorizationHeaderFieldWithToken:accessToken];
    [self.sessionManager GET:kUserEndPoint parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Unable to get the user because: %@", error);
        completion(nil, error);
    }];
}

#pragma mark - Custom accessors


- (NSManagedObjectContext *)managedObjectContext {
    return self.coreDataStack.managedObjectContext;
}

#pragma mark - Private methods

+ (AFHTTPSessionManager *)configuredSessionManager {
    NSURL *baseURL = [NSURL URLWithString:kAPIBaseURL];
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [sessionManager.requestSerializer setValue:[[NSLocale preferredLanguages] firstObject] forHTTPHeaderField:@"Accept-Language"];

    return sessionManager;
}

+ (NSURL *)coreDataModelURL {
    NSArray *allBundles = [NSBundle allBundles];

    __block NSURL *modelURL;

    [allBundles enumerateObjectsUsingBlock:^(NSBundle *bundle, NSUInteger idx, BOOL *stop) {
        modelURL = [bundle URLForResource:@"CoreDataModel" withExtension:@"momd"];
        if (modelURL) {
            *stop = YES;
        }
    }];

    return modelURL;
}

- (NSArray *)suppliersFromResponseArray:(NSArray *)responseArray inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSMutableArray *suppliers = [NSMutableArray arrayWithCapacity:[responseArray count]];
    for (NSDictionary *supplierDictionary in responseArray) {
        TXHSupplier *supplier = [TXHSupplier createWithDictionary:supplierDictionary inManagedObjectContext:managedObjectContext];
        [suppliers addObject:supplier];
    }

    return [suppliers copy];
}

//- (void)fetchVenuesWithUsername:(NSString *)username password:(NSString *)password completion:(void(^)(NSArray *, NSError *))completion {
//    [self.appSessionManager fetchVenuesWithUsername:username password:password completion:completion];
//}
//
//- (void)fetchSeasonsForVenueToken:(NSString *)venueToken completion:(void (^)(NSArray *, NSError *))completion {
//    [self.sessionManager fetchSeasonsForVenueToken:venueToken completion:completion];
//}



@end
