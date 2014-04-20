//
//  MAGradeTableView.h
//  MistarApp
//
//  Created by Andrew Breckenridge on 3/25/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAGradeCell.h"
@class MAGradeCell;

@interface MAGradeTableView : NSObject <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (MAGradeCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)configureCell:(UITableViewCell *)cell row:(NSInteger *)row;


@end
