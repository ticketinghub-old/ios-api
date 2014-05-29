//
//  TXHEndpointsHelper.h
//  iOS-api
//
//  Created by Bartek Hugo Trzcinski on 30/04/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TXHEndpoint)
{
    // IMPORTANT: order of parameters in the array is very crucial
    
    SuppliersEndpoint,                          //
    UserEndpoint,                               //
    ProductTiersEndpointFormat,                 // requires 1 parameter: productID
    ProductAvailabilitiesEndpointForamt,        // requires 1 parameter: productID
    ReserveOrderTicketsEndpoint,                //
    RemoveOrderTicketsEndpointFormat,           // requires 1 parameter: orderID
    TicketUpgradesEndpointFormat,               // requires 1 parameter: ticketID
    TicketFieldsEndpointFormat,                 // requires 1 parameter: ticketID
    UpdateOrderEndpointFormat,                  // requires 1 parameter: orderID
    TicketOwnerFieldsEndpointFormat,            // requires 1 parameter: orderID
    OrderEndpointFormat,                        // requires 1 parameter: orderID
    ConfirmOrderEndpointFormat,                 // requires 1 parameter: orderID
    TicketsWithParamsEndpointFormat,            // requires 1 parameter: productID
    UnattendProductTicketEndpointFormat,        // requires 2 parameters: productID, ticketID
    AttendProductTicketEndpointFormat,          // requires 2 parameters: productID, ticketID
    ProductTicketForSeqIdEndpointFormat,        // requires 2 parameters: productID, ticketID
    OrderForTicketProductEndpointFormat,        // requires 2 parameters: productID, ticketID
    OrdersForMSRCardTrackDataEndpoint,          //
    OrderReceiptEndpointFormat,                 // requires 2 parameters: orderID, receiptType (pdf, ps, png)
    TicketTemplatesEndpoint,                    //
    OrderTicketsForTemplateEndpoint,            // requires 2 parameters: orderID, ticketFormat (pdf, ps, png), templeatID
    PaymentGatewaysEndpoint,                    //
    AvailableDatesSearch,                       // requires 1 parameter: productID
    ProductAvailabilitiesForDateAndTickets,     // requires 2 parameters: productID, datestring (yyyy-mm-dd)
    ProductTicketsSearch,                       // requires 1 parameter: productID
    OrderAttenAll,                              // requires 1 parameter: orderID
};

typedef NS_ENUM(NSInteger, TXHEndpointHTTPMethod)
{
    UnknownMethod,
    GETMethod,
    POSTMethod,
    DELETEMethod,
    PATCHMethod,
    DownloadTaskMethod,
};

@interface TXHEndpointsHelper : NSObject

+ (NSString *)endpointStringForTXHEndpoint:(TXHEndpoint)endpoint;
+ (NSString *)endpointStringForTXHEndpoint:(TXHEndpoint)endpoint parameters:(NSArray *)params;

@end
