//
// AlertViewDelegate.h
//
// Created by Scott Gruby based on ActionSheetDelegate
//

#import <UIKit/UIKit.h>

typedef void (^AlertButtonClickedHandler)(UIAlertView *alertView, NSInteger buttonClicked);

@interface AlertViewDelegate : NSObject <UIAlertViewDelegate>

@property (copy, nonatomic) AlertButtonClickedHandler handler;

+ (id)delegateWithHandler: (AlertButtonClickedHandler)newHandler;

/* Uses objc_setAssociatedObject() to tie self to the passed-in sheet;
 * the delegate will therefore be released when the sheet is deallocated.
 * This obviates the need to keep a reference to the delegate in the scope
 * in which it was created.
 */
- (void)associateSelfWithAlertView: (UIAlertView *)sheet;

@end
