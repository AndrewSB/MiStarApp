//
//  MASMSViewController.m
//  mistar-with-storyboard
//
//  Created by Andrew Breckenridge on 4/27/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import "MASMSViewController.h"

@interface MASMSViewController () <
    MFMailComposeViewControllerDelegate,
    MFMessageComposeViewControllerDelegate,
    UINavigationControllerDelegate
>

@property (nonatomic, weak) IBOutlet UILabel *feedbackMsg;

@end

@implementation MASMSViewController

- (MFMessageComposeViewController *)displaySMSComposerSheet
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    
    // You can specify one or more preconfigured recipients.  The user has
    // the option to remove or add recipients from the message composer view
    // controller.
    /* picker.recipients = @[@"Phone number here"]; */
    
    // You can specify the initial message text that will appear in the message
    // composer view controller.
    picker.body = @"Hello from California!";
    
    
    return picker;
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    self.feedbackMsg.hidden = NO;
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MessageComposeResultCancelled:
            self.feedbackMsg.text = @"Result: SMS sending canceled";
            break;
        case MessageComposeResultSent:
            self.feedbackMsg.text = @"Result: SMS sent";
            break;
        case MessageComposeResultFailed:
            self.feedbackMsg.text = @"Result: SMS sending failed";
            break;
        default:
            self.feedbackMsg.text = @"Result: SMS not sent";
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
