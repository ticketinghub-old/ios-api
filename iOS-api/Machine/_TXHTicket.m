// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHTicket.m instead.

#import "_TXHTicket.h"

const struct TXHTicketAttributes TXHTicketAttributes = {
	.attendedAt = @"attendedAt",
	.bitmask = @"bitmask",
	.code = @"code",
	.errors = @"errors",
	.expiresAt = @"expiresAt",
	.price = @"price",
	.reference = @"reference",
	.serial = @"serial",
	.ticketId = @"ticketId",
	.validFrom = @"validFrom",
	.voucher = @"voucher",
};

const struct TXHTicketRelationships TXHTicketRelationships = {
	.customer = @"customer",
	.order = @"order",
	.product = @"product",
	.tier = @"tier",
	.upgrades = @"upgrades",
};

const struct TXHTicketFetchedProperties TXHTicketFetchedProperties = {
};

@implementation TXHTicketID
@end

@implementation _TXHTicket

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Ticket" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Ticket";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Ticket" inManagedObjectContext:moc_];
}

- (TXHTicketID*)objectID {
	return (TXHTicketID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"bitmaskValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"bitmask"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"priceValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"price"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"serialValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"serial"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic attendedAt;






@dynamic bitmask;



- (int32_t)bitmaskValue {
	NSNumber *result = [self bitmask];
	return [result intValue];
}

- (void)setBitmaskValue:(int32_t)value_ {
	[self setBitmask:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveBitmaskValue {
	NSNumber *result = [self primitiveBitmask];
	return [result intValue];
}

- (void)setPrimitiveBitmaskValue:(int32_t)value_ {
	[self setPrimitiveBitmask:[NSNumber numberWithInt:value_]];
}





@dynamic code;






@dynamic errors;






@dynamic expiresAt;






@dynamic price;



- (int32_t)priceValue {
	NSNumber *result = [self price];
	return [result intValue];
}

- (void)setPriceValue:(int32_t)value_ {
	[self setPrice:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitivePriceValue {
	NSNumber *result = [self primitivePrice];
	return [result intValue];
}

- (void)setPrimitivePriceValue:(int32_t)value_ {
	[self setPrimitivePrice:[NSNumber numberWithInt:value_]];
}





@dynamic reference;






@dynamic serial;



- (int32_t)serialValue {
	NSNumber *result = [self serial];
	return [result intValue];
}

- (void)setSerialValue:(int32_t)value_ {
	[self setSerial:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveSerialValue {
	NSNumber *result = [self primitiveSerial];
	return [result intValue];
}

- (void)setPrimitiveSerialValue:(int32_t)value_ {
	[self setPrimitiveSerial:[NSNumber numberWithInt:value_]];
}





@dynamic ticketId;






@dynamic validFrom;






@dynamic voucher;






@dynamic customer;

	

@dynamic order;

	

@dynamic product;

	

@dynamic tier;

	

@dynamic upgrades;

	
- (NSMutableSet*)upgradesSet {
	[self willAccessValueForKey:@"upgrades"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"upgrades"];
  
	[self didAccessValueForKey:@"upgrades"];
	return result;
}
	






@end
