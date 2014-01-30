//
//  OnDevicesViewController.m
//  VeraAutomation
//
//  Created by Scott Gruby on 1/29/14.
//  Copyright (c) 2014 Gruby Solutions. All rights reserved.
//

#import "OnDevicesViewController.h"
#import "VeraRoom.h"
#import "VeraDevice.h"
#import "VeraAPI.h"
#import "VeraUnitInfo.h"
#import "OnDeviceCell.h"

@interface OnDevicesViewController ()
@property (nonatomic, strong) NSArray *devices;
@end

@implementation OnDevicesViewController
- (void) viewDidLoad
{
	[super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unitInfoChanged:) name:kDeviceInfoNotification object:nil];
}

- (void) refreshRoom
{
	NSMutableArray *deviceArray = [NSMutableArray array];
	for (VeraRoom *room in [VeraAutomationAppDelegate appDelegate].api.unitInfo.rooms)
	{
		NSArray *devices = [[VeraAutomationAppDelegate appDelegate].api devicesForRoom:room forType:VeraDeviceTypeSwitch];
		for (VeraDevice *device in devices)
		{
			if (device.status == 1)
			{
				[deviceArray addObject:device];
			}
		}
	}
	
	self.devices = deviceArray;
	[self.collectionView reloadData];
}

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	if ([self.devices count] == 0)
	{
		[self refreshRoom];
	}
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	OnDeviceCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"OnDeviceCell" forIndexPath:indexPath];
	VeraDevice *device = nil;
	if (indexPath.row < [self.devices count])
	{
		device = self.devices[indexPath.row];
	}
	
	[cell setDeviceTitle:device.name];
	return cell;
}

- (void) unitInfoChanged:(NSNotification *) notification
{
	[self refreshRoom];
	[self.collectionView reloadData];
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	// Toggle the device
	VeraDevice *device = nil;
	if (indexPath.row < [self.devices count])
	{
		device = self.devices[indexPath.row];
	}
	
	if (device)
	{
		[[VeraAutomationAppDelegate appDelegate] toggleDevice:device];
		
		NSString *subtitleString = nil;
		if (device.status)
		{
			subtitleString = [NSString stringWithFormat:NSLocalizedString(@"COMMAND_SENT_MESSAGE_OFF_%@", nil), device.name];
		}
		else
		{
			subtitleString = [NSString stringWithFormat:NSLocalizedString(@"COMMAND_SENT_MESSAGE_ON_%@", nil), device.name];
		}
		[VeraAutomationAppDelegate showNotificationWithTitle:NSLocalizedString(@"COMMAND_SENT_TITLE", nil)
													subtitle:subtitleString
														type:TSMessageNotificationTypeSuccess];
	}
}

@end
