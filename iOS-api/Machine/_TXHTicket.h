// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHTicket.h instead.

#import <CoreData/CoreData.h>


extern const struct TXHTicketAttributes {
	__unsafe_unretained NSString *bitmask;
	__unsafe_unretained NSString *code;
	__unsafe_unretained NSString *customer;
	__unsafe_unretained NSString *expiresAt;
	__unsafe_unretained NSString *price;
	__unsafe_unretained NSString *ticketId;
	__unsafe_unretained NSString *validFrom;
	__unsafe_unretained NSString *voucher;
} TXHTicketAttributes;

extern const struct TXHTicketRelationships {
	__unsafe_unretained NSString *order;
} TXHTicketRelationships;

extern const struct TXHTicketFetchedProperties {
} TXHTicketFetchedProperties;

@class TXHOrder;










@interface TXHTicketID : NSManagedObjectID {}
@end

@interface _TXHTicket : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TXHTicketID*)objectID;





@property (nonatomic, strong) NSString* bitmask;



//- (BOOL)validateBitmask:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* code;



//- (BOOL)validateCode:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* customer;



//- (BOOL)validateCustomer:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* expiresAt;



//- (BOOL)validateExpiresAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* price;



@property int32_t priceValue;
- (int32_t)priceValue;
- (void)setPriceValue:(int32_t)value_;

//- (BOOL)validatePrice:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* ticketId;



//- (BOOL)validateTicketId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* validFrom;



//- (BOOL)validateValidFrom:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* voucher;



//- (BOOL)validateVoucher:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TXHOrder *order;

//- (BOOL)validateOrder:(id*)value_ error:(NSError**)error_;





@end

@interface _TXHTicket (CoreDataGeneratedAccessors)

@end

@interface _TXHTicket (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveBitmask;
- (void)setPrimitiveBitmask:(NSString*)value;




- (NSString*)primitiveCode;
- (void)setPrimitiveCode:(NSString*)value;




- (NSString*)primitiveCustomer;
- (void)setPrimitiveCustomer:(NSString*)value;




- (NSString*)primitiveExpiresAt;
- (void)setPrimitiveExpiresAt:(NSString*)value;




- (NSNumber*)primitivePrice;
- (void)setPrimitivePrice:(NSNumber*)value;

- (int32_t)primitivePriceValue;
- (void)setPrimitivePriceValue:(int32_t)value_;




- (NSString*)primitiveTicketId;
- (void)setPrimitiveTicketId:(NSString*)value;




- (NSString*)primitiveValidFrom;
- (void)setPrimitiveValidFrom:(NSString*)value;




- (NSString*)primitiveVoucher;
- (void)setPrimitiveVoucher:(NSString*)value;





- (TXHOrder*)primitiveOrder;
- (void)setPrimitiveOrder:(TXHOrder*)value;


@end
