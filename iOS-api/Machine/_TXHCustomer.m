// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHCustomer.m instead.

#import "_TXHCustomer.h"

const struct TXHCustomerAttributes TXHCustomerAttributes = {
	.country = @"country",
	.email = @"email",
	.firstName = @"firstName",
	.fullName = @"fullName",
	.lastName = @"lastName",
	.telephone = @"telephone",
};

const struct TXHCustomerRelationships TXHCustomerRelationships = {
	.order = @"order",
	.ticket = @"ticket",
};

const struct TXHCustomerFetchedProperties TXHCustomerFetchedProperties = {
};

@implementation TXHCustomerID
@end

@implementation _TXHCustomer

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Customer" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Customer";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Customer" inManagedObjectContext:moc_];
}

- (TXHCustomerID*)objectID {
	return (TXHCustomerID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic country;






@dynamic email;






@dynamic firstName;






@dynamic fullName;






@dynamic lastName;






@dynamic telephone;






@dynamic order;

	

@dynamic ticket;

	






@end
