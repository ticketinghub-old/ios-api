//
//  TXHCoupon.m
//  iOS-api
//
//  Created by Bartek Hugo Trzcinski on 08/09/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHCoupon.h"
#import "NSDate+ISO.h"
#import "TXHDefines.h"

static NSString * const kCouponCodeKey           = @"code";
static NSString * const kCouponExpiresOnKey      = @"expires_on";
static NSString * const kCopuonMaxRedemptionsKey = @"max_redemptions";
static NSString * const kCouponRedemptionsKey    = @"redemptions";

@implementation TXHCoupon

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (!(self = [super init]))
        return nil;
    
    self.code           = nilIfNSNull(dictionary[kCouponCodeKey]);
    self.maxRedemptions = nilIfNSNull(dictionary[kCopuonMaxRedemptionsKey]);
    self.redemptions    = nilIfNSNull(dictionary[kCouponRedemptionsKey]);
    self.expiresOn      = [NSDate dateFromISOString:nilIfNSNull(dictionary[kCouponExpiresOnKey])];
    
    return self;
}


@end
