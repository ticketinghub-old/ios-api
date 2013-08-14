//
//  TXHSeasonSpec.m
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 13/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#define EXP_SHORTHAND

#import "Specta.h"
#import "Expecta.h"

SpecBegin(TXHSeason)

__block NSDictionary *_season;
__block NSDictionary *_option1;
__block NSDictionary *_option2;
__block NSDictionary *_variation1;
__block NSDictionary *_variation2;

before(^{
    _option1 = @{@"time" : @"09:00",
                 @"wday" : @1};

    _option2 = @{@"time" : @"10:00",
                 @"wday" : @1};

    _variation1 = @{@"date" : @"2013-07-31",
                    @"options" : @[@{@"time" : @"13:00"}]};

    _variation2 = @{@"date" : @"2013-12-25",
                    @"options" : @[]};

    _season = @{@"ends_on" : @"2013-12-31",
                @"starts_on" : @"2013-07-01",
                @"options" : @[_option1, _option2]};
});

SpecEnd
