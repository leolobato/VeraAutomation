//
//  VeraCategories.m
//
//  Created by Scott Gruby on 12/7/13
//  Copyright (c) 2013 Gruby Solutions. All rights reserved.
//

#import "VeraCategories.h"


NSString *const kVeraCategoriesName = @"name";
NSString *const kVeraCategoriesId = @"id";


@implementation VeraCategories

+ (VeraCategories *)modelObjectWithDictionary:(NSDictionary *)dict
{
    VeraCategories *instance = [[VeraCategories alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]])
	{
		_name = dict[kVeraCategoriesName];
		_categoriesIdentifier = [dict[kVeraCategoriesId] integerValue];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
	if (self.name)
	{
		mutableDict[kVeraCategoriesName] = self.name;
	}
	
	mutableDict[kVeraCategoriesId] = [NSNumber numberWithInteger:self.categoriesIdentifier];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    _name = [aDecoder decodeObjectForKey:kVeraCategoriesName];
    _categoriesIdentifier = [aDecoder decodeIntegerForKey:kVeraCategoriesId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_name forKey:kVeraCategoriesName];
    [aCoder encodeInteger:_categoriesIdentifier forKey:kVeraCategoriesId];
}


@end
