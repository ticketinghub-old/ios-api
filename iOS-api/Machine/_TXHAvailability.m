// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHAvailability.m instead.

#import "_TXHAvailability.h"

const struct TXHAvailabilityAttributes TXHAvailabilityAttributes = {
	.dateString = @"dateString",
	.duration = @"duration",
	.limit = @"limit",
	.timeString = @"timeString",
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
	
	if ([key isEqualToString:@"limitValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"limit"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




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






@dynamic product;

	

@dynamic tiers;

	
- (NSMutableSet*)tiersSet {
	[self willAccessValueForKey:@"tiers"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"tiers"];
  
	[self didAccessValueForKey:@"tiers"];
	return result;
}
	






#if TARGET_OS_IPHONE




- (NSFetchedResultsController*)newTiersFetchedResultsControllerWithSortDescriptors:(NSArray*)sortDescriptors {
	NSFetchRequest *fetchRequest = [NSFetchRequest new];
	
	fetchRequest.entity = [NSEntityDescription entityForName:@"Tier" inManagedObjectContext:self.managedObjectContext];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"availability == %@", self];
	fetchRequest.sortDescriptors = sortDescriptors;
	
	return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
											   managedObjectContext:self.managedObjectContext
												 sectionNameKeyPath:nil
														  cacheName:nil];
}


#endif

@end
