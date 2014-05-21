//
//  JSONResponseSerializerWithData.h
//  iOS-api
//
//  Created by Greg Fiumara on 26/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "AFURLResponseSerialization.h"

/// NSError userInfo key that will contain response data
extern NSString * const JSONResponseSerializerWithDataKey;

@interface JSONResponseSerializerWithData : AFJSONResponseSerializer
@end
