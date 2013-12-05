// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHUpgrade.h instead.

#import <CoreData/CoreData.h>


extern const struct TXHUpgradeAttributes {
	__unsafe_unretained NSString *bit;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *price;
	__unsafe_unretained NSString *upgradeDescription;
	__unsafe_unretained NSString *upgradeId;
} TXHUpgradeAttributes;

extern const struct TXHUpgradeRelationships {
	__unsafe_unretained NSString *tier;
} TXHUpgradeRelationships;

extern const struct TXHUpgradeFetchedProperties {
} TXHUpgradeFetchedProperties;

@class TXHTier;







@interface TXHUpgradeID : NSManagedObjectID {}
@end

@interface _TXHUpgrade : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TXHUpgradeID*)objectID;





@property (nonatomic, strong) NSString* bit;



//- (BOOL)validateBit:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* price;



@property int32_t priceValue;
- (int32_t)priceValue;
- (void)setPriceValue:(int32_t)value_;

//- (BOOL)validatePrice:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* upgradeDescription;



//- (BOOL)validateUpgradeDescription:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* upgradeId;



//- (BOOL)validateUpgradeId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TXHTier *tier;

//- (BOOL)validateTier:(id*)value_ error:(NSError**)error_;





#if TARGET_OS_IPHONE



#endif

@end

@interface _TXHUpgrade (CoreDataGeneratedAccessors)

@end

@interface _TXHUpgrade (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveBit;
- (void)setPrimitiveBit:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitivePrice;
- (void)setPrimitivePrice:(NSNumber*)value;

- (int32_t)primitivePriceValue;
- (void)setPrimitivePriceValue:(int32_t)value_;




- (NSString*)primitiveUpgradeDescription;
- (void)setPrimitiveUpgradeDescription:(NSString*)value;




- (NSString*)primitiveUpgradeId;
- (void)setPrimitiveUpgradeId:(NSString*)value;





- (TXHTier*)primitiveTier;
- (void)setPrimitiveTier:(TXHTier*)value;


@end
