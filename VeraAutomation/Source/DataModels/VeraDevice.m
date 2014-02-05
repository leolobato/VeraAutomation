//
//  VeraDevices.m
//
//  Created by Scott Gruby on 12/7/13
//  Copyright (c) 2013 Gruby Solutions. All rights reserved.
//

#import "VeraDevice.h"


NSString *const kVeraDevicesId = @"id";
NSString *const kVeraDevicesCategory = @"category";
NSString *const kVeraDevicesLevel = @"level";
NSString *const kVeraDevicesState = @"state";
NSString *const kVeraDevicesParent = @"parent";
NSString *const kVeraDevicesHumidity = @"humidity";
NSString *const kVeraDevicesLasttrip = @"lasttrip";
NSString *const kVeraDevicesLocked = @"locked";
NSString *const kVeraDevicesObjectstatusmap = @"objectstatusmap";
NSString *const kVeraDevicesSubcategory = @"subcategory";
NSString *const kVeraDevicesSystemVeraRestart = @"systemVeraRestart";
NSString *const kVeraDevicesSystemLuupRestart = @"systemLuupRestart";
NSString *const kVeraDevicesTemperature = @"temperature";
NSString *const kVeraDevicesComment = @"comment";
NSString *const kVeraDevicesMemoryAvailable = @"memoryAvailable";
NSString *const kVeraDevicesMode = @"mode";
NSString *const kVeraDevicesHeatsp = @"heatsp";
NSString *const kVeraDevicesConditionsatisfied = @"conditionsatisfied";
NSString *const kVeraDevicesVendorstatusdata = @"vendorstatusdata";
NSString *const kVeraDevicesDetailedarmmode = @"detailedarmmode";
NSString *const kVeraDevicesBatterylevel = @"batterylevel";
NSString *const kVeraDevicesName = @"name";
NSString *const kVeraDevicesArmmode = @"armmode";
NSString *const kVeraDevicesArmed = @"armed";
NSString *const kVeraDevicesCoolsp = @"coolsp";
NSString *const kVeraDevicesStatus = @"status";
NSString *const kVeraDevicesVendorstatus = @"vendorstatus";
NSString *const kVeraDevicesHvacstate = @"hvacstate";
NSString *const kVeraDevicesMemoryFree = @"memoryFree";
NSString *const kVeraDevicesPincodes = @"pincodes";
NSString *const kVeraDevicesMemoryUsed = @"memoryUsed";
NSString *const kVeraDevicesTripped = @"tripped";
NSString *const kVeraDevicesAltid = @"altid";
NSString *const kVeraDevicesFanmode = @"fanmode";
NSString *const kVeraDevicesVendorstatuscode = @"vendorstatuscode";
NSString *const kVeraDevicesRoom = @"room";
NSString *const kVeraDevicesIp = @"ip";

@implementation VeraDevice

+ (VeraDevice *)modelObjectWithDictionary:(NSDictionary *)dict
{
    VeraDevice *instance = [[VeraDevice alloc] initWithDictionary:dict];
    return instance;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]])
	{
		_deviceIdentifier = [dict[kVeraDevicesId] integerValue];
		_category = [dict[kVeraDevicesCategory] integerValue];
		_level = [dict[kVeraDevicesLevel] integerValue];
		
		_state = [dict[kVeraDevicesState] integerValue];
		_parent = [dict[kVeraDevicesParent] integerValue];

		_parent = [dict[kVeraDevicesParent] integerValue];
		_humidity = dict[kVeraDevicesHumidity];
		_lasttrip = dict[kVeraDevicesLasttrip];
		_locked = [dict[kVeraDevicesLocked] boolValue];
		_objectstatusmap = dict[kVeraDevicesObjectstatusmap];
		_subcategory = [dict[kVeraDevicesSubcategory] integerValue];
		_systemVeraRestart = dict[kVeraDevicesSystemVeraRestart];
		_systemLuupRestart = dict[kVeraDevicesSystemLuupRestart];
		_temperature = [dict[kVeraDevicesTemperature] integerValue];
		_comment = dict[kVeraDevicesComment];
		_memoryAvailable = dict[kVeraDevicesMemoryAvailable];
		NSString *mode = dict[kVeraDevicesMode];
		if (mode && [mode caseInsensitiveCompare:@"off"] == NSOrderedSame)
		{
			_hvacMode = VeraHVACModeOff;
		}
		else if (mode && [mode caseInsensitiveCompare:@"HeatOn"] == NSOrderedSame)
		{
			_hvacMode = VeraHVACModeHeat;
		}
		else if (mode && [mode caseInsensitiveCompare:@"CoolOn"] == NSOrderedSame)
		{
			_hvacMode = VeraHVACModeCool;
		}
		else if (mode && [mode caseInsensitiveCompare:@"AutoChangeOver"] == NSOrderedSame)
		{
			_hvacMode = VeraHVACModeAuto;
		}
		
		_heatTemperatureSetPoint = [dict[kVeraDevicesHeatsp] integerValue];
		_conditionsatisfied = dict[kVeraDevicesConditionsatisfied];
		_vendorstatusdata = dict[kVeraDevicesVendorstatusdata];
		_detailedarmmode = dict[kVeraDevicesDetailedarmmode];
		_batterylevel = dict[kVeraDevicesBatterylevel];
		_name = dict[kVeraDevicesName];
		_armmode = dict[kVeraDevicesArmmode];
		_armed = dict[kVeraDevicesArmed];
		_coolTemperatureSetPoint = [dict[kVeraDevicesCoolsp] integerValue];
		_status = [dict[kVeraDevicesStatus] integerValue];
		_vendorstatus = dict[kVeraDevicesVendorstatus];
		_hvacstate = dict[kVeraDevicesHvacstate];
		_memoryFree = dict[kVeraDevicesMemoryFree];
		_pincodes = dict[kVeraDevicesPincodes];
		_memoryUsed = dict[kVeraDevicesMemoryUsed];
		_tripped = dict[kVeraDevicesTripped];
		_altid = dict[kVeraDevicesAltid];
		NSString *tempMode = dict[kVeraDevicesFanmode];
		if (tempMode && [tempMode caseInsensitiveCompare:@"auto"] != NSOrderedSame)
		{
			_fanmode = VeraFanModeOn;
		}
		else
		{
			_fanmode = VeraFanModeAuto;
		}
		_vendorstatuscode = dict[kVeraDevicesVendorstatuscode];
		_room = [dict[kVeraDevicesRoom] integerValue];
		_ip = dict[kVeraDevicesIp];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    mutableDict[kVeraDevicesId] = [NSNumber numberWithInteger:self.deviceIdentifier];
    mutableDict[kVeraDevicesCategory] = [NSNumber numberWithInteger:self.category];
	mutableDict[kVeraDevicesLevel] = [NSNumber numberWithInteger:self.level];
	
    mutableDict[kVeraDevicesState] = [NSNumber numberWithInteger:self.state];
    mutableDict[kVeraDevicesParent] = [NSNumber numberWithInteger:self.parent];
	if (self.humidity)
	{
		mutableDict[kVeraDevicesHumidity] = self.humidity;
	}
	
	if (self.lasttrip)
	{
		mutableDict[kVeraDevicesLasttrip] = self.lasttrip;
	}
	
	mutableDict[kVeraDevicesLocked] = [NSNumber numberWithBool:self.locked];

    if (self.objectstatusmap)
	{
		mutableDict[kVeraDevicesObjectstatusmap] = self.objectstatusmap;
	}
	
    mutableDict[kVeraDevicesSubcategory] = [NSNumber numberWithInteger:self.subcategory];
	
	if (self.systemVeraRestart)
	{
		mutableDict[kVeraDevicesSystemVeraRestart] = self.systemVeraRestart;
	}
	
	if (self.systemLuupRestart)
	{
		mutableDict[kVeraDevicesSystemLuupRestart] = self.systemLuupRestart;
	}
	
	mutableDict[kVeraDevicesTemperature] = [NSNumber numberWithInteger:self.temperature];
	
	if (self.comment)
	{
		mutableDict[kVeraDevicesComment] = self.comment;
	}
	
	if (self.memoryAvailable)
	{
		mutableDict[kVeraDevicesMemoryAvailable] = self.memoryAvailable;
	}
	
	switch (self.hvacMode)
	{
		case VeraHVACModeAuto:
		{
			mutableDict[kVeraDevicesMode] = @"Auto";
			break;
		}
			
		case VeraHVACModeOff:
		{
			mutableDict[kVeraDevicesMode] = @"Off";
			break;
		}

		case VeraHVACModeCool:
		{
			mutableDict[kVeraDevicesMode] = @"Cool";
			break;
		}

		case VeraHVACModeHeat:
		{
			mutableDict[kVeraDevicesMode] = @"Heat";
			break;
		}
	}
	
	mutableDict[kVeraDevicesHeatsp] = [NSNumber numberWithInteger:self.heatTemperatureSetPoint];
	
	if (self.conditionsatisfied)
	{
		mutableDict[kVeraDevicesConditionsatisfied] = self.conditionsatisfied;
	}
	
	if (self.vendorstatusdata)
	{
		mutableDict[kVeraDevicesVendorstatusdata] = self.vendorstatusdata;
	}
	
	if (self.detailedarmmode)
	{
		mutableDict[kVeraDevicesDetailedarmmode] = self.detailedarmmode;
	}
	
	if (self.batterylevel)
	{
		mutableDict[kVeraDevicesBatterylevel] = self.batterylevel;
	}
	
	if (self.name)
	{
		mutableDict[kVeraDevicesName] = self.name;
	}
	
	if (self.armmode)
	{
		mutableDict[kVeraDevicesArmmode] = self.armmode;
	}
	
	if (self.armed)
	{
		mutableDict[kVeraDevicesArmed] = self.armed;
	}
	
	mutableDict[kVeraDevicesCoolsp] = [NSNumber numberWithInteger:self.coolTemperatureSetPoint];
	
	mutableDict[kVeraDevicesStatus] = [NSNumber numberWithInteger:self.status];
	
	if (self.vendorstatus)
	{
		mutableDict[kVeraDevicesVendorstatus] = self.vendorstatus;
	}
	
	if (self.hvacstate)
	{
		mutableDict[kVeraDevicesHvacstate] = self.hvacstate;
	}
	
	if (self.memoryFree)
	{
		mutableDict[kVeraDevicesMemoryFree] = self.memoryFree;
	}
	
	if (self.pincodes)
	{
		mutableDict[kVeraDevicesPincodes] = self.pincodes;
	}
	
	if (self.memoryUsed)
	{
		mutableDict[kVeraDevicesMemoryUsed] = self.memoryUsed;
	}
	
	if (self.tripped)
	{
		mutableDict[kVeraDevicesTripped] = self.tripped;
	}
	
	if (self.altid)
	{
		mutableDict[kVeraDevicesAltid] = self.altid;
	}
	
	if (self.fanmode == VeraFanModeAuto)
	{
		mutableDict[kVeraDevicesFanmode] = @"Auto";
	}
	else
	{
		mutableDict[kVeraDevicesFanmode] = @"On";
	}
	
	if (self.vendorstatuscode)
	{
		mutableDict[kVeraDevicesVendorstatuscode] = self.vendorstatuscode;
	}
	
	if (self.ip)
	{
		mutableDict[kVeraDevicesIp] = self.ip;
	}
	

	mutableDict[kVeraDevicesRoom] = [NSNumber numberWithInteger:self.room];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

@end
