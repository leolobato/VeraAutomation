//
//  LocksViewController.m
//  VeraAutomation
//
//  Created by Scott Gruby on 2/2/14.
//  Copyright (c) 2014 Gruby Solutions. All rights reserved.
//

#import "LocksViewController.h"
#import "VeraRoom.h"
#import "VeraDevice.h"
#import "VeraAPI.h"
#import "VeraUnitInfo.h"
#import "LockCell.h"

@interface LocksViewController () <LockCellDelegate>
@property (nonatomic, strong) NSArray *devices;
@end

@implementation LocksViewController

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
		NSArray *devices = [[VeraAutomationAppDelegate appDelegate].api devicesForRoom:room forType:VeraDeviceTypeLock];
		for (VeraDevice *device in devices)
		{
			[deviceArray addObject:device];
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
	LockCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"LockCell" forIndexPath:indexPath];
	VeraDevice *device = nil;
	if (indexPath.row < [self.devices count])
	{
		device = self.devices[indexPath.row];
	}
	
	cell.delegate = self;
	cell.device = device;
	[cell setupCell];
	return cell;
}

- (void) unitInfoChanged:(NSNotification *) notification
{
	[self refreshRoom];
	[self.collectionView reloadData];
}

- (void) lockDevice:(VeraDevice *) device
{
	[self setDevice:device status:YES];
	[[VeraAutomationAppDelegate appDelegate] setLockState:device locked:YES];
}

- (void) unlockDevice:(VeraDevice *) device
{
	[self setDevice:device status:NO];
	[[VeraAutomationAppDelegate appDelegate] setLockState:device locked:NO];
}

- (void) setDevice:(VeraDevice *) device status:(BOOL) locked
{
	NSString *subtitleString = nil;
	if (locked)
	{
		subtitleString = [NSString stringWithFormat:NSLocalizedString(@"COMMAND_SENT_LOCKING_%@", nil), device.name];
	}
	else
	{
		subtitleString = [NSString stringWithFormat:NSLocalizedString(@"COMMAND_SENT_UNLOCKING_%@", nil), device.name];
	}
	[VeraAutomationAppDelegate showNotificationWithTitle:NSLocalizedString(@"COMMAND_SENT_TITLE", nil)
												subtitle:subtitleString
													type:TSMessageNotificationTypeSuccess];
}


@end
