//
//  LockCell.m
//  VeraAutomation
//
//  Created by Scott Gruby on 2/2/14.
//  Copyright (c) 2014 Gruby Solutions. All rights reserved.
//

#import "LockCell.h"

@interface LockCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation LockCell
- (void)prepareForReuse
{
	[super prepareForReuse];
	self.device = nil;
	[self setupCell];
}

- (void) setupCell
{
	DebugLog(@"device: %@", self.device);
	DebugLog(@"device locked: %@ - %d", self.device.name, self.device.locked);
	self.title.text = self.device.name;
	self.statusLabel.text = self.device.status == 0 ? NSLocalizedString(@"UNLOCKED_TITLE", nil) : NSLocalizedString(@"LOCKED_TITLE", nil);
}

- (IBAction)unlockAction:(id)sender
{
	if (self.delegate)
	{
		[self.delegate unlockDevice:self.device];
	}
}

- (IBAction)lockAction:(id)sender
{
	if (self.delegate)
	{
		[self.delegate lockDevice:self.device];
	}
}

@end
