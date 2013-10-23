//
//  TXHTicketingHubClient.h
//  iOS-api
//
//  Created by Abizer Nasir on 23/10/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

@import Foundation;

#import "TXHAPIError.h"

@interface TXHTicketingHubClient : NSObject

/*! Singleton initialiser
 *  @returns the singleton instance of the client
 */
+ (instancetype)sharedClient;

/*! Set the "Accept-Language" header for subsequent network callso
 *  \param identifier the string identifier of the language, e.g "en-GB"
 */
- (void)setDefaultAcceptLanguage:(NSString *)identifier;

- (void)fetchVenuesWithUsername:(NSString *)username password:(NSString *)password completion:(void(^)(id responseObject, NSError *error))completion;

@end
