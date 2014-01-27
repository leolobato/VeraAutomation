//
//  VeraSections.m
//
//  Created by Scott Gruby on 12/7/13
//  Copyright (c) 2013 Gruby Solutions. All rights reserved.
//

#import "VeraSections.h"


NSString *const kVeraSectionsName = @"name";
NSString *const kVeraSectionsId = @"id";

@implementation VeraSections

+ (VeraSections *)modelObjectWithDictionary:(NSDictionary *)dict
{
    VeraSections *instance = [[VeraSections alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]])
	{
		_name = dict[kVeraSectionsName];
		_sectionsIdentifier = [dict[kVeraSectionsId] integerValue];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
	if (self.name)
	{
		mutableDict[kVeraSectionsName] = self.name;
	}

	mutableDict[kVeraSectionsId] = [NSNumber numberWithInteger:self.sectionsIdentifier];

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

    _name = [aDecoder decodeObjectForKey:kVeraSectionsName];
    _sectionsIdentifier = [aDecoder decodeIntegerForKey:kVeraSectionsId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_name forKey:kVeraSectionsName];
    [aCoder encodeInteger:_sectionsIdentifier forKey:kVeraSectionsId];
}


@end
