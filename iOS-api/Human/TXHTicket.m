#import "TXHTicket.h"

#import "TXHCustomer.h"
#import "TXHProduct.h"
#import "NSDateFormatter+TicketingHubFormat.h"

static NSString * const kIdKey        = @"id";
static NSString * const kBitmaskKey   = @"bitmask";
static NSString * const kCodeKey      = @"code";
static NSString * const kCustomerKey  = @"customer";
static NSString * const kExpiresAtKey = @"expires_at";
static NSString * const kPriceKey     = @"price";
static NSString * const kValidFromKey = @"valid_from";
static NSString * const kVoucherKey   = @"voucher";
static NSString * const kProductKey   = @"product";


@interface TXHTicket ()

// Private interface goes here.

@end


@implementation TXHTicket

+ (instancetype)createWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc
{
    if (![dictionary isKindOfClass:[NSDictionary class]] || ![dictionary count])
        return nil;
    
    TXHTicket *ticket= [TXHTicket insertInManagedObjectContext:moc];
    
    ticket.ticketId  = nilIfNSNull(dictionary[kIdKey]);
    ticket.bitmask   = nilIfNSNull(dictionary[kBitmaskKey]);
    ticket.code      = nilIfNSNull(dictionary[kCodeKey]);
    ticket.price     = nilIfNSNull(dictionary[kPriceKey]);
    ticket.voucher   = nilIfNSNull(dictionary[kVoucherKey]);
    ticket.expiresAt = [NSDateFormatter txh_dateFromString:nilIfNSNull(dictionary[kExpiresAtKey])];
    ticket.validFrom = [NSDateFormatter txh_dateFromString:nilIfNSNull(dictionary[kValidFromKey])];

    NSDictionary *ticketDictionary  = nilIfNSNull(dictionary[kCustomerKey]);
    ticket.customer = [TXHCustomer createWithDictionary:ticketDictionary inManagedObjectContext:moc];

    NSDictionary *productDictionary  = nilIfNSNull(dictionary[kProductKey]);
    ticket.product = [TXHProduct createWithDictionary:productDictionary inManagedObjectContext:moc];
    
    return ticket;
}
@end
