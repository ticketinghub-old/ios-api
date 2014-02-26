//
//  TXHField.h
//  iOS-api
//
//  Created by Bartek Hugo Trzcinski on 25/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXHField : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *dataType;
@property (nonatomic, copy) NSString *inputType;
@property (nonatomic, copy) NSArray *options;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
