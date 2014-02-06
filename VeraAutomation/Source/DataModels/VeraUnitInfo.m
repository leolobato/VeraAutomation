//
//  VeraUnitInfo.m
//
//  Created by Scott Gruby on 12/7/13
//  Copyright (c) 2013 Gruby Solutions. All rights reserved.
//

#import "VeraUnitInfo.h"
#import "VeraCategories.h"
#import "VeraScene.h"
#import "VeraDevice.h"
#import "VeraSections.h"
#import "VeraRoom.h"


NSString *const kVeraUnitInfoState = @"state";
NSString *const kVeraUnitInfoCategories = @"categories";
NSString *const kVeraUnitInfoScenes = @"scenes";
NSString *const kVeraUnitInfoTemperature = @"temperature";
NSString *const kVeraUnitInfoIrtx = @"irtx";
NSString *const kVeraUnitInfoDevices = @"devices";
NSString *const kVeraUnitInfoVersion = @"version";
NSString *const kVeraUnitInfoIr = @"ir";
NSString *const kVeraUnitInfoFwd2 = @"fwd2";
NSString *const kVeraUnitInfoFull = @"full";
NSString *const kVeraUnitInfoSerialNumber = @"serial_number";
NSString *const kVeraUnitInfoSections = @"sections";
NSString *const kVeraUnitInfoLoadtime = @"loadtime";
NSString *const kVeraUnitInfoZwaveHeal = @"zwave_heal";
NSString *const kVeraUnitInfoFwd1 = @"fwd1";
NSString *const kVeraUnitInfoDataversion = @"dataversion";
NSString *const kVeraUnitInfoComment = @"comment";
NSString *const kVeraUnitInfoModel = @"model";
NSString *const kVeraUnitInfoRooms = @"rooms";


@interface VeraUnitInfo ()
- (VeraDevice *) deviceWithIdentifier:(NSInteger) deviceIdentifier;
@end

@implementation VeraUnitInfo


+ (VeraUnitInfo *)modelObjectWithDictionary:(NSDictionary *)dict
{
    VeraUnitInfo *instance = [[VeraUnitInfo alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]])
	{
		_state = [dict[kVeraUnitInfoState] integerValue];
		_temperatureUnits = dict[kVeraUnitInfoTemperature];
		_irtx = dict[kVeraUnitInfoIrtx];
        _version = dict[kVeraUnitInfoVersion];
        _ir = [dict[kVeraUnitInfoIr] doubleValue];
		_fwd1 = dict[kVeraUnitInfoFwd1];
		_fwd2 = dict[kVeraUnitInfoFwd2];
		_full = [dict[kVeraUnitInfoFull] boolValue];
		_serialNumber = dict[kVeraUnitInfoSerialNumber];
		_loadtime = [dict[kVeraUnitInfoLoadtime] integerValue];
		_zwaveHeal = [dict[kVeraUnitInfoZwaveHeal] doubleValue];
		_dataversion = [dict[kVeraUnitInfoDataversion] integerValue];
		_comment = dict[kVeraUnitInfoComment];
		_model = dict[kVeraUnitInfoModel];

		NSObject *receivedVeraCategories = dict[kVeraUnitInfoCategories];
		NSMutableArray *parsedVeraCategories = [NSMutableArray array];
		if ([receivedVeraCategories isKindOfClass:[NSArray class]])
		{
			for (NSDictionary *item in (NSArray *)receivedVeraCategories)
			{
				if ([item isKindOfClass:[NSDictionary class]])
				{
					[parsedVeraCategories addObject:[VeraCategories modelObjectWithDictionary:item]];
				}
			}
		}
		else if ([receivedVeraCategories isKindOfClass:[NSDictionary class]])
		{
			[parsedVeraCategories addObject:[VeraCategories modelObjectWithDictionary:(NSDictionary *)receivedVeraCategories]];
		}

		_categories = [NSArray arrayWithArray:parsedVeraCategories];
		NSObject *receivedVeraScenes = dict[kVeraUnitInfoScenes];
		NSMutableArray *parsedVeraScenes = [NSMutableArray array];
		if ([receivedVeraScenes isKindOfClass:[NSArray class]])
		{
			for (NSDictionary *item in (NSArray *)receivedVeraScenes)
			{
				if ([item isKindOfClass:[NSDictionary class]])
				{
					[parsedVeraScenes addObject:[VeraScene modelObjectWithDictionary:item]];
				}
			}
		}
		else if ([receivedVeraScenes isKindOfClass:[NSDictionary class]])
		{
			[parsedVeraScenes addObject:[VeraScene modelObjectWithDictionary:(NSDictionary *)receivedVeraScenes]];
		}

		_scenes = [NSArray arrayWithArray:parsedVeraScenes];
    
		NSObject *receivedVeraDevices = dict[kVeraUnitInfoDevices];
		NSMutableArray *parsedVeraDevices = [NSMutableArray array];
		if ([receivedVeraDevices isKindOfClass:[NSArray class]])
		{
			for (NSDictionary *item in (NSArray *)receivedVeraDevices)
			{
				if ([item isKindOfClass:[NSDictionary class]])
				{
					[parsedVeraDevices addObject:[VeraDevice modelObjectWithDictionary:item]];
				}
			}
		}
		else if ([receivedVeraDevices isKindOfClass:[NSDictionary class]])
		{
			[parsedVeraDevices addObject:[VeraDevice modelObjectWithDictionary:(NSDictionary *)receivedVeraDevices]];
		}

		_devices = [NSArray arrayWithArray:parsedVeraDevices];
    
		NSObject *receivedVeraSections = dict[kVeraUnitInfoSections];
    
		NSMutableArray *parsedVeraSections = [NSMutableArray array];
		if ([receivedVeraSections isKindOfClass:[NSArray class]])
		{
			for (NSDictionary *item in (NSArray *)receivedVeraSections)
			{
				if ([item isKindOfClass:[NSDictionary class]])
				{
					[parsedVeraSections addObject:[VeraSections modelObjectWithDictionary:item]];
				}
			}
		}
		else if ([receivedVeraSections isKindOfClass:[NSDictionary class]])
		{
			[parsedVeraSections addObject:[VeraSections modelObjectWithDictionary:(NSDictionary *)receivedVeraSections]];
		}

		_sections = [NSArray arrayWithArray:parsedVeraSections];
    
		NSObject *receivedVeraRooms = dict[kVeraUnitInfoRooms];

		NSMutableArray *parsedVeraRooms = [NSMutableArray array];
		if ([receivedVeraRooms isKindOfClass:[NSArray class]])
		{
			for (NSDictionary *item in (NSArray *)receivedVeraRooms)
			{
				if ([item isKindOfClass:[NSDictionary class]])
				{
					[parsedVeraRooms addObject:[VeraRoom modelObjectWithDictionary:item]];
				}
			}
		}
		else if ([receivedVeraRooms isKindOfClass:[NSDictionary class]])
		{
			[parsedVeraRooms addObject:[VeraRoom modelObjectWithDictionary:(NSDictionary *)receivedVeraRooms]];
		}

		_rooms = [NSArray arrayWithArray:parsedVeraRooms];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
	mutableDict[kVeraUnitInfoState] = [NSNumber numberWithInteger:self.state];
	if (self.temperatureUnits)
	{
		mutableDict[kVeraUnitInfoTemperature] = self.temperatureUnits;
	}
	
	if (self.irtx)
	{
		mutableDict[kVeraUnitInfoIrtx] = self.irtx;
	}
	
	if (self.version)
	{
		mutableDict[kVeraUnitInfoVersion] = self.version;
	}
	mutableDict[kVeraUnitInfoIr] = [NSNumber numberWithDouble:self.ir];
	if (self.fwd2)
	{
		mutableDict[kVeraUnitInfoFwd2] = self.fwd2;
	}
	
	mutableDict[kVeraUnitInfoFull] = [NSNumber numberWithBool:self.full];
	
	if (self.serialNumber)
	{
		mutableDict[kVeraUnitInfoSerialNumber] = self.serialNumber;
	}

	mutableDict[kVeraUnitInfoLoadtime] = [NSNumber numberWithInteger:self.loadtime];
	mutableDict[kVeraUnitInfoZwaveHeal] = [NSNumber numberWithDouble:self.zwaveHeal];
	if (self.fwd1)
	{
		mutableDict[kVeraUnitInfoFwd1] = self.fwd1;
	}
	
	mutableDict[kVeraUnitInfoDataversion] = [NSNumber numberWithInteger:self.dataversion];
	if (self.comment)
	{
		mutableDict[kVeraUnitInfoComment] = self.comment;
	}
	
	if (self.model)
	{
		mutableDict[kVeraUnitInfoModel] = self.model;
	}

	NSMutableArray *tempArrayForCategories = [NSMutableArray array];
    for (NSObject *subArrayObject in self.categories)
	{
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)])
		{
            // This class is a model object
            [tempArrayForCategories addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        }
		else
		{
            // Generic object
            [tempArrayForCategories addObject:subArrayObject];
        }
    }
	mutableDict[kVeraUnitInfoCategories] = [NSArray arrayWithArray:tempArrayForCategories];
	NSMutableArray *tempArrayForScenes = [NSMutableArray array];
    for (NSObject *subArrayObject in self.scenes)
	{
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)])
		{
            // This class is a model object
            [tempArrayForScenes addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        }
		else
		{
            // Generic object
            [tempArrayForScenes addObject:subArrayObject];
        }
    }
	mutableDict[kVeraUnitInfoScenes] = [NSArray arrayWithArray:tempArrayForScenes];

	NSMutableArray *tempArrayForDevices = [NSMutableArray array];
    for (NSObject *subArrayObject in self.devices)
	{
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)])
		{
            // This class is a model object
            [tempArrayForDevices addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        }
		else
		{
            // Generic object
            [tempArrayForDevices addObject:subArrayObject];
        }
    }
	
	mutableDict[kVeraUnitInfoDevices] = [NSArray arrayWithArray:tempArrayForDevices];

	NSMutableArray *tempArrayForSections = [NSMutableArray array];
    for (NSObject *subArrayObject in self.sections)
	{
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)])
		{
            // This class is a model object
            [tempArrayForSections addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        }
		else
		{
            // Generic object
            [tempArrayForSections addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForSections] forKey:kVeraUnitInfoSections];

	NSMutableArray *tempArrayForRooms = [NSMutableArray array];
    for (NSObject *subArrayObject in self.rooms)
	{
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)])
		{
            // This class is a model object
            [tempArrayForRooms addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        }
		else
		{
            // Generic object
            [tempArrayForRooms addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForRooms] forKey:kVeraUnitInfoRooms];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

- (VeraDevice *) deviceWithIdentifier:(NSInteger) deviceIdentifier
{
	for (VeraDevice *device in self.devices)
	{
		if (device.deviceIdentifier == deviceIdentifier)
		{
			return device;
		}
	}
	
	return nil;
}


- (void) updateDeviceInfo:(VeraUnitInfo *) newInfo
{
	for (VeraDevice *newDevice in newInfo.devices)
	{
		VeraDevice *device = [self deviceWithIdentifier:newDevice.deviceIdentifier];
		device.status = newDevice.status;
		device.state = newDevice.state;
		device.comment = newDevice.comment;
		device.level = newDevice.level;
		device.temperature = newDevice.temperature;
		device.fanmode = newDevice.fanmode;
		device.heatTemperatureSetPoint = newDevice.heatTemperatureSetPoint;
		device.coolTemperatureSetPoint = newDevice.coolTemperatureSetPoint;
		device.hvacMode = newDevice.hvacMode;
		device.locked = newDevice.locked;
	}
}

@end
