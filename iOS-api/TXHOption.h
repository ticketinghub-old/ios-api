//
//  TXHOption.h
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 12/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//
//  Options within a season

@import Foundation;

@interface TXHOption : NSObject

@property (assign, readonly, nonatomic) NSUInteger weekday;
@property (copy, readonly, nonatomic) NSString *timeString;
@property (copy, readonly, nonatomic) NSString *duration;

+ (instancetype)createWithDictionary:(NSDictionary *)dictionary;

@end
