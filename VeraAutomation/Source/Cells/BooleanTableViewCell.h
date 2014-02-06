//
//  BooleanTableViewCell.h
//  VeraAutomation
//
//  Created by Scott Gruby on 2/6/14.
//  Copyright (c) 2014 Gruby Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BooleanTableViewCell;

@protocol BooleanTableViewCellProtocol <NSObject>
- (void) valueChanged:(BooleanTableViewCell *) cell newValue:(BOOL) newValue;
@end

@interface BooleanTableViewCell : UITableViewCell
@property (nonatomic, weak) id <BooleanTableViewCellProtocol> delegate;
- (void) setTitle:(NSString *) title;
- (void) setSwitchValue:(BOOL) on;
@end
