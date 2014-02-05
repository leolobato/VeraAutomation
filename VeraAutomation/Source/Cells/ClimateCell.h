//
//  ClimateCell.h
//  VeraAutomation
//
//  Created by Scott Gruby on 2/2/14.
//  Copyright (c) 2014 Gruby Solutions. All rights reserved.
//

#import "BaseCell.h"

@class VeraDevice;

@protocol ClimateCellDelegate <NSObject>
- (void) setFanMode:(VeraFanMode) fanMode device:(VeraDevice *) device;
- (void) setHVACMode:(VeraHVACMode) hvacMode device:(VeraDevice *) device;;
- (void) setHeatTemperature:(NSUInteger) temperature device:(VeraDevice *) device;;
- (void) setCoolTemperature:(NSUInteger) temperature device:(VeraDevice *) device;;
@end

@interface ClimateCell : BaseCell
@property (nonatomic, strong) VeraDevice *device;
@property (nonatomic, weak) id <ClimateCellDelegate> delegate;
- (void) setupCell;
@end
