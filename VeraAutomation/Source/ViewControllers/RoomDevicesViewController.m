//
//  RoomDevicesViewController.m
//  VeraAutomation
//
//  Created by Scott Gruby on 12/7/13.
//  Copyright (c) 2013 Gruby Solutions. All rights reserved.
//

#import "RoomDevicesViewController.h"
#import "VeraRoom.h"
#import "VeraAPI.h"
#import "DeviceCell.h"
#import "VeraDevice.h"

static NSString *kDeviceKey = @"DeviceKey";
static NSString *kLevelKey = @"Level";

@interface RoomDevicesViewController () <DeviceCellProtocol>
@property (nonatomic, strong) NSArray *devices;
@end

@implementation RoomDevicesViewController

- (void)viewDidLoad
{
	self.deviceType = VeraDeviceTypeSwitch;
    [super viewDidLoad];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	DeviceCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"DeviceCell" forIndexPath:indexPath];
	VeraDevice *device = nil;
	if (indexPath.row < [self.devices count])
	{
		device = self.devices[indexPath.row];
	}
	
	cell.device = device;
	cell.delegate = self;
	[cell setupCell];
	return cell;
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

- (void) setLevel:(NSInteger) level forDevice:(VeraDevice *) device
{
	DebugLog(@"send new level");
	
	[[VeraAutomationAppDelegate appDelegate] setDeviceLevel:device level:level];
	
	NSString *subtitleString = nil;
	subtitleString = [NSString stringWithFormat:NSLocalizedString(@"COMMAND_SENT_MESSAGE_LEVEL_%@_%ld", nil), device.name, (long)level];

	[VeraAutomationAppDelegate showNotificationWithTitle:NSLocalizedString(@"COMMAND_SENT_TITLE", nil)
								subtitle:subtitleString
									type:TSMessageNotificationTypeSuccess];
}

@end
