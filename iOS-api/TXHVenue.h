//
//  TXHVenue.h
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 07/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//
//  Represents a venue

@import Foundation;
@import CoreLocation;

@interface TXHVenue : NSObject

@property (assign, readonly, nonatomic) NSUInteger venueId;
@property (copy, readonly, nonatomic) NSString *venueName;
@property (copy, readonly, nonatomic) NSString *token;

//@property (copy, readonly, nonatomic) NSString *street1;
//@property (copy, readonly, nonatomic) NSString *street2;
//@property (copy, readonly, nonatomic) NSString *city;
//@property (copy, readonly, nonatomic) NSString *region;
//@property (copy, readonly, nonatomic) NSString *postcode;
//@property (copy, readonly, nonatomic) NSString *country;
//
//@property (assign, readonly, nonatomic) CLLocationCoordinate2D locationCoordinates;

@property (copy, readonly, nonatomic) NSString *currency;
@property (copy, readonly, nonatomic) NSString *timeZoneName;

//@property (copy, readonly, nonatomic) NSString *website;
//@property (copy, readonly, nonatomic) NSString *email;
//@property (copy, readonly, nonatomic) NSString *telephone;
//
//@property (copy, readonly, nonatomic) NSString *establishmentType;

//@property (copy, readonly, nonatomic) NSString *stripePublishableKey;
//@property (copy, readonly, nonatomic) NSArray *permissions;

+ (instancetype)createWithDictionary:(NSDictionary *)dictionary;

@end
