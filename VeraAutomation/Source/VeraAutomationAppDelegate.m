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
#import "DDASLLogger.h"
#import "DDTTYLogger.h"

static NSTimeInterval sTimeForCheck = 4.0f;

int ddLogLevel = LOG_LEVEL_VERBOSE;

@interface VeraAutomationAppDelegate () <UITabBarControllerDelegate>
@property (nonatomic, strong) NSDate *lastUnitCheck;
@property (nonatomic, strong) NSTimer *periodicTimer;
@property (nonatomic, assign) BOOL handlingLogin;
@end

@implementation VeraAutomationAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
	self.api = [[VeraAPI alloc] init];
	
	NSString *pathToExclusionsList = [[NSBundle mainBundle] pathForResource:@"Exclusions" ofType:@"plist"];
	if ([pathToExclusionsList length])
	{
		NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:pathToExclusionsList];
		self.api.deviceNamesToExclude = dict[@"Devices To Exclude"];
		self.api.sceneNamesToExclude = dict[@"Scenes To Exclude"];
	}

	self.periodicTimer = [NSTimer scheduledTimerWithTimeInterval:sTimeForCheck target:self selector:@selector(updateUnitInfo) userInfo:nil repeats:YES];
	[self performSelector:@selector(handleLogin) withObject:nil afterDelay:1.0f];

#ifdef DEBUG
	[DDLog addLogger:[DDASLLogger sharedInstance] withLogLevel:LOG_LEVEL_VERBOSE];
	[DDLog addLogger:[DDTTYLogger sharedInstance] withLogLevel:LOG_LEVEL_VERBOSE];
#endif
	
	[[UIButton appearanceWhenContainedIn:[UICollectionView class], nil] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

	UITabBarController *tabBarController = (UITabBarController *) self.window.rootViewController;
	tabBarController.delegate = self;
	NSString *selectedVCString = [[NSUserDefaults standardUserDefaults] stringForKey:kSelectedTabDefault];
	if ([selectedVCString length])
	{
		NSUInteger selectedIndex = 0;
		for (UIViewController *vc in tabBarController.viewControllers)
		{
			UIViewController *viewController = vc;
			if ([vc isKindOfClass:[UINavigationController class]])
			{
				viewController = ((UINavigationController *) vc).topViewController;
			}
			
			NSString *vcClass = NSStringFromClass([viewController class]);
			if (vcClass && [vcClass isEqualToString:selectedVCString])
			{
				break;
			}
			
			selectedIndex++;
		}
		
		tabBarController.selectedIndex = selectedIndex;
	}
	
	NSArray *orderdViewControllers = [[NSUserDefaults standardUserDefaults] arrayForKey:kTabOrderDefault];
	NSMutableArray *newViewControllerArray = [tabBarController.viewControllers mutableCopy];
	NSUInteger currentIndex = 0;
	for (NSString *orderedVCClass in orderdViewControllers)
	{
		for (NSUInteger index = 0; index < [newViewControllerArray count]; index++)
		{
			UIViewController *vc = newViewControllerArray[index];
			if ([vc isKindOfClass:[UINavigationController class]])
			{
				vc = ((UINavigationController *) vc).topViewController;
			}
			
			if ([NSStringFromClass([vc class]) isEqualToString:orderedVCClass])
			{
				[newViewControllerArray exchangeObjectAtIndex:currentIndex withObjectAtIndex:index];
				break;
			}
		}
		
		currentIndex++;
	}
	
	tabBarController.viewControllers = newViewControllerArray;
	
	return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
	if (changed)
	{
		NSMutableArray *orderedViewControllers = [NSMutableArray new];
		for (UIViewController *vc in viewControllers)
		{
			UIViewController *viewController = vc;
			if ([viewController isKindOfClass:[UINavigationController class]])
			{
				viewController = ((UINavigationController *) viewController).topViewController;
			}
			NSString *vcClass = NSStringFromClass([viewController class]);
			[orderedViewControllers addObject:vcClass];
		}
		
		[[NSUserDefaults standardUserDefaults] setObject:orderedViewControllers forKey:kTabOrderDefault];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
	if ([viewController isKindOfClass:[UINavigationController class]])
	{
		viewController = ((UINavigationController *) viewController).topViewController;
	}
	NSString *vcClass = NSStringFromClass([viewController class]);
	[[NSUserDefaults standardUserDefaults] setObject:vcClass forKey:kSelectedTabDefault];
	[[NSUserDefaults standardUserDefaults] synchronize];
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
			DebugLogVerbose(@"Unit info: %@", self.api.unitInfo);
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

- (void) runSecene:(VeraScene *) scene
{
	VeraAutomationAppDelegate __weak *weakSelf = self;
	[self.api runScene:scene withHandler:^(NSError *error) {
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

- (void) setFanMode:(VeraFanMode) fanMode device:(VeraDevice *) device
{
	VeraAutomationAppDelegate __weak *weakSelf = self;
	[self.api setFanMode:fanMode device:device withHandler:^(NSError *error) {
		weakSelf.lastUnitCheck = nil;
		[weakSelf updateUnitInfo];
	}];
}

- (void) setHVACMode:(VeraHVACMode) fanMode device:(VeraDevice *) device
{
	VeraAutomationAppDelegate __weak *weakSelf = self;
	[self.api setHVACMode:fanMode device:device withHandler:^(NSError *error) {
		weakSelf.lastUnitCheck = nil;
		[weakSelf updateUnitInfo];
	}];
}

- (void) setTemperature:(NSUInteger) temperature heat:(BOOL) heat device:(VeraDevice *) device
{
	VeraAutomationAppDelegate __weak *weakSelf = self;
	[self.api setTemperature:temperature heat:heat device:device withHandler:^(NSError *error) {
		weakSelf.lastUnitCheck = nil;
		[weakSelf updateUnitInfo];
	}];
}

- (void) setLockState:(VeraDevice *) device locked:(BOOL) locked
{
	VeraAutomationAppDelegate __weak *weakSelf = self;
	[self.api setLockState:device locked:locked withHandler:^(NSError *error) {
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
