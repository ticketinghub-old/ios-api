//
//  TXHVariation.h
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 14/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

@import Foundation;

@interface TXHVariation : NSObject

@property (copy, readonly, nonatomic) NSString *dateString;
@property (copy, readonly, nonatomic) NSArray *options;

+ (instancetype)createWithDictionary:(NSDictionary *)dictionary;

@end
