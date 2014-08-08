// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHUser.h instead.

#import <CoreData/CoreData.h>


extern const struct TXHUserAttributes {
	__unsafe_unretained NSString *accessToken;
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *firstName;
	__unsafe_unretained NSString *lastName;
	__unsafe_unretained NSString *userId;
} TXHUserAttributes;

extern const struct TXHUserRelationships {
	__unsafe_unretained NSString *suppliers;
} TXHUserRelationships;

extern const struct TXHUserFetchedProperties {
} TXHUserFetchedProperties;

@class TXHSupplier;







@interface TXHUserID : NSManagedObjectID {}
@end

@interface _TXHUser : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TXHUserID*)objectID;





@property (nonatomic, strong) NSString* accessToken;



//- (BOOL)validateAccessToken:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* email;



//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* firstName;



//- (BOOL)validateFirstName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* lastName;



//- (BOOL)validateLastName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* userId;



//- (BOOL)validateUserId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *suppliers;

- (NSMutableSet*)suppliersSet;





@end

@interface _TXHUser (CoreDataGeneratedAccessors)

- (void)addSuppliers:(NSSet*)value_;
- (void)removeSuppliers:(NSSet*)value_;
- (void)addSuppliersObject:(TXHSupplier*)value_;
- (void)removeSuppliersObject:(TXHSupplier*)value_;

@end

@interface _TXHUser (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAccessToken;
- (void)setPrimitiveAccessToken:(NSString*)value;




- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;




- (NSString*)primitiveFirstName;
- (void)setPrimitiveFirstName:(NSString*)value;




- (NSString*)primitiveLastName;
- (void)setPrimitiveLastName:(NSString*)value;




- (NSString*)primitiveUserId;
- (void)setPrimitiveUserId:(NSString*)value;





- (NSMutableSet*)primitiveSuppliers;
- (void)setPrimitiveSuppliers:(NSMutableSet*)value;


@end
