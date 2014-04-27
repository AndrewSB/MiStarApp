//
//  MAViewController.h
//  mistar-with-storyboard
//
//  Created by Andrew Breckenridge on 4/17/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MAGradeCell.h"
#import "MAAppDelegate.h"
#import "MAClass.h"
#import "MAGradeParser.h"
#import "MASMSViewController.h"
#import "MAProgressReportViewController.h"

@interface MAViewController : UIViewController
<UITableViewDataSource, UITabBarDelegate, UIScrollViewDelegate>

@property BOOL cancel;

- (NSString *)percentEscapeString:(NSString *)string;
- (NSArray *)loginToMistarWithPin:(NSString *)pin password:(NSString *)password success:(void (^)(void))successHandler failure:(void (^)(void))failureHandler;

- (void)userStateButtonWasPressed;

- (void)configureDetailCell:(UITableViewCell *)cell row:(NSInteger *)row;

- (void)configureHeaderCell:(UITableViewCell *)cell title:(NSString *)title;
- (void)configureGradesCell:(UITableViewCell *)cell row:(NSInteger *)row;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
