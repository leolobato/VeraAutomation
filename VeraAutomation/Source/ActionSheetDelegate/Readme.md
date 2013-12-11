`ActionSheetDelegate` is a simple way to create a delegate for a `UIActionSheet`. When creating an instance, you specify a "handler" Block whose signature matches that of the `UIActionSheetDelegate` method `actionSheet:clickedButtonAtIndex:`. `ActionSheetDelegate` conforms to the `UIActionSheetDelegate` protocol and thus implements that method.

You then create a sheet, passing your instance of `ActionSheetDelegate` for the delegate argument. When the sheet sends `actionSheet:clickedButtonAtIndex:`, the delegate simply passes the arguments on to its handler Block.

The class also has a handy method that uses the Objective-C runtime associated objects feature to tie its lifetime to its sheet's. Tying the two together this way means that there is no need to keep a local (or ivar-level) reference to the delegate; its only owner is the sheet itself, and it will be destroyed when the sheet is.

A quick example of usage:

    ActionSheetDelegate * delegate;
    delegate = [ActionSheetDelegate delegateWithHandler:
        ^( UIActionSheet * sheet, NSInteger idx ){
            if( idx == [sheet destructiveButtonIndex] ){
                [controller removeSomeImage];
            }
            else if( idx == [sheet firstOtherButtonIndex] ){
                [controller presentImagePicker];
            }
            // Cancel button "falls through" to no action
    }];
    
    UIActionSheet * sheet;
    sheet = [[UIActionSheet alloc] initWithTitle:@""
                                        delegate:delegate
                               cancelButtonTitle:@"Cancel"
                          destructiveButtonTitle:@"Remove Image"
                               otherButtonTitles:@"Choose New Image", nil];
    // Tie delegate's lifespan to that of the sheet
    [delegate associateSelfWithSheet:sheet];
    
    [sheet showInView:[self view]];

The contents of this repository are in the public domain. I retain no copyright, and they are offered without restriction or warranty. You are free to use them in whatever way you like. If you would like to mention that I created the code, it will be appreciated, but it isn't at all necessary. For further details, please see License.txt