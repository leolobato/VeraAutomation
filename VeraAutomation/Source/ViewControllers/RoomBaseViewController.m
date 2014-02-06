//
//  RoomBaseViewController.m
//  VeraAutomation
//
//  Created by Scott Gruby on 1/27/14.
//  Copyright (c) 2014 Gruby Solutions. All rights reserved.
//

#import "RoomBaseViewController.h"
#import "VeraRoom.h"
#import "VeraAPI.h"
#import "VeraUnitInfo.h"
#import "VeraDevice.h"

@interface RoomBaseViewController ()
@property (nonatomic, strong) NSArray *devices;
@end

@implementation RoomBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self refreshRoom];
}

- (void) refreshRoom
{
	self.title = self.room.name;
	self.devices = [[VeraAutomationAppDelegate appDelegate].api devicesForRoom:self.room forType:self.deviceType];
	[self.collectionView reloadData];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return [self.devices count];
}

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unitInfoChanged:) name:kDeviceUpdatedNotification object:nil];
}

- (void) unitInfoChanged:(NSNotification *) notification
{
	[self refreshRoom];
}

@end
