#import "_TXHTicket.h"

extern NSString * const kTXHBarcodeTypeKey;
extern NSString * const kTXHBarcodeTicketSeqIdKey;
extern NSString * const kTXHBarcodeProductSeqIdKey;
extern NSString * const kTXHBarcodeTierSeqIdKey;
extern NSString * const kTXHBarcodeBitmaskKey;
extern NSString * const kTXHBarcodeValidFromTimestampKey;
extern NSString * const kTXHBarcodeExpiresAtTimestampKey;
extern NSString * const kTXHBarcodeSignatureKey;

@interface TXHTicket : _TXHTicket {}

/** Creates or updates a ticket object with the provided dictionary
 
 @param dictionary A dictionary of key values for the object properties.
 @param moc The managed object that is used to search for and create the object.
 
 @return an object of type TXHTicket.
 
 */
+ (instancetype)updateWithDictionaryOrCreateIfNeeded:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc;


+ (NSDictionary *)decodeBarcode:(NSString *)barcode;

@end
