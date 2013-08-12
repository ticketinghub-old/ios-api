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
@property (strong, nonatomic) NSArray *options;

@end

@implementation TXHSeason

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

@end
