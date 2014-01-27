//
//  VeraUnit.h
//
//  Created by Scott Gruby on 12/7/13
//  Copyright (c) 2013 Gruby Solutions. All rights reserved.
//

#import "VeraUnit.h"
#import "VeraForwardServer.h"


NSString *const kUnitSerialNumber = @"serialNumber";
NSString *const kUnitActiveServer = @"active_server";
NSString *const kUnitForwardServers = @"forwardServers";
NSString *const kUnitIpAddress = @"ipAddress";
NSString *const kUnitFirmwareVersion = @"FirmwareVersion";
NSString *const kUnitUsers = @"users";
NSString *const kUnitName = @"name";


@implementation VeraUnit

+ (VeraUnit *)modelObjectWithDictionary:(NSDictionary *)dict
{
    VeraUnit *instance = [[VeraUnit alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]])
	{
		_serialNumber = dict[kUnitSerialNumber];
        _activeServer = dict[kUnitActiveServer];
		_ipAddress = dict[kUnitIpAddress];
		_firmwareVersion = dict[kUnitFirmwareVersion];
		_users = dict[kUnitUsers];
		_name = dict[kUnitName];
    
		NSObject *receivedForwardServers = dict[kUnitForwardServers];
		NSMutableArray *parsedForwardServers = [NSMutableArray array];
    
		if ([receivedForwardServers isKindOfClass:[NSArray class]])
		{
			for (NSDictionary *item in (NSArray *)receivedForwardServers)
			{
				if ([item isKindOfClass:[NSDictionary class]])
				{
					[parsedForwardServers addObject:[VeraForwardServer modelObjectWithDictionary:item]];
				}
			}
		}
		else if ([receivedForwardServers isKindOfClass:[NSDictionary class]])
		{
			[parsedForwardServers addObject:[VeraForwardServer modelObjectWithDictionary:(NSDictionary *)receivedForwardServers]];
		}

		_forwardServers = [NSArray arrayWithArray:parsedForwardServers];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
	if (self.serialNumber)
	{
		mutableDict[kUnitSerialNumber] = self.serialNumber;
	}
	
	if (self.activeServer)
	{
		mutableDict[kUnitActiveServer] = self.activeServer;
	}
	
	if (self.ipAddress)
	{
		mutableDict[kUnitIpAddress] = self.ipAddress;
	}
	
	if (self.firmwareVersion)
	{
		mutableDict[kUnitFirmwareVersion] = self.firmwareVersion;
	}
	
	if (self.name)
	{
		mutableDict[kUnitName] = self.name;
	}

	NSMutableArray *tempArrayForForwardServers = [NSMutableArray array];
    for (NSObject *subArrayObject in self.forwardServers)
	{
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)])
		{
            // This class is a model object
            [tempArrayForForwardServers addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        }
		else
		{
            // Generic object
            [tempArrayForForwardServers addObject:subArrayObject];
        }
    }
	
	mutableDict[@"ForwardServers"] = [NSArray arrayWithArray:tempArrayForForwardServers];

	NSMutableArray *tempArrayForUsers = [NSMutableArray array];
    for (NSObject *subArrayObject in self.users)
	{
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)])
		{
            // This class is a model object
            [tempArrayForUsers addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        }
		else
		{
            // Generic object
            [tempArrayForUsers addObject:subArrayObject];
        }
    }

	mutableDict[@"UnitUsers"] = [NSArray arrayWithArray:tempArrayForUsers];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

@end
