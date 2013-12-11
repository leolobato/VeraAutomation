//
//  ForwardServers.m
//
//  Created by Scott Gruby on 12/7/13
//  Copyright (c) 2013 Gruby Soltuons. All rights reserved.
//

#import "VeraForwardServer.h"


NSString *const kForwardServerPrimary = @"primary";
NSString *const kForwardServerHostName = @"hostName";

@implementation VeraForwardServer

+ (VeraForwardServer *)modelObjectWithDictionary:(NSDictionary *)dict
{
    VeraForwardServer *instance = [[VeraForwardServer alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]])
	{
		_primary = [dict[kForwardServerPrimary] boolValue];
		_hostName = dict[kForwardServerHostName];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
	mutableDict[kForwardServerPrimary] = [NSNumber numberWithBool:self.primary];
	if (self.hostName)
	{
		mutableDict[kForwardServerHostName] = self.hostName;
	}

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method

#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    _primary = [aDecoder decodeBoolForKey:kForwardServerPrimary];
    _hostName = [aDecoder decodeObjectForKey:kForwardServerHostName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeBool:_primary forKey:kForwardServerPrimary];
    [aCoder encodeObject:_hostName forKey:kForwardServerHostName];
}


@end
