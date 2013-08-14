//
//  TXHSeasonSpec.m
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 12/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#define EXP_SHORTHAND

#import "Specta.h"
#import "Expecta.h"

#import "OHHTTPStubs.h"
#import "TXHSeason.h"
#import "TXHSeasonalOption.h"

SpecBegin(TXHSeason)

__block NSDictionary *_seasonDictionary;
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

    _seasonDictionary = @{@"ends_on" : @"2013-12-31",
                @"starts_on" : @"2013-07-01",
                @"options" : @[_option1, _option2]};
});

describe(@"TXHSeason", ^{
    __block TXHSeason *_season;

    before(^{
        _season = [TXHSeason createWithDictionary:_seasonDictionary];
    });

    after(^{
        _season = nil;
    });

    it(@"can be properly created with a response dictionary", ^{
        expect(_season).toNot.beNil();
        expect(_season.startsOnDateString).to.equal(_seasonDictionary[@"starts_on"]);
        expect(_season.endsOnDateString).to.equal(_seasonDictionary[@"ends_on"]);
        expect([_season.seasonalOptions count]).to.equal(2);

        TXHSeasonalOption *option1 = _season.seasonalOptions[0];
        expect(option1.timeString).to.equal(_option1[@"time"]);
        expect(option1.weekday).to.equal([_option1[@"wday"] integerValue]);
    });
});

SpecEnd
