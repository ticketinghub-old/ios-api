// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHUpgrade.m instead.

#import "_TXHUpgrade.h"

const struct TXHUpgradeAttributes TXHUpgradeAttributes = {
	.bit = @"bit",
	.name = @"name",
	.price = @"price",
	.upgradeDescription = @"upgradeDescription",
	.upgradeId = @"upgradeId",
};

const struct TXHUpgradeRelationships TXHUpgradeRelationships = {
	.tier = @"tier",
};

const struct TXHUpgradeFetchedProperties TXHUpgradeFetchedProperties = {
};

@implementation TXHUpgradeID
@end

@implementation _TXHUpgrade

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Upgrade" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Upgrade";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Upgrade" inManagedObjectContext:moc_];
}

- (TXHUpgradeID*)objectID {
	return (TXHUpgradeID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"priceValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"price"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic bit;






@dynamic name;






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





@dynamic upgradeDescription;






@dynamic upgradeId;






@dynamic tier;

	






#if TARGET_OS_IPHONE



#endif

@end
