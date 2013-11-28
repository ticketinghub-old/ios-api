//
//  TXHTicketingHubClient.h
//  iOS-api
//
//  Created by Abizer Nasir on 23/10/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

@import Foundation;

#import "TXHAPIError.h"

@class NSManagedObjectContext;
@class TXHUser;

@interface TXHTicketingHubClient : NSObject

@property (strong, readonly, nonatomic) NSManagedObjectContext *managedObjectContext;

// Pass nil for an in-memory-store
- (id)initWithStoreURL:(NSURL *)storeURL;

/*! Set the "Accept-Language" header for subsequent network callso
 *  \param identifier the string identifier of the language, e.g "en-GB"
 */
- (void)setDefaultAcceptLanguage:(NSString *)identifier;

// Returns suppliers in the mainManagedObjectContext
- (void)fetchSuppliersForUsername:(NSString *)username password:(NSString *)password withCompletion:(void(^)(NSArray *suppliers, NSError *error))completion __attribute__((nonnull));

// Returns the user in the mainManagedObjectContext
- (void)updateUser:(TXHUser *)user completion:(void(^)(TXHUser *user, NSError *error))completion __attribute__((nonnull));

//- (void)fetchVenuesWithUsername:(NSString *)username password:(NSString *)password completion:(void(^)(NSArray *venues, NSError *error))completion;
//
//- (void)fetchSeasonsForVenueToken:(NSString *)venueToken completion:(void(^)(NSArray *seasons, NSError *error))completion;

@end