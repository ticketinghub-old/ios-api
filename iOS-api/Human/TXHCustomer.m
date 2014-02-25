#import "TXHCustomer.h"

#import "TXHOrder.h"
#import "TXHTicket.h"

static NSString * const kCountryKey   = @"country";
static NSString * const kEmailKey     = @"email";
static NSString * const kFirstNameKey = @"first_name";
static NSString * const kFullNameKey  = @"full_name";
static NSString * const kLastNameKey  = @"last_name";
static NSString * const kTelephoneKey = @"telephone";

@interface TXHCustomer ()

@end


@implementation TXHCustomer

+ (instancetype)createWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc
{
    if (![dictionary isKindOfClass:[NSDictionary class]] || ![dictionary count])
        return nil;
    
    TXHCustomer *customer = [TXHCustomer insertInManagedObjectContext:moc];
    
    customer.country   = nilIfNSNull(dictionary[kCountryKey]);
    customer.email     = nilIfNSNull(dictionary[kEmailKey]);
    customer.firstName = nilIfNSNull(dictionary[kFirstNameKey]);
    customer.lastName  = nilIfNSNull(dictionary[kLastNameKey]);
    customer.fullName  = nilIfNSNull(dictionary[kFullNameKey]);
    
    return customer;
}

@end
