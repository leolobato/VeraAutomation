//
//  VeraRooms.m
//
//  Created by Scott Gruby on 12/7/13
//  Copyright (c) 2013 Gruby Solutions. All rights reserved.
//

#import "VeraRoom.h"


NSString *const kVeraRoomName = @"name";
NSString *const kVeraRoomId = @"id";
NSString *const kVeraRoomSection = @"section";

@implementation VeraRoom

+ (VeraRoom *)modelObjectWithDictionary:(NSDictionary *)dict
{
    VeraRoom *instance = [[VeraRoom alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]])
	{
		_name = dict[kVeraRoomName];
		_roomIdentifier = [dict[kVeraRoomId] integerValue];
		_section = [dict[kVeraRoomSection] integerValue];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
	if (self.name)
	{
		mutableDict[kVeraRoomName] = self.name;
	}

	mutableDict[kVeraRoomId] = [NSNumber numberWithInteger:self.roomIdentifier];
	mutableDict[kVeraRoomSection] = [NSNumber numberWithInteger:self.section];

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

    _name = [aDecoder decodeObjectForKey:kVeraRoomName];
    _roomIdentifier = [aDecoder decodeIntegerForKey:kVeraRoomId];
    _section = [aDecoder decodeIntegerForKey:kVeraRoomSection];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_name forKey:kVeraRoomName];
    [aCoder encodeInteger:_roomIdentifier forKey:kVeraRoomId];
    [aCoder encodeInteger:_section forKey:kVeraRoomSection];
}

- (void) addDevice:(VeraDevice *) device
{
	NSMutableArray *devices = [NSMutableArray array];
	if ([self.devices count])
	{
		[devices addObjectsFromArray:self.devices];
	}
	
	[devices addObject:device];
	
	self.devices = devices;
}

- (BOOL)isEqual:(id)object
{
	if ([object isKindOfClass:[VeraRoom class]])
	{
		if (self.roomIdentifier == ((VeraRoom *) object).roomIdentifier)
		{
			return YES;
		}
	}
	
	return NO;
}

@end
