//
//  ClimateViewController.m
//  VeraAutomation
//
//  Created by Scott Gruby on 2/2/14.
//  Copyright (c) 2014 Gruby Solutions. All rights reserved.
//

#import "ClimateViewController.h"
#import "VeraRoom.h"
#import "VeraDevice.h"
#import "VeraAPI.h"
#import "VeraUnitInfo.h"
#import "ClimateCell.h"

@interface ClimateViewController ()
@property (nonatomic, strong) NSArray *devices;
@end

@implementation ClimateViewController

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
		NSArray *devices = [[VeraAutomationAppDelegate appDelegate].api devicesForRoom:room forType:VeraDeviceTypeThermostat];
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
	ClimateCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"ClimateCell" forIndexPath:indexPath];
	VeraDevice *device = nil;
	if (indexPath.row < [self.devices count])
	{
		device = self.devices[indexPath.row];
	}
	
	//	[cell setDeviceTitle:device.name];
	return cell;
}

- (void) unitInfoChanged:(NSNotification *) notification
{
	[self refreshRoom];
	[self.collectionView reloadData];
}


@end
