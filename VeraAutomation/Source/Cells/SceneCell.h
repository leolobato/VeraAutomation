//
//  SceneCell.h
//  VeraAutomation
//
//  Created by Scott Gruby on 1/28/14.
//  Copyright (c) 2014 Gruby Solutions. All rights reserved.
//

#import "BaseCell.h"

@class VeraScene;

@interface SceneCell : BaseCell
@property (nonatomic, strong) VeraScene *scene;
- (void) setupCell;
@end
