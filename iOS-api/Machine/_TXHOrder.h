// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHOrder.h instead.

#import <CoreData/CoreData.h>


extern const struct TXHOrderAttributes {
	__unsafe_unretained NSString *cancelledAt;
	__unsafe_unretained NSString *confirmedAt;
	__unsafe_unretained NSString *coupon;
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *currency;
	__unsafe_unretained NSString *delivery;
	__unsafe_unretained NSString *expiresAt;
	__unsafe_unretained NSString *orderId;
	__unsafe_unretained NSString *payment;
	__unsafe_unretained NSString *postage;
	__unsafe_unretained NSString *reference;
	__unsafe_unretained NSString *tax;
	__unsafe_unretained NSString *taxName;
	__unsafe_unretained NSString *total;
	__unsafe_unretained NSString *updatedAt;
} TXHOrderAttributes;

extern const struct TXHOrderRelationships {
	__unsafe_unretained NSString *address;
	__unsafe_unretained NSString *customer;
	__unsafe_unretained NSString *tickets;
} TXHOrderRelationships;

extern const struct TXHOrderFetchedProperties {
} TXHOrderFetchedProperties;

@class TXHAddress;
@class TXHCustomer;
@class TXHTicket;

















@interface TXHOrderID : NSManagedObjectID {}
@end

@interface _TXHOrder : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TXHOrderID*)objectID;





@property (nonatomic, strong) NSString* cancelledAt;



//- (BOOL)validateCancelledAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* confirmedAt;



//- (BOOL)validateConfirmedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* coupon;



//- (BOOL)validateCoupon:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* createdAt;



//- (BOOL)validateCreatedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* currency;



//- (BOOL)validateCurrency:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* delivery;



//- (BOOL)validateDelivery:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* expiresAt;



//- (BOOL)validateExpiresAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* orderId;



//- (BOOL)validateOrderId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* payment;



//- (BOOL)validatePayment:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* postage;



@property int32_t postageValue;
- (int32_t)postageValue;
- (void)setPostageValue:(int32_t)value_;

//- (BOOL)validatePostage:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* reference;



//- (BOOL)validateReference:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* tax;



@property int32_t taxValue;
- (int32_t)taxValue;
- (void)setTaxValue:(int32_t)value_;

//- (BOOL)validateTax:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* taxName;



//- (BOOL)validateTaxName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* total;



@property int32_t totalValue;
- (int32_t)totalValue;
- (void)setTotalValue:(int32_t)value_;

//- (BOOL)validateTotal:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* updatedAt;



//- (BOOL)validateUpdatedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TXHAddress *address;

//- (BOOL)validateAddress:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) TXHCustomer *customer;

//- (BOOL)validateCustomer:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *tickets;

- (NSMutableSet*)ticketsSet;





@end

@interface _TXHOrder (CoreDataGeneratedAccessors)

- (void)addTickets:(NSSet*)value_;
- (void)removeTickets:(NSSet*)value_;
- (void)addTicketsObject:(TXHTicket*)value_;
- (void)removeTicketsObject:(TXHTicket*)value_;

@end

@interface _TXHOrder (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCancelledAt;
- (void)setPrimitiveCancelledAt:(NSString*)value;




- (NSString*)primitiveConfirmedAt;
- (void)setPrimitiveConfirmedAt:(NSString*)value;




- (NSString*)primitiveCoupon;
- (void)setPrimitiveCoupon:(NSString*)value;




- (NSString*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSString*)value;




- (NSString*)primitiveCurrency;
- (void)setPrimitiveCurrency:(NSString*)value;




- (NSString*)primitiveDelivery;
- (void)setPrimitiveDelivery:(NSString*)value;




- (NSString*)primitiveExpiresAt;
- (void)setPrimitiveExpiresAt:(NSString*)value;




- (NSString*)primitiveOrderId;
- (void)setPrimitiveOrderId:(NSString*)value;




- (NSString*)primitivePayment;
- (void)setPrimitivePayment:(NSString*)value;




- (NSNumber*)primitivePostage;
- (void)setPrimitivePostage:(NSNumber*)value;

- (int32_t)primitivePostageValue;
- (void)setPrimitivePostageValue:(int32_t)value_;




- (NSString*)primitiveReference;
- (void)setPrimitiveReference:(NSString*)value;




- (NSNumber*)primitiveTax;
- (void)setPrimitiveTax:(NSNumber*)value;

- (int32_t)primitiveTaxValue;
- (void)setPrimitiveTaxValue:(int32_t)value_;




- (NSString*)primitiveTaxName;
- (void)setPrimitiveTaxName:(NSString*)value;




- (NSNumber*)primitiveTotal;
- (void)setPrimitiveTotal:(NSNumber*)value;

- (int32_t)primitiveTotalValue;
- (void)setPrimitiveTotalValue:(int32_t)value_;




- (NSString*)primitiveUpdatedAt;
- (void)setPrimitiveUpdatedAt:(NSString*)value;





- (TXHAddress*)primitiveAddress;
- (void)setPrimitiveAddress:(TXHAddress*)value;



- (TXHCustomer*)primitiveCustomer;
- (void)setPrimitiveCustomer:(TXHCustomer*)value;



- (NSMutableSet*)primitiveTickets;
- (void)setPrimitiveTickets:(NSMutableSet*)value;


@end
