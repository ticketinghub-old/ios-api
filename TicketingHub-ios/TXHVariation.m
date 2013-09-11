//
//  TXHVariation.m
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 14/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHVariation.h"

#import "TXHOption.h"

@interface TXHVariation ()

// Redclare public property
@property (copy, nonatomic) NSString *dateString;


@property (strong, nonatomic) NSMutableSet *optionsSet;

@end

@implementation TXHVariation

#pragma  mark - Convenience constructor

+ (instancetype)createWithDictionary:(NSDictionary *)dictionary {
    TXHVariation *variation = [[self alloc] init];

    if (!variation) {
        return nil; // Bail!
    }

    variation.dateString = dictionary[@"date"];
    for (NSDictionary *optionDictionary in dictionary[@"options"]) {
        TXHOption *option = [TXHOption createWithDictionary:optionDictionary];
        if (option) {
            [variation.optionsSet addObject:option];
        }
    }

    return variation;
}

#pragma mark - Public methods

- (id)init {
    if (!(self = [super init])) {
        return nil; // Bail!
    }

    _optionsSet = [NSMutableSet set];

    return self;
}

#pragma mark - Custom accessors

- (NSArray *)options {
    return [self.optionsSet allObjects];
}

@end
