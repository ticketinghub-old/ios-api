// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHAvailability.h instead.

#import <CoreData/CoreData.h>


extern const struct TXHAvailabilityAttributes {
	__unsafe_unretained NSString *dateString;
	__unsafe_unretained NSString *duration;
	__unsafe_unretained NSString *limit;
	__unsafe_unretained NSString *timeString;
} TXHAvailabilityAttributes;

extern const struct TXHAvailabilityRelationships {
	__unsafe_unretained NSString *product;
	__unsafe_unretained NSString *tiers;
} TXHAvailabilityRelationships;

extern const struct TXHAvailabilityFetchedProperties {
} TXHAvailabilityFetchedProperties;

@class TXHProduct;
@class TXHTier;






@interface TXHAvailabilityID : NSManagedObjectID {}
@end

@interface _TXHAvailability : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TXHAvailabilityID*)objectID;





@property (nonatomic, strong) NSString* dateString;



//- (BOOL)validateDateString:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* duration;



//- (BOOL)validateDuration:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* limit;



@property int32_t limitValue;
- (int32_t)limitValue;
- (void)setLimitValue:(int32_t)value_;

//- (BOOL)validateLimit:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* timeString;



//- (BOOL)validateTimeString:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TXHProduct *product;

//- (BOOL)validateProduct:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *tiers;

- (NSMutableSet*)tiersSet;





@end

@interface _TXHAvailability (CoreDataGeneratedAccessors)

- (void)addTiers:(NSSet*)value_;
- (void)removeTiers:(NSSet*)value_;
- (void)addTiersObject:(TXHTier*)value_;
- (void)removeTiersObject:(TXHTier*)value_;

@end

@interface _TXHAvailability (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveDateString;
- (void)setPrimitiveDateString:(NSString*)value;




- (NSString*)primitiveDuration;
- (void)setPrimitiveDuration:(NSString*)value;




- (NSNumber*)primitiveLimit;
- (void)setPrimitiveLimit:(NSNumber*)value;

- (int32_t)primitiveLimitValue;
- (void)setPrimitiveLimitValue:(int32_t)value_;




- (NSString*)primitiveTimeString;
- (void)setPrimitiveTimeString:(NSString*)value;





- (TXHProduct*)primitiveProduct;
- (void)setPrimitiveProduct:(TXHProduct*)value;



- (NSMutableSet*)primitiveTiers;
- (void)setPrimitiveTiers:(NSMutableSet*)value;


@end
