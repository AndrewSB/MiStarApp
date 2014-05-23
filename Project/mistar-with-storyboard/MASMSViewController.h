//
//  MASMSViewController.h
//  mistar-with-storyboard
//
//  Created by Andrew Breckenridge on 4/27/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import "MANavController.h"

@interface MASMSViewController : UIViewController

- (MFMessageComposeViewController *)displaySMSComposerSheet;

@end
