//
//  DeviceCell.m
//  VeraAutomation
//
//  Created by Scott Gruby on 12/7/13.
//  Copyright (c) 2013 Gruby Solutions. All rights reserved.
//

#import "DeviceCell.h"
#import "VeraDevice.h"
#import <QuartzCore/QuartzCore.h>

@interface DeviceCell ()
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UISlider *levelSlider;
@property (nonatomic, assign) BOOL initialSliderSet;

@end

@implementation DeviceCell

- (void)prepareForReuse
{
	self.device = nil;
	self.levelSlider.hidden = NO;
	self.deviceNameLabel.text = nil;
	self.statusLabel.text = nil;
}

- (void) setupCell
{
	self.layer.cornerRadius = 5.0f;
	self.deviceNameLabel.text = self.device.name;
	self.statusLabel.text = [NSString stringWithFormat:@"Status: %ld", (long)self.device.status];
	
	if (self.device.category == 3)
	{
		self.levelSlider.hidden = YES;
	}
	else
	{
		self.levelSlider.value = self.device.level;
	}
	
}

- (IBAction)sliderTouchUpAction:(id)sender
{
	self.levelSlider.value = ceilf(self.levelSlider.value);
	if (self.delegate)
	{
		[self.delegate setLevel:(NSInteger) self.levelSlider.value forDevice:self.device];
	}
	DebugLog(@"value: %f", self.levelSlider.value);
}

@end
