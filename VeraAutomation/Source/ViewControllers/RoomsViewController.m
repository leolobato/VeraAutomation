//
//  RoomsViewController.m
//  VeraAutomation
//
//  Created by Scott Gruby on 12/7/13.
//  Copyright (c) 2013 Gruby Solutions. All rights reserved.
//

#import "RoomsViewController.h"
#import "VeraDevice.h"

@implementation RoomsViewController

- (void)viewDidLoad
{
	self.deviceType = VeraDeviceTypeSwitch;
	self.title = NSLocalizedString(@"SWITCHES_TITLE", nil);
    [super viewDidLoad];
}

@end
