//
//  TXHSeasonalOption.h
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 12/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//
//  Options within a season

#import <Foundation/Foundation.h>

@interface TXHSeasonalOption : NSObject

@property (assign, readonly, nonatomic) NSUInteger weekday;
@property (strong, readonly, nonatomic) NSString *timeString;
@property (assign, readonly, nonatomic) NSTimeInterval duration;

+ (instancetype)createWithDictionary:(NSDictionary *)dictionary;

@end
