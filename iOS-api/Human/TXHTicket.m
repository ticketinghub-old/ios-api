#import "TXHTicket.h"
#import "TXHDefines.h"

#import "TXHCustomer.h"
#import "TXHProduct.h"
#import "TXHTier.h"
#import "TXHUpgrade.h"

#import "NSDateFormatter+TicketingHubFormat.h"

static NSString * const kIdKey         = @"id";
static NSString * const kBitmaskKey    = @"bitmask";
static NSString * const kCodeKey       = @"code";
static NSString * const kCustomerKey   = @"customer";
static NSString * const kExpiresAtKey  = @"expires_at";
static NSString * const kAttendedAtKey = @"attended_at";
static NSString * const kPriceKey      = @"price";
static NSString * const kValidFromKey  = @"valid_from";
static NSString * const kVoucherKey    = @"voucher";
static NSString * const kProductKey    = @"product";
static NSString * const kTierKey       = @"tier";
static NSString * const kUpgradesKey   = @"upgrades";
static NSString * const kErrorsKey     = @"errors";
static NSString * const kSeqIDKey      = @"seq_id";



@interface TXHTicket ()

// Private interface goes here.

@end


@implementation TXHTicket


+ (instancetype)updateWithDictionaryOrCreateIfNeeded:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc
{
    NSString *ticketId = dictionary[kIdKey];
    
    TXHTicket *ticket = [self ticketWithID:ticketId inManagedObjectContext:moc];
    if (!ticket) {
        ticket = [TXHTicket insertInManagedObjectContext:moc];
    }
    
    [ticket updateWithDictionary:dictionary inManagedObjectContext:moc];
    
    return ticket;
}

+ (instancetype)ticketWithID:(NSString *)ticketID inManagedObjectContext:(NSManagedObjectContext *)moc {
    NSParameterAssert(ticketID);
    NSParameterAssert(moc);
    
    static NSPredicate *formattedPredicate = nil;
    if (!formattedPredicate) {
        formattedPredicate = [NSPredicate predicateWithFormat:@"ticketId == $TICKET_ID"];
    }
    
    NSDictionary *variables = @{@"TICKET_ID" : ticketID};
    
    NSPredicate *predicate = [formattedPredicate predicateWithSubstitutionVariables:variables];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    [request setPredicate:predicate];
    
    NSArray *tickets = [moc executeFetchRequest:request error:NULL];
    
    if (!tickets) {
        return nil;
    }
    
    return [tickets firstObject];
}

- (instancetype)updateWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc
{
    if (![dictionary isKindOfClass:[NSDictionary class]] || ![dictionary count])
        return nil;
    
    self.ticketId   = nilIfNSNull(dictionary[kIdKey]);
    self.bitmask    = nilIfNSNull(dictionary[kBitmaskKey]);
    self.code       = nilIfNSNull(dictionary[kCodeKey]);
    self.price      = nilIfNSNull(dictionary[kPriceKey]);
    self.voucher    = nilIfNSNull(dictionary[kVoucherKey]);
    self.seqId      = nilIfNSNull(dictionary[kSeqIDKey]);
    self.expiresAt  = [NSDateFormatter txh_dateFromString:nilIfNSNull(dictionary[kExpiresAtKey])];
    self.validFrom  = [NSDateFormatter txh_dateFromString:nilIfNSNull(dictionary[kValidFromKey])];
    self.attendedAt = [NSDateFormatter txh_dateFromString:nilIfNSNull(dictionary[kAttendedAtKey])];

    NSDictionary *ticketDictionary  = nilIfNSNull(dictionary[kCustomerKey]);
    self.customer = [TXHCustomer createWithDictionary:ticketDictionary inManagedObjectContext:moc];

    NSDictionary *productDictionary  = nilIfNSNull(dictionary[kProductKey]);
    self.product = [TXHProduct createWithDictionary:productDictionary inManagedObjectContext:moc];
    
    NSDictionary *tierDictionary  = nilIfNSNull(dictionary[kTierKey]);
    self.tier = [TXHTier updateWithDictionaryCreateIfNeeded:tierDictionary inManagedObjectContext:moc];
    
    [self removeUpgrades:self.upgrades];
    for (NSDictionary *upgradeDictionary in nilIfNSNull(dictionary[kUpgradesKey]))
    {
        TXHUpgrade *upgrade = [TXHUpgrade createWithDictionary:upgradeDictionary inManagedObjectContext:moc];
        [self addUpgradesObject:upgrade];
    }
    
    return self;
}


- (NSNumber *)totalPrice
{
    NSInteger total = [self.price integerValue];
    
    for (TXHUpgrade *upgrade in self.upgrades)
    {
        total += [upgrade.price integerValue];
    }
    
    return @(total);
}

@end
