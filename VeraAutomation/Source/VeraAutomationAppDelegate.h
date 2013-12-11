//
//  AppDelegate.h
//  VeraAutomation
//
//  Created by Scott Gruby on 12/5/13.
//  Copyright (c) 2013 Gruby Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSMessage.h"

@class VeraAPI;
@class VeraDevice;

@interface VeraAutomationAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) VeraAPI *api;
- (void) handleLogin;
+ (VeraAutomationAppDelegate *) appDelegate;
- (void) toggleDevice:(VeraDevice *) device;
- (void) setAudioDevicePower:(BOOL) on device:(VeraDevice *) device;
- (void) setAudioDeviceVolume:(BOOL) up device:(VeraDevice *) device;
- (void) setAudioDeviceInput:(NSInteger) input device:(VeraDevice *) device;
- (void) setAllAudioDevicePower:(BOOL) on device:(VeraDevice *) device;
- (void) setDeviceLevel:(VeraDevice *) device level:(NSInteger) level;
+ (void)showNotificationWithTitle:(NSString *)title subtitle:(NSString *)subtitle type:(TSMessageNotificationType)type;
@end
