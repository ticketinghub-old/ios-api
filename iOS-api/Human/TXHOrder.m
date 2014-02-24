#import "TXHOrder.h"

#import "TXHAddress.h"
#import "TXHTicket.h"

NSString * const kIdKey        = @"id";
NSString * const kReferenceKey = @"reference";
NSString * const kCurrencyKey  = @"currency";
NSString * const kTotalKey     = @"total";
NSString * const kPostageKey   = @"postage";
NSString * const kTaxKey       = @"tax";
NSString * const kTaxNameKey   = @"tax_name";
NSString * const kDeliveryKey  = @"delivery";
NSString * const kAddressKey   = @"address";
NSString * const kCustomerKey  = @"customer";
NSString * const kCouponKey    = @"coupon";
NSString * const kPaymentKey   = @"payment";
NSString * const kTicketsKey   = @"tickets";

#define nilIfNSNull(x) x != [NSNull null] ? x : nil


@interface TXHOrder ()

// Private interface goes here.

@end


@implementation TXHOrder

+ (instancetype)createWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc
{
    if (![dictionary count])
        return nil;
    
    TXHOrder *order = [TXHOrder insertInManagedObjectContext:moc];
    
    order.orderId   = nilIfNSNull(dictionary[kIdKey]);
    order.reference = nilIfNSNull(dictionary[kReferenceKey]);
    order.currency  = nilIfNSNull(dictionary[kCurrencyKey]);
    order.total     = nilIfNSNull(dictionary[kTotalKey]);
    order.postage   = nilIfNSNull(dictionary[kPostageKey]);
    order.tax       = nilIfNSNull(dictionary[kTaxKey]);
    order.taxName   = nilIfNSNull(dictionary[kTaxNameKey]);
    order.delivery  = nilIfNSNull(dictionary[kDeliveryKey]);
//    order.coupon    = dictionary[kCouponKey];
//    order.payment   = dictionary[kPaymentKey];
    
//    order.address = [TXHAddress createWithDictionary:dictionary[kAddressKey] inManagedObjectContext:moc];
//    
//    NSArray *tickets = dictionary[kTicketsKey];
//    for (NSDictionary *ticketDictionary in tickets)
//    {
//        TXHTicket *ticket = [TXHTicket createWithDictionary:ticketDictionary inManagedObjectContext:moc];
//        ticket.order = order;
//    }
    
    // TODO: customer creation
    
    return order;
}

@end
