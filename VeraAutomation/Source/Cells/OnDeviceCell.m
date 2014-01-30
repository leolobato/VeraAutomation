//
//  OnDeviceCell.m
//  VeraAutomation
//
//  Created by Scott Gruby on 1/29/14.
//  Copyright (c) 2014 Gruby Solutions. All rights reserved.
//

#import "OnDeviceCell.h"

@interface OnDeviceCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation OnDeviceCell
- (void)prepareForReuse
{
	[super prepareForReuse];
	self.titleLabel.text = nil;
}

- (void) setDeviceTitle:(NSString *) title
{
	self.titleLabel.text = title;
}
@end
