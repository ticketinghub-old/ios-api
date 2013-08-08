//
//  _TXHNetworkClient.h
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 02/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "AFHTTPClient.h"

extern NSString * const kUserEndpoint;
extern NSString * const kVenuesEndpoint;

@interface _TXHNetworkClient : AFHTTPClient

/*! Singleton initialise
 *  \returns The singleton instance of the network client
 */
+ (instancetype)sharedClient;

@end
