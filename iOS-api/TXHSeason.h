//
//  TXHSeason.h
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 12/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//
//  Representation of a season

@import Foundation;

@class TXHOption;

@interface TXHSeason : NSObject

@property (strong, readonly, nonatomic) NSString *startsOnDateString;
@property (strong, readonly, nonatomic) NSString *endsOnDateString;
@property (copy, readonly, nonatomic) NSArray *seasonalOptions;

+ (instancetype)createWithDictionary:(NSDictionary *)dictionary;

@end
