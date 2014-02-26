#import "TXHOrder.h"
#import "TXHDefines.h"

#import "TXHAddress.h"
#import "TXHTicket.h"
#import "TXHCustomer.h"
#import "NSDateFormatter+TicketingHubFormat.h"

static NSString * const kIdKey          = @"id";
static NSString * const kReferenceKey   = @"reference";
static NSString * const kCurrencyKey    = @"currency";
static NSString * const kTotalKey       = @"total";
static NSString * const kPostageKey     = @"postage";
static NSString * const kTaxKey         = @"tax";
static NSString * const kTaxNameKey     = @"tax_name";
static NSString * const kDeliveryKey    = @"delivery";
static NSString * const kAddressKey     = @"address";
static NSString * const kCustomerKey    = @"customer";
static NSString * const kCouponKey      = @"coupon";
static NSString * const kPaymentKey     = @"payment";
static NSString * const kTicketsKey     = @"tickets";
static NSString * const kUpdatedAtKey   = @"updated_at";
static NSString * const kCreatedAtKey   = @"created_at";
static NSString * const kCanceledAtKey  = @"cancelled_at";
static NSString * const kExpiresAtKey   = @"expires_at";
static NSString * const kConfirmedAtKey = @"confirmed_at";


@interface TXHOrder ()

// Private interface goes here.

@end


@implementation TXHOrder

+ (instancetype)updateWithDictionaryOrCreateIfNeeded:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc
{
    NSString *orderId = dictionary[kIdKey];
    
    TXHOrder *order = [self orderWithID:orderId inManagedObjectContext:moc];
    if (!order) {
        order = [TXHOrder insertInManagedObjectContext:moc];
    }
    
    [order updateWithDictionary:dictionary inManagedObjectContext:moc];
    
    return order;
}

+ (instancetype)orderWithID:(NSString *)orderID inManagedObjectContext:(NSManagedObjectContext *)moc {
    NSParameterAssert(orderID);
    NSParameterAssert(moc);
    
    static NSPredicate *formattedPredicate = nil;
    if (!formattedPredicate) {
        formattedPredicate = [NSPredicate predicateWithFormat:@"orderId == $ORDER_ID"];
    }
    
    NSDictionary *variables = @{@"ORDER_ID" : orderID};
    
    NSPredicate *predicate = [formattedPredicate predicateWithSubstitutionVariables:variables];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    [request setPredicate:predicate];
    
    NSArray *orders = [moc executeFetchRequest:request error:NULL];
    
    if (!orderID) {
        return nil;
    }
    
    return [orders firstObject];
}

- (id)updateWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc
{
    if (![dictionary isKindOfClass:[NSDictionary class]] || ![dictionary count])
        return nil;
    
    self.orderId     = nilIfNSNull(dictionary[kIdKey]);
    self.reference   = nilIfNSNull(dictionary[kReferenceKey]);
    self.currency    = nilIfNSNull(dictionary[kCurrencyKey]);
    self.total       = nilIfNSNull(dictionary[kTotalKey]);
    self.postage     = nilIfNSNull(dictionary[kPostageKey]);
    self.tax         = nilIfNSNull(dictionary[kTaxKey]);
    self.taxName     = nilIfNSNull(dictionary[kTaxNameKey]);
    self.delivery    = nilIfNSNull(dictionary[kDeliveryKey]);
    self.coupon      = nilIfNSNull(dictionary[kCouponKey]);
    self.expiresAt   = [NSDateFormatter txh_dateFromString:nilIfNSNull(dictionary[kExpiresAtKey])];
    self.updatedAt   = [NSDateFormatter txh_dateFromString:nilIfNSNull(dictionary[kUpdatedAtKey])];
    self.createdAt   = [NSDateFormatter txh_dateFromString:nilIfNSNull(dictionary[kCreatedAtKey])];
    self.cancelledAt = [NSDateFormatter txh_dateFromString:nilIfNSNull(dictionary[kCanceledAtKey])];
    self.confirmedAt = [NSDateFormatter txh_dateFromString:nilIfNSNull(dictionary[kConfirmedAtKey])];
    
    NSDictionary *ticketDictionary  = nilIfNSNull(dictionary[kCustomerKey]);
    self.customer = [TXHCustomer createWithDictionary:ticketDictionary inManagedObjectContext:moc];

    NSDictionary *addressDictionary  = nilIfNSNull(dictionary[kAddressKey]);
    self.address = [TXHAddress createWithDictionary:addressDictionary inManagedObjectContext:moc];

    NSArray *tickets = nilIfNSNull(dictionary[kTicketsKey]);
    [self removeTickets:self.tickets];
    
    for (NSDictionary *ticketDictionary in tickets)
    {
        TXHTicket *ticket = [TXHTicket createWithDictionary:ticketDictionary inManagedObjectContext:moc];
        if (ticket)
        {
            [self addTicketsObject:ticket];
        }
    }
    
    return self;
}

@end
