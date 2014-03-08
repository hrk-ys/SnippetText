// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SPTSnippet.h instead.

#import <CoreData/CoreData.h>


extern const struct SPTSnippetAttributes {
	__unsafe_unretained NSString *content;
	__unsafe_unretained NSString *orderNum;
	__unsafe_unretained NSString *secret;
	__unsafe_unretained NSString *title;
} SPTSnippetAttributes;

extern const struct SPTSnippetRelationships {
} SPTSnippetRelationships;

extern const struct SPTSnippetFetchedProperties {
} SPTSnippetFetchedProperties;







@interface SPTSnippetID : NSManagedObjectID {}
@end

@interface _SPTSnippet : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SPTSnippetID*)objectID;





@property (nonatomic, strong) NSString* content;



//- (BOOL)validateContent:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* orderNum;



@property int16_t orderNumValue;
- (int16_t)orderNumValue;
- (void)setOrderNumValue:(int16_t)value_;

//- (BOOL)validateOrderNum:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* secret;



@property BOOL secretValue;
- (BOOL)secretValue;
- (void)setSecretValue:(BOOL)value_;

//- (BOOL)validateSecret:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;






@end

@interface _SPTSnippet (CoreDataGeneratedAccessors)

@end

@interface _SPTSnippet (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveContent;
- (void)setPrimitiveContent:(NSString*)value;




- (NSNumber*)primitiveOrderNum;
- (void)setPrimitiveOrderNum:(NSNumber*)value;

- (int16_t)primitiveOrderNumValue;
- (void)setPrimitiveOrderNumValue:(int16_t)value_;




- (NSNumber*)primitiveSecret;
- (void)setPrimitiveSecret:(NSNumber*)value;

- (BOOL)primitiveSecretValue;
- (void)setPrimitiveSecretValue:(BOOL)value_;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




@end
