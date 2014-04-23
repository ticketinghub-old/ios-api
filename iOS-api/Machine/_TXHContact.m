// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHContact.m instead.

#import "_TXHContact.h"

const struct TXHContactAttributes TXHContactAttributes = {
	.email = @"email",
	.telephone = @"telephone",
	.website = @"website",
};

const struct TXHContactRelationships TXHContactRelationships = {
	.product = @"product",
};

const struct TXHContactFetchedProperties TXHContactFetchedProperties = {
};

@implementation TXHContactID
@end

@implementation _TXHContact

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Contact";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:moc_];
}

- (TXHContactID*)objectID {
	return (TXHContactID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic email;






@dynamic telephone;






@dynamic website;






@dynamic product;

	






@end
