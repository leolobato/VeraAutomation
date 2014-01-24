//
//  VeraDevices.m
//
//  Created by Scott Gruby on 12/7/13
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
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
		_locked = dict[kVeraDevicesLocked];
		_objectstatusmap = dict[kVeraDevicesObjectstatusmap];
		_subcategory = [dict[kVeraDevicesSubcategory] integerValue];
		_systemVeraRestart = dict[kVeraDevicesSystemVeraRestart];
		_systemLuupRestart = dict[kVeraDevicesSystemLuupRestart];
		_temperature = dict[kVeraDevicesTemperature];
		_comment = dict[kVeraDevicesComment];
		_memoryAvailable = dict[kVeraDevicesMemoryAvailable];
		_mode = dict[kVeraDevicesMode];
		_heatsp = dict[kVeraDevicesHeatsp];
		_conditionsatisfied = dict[kVeraDevicesConditionsatisfied];
		_vendorstatusdata = dict[kVeraDevicesVendorstatusdata];
		_detailedarmmode = dict[kVeraDevicesDetailedarmmode];
		_batterylevel = dict[kVeraDevicesBatterylevel];
		_name = dict[kVeraDevicesName];
		_armmode = dict[kVeraDevicesArmmode];
		_armed = dict[kVeraDevicesArmed];
		_coolsp = dict[kVeraDevicesCoolsp];
		_status = [dict[kVeraDevicesStatus] integerValue];
		_vendorstatus = dict[kVeraDevicesVendorstatus];
		_hvacstate = dict[kVeraDevicesHvacstate];
		_memoryFree = dict[kVeraDevicesMemoryFree];
		_pincodes = dict[kVeraDevicesPincodes];
		_memoryUsed = dict[kVeraDevicesMemoryUsed];
		_tripped = dict[kVeraDevicesTripped];
		_altid = dict[kVeraDevicesAltid];
		_fanmode = dict[kVeraDevicesFanmode];
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
	
	if (self.locked)
	{
		mutableDict[kVeraDevicesLocked] = self.locked;
	}
	
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
	
	if (self.temperature)
	{
		mutableDict[kVeraDevicesTemperature] = self.temperature;
	}
	
	if (self.comment)
	{
		mutableDict[kVeraDevicesComment] = self.comment;
	}
	
	if (self.memoryAvailable)
	{
		mutableDict[kVeraDevicesMemoryAvailable] = self.memoryAvailable;
	}
	
	if (self.mode)
	{
		mutableDict[kVeraDevicesMode] = self.mode;
	}
	
	if (self.heatsp)
	{
		mutableDict[kVeraDevicesHeatsp] = self.heatsp;
	}
	
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
	
	if (self.coolsp)
	{
		mutableDict[kVeraDevicesCoolsp] = self.coolsp;
	}
	
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
	
	if (self.fanmode)
	{
		mutableDict[kVeraDevicesFanmode] = self.fanmode;
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

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    _deviceIdentifier = [aDecoder decodeIntegerForKey:kVeraDevicesId];
    _category = [aDecoder decodeIntegerForKey:kVeraDevicesCategory];
    _level = [aDecoder decodeIntegerForKey:kVeraDevicesLevel];
    _state = [aDecoder decodeIntegerForKey:kVeraDevicesState];
    _parent = [aDecoder decodeIntegerForKey:kVeraDevicesParent];
    _humidity = [aDecoder decodeObjectForKey:kVeraDevicesHumidity];
    _lasttrip = [aDecoder decodeObjectForKey:kVeraDevicesLasttrip];
    _locked = [aDecoder decodeObjectForKey:kVeraDevicesLocked];
    _objectstatusmap = [aDecoder decodeObjectForKey:kVeraDevicesObjectstatusmap];
    _subcategory = [aDecoder decodeIntegerForKey:kVeraDevicesSubcategory];
    _systemVeraRestart = [aDecoder decodeObjectForKey:kVeraDevicesSystemVeraRestart];
    _systemLuupRestart = [aDecoder decodeObjectForKey:kVeraDevicesSystemLuupRestart];
    _temperature = [aDecoder decodeObjectForKey:kVeraDevicesTemperature];
    _comment = [aDecoder decodeObjectForKey:kVeraDevicesComment];
    _memoryAvailable = [aDecoder decodeObjectForKey:kVeraDevicesMemoryAvailable];
    _mode = [aDecoder decodeObjectForKey:kVeraDevicesMode];
    _heatsp = [aDecoder decodeObjectForKey:kVeraDevicesHeatsp];
    _conditionsatisfied = [aDecoder decodeObjectForKey:kVeraDevicesConditionsatisfied];
    _vendorstatusdata = [aDecoder decodeObjectForKey:kVeraDevicesVendorstatusdata];
    _detailedarmmode = [aDecoder decodeObjectForKey:kVeraDevicesDetailedarmmode];
    _batterylevel = [aDecoder decodeObjectForKey:kVeraDevicesBatterylevel];
    _name = [aDecoder decodeObjectForKey:kVeraDevicesName];
    _armmode = [aDecoder decodeObjectForKey:kVeraDevicesArmmode];
    _armed = [aDecoder decodeObjectForKey:kVeraDevicesArmed];
    _coolsp = [aDecoder decodeObjectForKey:kVeraDevicesCoolsp];
    _status = [aDecoder decodeIntegerForKey:kVeraDevicesStatus];
    _vendorstatus = [aDecoder decodeObjectForKey:kVeraDevicesVendorstatus];
    _hvacstate = [aDecoder decodeObjectForKey:kVeraDevicesHvacstate];
    _memoryFree = [aDecoder decodeObjectForKey:kVeraDevicesMemoryFree];
    _pincodes = [aDecoder decodeObjectForKey:kVeraDevicesPincodes];
    _memoryUsed = [aDecoder decodeObjectForKey:kVeraDevicesMemoryUsed];
    _tripped = [aDecoder decodeObjectForKey:kVeraDevicesTripped];
    _altid = [aDecoder decodeObjectForKey:kVeraDevicesAltid];
    _fanmode = [aDecoder decodeObjectForKey:kVeraDevicesFanmode];
    _vendorstatuscode = [aDecoder decodeObjectForKey:kVeraDevicesVendorstatuscode];
    _room = [aDecoder decodeIntegerForKey:kVeraDevicesRoom];
    _ip = [aDecoder decodeObjectForKey:kVeraDevicesIp];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeInteger:_deviceIdentifier forKey:kVeraDevicesId];
    [aCoder encodeInteger:_category forKey:kVeraDevicesCategory];
    [aCoder encodeInteger:_level forKey:kVeraDevicesLevel];
    [aCoder encodeInteger:_state forKey:kVeraDevicesState];
    [aCoder encodeInteger:_parent forKey:kVeraDevicesParent];
    [aCoder encodeObject:_humidity forKey:kVeraDevicesHumidity];
    [aCoder encodeObject:_lasttrip forKey:kVeraDevicesLasttrip];
    [aCoder encodeObject:_locked forKey:kVeraDevicesLocked];
    [aCoder encodeObject:_objectstatusmap forKey:kVeraDevicesObjectstatusmap];
    [aCoder encodeInteger:_subcategory forKey:kVeraDevicesSubcategory];
    [aCoder encodeObject:_systemVeraRestart forKey:kVeraDevicesSystemVeraRestart];
    [aCoder encodeObject:_systemLuupRestart forKey:kVeraDevicesSystemLuupRestart];
    [aCoder encodeObject:_temperature forKey:kVeraDevicesTemperature];
    [aCoder encodeObject:_comment forKey:kVeraDevicesComment];
    [aCoder encodeObject:_memoryAvailable forKey:kVeraDevicesMemoryAvailable];
    [aCoder encodeObject:_mode forKey:kVeraDevicesMode];
    [aCoder encodeObject:_heatsp forKey:kVeraDevicesHeatsp];
    [aCoder encodeObject:_conditionsatisfied forKey:kVeraDevicesConditionsatisfied];
    [aCoder encodeObject:_vendorstatusdata forKey:kVeraDevicesVendorstatusdata];
    [aCoder encodeObject:_detailedarmmode forKey:kVeraDevicesDetailedarmmode];
    [aCoder encodeObject:_batterylevel forKey:kVeraDevicesBatterylevel];
    [aCoder encodeObject:_name forKey:kVeraDevicesName];
    [aCoder encodeObject:_armmode forKey:kVeraDevicesArmmode];
    [aCoder encodeObject:_armed forKey:kVeraDevicesArmed];
    [aCoder encodeObject:_coolsp forKey:kVeraDevicesCoolsp];
    [aCoder encodeInteger:_status forKey:kVeraDevicesStatus];
    [aCoder encodeObject:_vendorstatus forKey:kVeraDevicesVendorstatus];
    [aCoder encodeObject:_hvacstate forKey:kVeraDevicesHvacstate];
    [aCoder encodeObject:_memoryFree forKey:kVeraDevicesMemoryFree];
    [aCoder encodeObject:_pincodes forKey:kVeraDevicesPincodes];
    [aCoder encodeObject:_memoryUsed forKey:kVeraDevicesMemoryUsed];
    [aCoder encodeObject:_tripped forKey:kVeraDevicesTripped];
    [aCoder encodeObject:_altid forKey:kVeraDevicesAltid];
    [aCoder encodeObject:_fanmode forKey:kVeraDevicesFanmode];
    [aCoder encodeObject:_vendorstatuscode forKey:kVeraDevicesVendorstatuscode];
    [aCoder encodeInteger:_room forKey:kVeraDevicesRoom];
    [aCoder encodeObject:_ip forKey:kVeraDevicesIp];
}

@end
