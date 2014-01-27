//
//  AudioRoomsViewController.m
//  VeraAutomation
//
//  Created by Scott Gruby on 12/7/13.
//  Copyright (c) 2013 Gruby Solutions. All rights reserved.
//

#import "AudioRoomsViewController.h"
#import "VeraDevice.h"

@implementation AudioRoomsViewController

- (void)viewDidLoad
{
	self.title = NSLocalizedString(@"AUDIO_TITLE", nil);
	self.deviceType = VeraDeviceTypeAudio;
    [super viewDidLoad];
}

@end
