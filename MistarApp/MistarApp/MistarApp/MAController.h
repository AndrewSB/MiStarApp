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
#import "MAManager.h"

@interface MAController : UIViewController
<UITableViewDataSource, UITabBarDelegate, UIScrollViewDelegate>

- (void)dismissKeyboard;
- (void)loginButtonWasPressed;


- (void)configureHeaderCell:(UITableViewCell *)cell title:(NSString *)title;
- (void)configureGradesCell:(UITableViewCell *)cell grade:(MAGradeClient *)grade;
- (void)configureHourlyCell:(UITableViewCell *)cell weather:(MACondition *)weather;
- (void)configureDailyCell:(UITableViewCell *)cell weather:(MACondition *)weather;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;


@end
