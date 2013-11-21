// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHProduct.h instead.

#import <CoreData/CoreData.h>


extern const struct TXHProductAttributes {
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *productId;
} TXHProductAttributes;

extern const struct TXHProductRelationships {
	__unsafe_unretained NSString *supplier;
} TXHProductRelationships;

extern const struct TXHProductFetchedProperties {
} TXHProductFetchedProperties;

@class TXHSupplier;




@interface TXHProductID : NSManagedObjectID {}
@end

@interface _TXHProduct : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TXHProductID*)objectID;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* productId;



//- (BOOL)validateProductId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TXHSupplier *supplier;

//- (BOOL)validateSupplier:(id*)value_ error:(NSError**)error_;





#if TARGET_OS_IPHONE



#endif

@end

@interface _TXHProduct (CoreDataGeneratedAccessors)

@end

@interface _TXHProduct (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitiveProductId;
- (void)setPrimitiveProductId:(NSString*)value;





- (TXHSupplier*)primitiveSupplier;
- (void)setPrimitiveSupplier:(TXHSupplier*)value;


@end
