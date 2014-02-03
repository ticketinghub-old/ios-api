// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHProduct.h instead.

#import <CoreData/CoreData.h>


extern const struct TXHProductAttributes {
	__unsafe_unretained NSString *availabilitiesUpdated;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *productId;
} TXHProductAttributes;

extern const struct TXHProductRelationships {
	__unsafe_unretained NSString *availabilities;
	__unsafe_unretained NSString *supplier;
} TXHProductRelationships;

extern const struct TXHProductFetchedProperties {
} TXHProductFetchedProperties;

@class TXHAvailability;
@class TXHSupplier;





@interface TXHProductID : NSManagedObjectID {}
@end

@interface _TXHProduct : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TXHProductID*)objectID;





@property (nonatomic, strong) NSDate* availabilitiesUpdated;



//- (BOOL)validateAvailabilitiesUpdated:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* productId;



//- (BOOL)validateProductId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *availabilities;

- (NSMutableSet*)availabilitiesSet;




@property (nonatomic, strong) TXHSupplier *supplier;

//- (BOOL)validateSupplier:(id*)value_ error:(NSError**)error_;





#if TARGET_OS_IPHONE


- (NSFetchedResultsController*)newAvailabilitiesFetchedResultsControllerWithSortDescriptors:(NSArray*)sortDescriptors;




#endif

@end

@interface _TXHProduct (CoreDataGeneratedAccessors)

- (void)addAvailabilities:(NSSet*)value_;
- (void)removeAvailabilities:(NSSet*)value_;
- (void)addAvailabilitiesObject:(TXHAvailability*)value_;
- (void)removeAvailabilitiesObject:(TXHAvailability*)value_;

@end

@interface _TXHProduct (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveAvailabilitiesUpdated;
- (void)setPrimitiveAvailabilitiesUpdated:(NSDate*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitiveProductId;
- (void)setPrimitiveProductId:(NSString*)value;





- (NSMutableSet*)primitiveAvailabilities;
- (void)setPrimitiveAvailabilities:(NSMutableSet*)value;



- (TXHSupplier*)primitiveSupplier;
- (void)setPrimitiveSupplier:(TXHSupplier*)value;


@end
