//
//  _TXHAPISessionManager.h
//  iOS-api
//
//  Created by Abizer Nasir on 23/10/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface _TXHAPISessionManager : AFHTTPSessionManager

/*! Set the "Accept-Language" header for subsequent network callso
 *  \param identifier the string identifier of the language, e.g "en-GB"
 */
- (void)setDefaultAcceptLanguage:(NSString *)identifier;

- (void)fetchSeasonsForVenueToken:(NSString *)venueToken completion:(void(^)(NSArray *seasons, NSError *error))completion;

@end
