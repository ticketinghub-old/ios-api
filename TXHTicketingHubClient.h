//
//  TXHTicketingHubClient.h
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 01/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

@import Foundation;

@class TXHUser;


@interface TXHTicketingHubClient : NSObject

/*! Whether or not the activity indicator is shown and hidden automatically for network requests
 *  By default this is turned turned off.
 */
@property (assign, nonatomic) BOOL showActivityIndicatorAutomatically;

/*! Singleton initialiser
 *  \returns the singleton instance of the client
 */
+ (instancetype)sharedClient;

/*! Set the "Accept-Language" header for subsequent network callso
 *  \param identifier the string identifier of the language, e.g "en-GB"
 */
- (void)setDefaultAcceptLanguage:(NSString *)identifier;

/** Configure the client with the access token and the refresh token.
 @param username the username
 @param password the password
 @param clientId the clientId
 @param clientSecret the clientSecret
 @param completionBlock a block to perform when the request is completed This takes two parameters, the JSON return (could be an NSArray or an NSDictionary and an NSError. On success, both are nil, as the response is just used internally.
 */
- (void)configureWithUsername:(NSString *)username password:(NSString *)password clientId:(NSString *)clientId clientSecret:(NSString *)clientSecret completion:(void(^)(id JSON, NSError *error))completionBlock __attribute__((nonnull));

- (void)userInformationWithCompletion:(void(^)(TXHUser *user, NSError *error))completionBlock __attribute__((nonnull));

- (void)venuesWithCompletion:(void(^)(NSArray *venues, NSError *error))completionBlock __attribute__((nonnull));

- (void)seasonsForVenueId:(NSUInteger)venueId withCompletion:(void(^)(NSArray *seasons, NSError *error))completionBlock __attribute__((nonnull));

- (void)variationsForVenueId:(NSUInteger)venueId withCompletion:(void(^)(NSArray *variations, NSError *error))completionBlock __attribute__((nonnull));

- (void)availabilityForVenueId:(NSUInteger)venueId from:(NSString *)fromDateString to:(NSString *)toDateString withCompletion:(void(^)(NSDictionary *unavailableDates, NSError *error))completionBlock __attribute__((nonnull));

@end