//
//  TXHUser.m
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 06/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHUser.h"

#import "NSDictionary+JCSKeyMapping.h"

@interface TXHUser ()

// strong, not copy because this is a lazily loaded convenience dictionary.
@property (strong, nonatomic) NSDictionary *mappingDictionary;

@end

@implementation TXHUser

#pragma mark - Class methods

+ (instancetype)createWithDictionary:(NSDictionary *)dictionary {
    TXHUser *user = [[[self class] alloc] init];

    if (!user) {
        return nil; // Bail!
    }

    NSDictionary *mappedDictionary = [dictionary jcsRemapKeysWithMapping:[self mappingDictionary] removingNullValues:NO];

    [user setValuesForKeysWithDictionary:mappedDictionary];

    return user;
}

#pragma mark - Superclass overrides

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // Rather than crash when trying to set undefined key values, do nothing;
    NSLog(@"Trying to set value: %@, for undefined key: %@", value, key);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"firstName: %@, lastName: %@, email: %@", self.firstName, self.lastName, self.email];
}

#pragma mark - Private methods

// Maps the parameters from the input dictionary to the property names of the class
+ (NSDictionary *)mappingDictionary {
    static NSDictionary *dictionary = nil;

    if (!dictionary) {
        dictionary = @{@"first_name": @"firstName", @"last_name" : @"lastName"};
    }

    return dictionary;
}


@end
