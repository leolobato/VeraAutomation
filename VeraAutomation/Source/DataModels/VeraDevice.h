//
//  VeraDevices.h
//
//  Created by Scott Gruby on 12/7/13
//  Copyright (c) 2013 Gruby Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, VeraDeviceTypeEnum) {
    VeraDeviceTypeUnknown			= -1,
	VeraDeviceTypeSwitch			= 0,
	VeraDeviceTypeAudio				= 1,
	VeraDeviceTypeThermostat		= 2,
	VeraDeviceTypeLock				= 3,
	VeraDeviceTypeScene				= 4 // A scene isn't a device, but it is convenient to put here
};


@interface VeraDevice : NSObject

@property (nonatomic, assign) NSInteger deviceIdentifier;
@property (nonatomic, assign) NSInteger category;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) NSInteger parent;
@property (nonatomic, strong) NSString *humidity;
@property (nonatomic, strong) NSString *lasttrip;
@property (nonatomic, assign) BOOL locked;
@property (nonatomic, strong) NSString *objectstatusmap;
@property (nonatomic, assign) NSInteger subcategory;
@property (nonatomic, strong) NSString *systemVeraRestart;
@property (nonatomic, strong) NSString *systemLuupRestart;
@property (nonatomic, strong) NSString *temperature;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *memoryAvailable;
@property (nonatomic, strong) NSString *mode;
@property (nonatomic, strong) NSString *heatsp;
@property (nonatomic, strong) NSString *conditionsatisfied;
@property (nonatomic, strong) NSString *vendorstatusdata;
@property (nonatomic, strong) NSString *detailedarmmode;
@property (nonatomic, strong) NSString *batterylevel;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *armmode;
@property (nonatomic, strong) NSString *armed;
@property (nonatomic, strong) NSString *coolsp;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *vendorstatus;
@property (nonatomic, strong) NSString *hvacstate;
@property (nonatomic, strong) NSString *memoryFree;
@property (nonatomic, strong) NSString *pincodes;
@property (nonatomic, strong) NSString *memoryUsed;
@property (nonatomic, strong) NSString *tripped;
@property (nonatomic, strong) NSString *altid;
@property (nonatomic, strong) NSString *fanmode;
@property (nonatomic, strong) NSString *vendorstatuscode;
@property (nonatomic, assign) NSInteger room;
@property (nonatomic, strong) NSString *ip;


+ (VeraDevice *)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;
@end
