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

@interface TXHTicketingHubClient : NSObject

@property (strong, readonly, nonatomic) NSManagedObjectContext *managedObjectContext;

// Pass nil for an in-memory-store
- (id)initWithStoreURL:(NSURL *)storeURL;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext __attribute__((nonnull));

/*! Set the "Accept-Language" header for subsequent network callso
 *  \param identifier the string identifier of the language, e.g "en-GB"
 */
- (void)setDefaultAcceptLanguage:(NSString *)identifier;

- (void)loginWithUsername:(NSString *)username password:(NSString *)password createSuppliersInManagedObjectContext:(NSManagedObjectContext *)moc __attribute__((nonnull));

//- (void)fetchVenuesWithUsername:(NSString *)username password:(NSString *)password completion:(void(^)(NSArray *venues, NSError *error))completion;
//
//- (void)fetchSeasonsForVenueToken:(NSString *)venueToken completion:(void(^)(NSArray *seasons, NSError *error))completion;

@end
