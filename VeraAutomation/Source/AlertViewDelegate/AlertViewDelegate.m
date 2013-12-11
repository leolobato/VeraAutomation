//
//  AlertViewDelegate.h
//
// Created by Scott Gruby based on ActionSheetDelegate

#import "AlertViewDelegate.h"
#import <objc/runtime.h>

#define SAFE_BLOCK_INVOKE(b,...) ((b) ? (b)(__VA_ARGS__) : 0)

@implementation AlertViewDelegate

+ (id)delegateWithHandler: (AlertButtonClickedHandler)newHandler
{
    return [[self alloc] initWithHandler:newHandler];
}

- (id)initWithHandler: (AlertButtonClickedHandler)newHandler
{
    self = [super init];
    if( !self ) return nil;

    _handler = [newHandler copy];

    return self;
}

static char alert_key;
- (void)associateSelfWithAlertView: (UIAlertView *)alertView
{
    // Tie delegate's lifetime to that of the action sheet
    objc_setAssociatedObject(alertView, &alert_key, self, OBJC_ASSOCIATION_RETAIN);
}

//MARK: -
//MARK: UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    SAFE_BLOCK_INVOKE(self.handler, alertView, buttonIndex);
}

@end
