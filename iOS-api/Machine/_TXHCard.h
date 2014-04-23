// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHCard.h instead.

#import <CoreData/CoreData.h>


extern const struct TXHCardAttributes {
	__unsafe_unretained NSString *brand;
	__unsafe_unretained NSString *fingerprint;
	__unsafe_unretained NSString *firstName;
	__unsafe_unretained NSString *last4;
	__unsafe_unretained NSString *mask;
	__unsafe_unretained NSString *month;
	__unsafe_unretained NSString *year;
} TXHCardAttributes;

extern const struct TXHCardRelationships {
	__unsafe_unretained NSString *payment;
} TXHCardRelationships;

extern const struct TXHCardFetchedProperties {
} TXHCardFetchedProperties;

@class TXHPayment;









@interface TXHCardID : NSManagedObjectID {}
@end

@interface _TXHCard : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TXHCardID*)objectID;





@property (nonatomic, strong) NSString* brand;



//- (BOOL)validateBrand:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* fingerprint;



//- (BOOL)validateFingerprint:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* firstName;



//- (BOOL)validateFirstName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* last4;



//- (BOOL)validateLast4:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* mask;



//- (BOOL)validateMask:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* month;



@property int16_t monthValue;
- (int16_t)monthValue;
- (void)setMonthValue:(int16_t)value_;

//- (BOOL)validateMonth:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* year;



@property int16_t yearValue;
- (int16_t)yearValue;
- (void)setYearValue:(int16_t)value_;

//- (BOOL)validateYear:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TXHPayment *payment;

//- (BOOL)validatePayment:(id*)value_ error:(NSError**)error_;





@end

@interface _TXHCard (CoreDataGeneratedAccessors)

@end

@interface _TXHCard (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveBrand;
- (void)setPrimitiveBrand:(NSString*)value;




- (NSString*)primitiveFingerprint;
- (void)setPrimitiveFingerprint:(NSString*)value;




- (NSString*)primitiveFirstName;
- (void)setPrimitiveFirstName:(NSString*)value;




- (NSString*)primitiveLast4;
- (void)setPrimitiveLast4:(NSString*)value;




- (NSString*)primitiveMask;
- (void)setPrimitiveMask:(NSString*)value;




- (NSNumber*)primitiveMonth;
- (void)setPrimitiveMonth:(NSNumber*)value;

- (int16_t)primitiveMonthValue;
- (void)setPrimitiveMonthValue:(int16_t)value_;




- (NSNumber*)primitiveYear;
- (void)setPrimitiveYear:(NSNumber*)value;

- (int16_t)primitiveYearValue;
- (void)setPrimitiveYearValue:(int16_t)value_;





- (TXHPayment*)primitivePayment;
- (void)setPrimitivePayment:(TXHPayment*)value;


@end
