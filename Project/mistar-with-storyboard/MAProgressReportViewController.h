//
//  MAProgressReportViewController.h
//  mistar-with-storyboard
//
//  Created by Andrew Breckenridge on 4/28/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAProgressReportViewController : UIViewController
<UITableViewDataSource, UITabBarDelegate, UIScrollViewDelegate>

- (void)setClass:(NSInteger *)row;

@end
