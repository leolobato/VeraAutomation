//
//  BooleanTableViewCell.m
//  VeraAutomation
//
//  Created by Scott Gruby on 2/6/14.
//  Copyright (c) 2014 Gruby Solutions. All rights reserved.
//

#import "BooleanTableViewCell.h"
@interface BooleanTableViewCell ()
@property (weak, nonatomic) IBOutlet UISwitch *boolSwitch;
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation BooleanTableViewCell

- (IBAction)switchChanged:(id)sender
{
	[self.delegate valueChanged:self newValue:self.boolSwitch.on];
}

- (void) setSwitchValue:(BOOL) on
{
	self.boolSwitch.on = on;
}


- (void) setTitle:(NSString *) title
{
	self.label.text = title;
}
@end
