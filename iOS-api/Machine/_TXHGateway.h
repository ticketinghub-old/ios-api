// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHGateway.h instead.

#import <CoreData/CoreData.h>


extern const struct TXHGatewayAttributes {
	__unsafe_unretained NSString *gatewayId;
	__unsafe_unretained NSString *publishableKey;
	__unsafe_unretained NSString *type;
} TXHGatewayAttributes;

extern const struct TXHGatewayRelationships {
	__unsafe_unretained NSString *payment;
} TXHGatewayRelationships;

extern const struct TXHGatewayFetchedProperties {
} TXHGatewayFetchedProperties;

@class TXHPayment;





@interface TXHGatewayID : NSManagedObjectID {}
@end

@interface _TXHGateway : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TXHGatewayID*)objectID;





@property (nonatomic, strong) NSString* gatewayId;



//- (BOOL)validateGatewayId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* publishableKey;



//- (BOOL)validatePublishableKey:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* type;



//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TXHPayment *payment;

//- (BOOL)validatePayment:(id*)value_ error:(NSError**)error_;





@end

@interface _TXHGateway (CoreDataGeneratedAccessors)

@end

@interface _TXHGateway (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveGatewayId;
- (void)setPrimitiveGatewayId:(NSString*)value;




- (NSString*)primitivePublishableKey;
- (void)setPrimitivePublishableKey:(NSString*)value;




- (NSString*)primitiveType;
- (void)setPrimitiveType:(NSString*)value;





- (TXHPayment*)primitivePayment;
- (void)setPrimitivePayment:(TXHPayment*)value;


@end
