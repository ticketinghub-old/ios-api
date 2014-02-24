#import "TXHTicket.h"

static NSString * const kIdKey        = @"id";
static NSString * const kBitmaskKey   = @"bitmask";
static NSString * const kCodeKey      = @"code";
static NSString * const kCustomerKey  = @"customer";
static NSString * const kExpiresAtKey = @"expires_at";
static NSString * const kPriceKey     = @"price";
static NSString * const kValidFromKey = @"valid_from";
static NSString * const kVoucherKey   = @"voucher";

#define nilIfNSNull(x) x != [NSNull null] ? x : nil

@interface TXHTicket ()

// Private interface goes here.

@end


@implementation TXHTicket

+ (instancetype)createWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc
{
    if (![dictionary count]) {
        return nil;
    }
    
    TXHTicket *ticket= [TXHTicket insertInManagedObjectContext:moc];
    
    ticket.ticketId  = nilIfNSNull(dictionary[kIdKey]);
    ticket.bitmask   = nilIfNSNull(dictionary[kBitmaskKey]);
    ticket.code      = nilIfNSNull(dictionary[kCodeKey]);
    ticket.customer  = nilIfNSNull(dictionary[kCustomerKey]);
    ticket.expiresAt = nilIfNSNull(dictionary[kExpiresAtKey]);
    ticket.price     = nilIfNSNull(dictionary[kPriceKey]);
    ticket.validFrom = nilIfNSNull(dictionary[kValidFromKey]);
    ticket.voucher   = nilIfNSNull(dictionary[kVoucherKey]);
    
    return ticket;
}
@end
