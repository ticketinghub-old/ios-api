// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHCustomer.h instead.

#import <CoreData/CoreData.h>


extern const struct TXHCustomerAttributes {
	__unsafe_unretained NSString *attribute;
	__unsafe_unretained NSString *attribute1;
	__unsafe_unretained NSString *attribute2;
	__unsafe_unretained NSString *attribute3;
	__unsafe_unretained NSString *attribute4;
	__unsafe_unretained NSString *country;
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *errors;
	__unsafe_unretained NSString *firstName;
	__unsafe_unretained NSString *fullName;
	__unsafe_unretained NSString *lastName;
	__unsafe_unretained NSString *telephone;
} TXHCustomerAttributes;

extern const struct TXHCustomerRelationships {
	__unsafe_unretained NSString *address;
	__unsafe_unretained NSString *order;
	__unsafe_unretained NSString *ticket;
} TXHCustomerRelationships;

extern const struct TXHCustomerFetchedProperties {
} TXHCustomerFetchedProperties;

@class TXHAddress;
@class TXHOrder;
@class TXHTicket;








@class NSObject;





@interface TXHCustomerID : NSManagedObjectID {}
@end

@interface _TXHCustomer : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TXHCustomerID*)objectID;















@property (nonatomic, strong) NSString* country;



//- (BOOL)validateCountry:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* email;



//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) id errors;



//- (BOOL)validateErrors:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* firstName;



//- (BOOL)validateFirstName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* fullName;



//- (BOOL)validateFullName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* lastName;



//- (BOOL)validateLastName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* telephone;



//- (BOOL)validateTelephone:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TXHAddress *address;

//- (BOOL)validateAddress:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) TXHOrder *order;

//- (BOOL)validateOrder:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) TXHTicket *ticket;

//- (BOOL)validateTicket:(id*)value_ error:(NSError**)error_;





@end

@interface _TXHCustomer (CoreDataGeneratedAccessors)

@end

@interface _TXHCustomer (CoreDataGeneratedPrimitiveAccessors)












- (NSString*)primitiveCountry;
- (void)setPrimitiveCountry:(NSString*)value;




- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;




- (id)primitiveErrors;
- (void)setPrimitiveErrors:(id)value;




- (NSString*)primitiveFirstName;
- (void)setPrimitiveFirstName:(NSString*)value;




- (NSString*)primitiveFullName;
- (void)setPrimitiveFullName:(NSString*)value;




- (NSString*)primitiveLastName;
- (void)setPrimitiveLastName:(NSString*)value;




- (NSString*)primitiveTelephone;
- (void)setPrimitiveTelephone:(NSString*)value;





- (TXHAddress*)primitiveAddress;
- (void)setPrimitiveAddress:(TXHAddress*)value;



- (TXHOrder*)primitiveOrder;
- (void)setPrimitiveOrder:(TXHOrder*)value;



- (TXHTicket*)primitiveTicket;
- (void)setPrimitiveTicket:(TXHTicket*)value;


@end
