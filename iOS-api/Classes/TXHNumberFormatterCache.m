//
//  TXHNumberFormatterCache.m
//  iOS-api
//
//  Created by Bartek Hugo Trzcinski on 13/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHNumberFormatterCache.h"
#import "TXHSupplier.h"

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

- (NSNumberFormatter *)formatterForSuplier:(TXHSupplier *)suplier
{
    NSNumberFormatter *formatter = [self.cache objectForKey:suplier];
    
    if (!formatter)
    {
        formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterCurrencyStyle;
        formatter.currencyCode = suplier.currency;
        [self.cache setObject:formatter forKey:suplier];
    }
   
    return formatter;
}

@end
