//
//  AudioRoomViewController.m
//  VeraAutomation
//
//  Created by Scott Gruby on 12/7/13.
//  Copyright (c) 2013 Gruby Solutions. All rights reserved.
//

#import "AudioRoomViewController.h"
#import "VeraRoom.h"
#import "VeraAPI.h"
#import "VeraUnitInfo.h"
#import "VeraDevice.h"
#import "AudioDeviceCell.h"

@interface AudioRoomViewController () <AudioDeviceCellProtocol>
@property (nonatomic, strong) NSArray *devices;
@end

@implementation AudioRoomViewController

- (void)viewDidLoad
{
	self.deviceType = VeraDeviceTypeAudio;
    [super viewDidLoad];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	AudioDeviceCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"AudioDeviceCell" forIndexPath:indexPath];
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

- (void) deviceButtonTapped:(NSInteger) tag forDevice:(VeraDevice *) device
{
	DebugLog(@"tapped: %ld", (long)tag);
	
	if (device)
	{
		NSString *subtitleString = nil;

		if (tag == 0)
		{
			if (device.parent == 0)
			{
				[[VeraAutomationAppDelegate appDelegate] setAllAudioDevicePower:NO device:device];
			}
			else
			{
				[[VeraAutomationAppDelegate appDelegate] setAudioDevicePower:NO device:device];
			}
			subtitleString = [NSString stringWithFormat:NSLocalizedString(@"COMMAND_SENT_MESSAGE_OFF_%@", nil), device.name];
		}
		else if (tag == 1)
		{
			if (device.parent == 0)
			{
				[[VeraAutomationAppDelegate appDelegate] setAllAudioDevicePower:YES device:device];
			}
			else
			{
				[[VeraAutomationAppDelegate appDelegate] setAudioDevicePower:YES device:device];
			}
			subtitleString = [NSString stringWithFormat:NSLocalizedString(@"COMMAND_SENT_MESSAGE_ON_%@", nil), device.name];
		}
		else if (tag == 2)
		{
			[[VeraAutomationAppDelegate appDelegate] setAudioDeviceVolume:NO device:device];
			subtitleString = [NSString stringWithFormat:NSLocalizedString(@"COMMAND_SENT_VOLUME_DOWN_%@", nil), device.name];
		}
		else if (tag == 3)
		{
			[[VeraAutomationAppDelegate appDelegate] setAudioDeviceVolume:YES device:device];
			subtitleString = [NSString stringWithFormat:NSLocalizedString(@"COMMAND_SENT_VOLUME_UP_%@", nil), device.name];
		}
		else if (tag == 4)
		{
			[[VeraAutomationAppDelegate appDelegate] setAudioDeviceInput:1 device:device];
			subtitleString = [NSString stringWithFormat:NSLocalizedString(@"COMMAND_SENT_INPUT_1_%@", nil), device.name];
		}
		else if (tag == 5)
		{
			[[VeraAutomationAppDelegate appDelegate] setAudioDeviceInput:2 device:device];
			subtitleString = [NSString stringWithFormat:NSLocalizedString(@"COMMAND_SENT_INPUT_2_%@", nil), device.name];
		}
		else if (tag == 6)
		{
			[[VeraAutomationAppDelegate appDelegate] setAudioDeviceInput:3 device:device];
			subtitleString = [NSString stringWithFormat:NSLocalizedString(@"COMMAND_SENT_INPUT_3_%@", nil), device.name];
		}
		
		[VeraAutomationAppDelegate showNotificationWithTitle:NSLocalizedString(@"COMMAND_SENT_TITLE", nil)
									subtitle:subtitleString
										type:TSMessageNotificationTypeSuccess];
	}

	
}


@end
