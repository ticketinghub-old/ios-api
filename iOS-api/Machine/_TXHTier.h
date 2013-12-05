// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHTier.h instead.

#import <CoreData/CoreData.h>


extern const struct TXHTierAttributes {
	__unsafe_unretained NSString *discount;
	__unsafe_unretained NSString *limit;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *price;
	__unsafe_unretained NSString *size;
	__unsafe_unretained NSString *tierDescription;
	__unsafe_unretained NSString *tierId;
} TXHTierAttributes;

extern const struct TXHTierRelationships {
	__unsafe_unretained NSString *availability;
	__unsafe_unretained NSString *upgrades;
} TXHTierRelationships;

extern const struct TXHTierFetchedProperties {
} TXHTierFetchedProperties;

@class TXHAvailability;
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





@property (nonatomic, strong) NSNumber* size;



@property int32_t sizeValue;
- (int32_t)sizeValue;
- (void)setSizeValue:(int32_t)value_;

//- (BOOL)validateSize:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* tierDescription;



//- (BOOL)validateTierDescription:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* tierId;



//- (BOOL)validateTierId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TXHAvailability *availability;

//- (BOOL)validateAvailability:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *upgrades;

- (NSMutableSet*)upgradesSet;





#if TARGET_OS_IPHONE




- (NSFetchedResultsController*)newUpgradesFetchedResultsControllerWithSortDescriptors:(NSArray*)sortDescriptors;


#endif

@end

@interface _TXHTier (CoreDataGeneratedAccessors)

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




- (NSNumber*)primitiveSize;
- (void)setPrimitiveSize:(NSNumber*)value;

- (int32_t)primitiveSizeValue;
- (void)setPrimitiveSizeValue:(int32_t)value_;




- (NSString*)primitiveTierDescription;
- (void)setPrimitiveTierDescription:(NSString*)value;




- (NSString*)primitiveTierId;
- (void)setPrimitiveTierId:(NSString*)value;





- (TXHAvailability*)primitiveAvailability;
- (void)setPrimitiveAvailability:(TXHAvailability*)value;



- (NSMutableSet*)primitiveUpgrades;
- (void)setPrimitiveUpgrades:(NSMutableSet*)value;


@end
