//
//  AppDelegate.m
//  VeraAutomation
//
//  Created by Scott Gruby on 12/5/13.
//  Copyright (c) 2013 Gruby Solutions. All rights reserved.
//

#import "VeraAutomationAppDelegate.h"
#import "ActionSheetDelegate.h"
#import "AlertViewDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "VeraAPI.h"
#import "VeraUnitInfo.h"

static NSTimeInterval sTimeForCheck = 4.0f;

@interface VeraAutomationAppDelegate ()
@property (nonatomic, strong) NSDate *lastUnitCheck;
@property (nonatomic, strong) NSTimer *periodicTimer;
@property (nonatomic, assign) BOOL handlingLogin;
@end

@implementation VeraAutomationAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
	self.api = [[VeraAPI alloc] init];

	self.periodicTimer = [NSTimer scheduledTimerWithTimeInterval:sTimeForCheck target:self selector:@selector(updateUnitInfo) userInfo:nil repeats:YES];
	[self performSelector:@selector(handleLogin) withObject:nil afterDelay:1.0f];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
	[self.periodicTimer invalidate];
	self.periodicTimer = nil;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	[TSMessage setDefaultViewController:[UIApplication sharedApplication].keyWindow.rootViewController];

	if (self.periodicTimer == nil)
	{
		self.periodicTimer = [NSTimer scheduledTimerWithTimeInterval:sTimeForCheck target:self selector:@selector(updateUnitInfo) userInfo:nil repeats:YES];
	}
	
	self.lastUnitCheck = nil;
	[self updateUnitInfo];
	
	[self performSelector:@selector(handleLogin) withObject:nil afterDelay:1.0f];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) handleLogin
{
	if (self.handlingLogin)
	{
		return;
	}
	
	self.handlingLogin = YES;
	VeraAutomationAppDelegate __weak *weakSelf = self;
	PDKeychainBindingsController *controller = [PDKeychainBindingsController sharedKeychainBindingsController];
	NSString *password = [controller stringForKey:kPasswordKey];
	NSString *username = [controller stringForKey:kUsernameKey];
	if ([password length] && [username length])
	{
		self.api.username = username;
		self.api.password = password;
		[self.api getVeraInformationWithHandler:^(NSError *error) {
			if (error)
			{
				[weakSelf presentLogin];
			}
			else
			{
				weakSelf.handlingLogin = NO;
				[weakSelf updateUnitInfo];
			}
		}];
	}
	else
	{
		[self presentLogin];
	}
}

- (void) presentLogin
{
	VeraAutomationAppDelegate __weak *weakSelf = self;
	AlertViewDelegate *delegate = [AlertViewDelegate delegateWithHandler:^(UIAlertView *alertView, NSInteger buttonClicked) {
		if (buttonClicked != alertView.cancelButtonIndex)
		{
			NSString *password = [alertView textFieldAtIndex:1].text;
			NSString *username = [alertView textFieldAtIndex:0].text;
			if ([password length] && [username length])
			{
				PDKeychainBindingsController *controller = [PDKeychainBindingsController sharedKeychainBindingsController];
				[controller storeString:username forKey:kUsernameKey];
				[controller storeString:password forKey:kPasswordKey];
				
				self.api.username = username;
				self.api.password = password;

				[weakSelf.api getVeraInformationWithHandler:^(NSError *error) {
					[weakSelf updateUnitInfo];
					weakSelf.handlingLogin = NO;
				}];
			}
			else
			{
				weakSelf.handlingLogin = NO;
			}
		}
		else
		{
			weakSelf.handlingLogin = NO;
		}
	}];
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LOGIN_TITLE", nil) message:NSLocalizedString(@"LOGIN_MESSAGE", nil) delegate:delegate cancelButtonTitle:NSLocalizedString(@"CANCEL_BUTTON_TITLE", nil) otherButtonTitles:NSLocalizedString(@"LOGIN_BUTTON_TITLE", nil), nil];
	alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
	[delegate associateSelfWithAlertView:alertView];
	[alertView show];

}

+ (VeraAutomationAppDelegate *) appDelegate
{
	return (VeraAutomationAppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void) updateUnitInfo
{
	if ((self.lastUnitCheck == nil || [[NSDate date] timeIntervalSinceDate:self.lastUnitCheck] >= sTimeForCheck) && self.api.username && self.api.password)
	{
		VeraAutomationAppDelegate __weak *weakSelf = self;
		[self.api getUnitInformationWithHandler:^(NSError *error, BOOL fullReload) {
			if (error == nil && fullReload)
			{
				[[NSNotificationCenter defaultCenter] postNotificationName:kDeviceInfoNotification object:nil];
			}
			else if (error == nil)
			{
				[[NSNotificationCenter defaultCenter] postNotificationName:kDeviceUpdatedNotification object:nil];
			}
			
			if (error)
			{
				if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorCancelled)
				{
					DebugLog(@"The request was cancelled.");
				}
				else if ([error.domain isEqualToString:kVeraAPIErrorDomain] && error.code == VeraAPIIncorrectLogin)
				{
					weakSelf.api.username = nil;
					weakSelf.api.password = nil;
					PDKeychainBindingsController *controller = [PDKeychainBindingsController sharedKeychainBindingsController];
					[controller storeString:nil forKey:kUsernameKey];
					[controller storeString:nil forKey:kPasswordKey];
					[weakSelf performSelector:@selector(handleLogin) withObject:nil afterDelay:1.0f];
				}
			}
			
			if (error == nil)
			{
				weakSelf.lastUnitCheck = [NSDate date];
			}
		}];
	}
	//	DebugLog(@"timer");
}

- (void) toggleDevice:(VeraDevice *) device
{
	VeraAutomationAppDelegate __weak *weakSelf = self;
	[self.api toggleDevice:device withHandler:^(NSError *error) {
		weakSelf.lastUnitCheck = nil;
		[weakSelf updateUnitInfo];
	}];
}

- (void) setAudioDevicePower:(BOOL) on device:(VeraDevice *) device
{
	VeraAutomationAppDelegate __weak *weakSelf = self;
	[self.api setAudioDevicePower:on device:device withHandler:^(NSError *error) {
		weakSelf.lastUnitCheck = nil;
		[weakSelf updateUnitInfo];
	} ];
}

- (void) setAudioDeviceVolume:(BOOL) up device:(VeraDevice *) device
{
	VeraAutomationAppDelegate __weak *weakSelf = self;
	[self.api setAudioDeviceVolume:up device:device withHandler:^(NSError *error) {
		weakSelf.lastUnitCheck = nil;
		[weakSelf updateUnitInfo];
	} ];
}

- (void) setAudioDeviceInput:(NSInteger) input device:(VeraDevice *) device
{
	VeraAutomationAppDelegate __weak *weakSelf = self;
	[self.api setAudioDeviceInput:input device:device withHandler:^(NSError *error) {
		weakSelf.lastUnitCheck = nil;
		[weakSelf updateUnitInfo];
	} ];
}

- (void) setAllAudioDevicePower:(BOOL) on device:(VeraDevice *) device
{
	VeraAutomationAppDelegate __weak *weakSelf = self;
	[self.api setAllAudioDevicePower:on device:device withHandler:^(NSError *error) {
		weakSelf.lastUnitCheck = nil;
		[weakSelf updateUnitInfo];
	} ];
}


- (void) setDeviceLevel:(VeraDevice *) device level:(NSInteger) level
{
	VeraAutomationAppDelegate __weak *weakSelf = self;
	[self.api setDeviceLevel:device level:level withHandler:^(NSError *error) {
		weakSelf.lastUnitCheck = nil;
		[weakSelf updateUnitInfo];
	}];
}

+ (void)showNotificationWithTitle:(NSString *)title
                         subtitle:(NSString *)subtitle
                             type:(TSMessageNotificationType)type
{
    [TSMessage showNotificationInViewController:[UIApplication sharedApplication].keyWindow.rootViewController
                                     title:title
                                  subtitle:subtitle
                                      type:type
                                  duration:0.75
                                  callback:nil
                               buttonTitle:nil
                            buttonCallback:nil
                                atPosition:TSMessageNotificationPositionTop
                       canBeDismisedByUser:YES];
}


@end
