//
//  TXHTicketTemplate.m
//  iOS-api
//
//  Created by Bartek Hugo Trzcinski on 28/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHTicketTemplate.h"

static NSString * const kTemplateIdKey     = @"id";
static NSString * const kTemplateNameKey   = @"name";
static NSString * const kTemplateWidthKey  = @"width";
static NSString * const kTemplateHeightKey = @"height";

@implementation TXHTicketTemplate

- (instancetype)initWithDictionary:(NSDictionary *)dicRepresentation
{
    if (!dicRepresentation || ![dicRepresentation count])
        return nil;
    
    if (!(self = [super init]))
        return nil;
    
    self.templateId = dicRepresentation[kTemplateIdKey];
    self.name       = dicRepresentation[kTemplateNameKey];
    self.width      = dicRepresentation[kTemplateWidthKey];
    self.height     = dicRepresentation[kTemplateHeightKey];
    
    return self;
}

@end
