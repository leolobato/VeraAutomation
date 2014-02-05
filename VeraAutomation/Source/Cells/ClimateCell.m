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
	if (self.device.fanmode == VeraFanModeAuto)
	{
		self.fanSegmentedControl.selectedSegmentIndex = 0;
	}
	else
	{
		self.fanSegmentedControl.selectedSegmentIndex = 1;
	}
	
	switch (self.device.hvacMode)
	{
		case VeraHVACModeOff:
		{
			self.hvacSegmentedControl.selectedSegmentIndex = 0;
			break;
		}
			
		case VeraHVACModeAuto:
		{
			self.hvacSegmentedControl.selectedSegmentIndex = 1;
			break;
		}

		case VeraHVACModeCool:
		{
			self.hvacSegmentedControl.selectedSegmentIndex = 2;
			break;
		}

		case VeraHVACModeHeat:
		{
			self.hvacSegmentedControl.selectedSegmentIndex = 3;
			break;
		}
	}
	
	self.heatSetLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.device.heatTemperatureSetPoint];
	self.coolSetLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.device.coolTemperatureSetPoint];
	self.heatStepper.value = self.device.heatTemperatureSetPoint;
	self.coolStepper.value = self.device.coolTemperatureSetPoint;
}


- (IBAction)heatStepperChanged:(id)sender
{
	self.heatSetLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.heatStepper.value];
	[self performSelector:@selector(sendHeatTemperatureChanged) withObject:nil afterDelay:1.5f];
}

- (void) sendHeatTemperatureChanged
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(sendHeatTemperatureChanged) object:nil];
	[self.delegate setHeatTemperature:self.heatStepper.value device:self.device];
}

- (IBAction)coolStepperChanged:(id)sender
{
	self.coolSetLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.coolStepper.value];
	[self performSelector:@selector(sendCoolTemperatureChanged) withObject:nil afterDelay:1.5f];
}

- (void) sendCoolTemperatureChanged
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(sendCoolTemperatureChanged) object:nil];
	[self.delegate setCoolTemperature:self.coolStepper.value device:self.device];
}

- (IBAction)fanChanged:(id)sender
{
	[self.delegate setFanMode:self.fanSegmentedControl.selectedSegmentIndex == 0 ? VeraFanModeAuto : VeraFanModeOn device:self.device];
}

- (IBAction)hvacStageChanged:(id)sender
{
	VeraHVACMode mode = VeraHVACModeOff;
	if (self.hvacSegmentedControl.selectedSegmentIndex == 0)
	{
		mode = VeraHVACModeOff;
	}
	else if (self.hvacSegmentedControl.selectedSegmentIndex == 1)
	{
		mode = VeraHVACModeAuto;
	}
	else if (self.hvacSegmentedControl.selectedSegmentIndex == 2)
	{
		mode = VeraHVACModeCool;
	}
	else if (self.hvacSegmentedControl.selectedSegmentIndex == 3)
	{
		mode = VeraHVACModeHeat;
	}
	
	[self.delegate setHVACMode:mode device:self.device];
}
@end
