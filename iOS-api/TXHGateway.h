//
//  TXHGateway.h
//  iOS-api
//
//  Created by Bartek Hugo Trzcinski on 24/04/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXHGateway : NSObject

@property (nonatomic, copy, readonly) NSString *gatewayId;
@property (nonatomic, copy, readonly) NSString *publishableKey;
@property (nonatomic, copy, readonly) NSString *type;
@property (nonatomic, copy, readonly) NSArray  *inputTypes;
@property (nonatomic, copy, readonly) NSArray  *schemes;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
