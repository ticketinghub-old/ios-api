// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHContact.h instead.

#import <CoreData/CoreData.h>


extern const struct TXHContactAttributes {
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *telephone;
	__unsafe_unretained NSString *website;
} TXHContactAttributes;

extern const struct TXHContactRelationships {
	__unsafe_unretained NSString *product;
} TXHContactRelationships;

extern const struct TXHContactFetchedProperties {
} TXHContactFetchedProperties;

@class TXHProduct;





@interface TXHContactID : NSManagedObjectID {}
@end

@interface _TXHContact : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TXHContactID*)objectID;





@property (nonatomic, strong) NSString* email;



//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* telephone;



//- (BOOL)validateTelephone:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* website;



//- (BOOL)validateWebsite:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TXHProduct *product;

//- (BOOL)validateProduct:(id*)value_ error:(NSError**)error_;





@end

@interface _TXHContact (CoreDataGeneratedAccessors)

@end

@interface _TXHContact (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;




- (NSString*)primitiveTelephone;
- (void)setPrimitiveTelephone:(NSString*)value;




- (NSString*)primitiveWebsite;
- (void)setPrimitiveWebsite:(NSString*)value;





- (TXHProduct*)primitiveProduct;
- (void)setPrimitiveProduct:(TXHProduct*)value;


@end
