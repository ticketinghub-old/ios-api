// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHPayment.m instead.

#import "_TXHPayment.h"

const struct TXHPaymentAttributes TXHPaymentAttributes = {
	.amount = @"amount",
	.authorization = @"authorization",
	.avsResult = @"avsResult",
	.currency = @"currency",
	.inputType = @"inputType",
	.postalMatch = @"postalMatch",
	.reference = @"reference",
	.securityCodeResult = @"securityCodeResult",
	.signature = @"signature",
	.streetMatch = @"streetMatch",
	.type = @"type",
	.verificationMethod = @"verificationMethod",
};

const struct TXHPaymentRelationships TXHPaymentRelationships = {
	.address = @"address",
	.card = @"card",
	.gateway = @"gateway",
	.order = @"order",
};

const struct TXHPaymentFetchedProperties TXHPaymentFetchedProperties = {
};

@implementation TXHPaymentID
@end

@implementation _TXHPayment

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Payment" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Payment";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Payment" inManagedObjectContext:moc_];
}

- (TXHPaymentID*)objectID {
	return (TXHPaymentID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"amountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"amount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"postalMatchValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"postalMatch"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"streetMatchValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"streetMatch"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic amount;



- (int64_t)amountValue {
	NSNumber *result = [self amount];
	return [result longLongValue];
}

- (void)setAmountValue:(int64_t)value_ {
	[self setAmount:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveAmountValue {
	NSNumber *result = [self primitiveAmount];
	return [result longLongValue];
}

- (void)setPrimitiveAmountValue:(int64_t)value_ {
	[self setPrimitiveAmount:[NSNumber numberWithLongLong:value_]];
}





@dynamic authorization;






@dynamic avsResult;






@dynamic currency;






@dynamic inputType;






@dynamic postalMatch;



- (BOOL)postalMatchValue {
	NSNumber *result = [self postalMatch];
	return [result boolValue];
}

- (void)setPostalMatchValue:(BOOL)value_ {
	[self setPostalMatch:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitivePostalMatchValue {
	NSNumber *result = [self primitivePostalMatch];
	return [result boolValue];
}

- (void)setPrimitivePostalMatchValue:(BOOL)value_ {
	[self setPrimitivePostalMatch:[NSNumber numberWithBool:value_]];
}





@dynamic reference;






@dynamic securityCodeResult;






@dynamic signature;






@dynamic streetMatch;



- (BOOL)streetMatchValue {
	NSNumber *result = [self streetMatch];
	return [result boolValue];
}

- (void)setStreetMatchValue:(BOOL)value_ {
	[self setStreetMatch:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveStreetMatchValue {
	NSNumber *result = [self primitiveStreetMatch];
	return [result boolValue];
}

- (void)setPrimitiveStreetMatchValue:(BOOL)value_ {
	[self setPrimitiveStreetMatch:[NSNumber numberWithBool:value_]];
}





@dynamic type;






@dynamic verificationMethod;






@dynamic address;

	

@dynamic card;

	

@dynamic gateway;

	

@dynamic order;

	






@end
