// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TXHUser.m instead.

#import "_TXHUser.h"

const struct TXHUserAttributes TXHUserAttributes = {
	.email = @"email",
	.firstName = @"firstName",
	.lastName = @"lastName",
	.userId = @"userId",
};

const struct TXHUserRelationships TXHUserRelationships = {
	.suppliers = @"suppliers",
};

const struct TXHUserFetchedProperties TXHUserFetchedProperties = {
};

@implementation TXHUserID
@end

@implementation _TXHUser

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"User";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"User" inManagedObjectContext:moc_];
}

- (TXHUserID*)objectID {
	return (TXHUserID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic email;






@dynamic firstName;






@dynamic lastName;






@dynamic userId;






@dynamic suppliers;

	
- (NSMutableSet*)suppliersSet {
	[self willAccessValueForKey:@"suppliers"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"suppliers"];
  
	[self didAccessValueForKey:@"suppliers"];
	return result;
}
	






@end
