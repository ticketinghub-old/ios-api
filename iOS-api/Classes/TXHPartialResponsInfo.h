//
//  TXHPartialResponsInfo.h
//  iOS-api
//
//  Created by Bartek Hugo Trzcinski on 27/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXHPartialResponsInfo : NSObject

@property (nonatomic, assign, readonly) BOOL hasMore;
@property (nonatomic, strong, readonly) NSString *range;

- (instancetype)initWithNSURLResponse:(NSURLResponse *)response;


@end
