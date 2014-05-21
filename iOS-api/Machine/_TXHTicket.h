// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHTicket.h instead.

#import <CoreData/CoreData.h>


extern const struct TXHTicketAttributes {
	__unsafe_unretained NSString *attendedAt;
	__unsafe_unretained NSString *bitmask;
	__unsafe_unretained NSString *code;
	__unsafe_unretained NSString *errors;
	__unsafe_unretained NSString *expiresAt;
	__unsafe_unretained NSString *price;
	__unsafe_unretained NSString *reference;
	__unsafe_unretained NSString *serial;
	__unsafe_unretained NSString *ticketId;
	__unsafe_unretained NSString *validFrom;
	__unsafe_unretained NSString *voucher;
} TXHTicketAttributes;

extern const struct TXHTicketRelationships {
	__unsafe_unretained NSString *customer;
	__unsafe_unretained NSString *order;
	__unsafe_unretained NSString *product;
	__unsafe_unretained NSString *tier;
	__unsafe_unretained NSString *upgrades;
} TXHTicketRelationships;

extern const struct TXHTicketFetchedProperties {
} TXHTicketFetchedProperties;

@class TXHCustomer;
@class TXHOrder;
@class TXHProduct;
@class TXHTier;
@class TXHUpgrade;




@class NSObject;








@interface TXHTicketID : NSManagedObjectID {}
@end

@interface _TXHTicket : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TXHTicketID*)objectID;





@property (nonatomic, strong) NSDate* attendedAt;



//- (BOOL)validateAttendedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* bitmask;



@property int32_t bitmaskValue;
- (int32_t)bitmaskValue;
- (void)setBitmaskValue:(int32_t)value_;

//- (BOOL)validateBitmask:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* code;



//- (BOOL)validateCode:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) id errors;



//- (BOOL)validateErrors:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* expiresAt;



//- (BOOL)validateExpiresAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* price;



@property int32_t priceValue;
- (int32_t)priceValue;
- (void)setPriceValue:(int32_t)value_;

//- (BOOL)validatePrice:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* reference;



//- (BOOL)validateReference:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* serial;



@property int32_t serialValue;
- (int32_t)serialValue;
- (void)setSerialValue:(int32_t)value_;

//- (BOOL)validateSerial:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* ticketId;



//- (BOOL)validateTicketId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* validFrom;



//- (BOOL)validateValidFrom:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* voucher;



//- (BOOL)validateVoucher:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TXHCustomer *customer;

//- (BOOL)validateCustomer:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) TXHOrder *order;

//- (BOOL)validateOrder:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) TXHProduct *product;

//- (BOOL)validateProduct:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) TXHTier *tier;

//- (BOOL)validateTier:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *upgrades;

- (NSMutableSet*)upgradesSet;





@end

@interface _TXHTicket (CoreDataGeneratedAccessors)

- (void)addUpgrades:(NSSet*)value_;
- (void)removeUpgrades:(NSSet*)value_;
- (void)addUpgradesObject:(TXHUpgrade*)value_;
- (void)removeUpgradesObject:(TXHUpgrade*)value_;

@end

@interface _TXHTicket (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveAttendedAt;
- (void)setPrimitiveAttendedAt:(NSDate*)value;




- (NSNumber*)primitiveBitmask;
- (void)setPrimitiveBitmask:(NSNumber*)value;

- (int32_t)primitiveBitmaskValue;
- (void)setPrimitiveBitmaskValue:(int32_t)value_;




- (NSString*)primitiveCode;
- (void)setPrimitiveCode:(NSString*)value;




- (id)primitiveErrors;
- (void)setPrimitiveErrors:(id)value;




- (NSDate*)primitiveExpiresAt;
- (void)setPrimitiveExpiresAt:(NSDate*)value;




- (NSNumber*)primitivePrice;
- (void)setPrimitivePrice:(NSNumber*)value;

- (int32_t)primitivePriceValue;
- (void)setPrimitivePriceValue:(int32_t)value_;




- (NSString*)primitiveReference;
- (void)setPrimitiveReference:(NSString*)value;




- (NSNumber*)primitiveSerial;
- (void)setPrimitiveSerial:(NSNumber*)value;

- (int32_t)primitiveSerialValue;
- (void)setPrimitiveSerialValue:(int32_t)value_;




- (NSString*)primitiveTicketId;
- (void)setPrimitiveTicketId:(NSString*)value;




- (NSDate*)primitiveValidFrom;
- (void)setPrimitiveValidFrom:(NSDate*)value;




- (NSString*)primitiveVoucher;
- (void)setPrimitiveVoucher:(NSString*)value;





- (TXHCustomer*)primitiveCustomer;
- (void)setPrimitiveCustomer:(TXHCustomer*)value;



- (TXHOrder*)primitiveOrder;
- (void)setPrimitiveOrder:(TXHOrder*)value;



- (TXHProduct*)primitiveProduct;
- (void)setPrimitiveProduct:(TXHProduct*)value;



- (TXHTier*)primitiveTier;
- (void)setPrimitiveTier:(TXHTier*)value;



- (NSMutableSet*)primitiveUpgrades;
- (void)setPrimitiveUpgrades:(NSMutableSet*)value;


@end
