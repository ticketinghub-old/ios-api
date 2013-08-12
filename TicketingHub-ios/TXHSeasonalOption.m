//
//  TXHSeasonalOption.m
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 12/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSeasonalOption.h"

@interface TXHSeasonalOption ()

@property (assign, nonatomic) NSUInteger weekday;
@property (strong, nonatomic) NSString *timeString;
@property (assign, nonatomic) NSTimeInterval duration;

@end

@implementation TXHSeasonalOption

#pragma  mark - Convenience constructor

+ (instancetype)optionWithWeekday:(NSUInteger)aWeekday timeString:(NSString *)aTimeString duration:(NSTimeInterval)aDuration {

    TXHSeasonalOption *option = [[self alloc] init];

    if (!option) {
        return nil; // Bail!
    }

    option.weekday = aWeekday;
    option.timeString = aTimeString;
    option.duration = aDuration;

    return option;
}

@end
