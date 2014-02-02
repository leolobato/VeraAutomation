//
//  LockCell.h
//  VeraAutomation
//
//  Created by Scott Gruby on 2/2/14.
//  Copyright (c) 2014 Gruby Solutions. All rights reserved.
//

#import "BaseCell.h"

@protocol LockCellDelegate <NSObject>
- (void) lockDevice:(VeraDevice *) device;
- (void) unlockDevice:(VeraDevice *) device;
@end

@interface LockCell : BaseCell
@property (nonatomic, strong) VeraDevice *device;
@property (nonatomic, weak) id <LockCellDelegate> delegate;
- (void) setupCell;
@end
