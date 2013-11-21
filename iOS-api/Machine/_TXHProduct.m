// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHProduct.m instead.

#import "_TXHProduct.h"

const struct TXHProductAttributes TXHProductAttributes = {
	.name = @"name",
	.productId = @"productId",
};

const struct TXHProductRelationships TXHProductRelationships = {
	.supplier = @"supplier",
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




@dynamic name;






@dynamic productId;






@dynamic supplier;

	






#if TARGET_OS_IPHONE



#endif

@end
