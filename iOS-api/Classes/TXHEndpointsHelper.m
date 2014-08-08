//
//  TXHEndpointsHelper.m
//  iOS-api
//
//  Created by Bartek Hugo Trzcinski on 30/04/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHEndpointsHelper.h"


@implementation TXHEndpointsHelper

+ (NSString *)endpointStringForTXHEndpoint:(TXHEndpoint)endpoint parameters:(NSArray *)params
{
    NSString *format = [self endpointFormatForTXHEndpoint:endpoint];
    
    NSRange range = NSMakeRange(0, [params count]);
    NSMutableData* data = [NSMutableData dataWithLength: sizeof(id) * [params count]];
    
    [params getObjects:(__unsafe_unretained id *)data.mutableBytes range:range];
    
    NSString* result = [[NSString alloc] initWithFormat:format arguments:data.mutableBytes];
    return result;
}

+ (NSString *)endpointStringForTXHEndpoint:(TXHEndpoint)endpoint
{
    return [self endpointStringForTXHEndpoint:endpoint parameters:nil];
}

+ (NSString *)endpointFormatForTXHEndpoint:(TXHEndpoint)endpoint
{
    switch (endpoint)
    {
        case SuppliersEndpoint:                     return @"user/suppliers";
        case UserEndpoint:                          return @"user";
        case UserTokenEndpoint:                     return @"user/token";
        case ProductsForSupplierEndpointFormat:     return @"supplier/products";
        case ProductTiersEndpointFormat:            return @"supplier/products/%@/tiers";
        case ProductAvailabilitiesEndpointForamt:   return @"supplier/products/%@/availability";
        case ProductAvailabilitiesForDateAndTickets:return @"supplier/products/%@/options/available/dates/%@/times/search.json";
        case TicketsForOrderEndpointFormat:         return @"supplier/orders/%@/tickets";
        case ReserveOrderTicketsEndpoint:           return @"supplier/orders";
        case RemoveOrderTicketsEndpointFormat:      return @"supplier/orders/%@";
        case TicketAvailableUpgradesEndpointFormat: return @"supplier/tickets/%@/available/upgrades";
        case TicketUpgradesEndpointFormat:          return @"supplier/tickets/%@/upgrades";
        case TicketFieldsEndpointFormat:            return @"supplier/tickets/%@/fields";
        case UpdateOrderEndpointFormat:             return @"supplier/orders/%@";
        case TicketOwnerFieldsEndpointFormat:       return @"supplier/orders/%@/fields";
        case OrderEndpointFormat:                   return @"supplier/orders/%@";
        case ConfirmOrderEndpointFormat:            return @"supplier/orders/%@/confirm";
        case TicketsWithParamsEndpointFormat:       return @"supplier/products/%@/tickets";
        case UnattendProductTicketEndpointFormat:   return @"supplier/products/%@/tickets/%@/attend";
        case AttendProductTicketEndpointFormat:     return @"supplier/products/%@/tickets/%@/attend";
        case ProductTicketForSeqIdEndpointFormat:   return @"supplier/products/%@/tickets/%@";
        case OrderForTicketProductEndpointFormat:   return @"supplier/tickets/%@/order";
        case OrdersForMSRCardTrackDataEndpoint:     return @"supplier/orders/search.json";
        case OrderReceiptEndpointFormat:            return @"supplier/orders/%@/receipt.%@";
        case TicketTemplatesEndpoint:               return @"supplier/templates";
        case OrderTicketsForTemplateEndpoint:       return @"supplier/orders/%@/tickets.%@?template=%@";
        case TicketImageForTemplateEndpoint:        return @"supplier/tickets/%@.%@?template=%@&dpi=%@";
        case PaymentGatewaysEndpoint:               return @"supplier/gateways.json";
        case AvailableDatesSearch:                  return @"supplier/products/%@/options/available/dates/search";
        case ProductTicketsSearch:                  return @"supplier/products/%@/tickets/search.json";
        case OrderAttenAll:                         return @"supplier/orders/%@/tickets/attend";
        case SummaryEndpointFormat:                 return @"user/summary.%@?access_token=%@";
    }
    return nil;
}

+ (TXHEndpointHTTPMethod)httpMethodForEndpoint:(TXHEndpoint)endpoint
{
    switch (endpoint) {
        case SuppliersEndpoint:
        case UserEndpoint:
        case ProductTiersEndpointFormat:
        case ProductAvailabilitiesEndpointForamt:
        case TicketAvailableUpgradesEndpointFormat:
        case TicketUpgradesEndpointFormat:
        case TicketFieldsEndpointFormat:
        case TicketOwnerFieldsEndpointFormat:
        case OrderEndpointFormat:
        case TicketsWithParamsEndpointFormat:
        case ProductTicketForSeqIdEndpointFormat:
        case OrderForTicketProductEndpointFormat:
        case PaymentGatewaysEndpoint:
        case TicketTemplatesEndpoint:
        case TicketsForOrderEndpointFormat:
        case ProductsForSupplierEndpointFormat:
            return GETMethod;
            
        case ReserveOrderTicketsEndpoint:
        case ConfirmOrderEndpointFormat:
        case AttendProductTicketEndpointFormat:
        case OrdersForMSRCardTrackDataEndpoint:
        case AvailableDatesSearch:
        case ProductAvailabilitiesForDateAndTickets:
        case ProductTicketsSearch:
        case OrderAttenAll:
        case UserTokenEndpoint:
            return POSTMethod;
        
        case RemoveOrderTicketsEndpointFormat:
        case UpdateOrderEndpointFormat:
            return PATCHMethod;
            
        case UnattendProductTicketEndpointFormat:
            return DELETEMethod;

        case OrderReceiptEndpointFormat:
        case OrderTicketsForTemplateEndpoint:
        case TicketImageForTemplateEndpoint:
            
        default:
            break;
    }
    
    return UnknownMethod;
}






@end
