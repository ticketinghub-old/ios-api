// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHTier.h instead.

#import <CoreData/CoreData.h>


extern const struct TXHTierAttributes {
	__unsafe_unretained NSString *discount;
	__unsafe_unretained NSString *internalTierId;
	__unsafe_unretained NSString *limit;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *price;
	__unsafe_unretained NSString *seqId;
	__unsafe_unretained NSString *size;
	__unsafe_unretained NSString *tierDescription;
	__unsafe_unretained NSString *tierId;
} TXHTierAttributes;

extern const struct TXHTierRelationships {
	__unsafe_unretained NSString *availabilities;
	__unsafe_unretained NSString *tickets;
	__unsafe_unretained NSString *upgrades;
} TXHTierRelationships;

extern const struct TXHTierFetchedProperties {
} TXHTierFetchedProperties;

@class TXHAvailability;
@class TXHTicket;
@class TXHUpgrade;











@interface TXHTierID : NSManagedObjectID {}
@end

@interface _TXHTier : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TXHTierID*)objectID;





@property (nonatomic, strong) NSNumber* discount;



@property int32_t discountValue;
- (int32_t)discountValue;
- (void)setDiscountValue:(int32_t)value_;

//- (BOOL)validateDiscount:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* internalTierId;



//- (BOOL)validateInternalTierId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* limit;



@property int32_t limitValue;
- (int32_t)limitValue;
- (void)setLimitValue:(int32_t)value_;

//- (BOOL)validateLimit:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* price;



@property int32_t priceValue;
- (int32_t)priceValue;
- (void)setPriceValue:(int32_t)value_;

//- (BOOL)validatePrice:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* seqId;



@property int32_t seqIdValue;
- (int32_t)seqIdValue;
- (void)setSeqIdValue:(int32_t)value_;

//- (BOOL)validateSeqId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* size;



@property int32_t sizeValue;
- (int32_t)sizeValue;
- (void)setSizeValue:(int32_t)value_;

//- (BOOL)validateSize:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* tierDescription;



//- (BOOL)validateTierDescription:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* tierId;



//- (BOOL)validateTierId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *availabilities;

- (NSMutableSet*)availabilitiesSet;




@property (nonatomic, strong) NSSet *tickets;

- (NSMutableSet*)ticketsSet;




@property (nonatomic, strong) NSSet *upgrades;

- (NSMutableSet*)upgradesSet;





@end

@interface _TXHTier (CoreDataGeneratedAccessors)

- (void)addAvailabilities:(NSSet*)value_;
- (void)removeAvailabilities:(NSSet*)value_;
- (void)addAvailabilitiesObject:(TXHAvailability*)value_;
- (void)removeAvailabilitiesObject:(TXHAvailability*)value_;

- (void)addTickets:(NSSet*)value_;
- (void)removeTickets:(NSSet*)value_;
- (void)addTicketsObject:(TXHTicket*)value_;
- (void)removeTicketsObject:(TXHTicket*)value_;

- (void)addUpgrades:(NSSet*)value_;
- (void)removeUpgrades:(NSSet*)value_;
- (void)addUpgradesObject:(TXHUpgrade*)value_;
- (void)removeUpgradesObject:(TXHUpgrade*)value_;

@end

@interface _TXHTier (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveDiscount;
- (void)setPrimitiveDiscount:(NSNumber*)value;

- (int32_t)primitiveDiscountValue;
- (void)setPrimitiveDiscountValue:(int32_t)value_;




- (NSString*)primitiveInternalTierId;
- (void)setPrimitiveInternalTierId:(NSString*)value;




- (NSNumber*)primitiveLimit;
- (void)setPrimitiveLimit:(NSNumber*)value;

- (int32_t)primitiveLimitValue;
- (void)setPrimitiveLimitValue:(int32_t)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitivePrice;
- (void)setPrimitivePrice:(NSNumber*)value;

- (int32_t)primitivePriceValue;
- (void)setPrimitivePriceValue:(int32_t)value_;




- (NSNumber*)primitiveSeqId;
- (void)setPrimitiveSeqId:(NSNumber*)value;

- (int32_t)primitiveSeqIdValue;
- (void)setPrimitiveSeqIdValue:(int32_t)value_;




- (NSNumber*)primitiveSize;
- (void)setPrimitiveSize:(NSNumber*)value;

- (int32_t)primitiveSizeValue;
- (void)setPrimitiveSizeValue:(int32_t)value_;




- (NSString*)primitiveTierDescription;
- (void)setPrimitiveTierDescription:(NSString*)value;




- (NSString*)primitiveTierId;
- (void)setPrimitiveTierId:(NSString*)value;





- (NSMutableSet*)primitiveAvailabilities;
- (void)setPrimitiveAvailabilities:(NSMutableSet*)value;



- (NSMutableSet*)primitiveTickets;
- (void)setPrimitiveTickets:(NSMutableSet*)value;



- (NSMutableSet*)primitiveUpgrades;
- (void)setPrimitiveUpgrades:(NSMutableSet*)value;


@end
