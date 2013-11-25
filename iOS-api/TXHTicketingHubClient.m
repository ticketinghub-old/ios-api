//
//  TXHTicketingHubClient.m
//  iOS-api
//
//  Created by Abizer Nasir on 23/10/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHTicketingHubClient.h"

#import "_TXHAPISessionManager.h"
#import "TXHSupplier.h"
#import "TXHProduct.h"
#import <DCTCoreDataStack/DCTCoreDataStack.h>

// Static declaration of endpoints
static NSString * const
    kVenuesEndpoint = @"venues"
;

@interface TXHTicketingHubClient ()

@property (strong, nonatomic) DCTCoreDataStack *coreDataStack;
@property (strong, nonatomic) _TXHAPISessionManager *sessionManager;

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

    _coreDataStack = [[DCTCoreDataStack alloc] initWithStoreURL:storeURL storeType:storeType storeOptions:nil modelConfiguration:nil modelURL:nil];

    _sessionManager = [_TXHAPISessionManager new];
    [_sessionManager setDefaultAcceptLanguage:[[NSLocale preferredLanguages] firstObject]];

    return self;
}

- (id)init {
    return [self initWithStoreURL:nil];
}

#pragma mark - Public

- (void)setDefaultAcceptLanguage:(NSString *)identifier {
    [self.sessionManager setDefaultAcceptLanguage:identifier];
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password createSuppliersInManagedObjectContext:(NSManagedObjectContext *)moc {
    NSAssert(username, @"username parameter cannot be nil");
    NSAssert(password, @"password parameter cannot be nil");
    NSAssert(moc, @"managed object context parameter cannot be nil");

    [self.sessionManager loginWithUsername:username password:password completion:^(NSArray *suppliers, NSError *error) {
        if (!suppliers) {
            NSLog(@"API Error with suppliers %@", error);
            return;
        }

        for (NSDictionary *supplierDictionary in suppliers) {
            [TXHSupplier createWithDictionary:supplierDictionary inManagedObjectContext:moc];
        }
    }];
}

- (void)fetchSuppliersForUsername:(NSString *)username password:(NSString *)password withCompletion:(void (^)(NSArray *, NSError *))completion {
    NSAssert(username, @"username parameter cannot be nil");
    NSAssert(password, @"password parameter cannot be nil");
    NSAssert(completion, @"completion handler cannot be nil");


}

#pragma mark - Custom accessors

- (NSManagedObjectContext *)managedObjectContext {
    return self.coreDataStack.managedObjectContext;
}

//- (void)fetchVenuesWithUsername:(NSString *)username password:(NSString *)password completion:(void(^)(NSArray *, NSError *))completion {
//    [self.appSessionManager fetchVenuesWithUsername:username password:password completion:completion];
//}
//
//- (void)fetchSeasonsForVenueToken:(NSString *)venueToken completion:(void (^)(NSArray *, NSError *))completion {
//    [self.sessionManager fetchSeasonsForVenueToken:venueToken completion:completion];
//}

@end
