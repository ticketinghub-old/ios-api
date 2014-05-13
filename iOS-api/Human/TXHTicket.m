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
static NSString * const kReferenceKey  = @"reference";


// barcode dictionary keys

NSString * const kTXHBarcodeTypeKey                 = @"kTXHBarcodeTypeKey";
NSString * const kTXHBarcodeTicketSeqIdKey          = @"kTXHBarcodeTicketSeqIdKey";
NSString * const kTXHBarcodeProductSeqIdKey         = @"kTXHBarcodeProductSeqIdKey";
NSString * const kTXHBarcodeTierSeqIdKey            = @"kTXHBarcodeTierSeqIdKey";
NSString * const kTXHBarcodeBitmaskKey              = @"kTXHBarcodeBitmaskKey";
NSString * const kTXHBarcodeValidFromTimestampKey   = @"kTXHBarcodeValidFromTimestampKey";
NSString * const kTXHBarcodeExpiresAtTimestampKey   = @"kTXHBarcodeExpiresAtTimestampKey";
NSString * const kTXHBarcodeSignatureKey            = @"kTXHBarcodeSignatureKey";

@interface TXHTicket ()

// Private interface goes here.

@end


@implementation TXHTicket

+ (NSDictionary *)decodeBarcode:(NSString *)barcode
{
    size_t totalBytes = 0;
    
    NSData *jsonData       = [[NSData alloc] initWithBase64EncodedString:barcode options:0];
    
    if (!jsonData)
        return nil;
    
    NSData *typeData       = [jsonData subdataWithRange:NSMakeRange(totalBytes, sizeof(uint8_t))]; totalBytes += sizeof(uint8_t);
    NSData *ticketSeqData  = [jsonData subdataWithRange:NSMakeRange(totalBytes, sizeof(uint32_t))]; totalBytes += sizeof(uint32_t);
    NSData *productSeqData = [jsonData subdataWithRange:NSMakeRange(totalBytes, sizeof(uint8_t))]; totalBytes += sizeof(uint8_t);
    NSData *tierSeqData    = [jsonData subdataWithRange:NSMakeRange(totalBytes, sizeof(uint8_t))]; totalBytes += sizeof(uint8_t);
    NSData *bitmaskData    = [jsonData subdataWithRange:NSMakeRange(totalBytes, sizeof(uint32_t))]; totalBytes += sizeof(uint32_t);
    NSData *validFromData  = [jsonData subdataWithRange:NSMakeRange(totalBytes, sizeof(uint32_t))]; totalBytes += sizeof(uint32_t);
    NSData *expiresAtData  = [jsonData subdataWithRange:NSMakeRange(totalBytes, sizeof(uint32_t))]; totalBytes += sizeof(uint32_t);
    NSData *signatureData  = [jsonData subdataWithRange:NSMakeRange(totalBytes, [jsonData length] - totalBytes)];
    
    NSNumber *type               = @(*(uint8_t *)[typeData bytes]);
    NSNumber *ticketSeq          = @(*(uint32_t *)[ticketSeqData bytes]);
    NSNumber *productSeq         = @(*(uint8_t *)[productSeqData bytes]);
    NSNumber *tierSeq            = @(*(uint8_t *)[tierSeqData bytes]);
    NSNumber *bitmask            = @(*(uint32_t *)[bitmaskData bytes]);
    NSNumber *validFromTimestamp = @(*(uint32_t *)[validFromData bytes]);
    NSNumber *expiresAtTimestamp = @(*(uint32_t *)[expiresAtData bytes]);
    NSString* signature = [[NSString alloc] initWithData:signatureData
                                                encoding:NSASCIIStringEncoding];
    
    if (!type || !ticketSeq || !productSeq ||
        !tierSeq || !bitmask ||
        !validFromData || !expiresAtData ||
        !expiresAtData || !signature)
        return nil;
    
    return @{kTXHBarcodeTypeKey : type,
             kTXHBarcodeTicketSeqIdKey : ticketSeq,
             kTXHBarcodeProductSeqIdKey : productSeq,
             kTXHBarcodeTierSeqIdKey : tierSeq,
             kTXHBarcodeBitmaskKey : bitmask,
             kTXHBarcodeValidFromTimestampKey : validFromTimestamp,
             kTXHBarcodeExpiresAtTimestampKey : expiresAtTimestamp,
             kTXHBarcodeSignatureKey : signature};
}

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
    self.reference  = nilIfNSNull(dictionary[kReferenceKey]);
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

@end
