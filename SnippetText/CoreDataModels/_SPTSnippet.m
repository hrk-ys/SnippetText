// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SPTSnippet.m instead.

#import "_SPTSnippet.h"

const struct SPTSnippetAttributes SPTSnippetAttributes = {
	.content = @"content",
	.orderNum = @"orderNum",
	.secret = @"secret",
	.title = @"title",
};

const struct SPTSnippetRelationships SPTSnippetRelationships = {
};

const struct SPTSnippetFetchedProperties SPTSnippetFetchedProperties = {
};

@implementation SPTSnippetID
@end

@implementation _SPTSnippet

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Snippet" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Snippet";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Snippet" inManagedObjectContext:moc_];
}

- (SPTSnippetID*)objectID {
	return (SPTSnippetID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"orderNumValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"orderNum"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"secretValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"secret"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic content;






@dynamic orderNum;



- (int16_t)orderNumValue {
	NSNumber *result = [self orderNum];
	return [result shortValue];
}

- (void)setOrderNumValue:(int16_t)value_ {
	[self setOrderNum:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveOrderNumValue {
	NSNumber *result = [self primitiveOrderNum];
	return [result shortValue];
}

- (void)setPrimitiveOrderNumValue:(int16_t)value_ {
	[self setPrimitiveOrderNum:[NSNumber numberWithShort:value_]];
}





@dynamic secret;



- (BOOL)secretValue {
	NSNumber *result = [self secret];
	return [result boolValue];
}

- (void)setSecretValue:(BOOL)value_ {
	[self setSecret:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveSecretValue {
	NSNumber *result = [self primitiveSecret];
	return [result boolValue];
}

- (void)setPrimitiveSecretValue:(BOOL)value_ {
	[self setPrimitiveSecret:[NSNumber numberWithBool:value_]];
}





@dynamic title;











@end
