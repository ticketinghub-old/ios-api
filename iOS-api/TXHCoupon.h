//
//  TXHCoupon.h
//  iOS-api
//
//  Created by Bartek Hugo Trzcinski on 08/09/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXHCoupon : NSObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSDate *expiresOn;
@property (nonatomic, copy) NSNumber *maxRedemptions;
@property (nonatomic, copy) NSNumber *redemptions;


- (instancetype)initWithDictionary:(NSDictionary *)dicRepresentation;

@end
