//
//  MAProgressReportViewController.h
//  mistar-with-storyboard
//
//  Created by Andrew Breckenridge on 4/27/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAProgressReportViewController : UIViewController <UITableViewDataSource, UITabBarDelegate, UIScrollViewDelegate>

- (NSArray *)getAssignmentsFromFile;

@end
