//
//  MAViewController.h
//  mistar-with-storyboard
//
//  Created by Andrew Breckenridge on 4/17/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MAAppDelegate.h"

#import "MAGradeParser.h"
#import "MAGradeCell.h"

#import "MAClass.h"
#import "MAAssignment.h"

#import "MASMSViewController.h"

#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>

#import <SVProgressHUD/SVProgressHUD.h>
#import <MZFormSheetController/MZFormSheetBackgroundWindowViewController.h>
#import <MZFormSheetController/MZFormSheetBackgroundWindow.h>
#import <MZFormSheetController/MZFormSheetController.h>
#import <MZFormSheetController/MZFormSheetSegue.h>

#import "MAProgressReportTableViewController.h"

#import <FPPopover/FPPopoverController.h>
#import <FPPopover/FPPopoverView.h>
#import <FPPopover/FPTouchView.h>

@interface MAViewController : GAITrackedViewController
<UITableViewDataSource, UITabBarDelegate, UIScrollViewDelegate>

@property BOOL cancel;

- (NSString *)percentEscapeString:(NSString *)string;
- (NSDictionary *)loginToMistarWithPin:(NSString *)pin password:(NSString *)password;

- (void)userStateButtonWasPressed;

- (void)configureDetailCell:(UITableViewCell *)cell row:(NSInteger *)row;

- (void)configureHeaderCell:(UITableViewCell *)cell title:(NSString *)title;
- (void)configureGradesCell:(UITableViewCell *)cell row:(NSInteger *)row;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
