// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHAddress.m instead.

#import "_TXHAddress.h"

const struct TXHAddressAttributes TXHAddressAttributes = {
	.building = @"building",
	.city = @"city",
	.country = @"country",
	.formatted = @"formatted",
	.postal_code = @"postal_code",
	.region = @"region",
	.street = @"street",
};

const struct TXHAddressRelationships TXHAddressRelationships = {
	.customer = @"customer",
	.order = @"order",
	.payment = @"payment",
	.product = @"product",
};

const struct TXHAddressFetchedProperties TXHAddressFetchedProperties = {
};

@implementation TXHAddressID
@end

@implementation _TXHAddress

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Address" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Address";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Address" inManagedObjectContext:moc_];
}

- (TXHAddressID*)objectID {
	return (TXHAddressID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic building;






@dynamic city;






@dynamic country;






@dynamic formatted;






@dynamic postal_code;






@dynamic region;






@dynamic street;






@dynamic customer;

	

@dynamic order;

	

@dynamic payment;

	

@dynamic product;

	






@end
