//
//  AudioRoomViewController.h
//  VeraAutomation
//
//  Created by Scott Gruby on 12/7/13.
//  Copyright (c) 2013 Gruby Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VeraRoom;
@interface AudioRoomViewController : UICollectionViewController
@property (nonatomic, strong) VeraRoom *room;
- (void) refreshRoom;
@end
