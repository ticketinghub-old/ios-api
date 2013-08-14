//
//  TXHSeason.m
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 12/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSeason.h"

#import "TXHSeasonalOption.h"

@interface TXHSeason ()

@property (strong, nonatomic) NSString *startsOnDateString;
@property (strong, nonatomic) NSString *endsOnDateString;
@property (copy, nonatomic) NSArray *options;

@end

@implementation TXHSeason

#pragma mark - Convenience Constructor

+ (instancetype)seasonWithStartDate:(NSString *)aStartDate endDate:(NSString *)anEndDate options:(NSArray *)optionsArray {
    TXHSeason *season = [[self alloc] init];

    if (!season) {
        return nil; // Bail!
    }

    season.startsOnDateString = aStartDate;
    season.endsOnDateString = anEndDate;
    season.options = optionsArray;

    return season;
}

#pragma mark - Public methods

- (void)addOption:(TXHSeasonalOption *)aSeasonalOption {
    if (!aSeasonalOption) {
        return;
    }

    NSMutableArray *options = [self.options mutableCopy];
    [options addObject:aSeasonalOption];
    self.options = options;

}

@end
