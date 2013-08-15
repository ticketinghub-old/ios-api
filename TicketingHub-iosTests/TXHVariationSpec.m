//
//  TXHVariationSpec.m
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 15/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#define EXP_SHORTHAND

#import "Specta.h"
#import "Expecta.h"

#import "TXHOption.h"
#import "TXHVariation.h"

SpecBegin(TXHVariation)

__block NSDictionary *_variation1;
__block NSDictionary *_variation2;

beforeAll(^{
    _variation1 = @{@"date" : @"2013-07-31",
                    @"options" : @[@{@"time" : @"13:00"}, @{@"time" : @"17:00"}]};

    _variation2 = @{@"date" : @"2013-12-25",
                    @"options" : @[]};

});

describe(@"TXHVariation", ^{
    it(@"can be created from a dictionary", ^{
        TXHVariation *variation = [TXHVariation createWithDictionary:_variation1];
        NSArray *options = variation.options;

        expect(variation.dateString).to.equal(_variation1[@"date"]);
        expect([options count]).to.equal(2);
        expect(options[0]).to.beKindOf([TXHOption class]);
        expect(options[1]).to.beKindOf([TXHOption class]);
    });

    it(@"has an empty array for nil options for a date", ^{
        TXHVariation *variation = [TXHVariation createWithDictionary:_variation2];
        NSArray *options = variation.options;

        expect(variation.dateString).to.equal(_variation2[@"date"]);
        expect(options).to.beKindOf([NSArray class]);
        expect([options count]).to.equal(0);
    });
});

SpecEnd
