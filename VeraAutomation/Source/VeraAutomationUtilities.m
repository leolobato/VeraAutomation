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
	
    UIColor *colorOne = [UIColor whiteColor];
    UIColor *colorTwo = [UIColor colorWithRed:176.0f/255.0f  green:224.0f/255.0f  blue:230.0f/255.0f  alpha:1.0];
	
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
