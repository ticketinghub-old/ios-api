//
//  NSDictionary+JCSKeyMapping.m
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 06/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "NSDictionary+JCSKeyMapping.h"

@implementation NSDictionary (JCSKeyMapping)


- (NSDictionary *)jcsRemapKeysWithMapping:(NSDictionary *)keyMapping removingNullValues:(BOOL)removeNulls {
    __block NSMutableDictionary *newDictionary = [[NSMutableDictionary alloc] initWithCapacity:[self count]];

    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (removeNulls) {
            if ([obj isEqual:[NSNull null]]) return;
        }

        id newKey = keyMapping[key];
        if (!newKey) {
            [newDictionary setObject:obj forKey:key];
        } else {
            [newDictionary setObject:obj forKey:newKey];
        }
    }];

    return [newDictionary copy];
}

@end
