//
//  AudioDeviceCell.m
//  VeraAutomation
//
//  Created by Scott Gruby on 12/7/13.
//  Copyright (c) 2013 Gruby Solutions. All rights reserved.
//

#import "AudioDeviceCell.h"
#import "VeraDevice.h"
#import <QuartzCore/QuartzCore.h>

@interface AudioDeviceCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *server1Button;
@property (weak, nonatomic) IBOutlet UIButton *server2Button;
@property (weak, nonatomic) IBOutlet UIButton *server3Button;
@property (weak, nonatomic) IBOutlet UIButton *increaseVolumeButton;
@property (weak, nonatomic) IBOutlet UIButton *decreaseVolumeButton;

@end

@implementation AudioDeviceCell
- (void)prepareForReuse
{
	self.device = nil;
	[self setupCell];
}

- (void) setupCell
{
	self.layer.cornerRadius = 5.0f;
	self.titleLabel.text = self.device.name;
	self.server1Button.hidden = self.device.parent == 0;
	self.server2Button.hidden = self.device.parent == 0;
	self.server3Button.hidden = self.device.parent == 0;
	self.increaseVolumeButton.hidden = self.device.parent == 0;
	self.decreaseVolumeButton.hidden = self.device.parent == 0;
}

- (IBAction)buttonTapped:(id)sender
{
	if (self.delegate)
	{
		[self.delegate deviceButtonTapped:[sender tag] forDevice:self.device];
	}
}
@end
