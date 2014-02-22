//
//  TXHTier+PriceFormatter.h
//  iOS-api
//
//  Created by Bartek Hugo Trzcinski on 13/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHTier.h"

@class TXHProduct;

@interface TXHTier (PriceFormatter)

- (NSString *)priceStringForProduct:(TXHProduct *)product;

@end
