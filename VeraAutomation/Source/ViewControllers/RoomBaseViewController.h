//
//  RoomBaseViewController.h
//  VeraAutomation
//
//  Created by Scott Gruby on 1/27/14.
//  Copyright (c) 2014 Gruby Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VeraRoom;

@interface RoomBaseViewController : UICollectionViewController
@property (nonatomic, assign) VeraDeviceTypeEnum deviceType;
@property (nonatomic, strong) VeraRoom *room;
- (void) refreshRoom;
@end
