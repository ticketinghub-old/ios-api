// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHSupplier.m instead.

#import "_TXHSupplier.h"

const struct TXHSupplierAttributes TXHSupplierAttributes = {
	.accessToken = @"accessToken",
	.country = @"country",
	.currency = @"currency",
	.refreshToken = @"refreshToken",
	.timeZoneName = @"timeZoneName",
};

const struct TXHSupplierRelationships TXHSupplierRelationships = {
	.products = @"products",
	.user = @"user",
};

const struct TXHSupplierFetchedProperties TXHSupplierFetchedProperties = {
};

@implementation TXHSupplierID
@end

@implementation _TXHSupplier

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Supplier" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Supplier";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Supplier" inManagedObjectContext:moc_];
}

- (TXHSupplierID*)objectID {
	return (TXHSupplierID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic accessToken;






@dynamic country;






@dynamic currency;






@dynamic refreshToken;






@dynamic timeZoneName;






@dynamic products;

	
- (NSMutableSet*)productsSet {
	[self willAccessValueForKey:@"products"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"products"];
  
	[self didAccessValueForKey:@"products"];
	return result;
}
	

@dynamic user;

	






@end
