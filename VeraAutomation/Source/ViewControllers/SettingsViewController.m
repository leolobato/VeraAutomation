//
//  SettingsViewController.m
//  VeraAutomation
//
//  Created by Scott Gruby on 2/5/14.
//  Copyright (c) 2014 Gruby Solutions. All rights reserved.
//

#import "SettingsViewController.h"
#import "VeraAPI.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"LOGOUT_TITLE", nil) style:UIBarButtonItemStylePlain target:self action:@selector(logoutAction)];
}

- (void) logoutAction
{
	PDKeychainBindingsController *controller = [PDKeychainBindingsController sharedKeychainBindingsController];
	[controller storeString:nil forKey:kPasswordKey];
	[controller storeString:nil forKey:kUsernameKey];
	
	[[VeraAutomationAppDelegate appDelegate] handleLogin];
	[[VeraAutomationAppDelegate appDelegate].api resetAPI];
}

@end
