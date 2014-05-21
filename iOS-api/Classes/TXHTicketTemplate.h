//
//  TXHTicketTemplate.h
//  iOS-api
//
//  Created by Bartek Hugo Trzcinski on 28/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXHTicketTemplate : NSObject

@property (nonatomic, copy) NSString *templateId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSNumber *width;
@property (nonatomic, copy) NSNumber *height;

- (instancetype)initWithDictionary:(NSDictionary *)dicRepresentation;

@end
