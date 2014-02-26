//
//  TXHField.m
//  iOS-api
//
//  Created by Bartek Hugo Trzcinski on 25/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHField.h"

static NSString * const kNameKey      = @"name";
static NSString * const kLabelKey     = @"label";
static NSString * const kDataTypeKey  = @"data_type";
static NSString * const kInputTypeKey = @"input_type";
static NSString * const kOptionsKey   = @"options";

@implementation TXHField

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (!(self = [super init]))
        return nil;
    
    self.name      = dictionary[kNameKey];
    self.label     = dictionary[kLabelKey];
    self.dataType  = dictionary[kDataTypeKey];
    self.inputType = dictionary[kInputTypeKey];
    self.options   = dictionary[kOptionsKey];    
    
    return self;
}

@end
