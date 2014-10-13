//
//  NSError+TXHAPIClient.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 28/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const TXHAPIClientErrorDomain;

typedef NS_ENUM(NSInteger, TXHAPIClientErrorCode)
{
    kTXHAPIClientArgsInconsistencyError = 20000,
};

@interface NSError (TXHAPIClient)

+ (NSError *)clientErrorWithCode:(TXHAPIClientErrorCode)errorCode;

- (NSString *)errorDescription;

@end
