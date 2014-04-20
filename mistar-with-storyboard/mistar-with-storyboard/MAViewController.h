//
//  MAViewController.h
//  mistar-with-storyboard
//
//  Created by Andrew Breckenridge on 4/17/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MAGradeClient.h"
#import "MAGradeCell.h"
#import "MAAppDelegate.h"
#import "MAGradeTableView.h"
#import "MAClass.h"
#import "MAStudent.h"
#import "MADetailTableViewDelegate.h"

@interface MAViewController : UIViewController
<UITableViewDataSource, UITabBarDelegate, UIScrollViewDelegate>

- (void)userStateButtonWasPressed;

- (void)configureDetailCell:(UITableViewCell *)cell row:(NSInteger *)row;

- (void)configureHeaderCell:(UITableViewCell *)cell title:(NSString *)title;
- (void)configureGradesCell:(UITableViewCell *)cell row:(NSInteger *)row;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
