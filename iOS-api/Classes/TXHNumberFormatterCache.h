//
//  TXHNumberFormatterCache.h
//  iOS-api
//
//  Created by Bartek Hugo Trzcinski on 13/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TXHNUMBERFORMATTERCACHE [TXHNumberFormatterCache sharedCache]

@class TXHProduct;

@interface TXHNumberFormatterCache : NSObject

+ (instancetype)sharedCache;

- (NSNumberFormatter *)formatterForProduct:(TXHProduct *)product;

@end
