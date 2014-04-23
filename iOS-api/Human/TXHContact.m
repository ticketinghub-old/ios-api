#import "TXHContact.h"

static NSString * const kEmailKey     = @"email";
static NSString * const kTelephoneKey = @"telephone";
static NSString * const kWebsiteKey   = @"website";


@interface TXHContact ()


@end


@implementation TXHContact

+ (instancetype)createWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc
{
    if (![dictionary isKindOfClass:[NSDictionary class]] || ![dictionary count])
        return nil;
    
    TXHContact *contact = [TXHContact insertInManagedObjectContext:moc];
    
    contact.email     = nilIfNSNull(dictionary[kEmailKey]);
    contact.telephone = nilIfNSNull(dictionary[kTelephoneKey]);
    contact.website   = nilIfNSNull(dictionary[kWebsiteKey]);
    
    return contact;
}

@end
