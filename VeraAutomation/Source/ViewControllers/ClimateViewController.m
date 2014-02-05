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

@interface ClimateViewController () <ClimateCellDelegate>
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
	ClimateCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"ClimateCell" forIndexPath:indexPath];
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

- (void) unitInfoChanged:(NSNotification *) notification
{
	[self refreshRoom];
	[self.collectionView reloadData];
}

- (void) setFanMode:(VeraFanMode) fanMode device:(VeraDevice *)device
{
	NSString *command = [NSString stringWithFormat:fanMode == VeraFanModeAuto ? NSLocalizedString(@"COMMAND_SENT_FAN_MODE_AUTO_%@", nil) :  NSLocalizedString(@"COMMAND_SENT_FAN_MODE_OFF_%@", nil), device.name];
	[VeraAutomationAppDelegate showNotificationWithTitle:NSLocalizedString(@"COMMAND_SENT_TITLE", nil)
												subtitle:command
													type:TSMessageNotificationTypeSuccess];
	[[VeraAutomationAppDelegate appDelegate] setFanMode:fanMode device:device];
}

- (void) setHVACMode:(VeraHVACMode) hvacMode device:(VeraDevice *)device
{
	NSString *command = nil;
	switch (hvacMode)
	{
		case VeraHVACModeOff:
		{
			command = [NSString stringWithFormat:NSLocalizedString(@"COMMAND_SENT_HVAC_OFF_%@", nil), device.name];
			break;
		}
			
		case VeraHVACModeAuto:
		{
			command = [NSString stringWithFormat:NSLocalizedString(@"COMMAND_SENT_HVAC_AUTO_%@", nil), device.name];
			break;
		}
			
		case VeraHVACModeHeat:
		{
			command = [NSString stringWithFormat:NSLocalizedString(@"COMMAND_SENT_HVAC_HEAT_%@", nil), device.name];
			break;
		}
			
		case VeraHVACModeCool:
		{
			command = [NSString stringWithFormat:NSLocalizedString(@"COMMAND_SENT_HVAC_COOL_%@", nil), device.name];
			break;
		}
			
	}
	
	[VeraAutomationAppDelegate showNotificationWithTitle:NSLocalizedString(@"COMMAND_SENT_TITLE", nil)
												subtitle:command
													type:TSMessageNotificationTypeSuccess];
	[[VeraAutomationAppDelegate appDelegate] setHVACMode:hvacMode device:device];
}

- (void) setHeatTemperature:(NSUInteger) temperature device:(VeraDevice *)device
{
	NSString *command = [NSString stringWithFormat:NSLocalizedString(@"COMMAND_SENT_HEAT_TEMPERATURE_%@_%ld", nil), device.name, temperature];
	[VeraAutomationAppDelegate showNotificationWithTitle:NSLocalizedString(@"COMMAND_SENT_TITLE", nil)
												subtitle:command
													type:TSMessageNotificationTypeSuccess];
	[[VeraAutomationAppDelegate appDelegate] setTemperature:temperature heat:YES device:device];
}

- (void) setCoolTemperature:(NSUInteger) temperature device:(VeraDevice *)device
{
	NSString *command = [NSString stringWithFormat:NSLocalizedString(@"COMMAND_SENT_COOL_TEMPERATURE_%@_%ld", nil), device.name, temperature];
	[VeraAutomationAppDelegate showNotificationWithTitle:NSLocalizedString(@"COMMAND_SENT_TITLE", nil)
												subtitle:command
													type:TSMessageNotificationTypeSuccess];
	[[VeraAutomationAppDelegate appDelegate] setTemperature:temperature heat:NO device:device];
}


@end
