// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHProduct.m instead.

#import "_TXHProduct.h"

const struct TXHProductAttributes TXHProductAttributes = {
	.availabilitiesUpdated = @"availabilitiesUpdated",
	.currency = @"currency",
	.name = @"name",
	.productId = @"productId",
};

const struct TXHProductRelationships TXHProductRelationships = {
	.address = @"address",
	.availabilities = @"availabilities",
	.contact = @"contact",
	.supplier = @"supplier",
	.ticket = @"ticket",
};

const struct TXHProductFetchedProperties TXHProductFetchedProperties = {
};

@implementation TXHProductID
@end

@implementation _TXHProduct

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Product";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Product" inManagedObjectContext:moc_];
}

- (TXHProductID*)objectID {
	return (TXHProductID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic availabilitiesUpdated;






@dynamic currency;






@dynamic name;






@dynamic productId;






@dynamic address;

	

@dynamic availabilities;

	
- (NSMutableSet*)availabilitiesSet {
	[self willAccessValueForKey:@"availabilities"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"availabilities"];
  
	[self didAccessValueForKey:@"availabilities"];
	return result;
}
	

@dynamic contact;

	

@dynamic supplier;

	

@dynamic ticket;

	






@end
