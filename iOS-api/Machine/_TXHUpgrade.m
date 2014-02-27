// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHUpgrade.m instead.

#import "_TXHUpgrade.h"

const struct TXHUpgradeAttributes TXHUpgradeAttributes = {
	.bit = @"bit",
	.internalUpgradeId = @"internalUpgradeId",
	.name = @"name",
	.price = @"price",
	.seqId = @"seqId",
	.upgradeDescription = @"upgradeDescription",
	.upgradeId = @"upgradeId",
};

const struct TXHUpgradeRelationships TXHUpgradeRelationships = {
	.tickets = @"tickets",
	.tiers = @"tiers",
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
	if ([key isEqualToString:@"seqIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"seqId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic bit;






@dynamic internalUpgradeId;






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





@dynamic seqId;



- (int32_t)seqIdValue {
	NSNumber *result = [self seqId];
	return [result intValue];
}

- (void)setSeqIdValue:(int32_t)value_ {
	[self setSeqId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveSeqIdValue {
	NSNumber *result = [self primitiveSeqId];
	return [result intValue];
}

- (void)setPrimitiveSeqIdValue:(int32_t)value_ {
	[self setPrimitiveSeqId:[NSNumber numberWithInt:value_]];
}





@dynamic upgradeDescription;






@dynamic upgradeId;






@dynamic tickets;

	
- (NSMutableSet*)ticketsSet {
	[self willAccessValueForKey:@"tickets"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"tickets"];
  
	[self didAccessValueForKey:@"tickets"];
	return result;
}
	

@dynamic tiers;

	
- (NSMutableSet*)tiersSet {
	[self willAccessValueForKey:@"tiers"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"tiers"];
  
	[self didAccessValueForKey:@"tiers"];
	return result;
}
	






@end
