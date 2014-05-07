// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHGateway.m instead.

#import "_TXHGateway.h"

const struct TXHGatewayAttributes TXHGatewayAttributes = {
	.gatewayId = @"gatewayId",
	.publishableKey = @"publishableKey",
	.type = @"type",
};

const struct TXHGatewayRelationships TXHGatewayRelationships = {
	.payment = @"payment",
};

const struct TXHGatewayFetchedProperties TXHGatewayFetchedProperties = {
};

@implementation TXHGatewayID
@end

@implementation _TXHGateway

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Gateway" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Gateway";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Gateway" inManagedObjectContext:moc_];
}

- (TXHGatewayID*)objectID {
	return (TXHGatewayID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic gatewayId;






@dynamic publishableKey;






@dynamic type;






@dynamic payment;

	






@end
