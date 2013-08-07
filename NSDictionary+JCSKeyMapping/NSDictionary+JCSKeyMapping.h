//
//  NSDictionary+JCSKeyMapping.h
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 06/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

@import Foundation;

@interface NSDictionary (JCSKeyMapping)

/*! A category method that replaces the keys in the receiver with the new key provided in the keyMapping
 *
 *  If no mapping is provided for a key, the key is left unchanged.
 *  \param keymapping a dictionary which maps the existing key to the new key. If no mapping is provided for a key it is unchanged.
 *  \param removeNulls If YES, then if the value for a key in the receiver is [NSNull null], then it is not in the returned dictionary.
 *  \returns A new NSDictionary with the keys changed according to the mapping, on optionally with [NSNull null] values removed.
 */
- (NSDictionary *)jcsRemapKeysWithMapping:(NSDictionary *)keyMapping removingNullValues:(BOOL)removeNulls;

@end
