//
//  ScenesRoomsViewController.m
//  VeraAutomation
//
//  Created by Scott Gruby on 1/27/14.
//  Copyright (c) 2014 Gruby Solutions. All rights reserved.
//

#import "ScenesRoomsViewController.h"
#import "VeraDevice.h"
#import "VeraRoom.h"
#import "VeraDevice.h"
#import "VeraAPI.h"
#import "VeraUnitInfo.h"

@interface ScenesRoomsViewController ()
@end

@implementation ScenesRoomsViewController

- (void)viewDidLoad
{
	self.deviceType = VeraDeviceTypeScene;
	self.title = NSLocalizedString(@"SCENES_TITLE", nil);
    [super viewDidLoad];
}

@end
