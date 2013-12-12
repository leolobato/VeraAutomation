//
//  VeraAPI.h
//  VeraAutomation
//
//  Created by Scott Gruby on 12/5/13.
//  Copyright (c) 2013 Gruby Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@class VeraUnit;
@class VeraUnitInfo;
@class VeraRoom;
@class VeraDevice;

extern NSString *kVeraAPIErrorDomain;

typedef NS_ENUM(NSInteger, VeraFanMode) {
    VeraFanModeOff          = 0,
	VeraFanModeOn,
	VeraFanModeAuo
};

typedef NS_ENUM(NSInteger, VeraAPIErroCode) {
    VeraAPIIncorrectLogin          = -1
};

@interface VeraAPI : NSObject
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) VeraUnit *unit;
@property (nonatomic, strong) VeraUnitInfo *unitInfo;
- (void) getVeraInformationWithHandler:(void (^)(NSError *error)) handler;
- (void) getUnitInformationWithHandler:(void (^)(NSError *error, BOOL fullReload)) handler;
- (VeraRoom *) roomWithIdentifier:(NSUInteger) identifier;
- (NSArray *) devicesForRoom:(VeraRoom *) inRoom;
- (void) toggleDevice:(VeraDevice *) device withHandler:(void (^)(NSError *error)) handler;
- (void) setDeviceLevel:(VeraDevice *) device level:(NSInteger) level withHandler:(void (^)(NSError *error)) handler;
- (void) setAudioDevicePower:(BOOL) on device:(VeraDevice *) device withHandler:(void (^)(NSError *error)) handler;
- (void) setAllAudioDevicePower:(BOOL) on device:(VeraDevice *) device withHandler:(void (^)(NSError *error)) handler;
- (void) setAudioDeviceVolume:(BOOL) up device:(VeraDevice *) device withHandler:(void (^)(NSError *error)) handler;
- (void) setAudioDeviceInput:(NSInteger) input device:(VeraDevice *) device withHandler:(void (^)(NSError *error)) handler;
- (void) setFanMode:(VeraFanMode) fanMode device:(VeraDevice *) device withHandler:(void (^)(NSError *error)) handler;
- (void) setTemperature:(NSUInteger) temperature device:(VeraDevice *) device withHandler:(void (^)(NSError *error)) handler;
@end

