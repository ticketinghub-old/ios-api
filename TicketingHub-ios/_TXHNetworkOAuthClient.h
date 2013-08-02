//
//  _TXHNetworkOAuthClient.h
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 02/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "AFHTTPClient.h"

@interface _TXHNetworkOAuthClient : AFHTTPClient

/*! Singleton initialise
 *  \returns the singleton instance
 */
+ (instancetype)sharedClient;

@end
