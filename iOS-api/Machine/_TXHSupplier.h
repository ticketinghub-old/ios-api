// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHSupplier.h instead.

#import <CoreData/CoreData.h>


extern const struct TXHSupplierAttributes {
	__unsafe_unretained NSString *accessToken;
	__unsafe_unretained NSString *country;
	__unsafe_unretained NSString *refreshToken;
	__unsafe_unretained NSString *timeZoneName;
} TXHSupplierAttributes;

extern const struct TXHSupplierRelationships {
	__unsafe_unretained NSString *contact;
	__unsafe_unretained NSString *products;
	__unsafe_unretained NSString *user;
} TXHSupplierRelationships;

extern const struct TXHSupplierFetchedProperties {
} TXHSupplierFetchedProperties;

@class TXHContact;
@class TXHProduct;
@class TXHUser;







@interface TXHSupplierID : NSManagedObjectID {}
@end

@interface _TXHSupplier : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TXHSupplierID*)objectID;





@property (nonatomic, strong) NSString* accessToken;



//- (BOOL)validateAccessToken:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* country;



//- (BOOL)validateCountry:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* refreshToken;



//- (BOOL)validateRefreshToken:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* timeZoneName;



//- (BOOL)validateTimeZoneName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TXHContact *contact;

//- (BOOL)validateContact:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *products;

- (NSMutableSet*)productsSet;




@property (nonatomic, strong) TXHUser *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;





@end

@interface _TXHSupplier (CoreDataGeneratedAccessors)

- (void)addProducts:(NSSet*)value_;
- (void)removeProducts:(NSSet*)value_;
- (void)addProductsObject:(TXHProduct*)value_;
- (void)removeProductsObject:(TXHProduct*)value_;

@end

@interface _TXHSupplier (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAccessToken;
- (void)setPrimitiveAccessToken:(NSString*)value;




- (NSString*)primitiveCountry;
- (void)setPrimitiveCountry:(NSString*)value;




- (NSString*)primitiveRefreshToken;
- (void)setPrimitiveRefreshToken:(NSString*)value;




- (NSString*)primitiveTimeZoneName;
- (void)setPrimitiveTimeZoneName:(NSString*)value;





- (TXHContact*)primitiveContact;
- (void)setPrimitiveContact:(TXHContact*)value;



- (NSMutableSet*)primitiveProducts;
- (void)setPrimitiveProducts:(NSMutableSet*)value;



- (TXHUser*)primitiveUser;
- (void)setPrimitiveUser:(TXHUser*)value;


@end
