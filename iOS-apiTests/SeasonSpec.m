//
//  SeasonSpec.m
//  iOS-api
//
//  Created by Abizer Nasir on 11/11/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSeason.h"
#import "TXHOption.h"

SpecBegin(Season)

__block NSArray *_responseArray;
__block NSDictionary *_seasonDictionary;
__block TXHSeason *_season;

beforeAll(^{
    NSBundle *testsBundle = [NSBundle bundleForClass:[self class]];
    NSURL *fileURL = [testsBundle URLForResource:@"Seasons" withExtension:@"json"];
    NSData *responseData = [NSData dataWithContentsOfURL:fileURL];
    _responseArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    _seasonDictionary = [_responseArray firstObject];

});

afterAll(^{
    _seasonDictionary = nil;
    _responseArray = nil;
});

describe(@"createWithDictionary:", ^{
    context(@"with a valid dictionary", ^{
        before(^{
            _season = [TXHSeason createWithDictionary:_seasonDictionary];
        });

        after(^{
            _season = nil;
        });

        it(@"should return a valid season object", ^{
            expect(_season).to.beKindOf([TXHSeason class]);
            expect(_season.startsOnDateString).to.equal(@"2013-09-01");
            expect(_season.endsOnDateString).to.equal(@"2014-03-31");
        });

        it(@"should contain an array of TXHOptions", ^{
            expect(_season.seasonalOptions).to.haveCountOf(1);

            TXHOption *option = _season.seasonalOptions[0];
            expect(option.duration).to.equal(@"P0MT8H");
            expect(option.timeString).to.equal(@"09:00");
            expect(option.weekday).to.equal(1);
        });
    });

    context(@"with a season that has no options", ^{
        before(^{
            _season = [TXHSeason createWithDictionary:[_responseArray lastObject]];
        });

        after(^{
            _season = nil;
        });

        it(@"should return a valid season object", ^{
            expect(_season).to.beKindOf([TXHSeason class]);
            expect(_season.startsOnDateString).to.equal(@"2014-04-01");
            expect(_season.endsOnDateString).to.equal(@"2014-08-31");
        });

        it(@"should have a nil options array", ^{
            expect(_season.seasonalOptions).to.beNil();
        });
    });

    context(@"with an empty seasons dictionary", ^{
        before(^{
            _season = [TXHSeason createWithDictionary:@{}];
        });

        after(^{
            _season = nil;
        });

        it(@"should return nil", ^{
            expect(_season).to.beNil();
        });
    });
});

SpecEnd
