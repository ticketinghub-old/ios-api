//
//  TXHCoupon.m
//  iOS-api
//
//  Created by Bartek Hugo Trzcinski on 08/09/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHCoupon.h"
#import "NSDate+ISO.h"

static NSString * const kCouponCodeKey           = @"code";
static NSString * const kCouponExpiresOnKey      = @"expires_on";
static NSString * const kCopuonMaxRedemptionsKey = @"max_redemptions";
static NSString * const kCouponRedemptionsKey    = @"redemptions";

@implementation TXHCoupon

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (!(self = [super init]))
        return nil;
    
    self.code           = dictionary[kCouponCodeKey];
    self.maxRedemptions = dictionary[kCopuonMaxRedemptionsKey];
    self.redemptions    = dictionary[kCouponRedemptionsKey];
    self.expiresOn      = [NSDate dateFromISOString:dictionary[kCouponExpiresOnKey]];
    
    return self;
}


@end
