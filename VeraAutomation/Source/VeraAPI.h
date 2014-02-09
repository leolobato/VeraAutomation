//
//  VeraAPI.h
//  VeraAutomation
//
//  Created by Scott Gruby on 12/5/13.
//  Copyright (c) 2013 Gruby Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "VeraDevice.h"

@class VeraUnit;
@class VeraUnitInfo;
@class VeraRoom;
@class VeraScene;

extern NSString *kVeraAPIErrorDomain;

typedef NS_ENUM(NSInteger, VeraAPIErroCode) {
    VeraAPIIncorrectLogin          = -1
};

@interface VeraAPI : NSObject
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) VeraUnit *unit;
@property (nonatomic, strong) VeraUnitInfo *unitInfo;
@property (nonatomic, strong) NSArray *deviceIDsToExclude;
@property (nonatomic, strong) NSArray *sceneIDsToExclude;
- (void) resetAPI;
- (void) getVeraInformationWithHandler:(void (^)(NSError *error)) handler;
- (void) getUnitInformationWithHandler:(void (^)(NSError *error, BOOL fullReload)) handler;
- (VeraRoom *) roomWithIdentifier:(NSUInteger) identifier;
- (void) toggleDevice:(VeraDevice *) device withHandler:(void (^)(NSError *error)) handler;
- (void) runScene:(VeraScene *) scene withHandler:(void (^)(NSError *error)) handler;
- (void) setDeviceLevel:(VeraDevice *) device level:(NSInteger) level withHandler:(void (^)(NSError *error)) handler;
- (void) setAudioDevicePower:(BOOL) on device:(VeraDevice *) device withHandler:(void (^)(NSError *error)) handler;
- (void) setAllAudioDevicePower:(BOOL) on device:(VeraDevice *) device withHandler:(void (^)(NSError *error)) handler;
- (void) setAudioDeviceVolume:(BOOL) up device:(VeraDevice *) device withHandler:(void (^)(NSError *error)) handler;
- (void) setAudioDeviceInput:(NSInteger) input device:(VeraDevice *) device withHandler:(void (^)(NSError *error)) handler;
- (void) setFanMode:(VeraFanMode) fanMode device:(VeraDevice *) device withHandler:(void (^)(NSError *error)) handler;
- (void) setTemperature:(NSUInteger) temperature heat:(BOOL) heat device:(VeraDevice *) device withHandler:(void (^)(NSError *error)) handler;
- (void) setHVACMode:(VeraHVACMode) hvacMode device:(VeraDevice *) device withHandler:(void (^)(NSError *error)) handler;
- (void) setLockState:(VeraDevice *) device locked:(BOOL) locked withHandler:(void (^)(NSError *error)) handler;

- (NSArray *) devicesForRoom:(VeraRoom *) inRoom forType:(VeraDeviceTypeEnum) deviceType;
- (NSArray *) devicesForRoom:(VeraRoom *) inRoom forType:(VeraDeviceTypeEnum) deviceType excludeDevices:(BOOL) excludeDevices;
- (void) saveExcludedDevicesAndScenes;
- (void) cancelAllOperations;
@end

