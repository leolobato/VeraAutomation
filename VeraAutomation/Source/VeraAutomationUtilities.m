//
//  VeraAutomationUtilities.m
//  VeraAutomation
//
//  Created by Scott Gruby on 1/28/14.
//  Copyright (c) 2014 Gruby Solutions. All rights reserved.
//

#import "VeraAutomationUtilities.h"

@implementation VeraAutomationUtilities
+ (CAGradientLayer *) blueGradientLayer
{
	
    UIColor *colorOne = [UIColor colorWithRed:129.0f/255.0f green:243.0f/255.0f blue:253.0f/255.0f alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:29.0f/255.0f  green:98.0f/255.0f  blue:240.0f/255.0f  alpha:1.0];
	
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
	
    NSArray *locations = @[stopOne, stopTwo];
	
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = colors;
    gradientLayer.locations = locations;
	
    return gradientLayer;
}

@end
