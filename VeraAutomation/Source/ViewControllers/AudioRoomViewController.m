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
    [super viewDidLoad];
	self.title = self.room.name;
	NSArray *devices = [[VeraAutomationAppDelegate appDelegate].api devicesForRoom:self.room];
	NSMutableArray *newArray = [NSMutableArray array];
	for (VeraDevice *device in devices)
	{
		if ([device isAudio])
		{
			[newArray addObject:device];
		}
	}
	self.devices = newArray;
	[self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return [self.devices count];
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
			subtitleString = [NSString stringWithFormat:NSLocalizedString(@"COMMAND_SENT_MESSAGE_OFF", nil), device.name];
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
			subtitleString = [NSString stringWithFormat:NSLocalizedString(@"COMMAND_SENT_MESSAGE_ON", nil), device.name];
		}
		else if (tag == 2)
		{
			[[VeraAutomationAppDelegate appDelegate] setAudioDeviceVolume:NO device:device];
			subtitleString = [NSString stringWithFormat:NSLocalizedString(@"COMMAND_SENT_VOLUME_DOWN", nil), device.name];
		}
		else if (tag == 3)
		{
			[[VeraAutomationAppDelegate appDelegate] setAudioDeviceVolume:YES device:device];
			subtitleString = [NSString stringWithFormat:NSLocalizedString(@"COMMAND_SENT_VOLUME_UP", nil), device.name];
		}
		else if (tag == 4)
		{
			[[VeraAutomationAppDelegate appDelegate] setAudioDeviceInput:1 device:device];
			subtitleString = [NSString stringWithFormat:NSLocalizedString(@"COMMAND_SENT_INPUT_1", nil), device.name];
		}
		else if (tag == 5)
		{
			[[VeraAutomationAppDelegate appDelegate] setAudioDeviceInput:2 device:device];
			subtitleString = [NSString stringWithFormat:NSLocalizedString(@"COMMAND_SENT_INPUT_2", nil), device.name];
		}
		else if (tag == 6)
		{
			[[VeraAutomationAppDelegate appDelegate] setAudioDeviceInput:3 device:device];
			subtitleString = [NSString stringWithFormat:NSLocalizedString(@"COMMAND_SENT_INPUT_3", nil), device.name];
		}
		
		[VeraAutomationAppDelegate showNotificationWithTitle:NSLocalizedString(@"COMMAND_SENT_TITLE", nil)
									subtitle:subtitleString
										type:TSMessageNotificationTypeSuccess];
	}

	
}


@end
