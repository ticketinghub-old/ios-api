//
//  TXHNumberFormatterCache.m
//  iOS-api
//
//  Created by Bartek Hugo Trzcinski on 13/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHNumberFormatterCache.h"
#import "TXHProduct.h"

@interface TXHNumberFormatterCache ()

@property (nonatomic, strong) NSCache *cache;

@end

@implementation TXHNumberFormatterCache

+ (instancetype)sharedCache
{
    static TXHNumberFormatterCache *_sharedCache;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedCache = [[TXHNumberFormatterCache alloc] init];
    });
    
    return _sharedCache;
}

- (instancetype)init
{
    if (!(self = [super init]))
        return nil;
    
    self.cache = [[NSCache alloc] init];

    return self;
}

- (NSNumberFormatter *)formatterForProduct:(TXHProduct *)product
{
    NSNumberFormatter *formatter = [self.cache objectForKey:product];
    
    if (!formatter)
    {
        formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterCurrencyStyle;
        formatter.currencyCode = product.currency;
        [self.cache setObject:formatter forKey:product];
    }
   
    return formatter;
}

@end
