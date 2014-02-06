//
//  SettingsViewController.m
//  VeraAutomation
//
//  Created by Scott Gruby on 2/5/14.
//  Copyright (c) 2014 Gruby Solutions. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsExcludeViewController.h"
#import "VeraAPI.h"
#import "BooleanTableViewCell.h"

@interface SettingsViewController () <BooleanTableViewCellProtocol>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
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


#pragma mark - Table View Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row)
	{
		case 0:
		{
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCell" forIndexPath:indexPath];
			cell.textLabel.text = NSLocalizedString(@"DEVICES_TO_EXCLUDE_TITLE", nil);
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			return cell;
		}
			
		case 1:
		{
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScenesToExcludeCell" forIndexPath:indexPath];
			cell.textLabel.text = NSLocalizedString(@"SCENES_TO_EXCLUDE_TITLE", nil);
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			return cell;
		}
			
		case 2:
		{
			BooleanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BooleanCell" forIndexPath:indexPath];
			[cell setTitle:NSLocalizedString(@"SHOW_AUDIO_TAB", nil)];
			[cell setSwitchValue:[[NSUserDefaults standardUserDefaults] boolForKey:kShowAudioTabDefault]];
			cell.delegate = self;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			return cell;
		}
	}
	
	return nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	SettingsExcludeViewController *vc = segue.destinationViewController;
	if ([segue.identifier isEqualToString:@"SceneToExcludeSegue"])
	{
		vc.showScenes = YES;
	}
	else
	{
		vc.showScenes = NO;
	}
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
	if (self.tableView.indexPathForSelectedRow.row == 2)
	{
		return NO;
	}
	
	return YES;
}

#pragma mark - Table View Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) valueChanged:(BooleanTableViewCell *) cell newValue:(BOOL) newValue
{
	[[NSUserDefaults standardUserDefaults] setBool:newValue forKey:kShowAudioTabDefault];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[[VeraAutomationAppDelegate appDelegate] showHideAudioTab];
}

@end
