//
//  TXHGateway.m
//  iOS-api
//
//  Created by Bartek Hugo Trzcinski on 24/04/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHGateway.h"

static NSString * const kGatewayIDKey     = @"id";
static NSString * const kInputTypesKey    = @"input_types";
static NSString * const kPublishableIDKey = @"publishable_key";
static NSString * const kSchemesKey       = @"schemes";
static NSString * const kTypeKey          = @"type";


@interface TXHGateway ()

@property (nonatomic, copy) NSString *gatewayId;
@property (nonatomic, copy) NSString *publishableKey;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSArray  *inputTypes;
@property (nonatomic, copy) NSArray  *schemes;

@end


@implementation TXHGateway

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (![dictionary count] || (self = [super init]))
        return nil;
    
    self.gatewayId      = dictionary[kGatewayIDKey];
    self.inputTypes     = dictionary[kInputTypesKey];
    self.publishableKey = dictionary[kPublishableIDKey];
    self.schemes        = dictionary[kSchemesKey];
    self.type           = dictionary[kTypeKey];
    
    return self;
}

@end
