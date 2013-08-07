//
//  TXHUser.h
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 06/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//
//  Represents a user

@import Foundation;

@interface TXHUser : NSObject

@property (copy, readonly, nonatomic) NSString *firstName;
@property (copy, readonly, nonatomic) NSString *lastName;
@property (copy, readonly, nonatomic) NSString *email;

+ (instancetype)createWithDictionary:(NSDictionary *)dictionary;

@end
