//
//  TXHTicketingHubClient.m
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 01/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHTicketingHubClient.h"

@implementation TXHTicketingHubClient

#pragma mark - Class methods

+ (instancetype)sharedClient {
    static TXHTicketingHubClient *client = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[self alloc] init];
    });

    return client;
}

@end
