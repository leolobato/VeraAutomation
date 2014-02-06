//
//  SettingsExcludeViewController.m
//  VeraAutomation
//
//  Created by Scott Gruby on 2/6/14.
//  Copyright (c) 2014 Gruby Solutions. All rights reserved.
//

#import "SettingsExcludeViewController.h"
#import "VeraAPI.h"
#import "VeraUnitInfo.h"
#import "VeraRoom.h"
#import "VeraScene.h"

@interface SettingsExcludeViewController ()
@property (nonatomic, strong) NSArray *rooms;
@property (nonatomic, strong) NSMutableArray *idsToExclude;
@end

@implementation SettingsExcludeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.idsToExclude = [NSMutableArray new];
	if (self.showScenes)
	{
		if ([VeraAutomationAppDelegate appDelegate].api.sceneIDsToExclude)
		{
			[self.idsToExclude addObjectsFromArray:[VeraAutomationAppDelegate appDelegate].api.sceneIDsToExclude];
		}
	}
	else
	{
		if ([VeraAutomationAppDelegate appDelegate].api.deviceIDsToExclude)
		{
			[self.idsToExclude addObjectsFromArray:[VeraAutomationAppDelegate appDelegate].api.deviceIDsToExclude];
		}
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unitInfoChanged:) name:kDeviceInfoNotification object:nil];
	[self refreshDevices];
	[self.tableView reloadData];
	
	self.title = self.showScenes ? NSLocalizedString(@"SCENES_TO_EXCLUDE_TITLE", nil) : NSLocalizedString(@"DEVICES_TO_EXCLUDE_TITLE", nil);
}

- (void) unitInfoChanged:(NSNotification *) notification
{
	[self refreshDevices];
	[self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	if (self.showScenes)
	{
		[VeraAutomationAppDelegate appDelegate].api.sceneIDsToExclude = self.idsToExclude;
	}
	else
	{
		[VeraAutomationAppDelegate appDelegate].api.deviceIDsToExclude = self.idsToExclude;
	}
	
	[[VeraAutomationAppDelegate appDelegate].api saveExcludedDevicesAndScenes];
	[[NSNotificationCenter defaultCenter] postNotificationName:kDeviceUpdatedNotification object:nil];
}

- (void) refreshDevices
{
	NSMutableArray *rooms = [NSMutableArray array];
	for (VeraRoom *room in [VeraAutomationAppDelegate appDelegate].api.unitInfo.rooms)
	{
		if (self.showScenes)
		{
			NSArray *devices = [[VeraAutomationAppDelegate appDelegate].api devicesForRoom:room forType:VeraDeviceTypeScene excludeDevices:NO];
			if ([devices count])
			{
				[rooms addObject:room];
				room.scenes = devices;
			}
		}
		else
		{
			NSArray *devices = [[VeraAutomationAppDelegate appDelegate].api devicesForRoom:room forType:VeraDeviceTypeSwitch excludeDevices:NO];
			if ([devices count])
			{
				[rooms addObject:room];
				room.devices = devices;
			}
		}
	}
	self.rooms = rooms;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.rooms count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	VeraRoom *room = self.rooms[section];
	return room.name;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	VeraRoom *room = self.rooms[section];
    return self.showScenes ? [room.scenes count] : [room.devices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExcludeCell" forIndexPath:indexPath];
	VeraRoom *room = self.rooms[indexPath.section];
	if (self.showScenes)
	{
		VeraScene *scene = room.scenes[indexPath.row];
		cell.textLabel.text = scene.name;
		if ([self.idsToExclude containsObject:[NSNumber numberWithInteger:scene.sceneIdentifier]])
		{
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		}
		else
		{
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
	}
	else
	{
		VeraDevice *device = room.devices[indexPath.row];
		cell.textLabel.text = device.name;
		if ([self.idsToExclude containsObject:[NSNumber numberWithInteger:device.deviceIdentifier]])
		{
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		}
		else
		{
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
	}
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

	VeraRoom *room = self.rooms[indexPath.section];
	if (self.showScenes)
	{
		VeraScene *scene = room.scenes[indexPath.row];
		if ([self.idsToExclude containsObject:[NSNumber numberWithInteger:scene.sceneIdentifier]])
		{
			[self.idsToExclude removeObject:[NSNumber numberWithInteger:scene.sceneIdentifier]];
		}
		else
		{
			[self.idsToExclude addObject:[NSNumber numberWithInteger:scene.sceneIdentifier]];
		}
	}
	else
	{
		VeraDevice *device = room.devices[indexPath.row];
		if ([self.idsToExclude containsObject:[NSNumber numberWithInteger:device.deviceIdentifier]])
		{
			[self.idsToExclude removeObject:[NSNumber numberWithInteger:device.deviceIdentifier]];
		}
		else
		{
			[self.idsToExclude addObject:[NSNumber numberWithInteger:device.deviceIdentifier]];
		}
	}
	
	[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
