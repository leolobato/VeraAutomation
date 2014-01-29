//
//  SceneCell.m
//  VeraAutomation
//
//  Created by Scott Gruby on 1/28/14.
//  Copyright (c) 2014 Gruby Solutions. All rights reserved.
//

#import "SceneCell.h"
#import "VeraScene.h"
#import "VeraAutomationUtilities.h"

@interface SceneCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation SceneCell
- (void)prepareForReuse
{
	[super prepareForReuse];
	self.scene = nil;
	self.titleLabel.text = nil;
}

- (void) setupCell
{
	self.layer.cornerRadius = 5.0f;
	self.backgroundColor = [UIColor clearColor];
	self.titleLabel.text = self.scene.name;
}
@end
