// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHCard.m instead.

#import "_TXHCard.h"

const struct TXHCardAttributes TXHCardAttributes = {
	.brand = @"brand",
	.fingerprint = @"fingerprint",
	.firstName = @"firstName",
	.last4 = @"last4",
	.lastName = @"lastName",
	.mask = @"mask",
	.month = @"month",
	.number = @"number",
	.scheme = @"scheme",
	.securityCode = @"securityCode",
	.trackData = @"trackData",
	.year = @"year",
};

const struct TXHCardRelationships TXHCardRelationships = {
	.payment = @"payment",
};

const struct TXHCardFetchedProperties TXHCardFetchedProperties = {
};

@implementation TXHCardID
@end

@implementation _TXHCard

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Card";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Card" inManagedObjectContext:moc_];
}

- (TXHCardID*)objectID {
	return (TXHCardID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"monthValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"month"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"yearValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"year"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic brand;






@dynamic fingerprint;






@dynamic firstName;






@dynamic last4;






@dynamic lastName;






@dynamic mask;






@dynamic month;



- (int16_t)monthValue {
	NSNumber *result = [self month];
	return [result shortValue];
}

- (void)setMonthValue:(int16_t)value_ {
	[self setMonth:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveMonthValue {
	NSNumber *result = [self primitiveMonth];
	return [result shortValue];
}

- (void)setPrimitiveMonthValue:(int16_t)value_ {
	[self setPrimitiveMonth:[NSNumber numberWithShort:value_]];
}





@dynamic number;






@dynamic scheme;






@dynamic securityCode;






@dynamic trackData;






@dynamic year;



- (int16_t)yearValue {
	NSNumber *result = [self year];
	return [result shortValue];
}

- (void)setYearValue:(int16_t)value_ {
	[self setYear:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveYearValue {
	NSNumber *result = [self primitiveYear];
	return [result shortValue];
}

- (void)setPrimitiveYearValue:(int16_t)value_ {
	[self setPrimitiveYear:[NSNumber numberWithShort:value_]];
}





@dynamic payment;

	






@end
