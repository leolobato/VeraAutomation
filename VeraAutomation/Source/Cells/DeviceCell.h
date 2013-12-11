//
//  DeviceCell.h
//  VeraAutomation
//
//  Created by Scott Gruby on 12/7/13.
//  Copyright (c) 2013 Gruby Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VeraDevice;

@protocol DeviceCellProtocol <NSObject>
- (void) setLevel:(NSInteger) level forDevice:(VeraDevice *) device;
@end

@interface DeviceCell : UICollectionViewCell
@property (nonatomic, strong) VeraDevice *device;
@property (nonatomic, weak) id<DeviceCellProtocol> delegate;
- (void) setupCell;
@end
