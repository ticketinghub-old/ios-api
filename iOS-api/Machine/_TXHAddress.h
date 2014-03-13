// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHAddress.h instead.

#import <CoreData/CoreData.h>


extern const struct TXHAddressAttributes {
	__unsafe_unretained NSString *building;
	__unsafe_unretained NSString *city;
	__unsafe_unretained NSString *country;
	__unsafe_unretained NSString *formatted;
	__unsafe_unretained NSString *postal_code;
	__unsafe_unretained NSString *region;
	__unsafe_unretained NSString *street;
} TXHAddressAttributes;

extern const struct TXHAddressRelationships {
	__unsafe_unretained NSString *customer;
	__unsafe_unretained NSString *order;
	__unsafe_unretained NSString *product;
} TXHAddressRelationships;

extern const struct TXHAddressFetchedProperties {
} TXHAddressFetchedProperties;

@class TXHCustomer;
@class TXHOrder;
@class TXHProduct;









@interface TXHAddressID : NSManagedObjectID {}
@end

@interface _TXHAddress : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TXHAddressID*)objectID;





@property (nonatomic, strong) NSString* building;



//- (BOOL)validateBuilding:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* city;



//- (BOOL)validateCity:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* country;



//- (BOOL)validateCountry:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* formatted;



//- (BOOL)validateFormatted:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* postal_code;



//- (BOOL)validatePostal_code:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* region;



//- (BOOL)validateRegion:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* street;



//- (BOOL)validateStreet:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TXHCustomer *customer;

//- (BOOL)validateCustomer:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) TXHOrder *order;

//- (BOOL)validateOrder:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) TXHProduct *product;

//- (BOOL)validateProduct:(id*)value_ error:(NSError**)error_;





@end

@interface _TXHAddress (CoreDataGeneratedAccessors)

@end

@interface _TXHAddress (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveBuilding;
- (void)setPrimitiveBuilding:(NSString*)value;




- (NSString*)primitiveCity;
- (void)setPrimitiveCity:(NSString*)value;




- (NSString*)primitiveCountry;
- (void)setPrimitiveCountry:(NSString*)value;




- (NSString*)primitiveFormatted;
- (void)setPrimitiveFormatted:(NSString*)value;




- (NSString*)primitivePostal_code;
- (void)setPrimitivePostal_code:(NSString*)value;




- (NSString*)primitiveRegion;
- (void)setPrimitiveRegion:(NSString*)value;




- (NSString*)primitiveStreet;
- (void)setPrimitiveStreet:(NSString*)value;





- (TXHCustomer*)primitiveCustomer;
- (void)setPrimitiveCustomer:(TXHCustomer*)value;



- (TXHOrder*)primitiveOrder;
- (void)setPrimitiveOrder:(TXHOrder*)value;



- (TXHProduct*)primitiveProduct;
- (void)setPrimitiveProduct:(TXHProduct*)value;


@end
