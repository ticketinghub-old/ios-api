// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHPayment.h instead.

#import <CoreData/CoreData.h>


extern const struct TXHPaymentAttributes {
	__unsafe_unretained NSString *amount;
	__unsafe_unretained NSString *authorization;
	__unsafe_unretained NSString *avsResult;
	__unsafe_unretained NSString *currency;
	__unsafe_unretained NSString *postalMatch;
	__unsafe_unretained NSString *securityCodeResult;
	__unsafe_unretained NSString *streetMatch;
	__unsafe_unretained NSString *type;
} TXHPaymentAttributes;

extern const struct TXHPaymentRelationships {
	__unsafe_unretained NSString *address;
	__unsafe_unretained NSString *card;
} TXHPaymentRelationships;

extern const struct TXHPaymentFetchedProperties {
} TXHPaymentFetchedProperties;

@class TXHAddress;
@class TXHCard;










@interface TXHPaymentID : NSManagedObjectID {}
@end

@interface _TXHPayment : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TXHPaymentID*)objectID;





@property (nonatomic, strong) NSNumber* amount;



@property int64_t amountValue;
- (int64_t)amountValue;
- (void)setAmountValue:(int64_t)value_;

//- (BOOL)validateAmount:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* authorization;



//- (BOOL)validateAuthorization:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* avsResult;



//- (BOOL)validateAvsResult:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* currency;



//- (BOOL)validateCurrency:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* postalMatch;



@property BOOL postalMatchValue;
- (BOOL)postalMatchValue;
- (void)setPostalMatchValue:(BOOL)value_;

//- (BOOL)validatePostalMatch:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* securityCodeResult;



//- (BOOL)validateSecurityCodeResult:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* streetMatch;



@property BOOL streetMatchValue;
- (BOOL)streetMatchValue;
- (void)setStreetMatchValue:(BOOL)value_;

//- (BOOL)validateStreetMatch:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* type;



//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TXHAddress *address;

//- (BOOL)validateAddress:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) TXHCard *card;

//- (BOOL)validateCard:(id*)value_ error:(NSError**)error_;





@end

@interface _TXHPayment (CoreDataGeneratedAccessors)

@end

@interface _TXHPayment (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveAmount;
- (void)setPrimitiveAmount:(NSNumber*)value;

- (int64_t)primitiveAmountValue;
- (void)setPrimitiveAmountValue:(int64_t)value_;




- (NSString*)primitiveAuthorization;
- (void)setPrimitiveAuthorization:(NSString*)value;




- (NSString*)primitiveAvsResult;
- (void)setPrimitiveAvsResult:(NSString*)value;




- (NSString*)primitiveCurrency;
- (void)setPrimitiveCurrency:(NSString*)value;




- (NSNumber*)primitivePostalMatch;
- (void)setPrimitivePostalMatch:(NSNumber*)value;

- (BOOL)primitivePostalMatchValue;
- (void)setPrimitivePostalMatchValue:(BOOL)value_;




- (NSString*)primitiveSecurityCodeResult;
- (void)setPrimitiveSecurityCodeResult:(NSString*)value;




- (NSNumber*)primitiveStreetMatch;
- (void)setPrimitiveStreetMatch:(NSNumber*)value;

- (BOOL)primitiveStreetMatchValue;
- (void)setPrimitiveStreetMatchValue:(BOOL)value_;




- (NSString*)primitiveType;
- (void)setPrimitiveType:(NSString*)value;





- (TXHAddress*)primitiveAddress;
- (void)setPrimitiveAddress:(TXHAddress*)value;



- (TXHCard*)primitiveCard;
- (void)setPrimitiveCard:(TXHCard*)value;


@end