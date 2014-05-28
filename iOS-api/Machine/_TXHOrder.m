// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHOrder.m instead.

#import "_TXHOrder.h"

const struct TXHOrderAttributes TXHOrderAttributes = {
	.cancelledAt = @"cancelledAt",
	.confirmedAt = @"confirmedAt",
	.coupon = @"coupon",
	.createdAt = @"createdAt",
	.currency = @"currency",
	.delivery = @"delivery",
	.directt = @"directt",
	.errors = @"errors",
	.expiresAt = @"expiresAt",
	.group = @"group",
	.orderId = @"orderId",
	.postage = @"postage",
	.provisional = @"provisional",
	.reference = @"reference",
	.tax = @"tax",
	.taxName = @"taxName",
	.total = @"total",
	.updatedAt = @"updatedAt",
};

const struct TXHOrderRelationships TXHOrderRelationships = {
	.address = @"address",
	.customer = @"customer",
	.payment = @"payment",
	.tickets = @"tickets",
};

const struct TXHOrderFetchedProperties TXHOrderFetchedProperties = {
};

@implementation TXHOrderID
@end

@implementation _TXHOrder

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Order" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Order";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Order" inManagedObjectContext:moc_];
}

- (TXHOrderID*)objectID {
	return (TXHOrderID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"directtValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"directt"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"groupValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"group"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"postageValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"postage"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"provisionalValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"provisional"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"taxValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"tax"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"totalValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"total"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic cancelledAt;






@dynamic confirmedAt;






@dynamic coupon;






@dynamic createdAt;






@dynamic currency;






@dynamic delivery;






@dynamic directt;



- (int32_t)directtValue {
	NSNumber *result = [self directt];
	return [result intValue];
}

- (void)setDirecttValue:(int32_t)value_ {
	[self setDirectt:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveDirecttValue {
	NSNumber *result = [self primitiveDirectt];
	return [result intValue];
}

- (void)setPrimitiveDirecttValue:(int32_t)value_ {
	[self setPrimitiveDirectt:[NSNumber numberWithInt:value_]];
}





@dynamic errors;






@dynamic expiresAt;






@dynamic group;



- (int32_t)groupValue {
	NSNumber *result = [self group];
	return [result intValue];
}

- (void)setGroupValue:(int32_t)value_ {
	[self setGroup:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveGroupValue {
	NSNumber *result = [self primitiveGroup];
	return [result intValue];
}

- (void)setPrimitiveGroupValue:(int32_t)value_ {
	[self setPrimitiveGroup:[NSNumber numberWithInt:value_]];
}





@dynamic orderId;






@dynamic postage;



- (int32_t)postageValue {
	NSNumber *result = [self postage];
	return [result intValue];
}

- (void)setPostageValue:(int32_t)value_ {
	[self setPostage:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitivePostageValue {
	NSNumber *result = [self primitivePostage];
	return [result intValue];
}

- (void)setPrimitivePostageValue:(int32_t)value_ {
	[self setPrimitivePostage:[NSNumber numberWithInt:value_]];
}





@dynamic provisional;



- (int16_t)provisionalValue {
	NSNumber *result = [self provisional];
	return [result shortValue];
}

- (void)setProvisionalValue:(int16_t)value_ {
	[self setProvisional:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveProvisionalValue {
	NSNumber *result = [self primitiveProvisional];
	return [result shortValue];
}

- (void)setPrimitiveProvisionalValue:(int16_t)value_ {
	[self setPrimitiveProvisional:[NSNumber numberWithShort:value_]];
}





@dynamic reference;






@dynamic tax;



- (int32_t)taxValue {
	NSNumber *result = [self tax];
	return [result intValue];
}

- (void)setTaxValue:(int32_t)value_ {
	[self setTax:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveTaxValue {
	NSNumber *result = [self primitiveTax];
	return [result intValue];
}

- (void)setPrimitiveTaxValue:(int32_t)value_ {
	[self setPrimitiveTax:[NSNumber numberWithInt:value_]];
}





@dynamic taxName;






@dynamic total;



- (int32_t)totalValue {
	NSNumber *result = [self total];
	return [result intValue];
}

- (void)setTotalValue:(int32_t)value_ {
	[self setTotal:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveTotalValue {
	NSNumber *result = [self primitiveTotal];
	return [result intValue];
}

- (void)setPrimitiveTotalValue:(int32_t)value_ {
	[self setPrimitiveTotal:[NSNumber numberWithInt:value_]];
}





@dynamic updatedAt;






@dynamic address;

	

@dynamic customer;

	

@dynamic payment;

	

@dynamic tickets;

	
- (NSMutableSet*)ticketsSet {
	[self willAccessValueForKey:@"tickets"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"tickets"];
  
	[self didAccessValueForKey:@"tickets"];
	return result;
}
	






@end
