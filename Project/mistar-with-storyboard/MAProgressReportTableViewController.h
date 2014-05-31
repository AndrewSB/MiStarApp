//
//  MAProgressReportTableViewController.h
//  mistar-with-storyboard
//
//  Created by Andrew Breckenridge on 5/29/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MAClass.h"
#import "MAAssignment.h"

#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>

@interface MAProgressReportTableViewController : UITableViewController

@property (nonatomic, assign) NSInteger *row;
@property (nonatomic, retain) NSIndexPath *selectedRowIndex;
@property (nonatomic, strong) NSArray *sourceArray;

- (id)initWithRow:(NSInteger *)row;

@end
