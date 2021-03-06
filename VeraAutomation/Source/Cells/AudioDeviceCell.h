//
//  AudioDeviceCell.h
//  VeraAutomation
//
//  Created by Scott Gruby on 12/7/13.
//  Copyright (c) 2013 Gruby Solutions. All rights reserved.
//

#import "BaseCell.h"

@protocol AudioDeviceCellProtocol <NSObject>
- (void) deviceButtonTapped:(NSInteger) tag forDevice:(VeraDevice *) device;
@end

@class VeraDevice;
@interface AudioDeviceCell : BaseCell
@property (nonatomic, strong) VeraDevice *device;
@property (nonatomic, weak) id<AudioDeviceCellProtocol> delegate;
- (void) setupCell;
@end
