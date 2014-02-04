//
//  ClimateCell.m
//  VeraAutomation
//
//  Created by Scott Gruby on 2/2/14.
//  Copyright (c) 2014 Gruby Solutions. All rights reserved.
//

#import "ClimateCell.h"
#import "VeraDevice.h"

@interface ClimateCell ()
@property (weak, nonatomic) IBOutlet UILabel *currentTemperatureLabel;
@property (weak, nonatomic) IBOutlet UIStepper *heatStepper;
@property (weak, nonatomic) IBOutlet UIStepper *coolStepper;
@property (weak, nonatomic) IBOutlet UILabel *heatSetLabel;
@property (weak, nonatomic) IBOutlet UILabel *coolSetLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *hvacSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *fanSegmentedControl;

@end

@implementation ClimateCell

-(void)prepareForReuse
{
	[super prepareForReuse];
	self.device = nil;
	[self setupCell];
}

- (void) setupCell
{
	self.currentTemperatureLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.device.temperature];
	DebugLog(@"device: %@", self.device);
	if ([self.device.fanmode caseInsensitiveCompare:@"auto"] == NSOrderedSame)
	{
		self.fanSegmentedControl.selectedSegmentIndex = 0;
	}
	else
	{
		self.fanSegmentedControl.selectedSegmentIndex = 1;
	}
}


- (IBAction)heatStepperChanged:(id)sender
{
}

- (IBAction)coolStepperChanged:(id)sender
{
}

- (IBAction)fanChanged:(id)sender
{
}

- (IBAction)hvacStageChanged:(id)sender
{
}
@end
