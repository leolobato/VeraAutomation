//
//  AppDelegate.h
//  VeraAutomation
//
//  Created by Scott Gruby on 12/5/13.
//  Copyright (c) 2013 Gruby Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSMessage.h"
#import "VeraAPI.h"

@class VeraDevice;
@class VeraScene;

@interface VeraAutomationAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) VeraAPI *api;
- (void) handleLogin;
+ (VeraAutomationAppDelegate *) appDelegate;

// All of the API calls are run through the app delegate so that the timer for updating
// the information can be reset and a new call can be made to get current status
- (void) toggleDevice:(VeraDevice *) device;
- (void) runSecene:(VeraScene *) scene;
- (void) setAudioDevicePower:(BOOL) on device:(VeraDevice *) device;
- (void) setAudioDeviceVolume:(BOOL) up device:(VeraDevice *) device;
- (void) setAudioDeviceInput:(NSInteger) input device:(VeraDevice *) device;
- (void) setAllAudioDevicePower:(BOOL) on device:(VeraDevice *) device;
- (void) setDeviceLevel:(VeraDevice *) device level:(NSInteger) level;
- (void) setFanMode:(VeraFanMode) fanMode device:(VeraDevice *) device;
- (void) setHVACMode:(VeraHVACMode) fanMode device:(VeraDevice *) device;
- (void) setTemperature:(NSUInteger) temperature heat:(BOOL) heat device:(VeraDevice *) device;
- (void) setLockState:(VeraDevice *) device locked:(BOOL) locked;


+ (void) showNotificationWithTitle:(NSString *)title subtitle:(NSString *)subtitle type:(TSMessageNotificationType)type;
@end
