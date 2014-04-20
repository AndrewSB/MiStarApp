//
//  MAController.h
//  MistarApp
//
//  Created by Andrew Breckenridge on 3/23/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MAGradeClient.h"
#import "MAGradeCell.h"
#import "MAAppDelegate.h"
#import "MAGradeTableView.h"
#import "MAClass.h"
#import "MAStudent.h"
#import "MADetailTableViewDelegate.h"

@interface MAController : UIViewController
<UITableViewDataSource, UITabBarDelegate, UIScrollViewDelegate>

- (void)userStateButtonWasPressed;

- (void)configureDetailCell:(UITableViewCell *)cell row:(NSInteger *)row;

- (void)configureHeaderCell:(UITableViewCell *)cell title:(NSString *)title;
- (void)configureGradesCell:(UITableViewCell *)cell row:(NSInteger *)row;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;


@end
