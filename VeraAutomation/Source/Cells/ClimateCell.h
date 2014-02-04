//
//  ClimateCell.h
//  VeraAutomation
//
//  Created by Scott Gruby on 2/2/14.
//  Copyright (c) 2014 Gruby Solutions. All rights reserved.
//

#import "BaseCell.h"

@class VeraDevice;
@interface ClimateCell : BaseCell
@property (nonatomic, strong) VeraDevice *device;
- (void) setupCell;
@end
