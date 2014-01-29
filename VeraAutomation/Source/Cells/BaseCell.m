//
//  BaseCell.m
//  VeraAutomation
//
//  Created by Scott Gruby on 1/28/14.
//  Copyright (c) 2014 Gruby Solutions. All rights reserved.
//

#import "BaseCell.h"
#import "VeraAutomationUtilities.h"

@implementation BaseCell
- (void) awakeFromNib
{
	[super awakeFromNib];
	CAGradientLayer *bgLayer = [VeraAutomationUtilities blueGradientLayer];
	bgLayer.frame = self.bounds;
	[self.layer insertSublayer:bgLayer atIndex:0];
}

@end
