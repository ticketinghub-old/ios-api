// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHAvailability.m instead.

#import "_TXHAvailability.h"

const struct TXHAvailabilityAttributes TXHAvailabilityAttributes = {
	.capacity = @"capacity",
	.coupon = @"coupon",
	.dateString = @"dateString",
	.duration = @"duration",
	.limit = @"limit",
	.timeString = @"timeString",
	.total = @"total",
};

const struct TXHAvailabilityRelationships TXHAvailabilityRelationships = {
	.product = @"product",
	.tiers = @"tiers",
};

const struct TXHAvailabilityFetchedProperties TXHAvailabilityFetchedProperties = {
};

@implementation TXHAvailabilityID
@end

@implementation _TXHAvailability

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Availability" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Availability";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Availability" inManagedObjectContext:moc_];
}

- (TXHAvailabilityID*)objectID {
	return (TXHAvailabilityID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"capacityValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"capacity"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"limitValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"limit"];
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




@dynamic capacity;



- (int32_t)capacityValue {
	NSNumber *result = [self capacity];
	return [result intValue];
}

- (void)setCapacityValue:(int32_t)value_ {
	[self setCapacity:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveCapacityValue {
	NSNumber *result = [self primitiveCapacity];
	return [result intValue];
}

- (void)setPrimitiveCapacityValue:(int32_t)value_ {
	[self setPrimitiveCapacity:[NSNumber numberWithInt:value_]];
}





@dynamic coupon;






@dynamic dateString;






@dynamic duration;






@dynamic limit;



- (int32_t)limitValue {
	NSNumber *result = [self limit];
	return [result intValue];
}

- (void)setLimitValue:(int32_t)value_ {
	[self setLimit:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveLimitValue {
	NSNumber *result = [self primitiveLimit];
	return [result intValue];
}

- (void)setPrimitiveLimitValue:(int32_t)value_ {
	[self setPrimitiveLimit:[NSNumber numberWithInt:value_]];
}





@dynamic timeString;






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





@dynamic product;

	

@dynamic tiers;

	
- (NSMutableSet*)tiersSet {
	[self willAccessValueForKey:@"tiers"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"tiers"];
  
	[self didAccessValueForKey:@"tiers"];
	return result;
}
	






@end
