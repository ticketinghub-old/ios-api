//
//  JSONResponseSerializerWithData.m
//  iOS-api
//
//  Created by Greg Fiumara on 26/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "JSONResponseSerializerWithData.h"

NSString * const JSONResponseSerializerWithDataKey = @"JSONResponseSerializerWithDataKey";

@implementation JSONResponseSerializerWithData

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
	id JSONObject = [super responseObjectForResponse:response data:data error:error];
	if (*error != nil) {
		NSMutableDictionary *userInfo = [(*error).userInfo mutableCopy];
        if (data == nil) {
            id json = [NSJSONSerialization JSONObjectWithData:[NSData data] options:0 error:nil];
            userInfo[JSONResponseSerializerWithDataKey] = json;
		} else {
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            userInfo[JSONResponseSerializerWithDataKey] = json;
		}
		NSError *newError = [NSError errorWithDomain:(*error).domain code:(*error).code userInfo:userInfo];
		(*error) = newError;
	}
    
	return (JSONObject);
}

@end
