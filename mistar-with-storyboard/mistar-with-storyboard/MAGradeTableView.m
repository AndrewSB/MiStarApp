//
//  MAGradeTableView.m
//  MistarApp
//
//  Created by Andrew Breckenridge on 3/25/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import "MAGradeTableView.h"

@implementation MAGradeTableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MIN(6,6) + 1; //TODO add getNumberOfClasses for people with 7 or 8
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger cellCount = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    return 1136 / (CGFloat)cellCount;
}


- (MAGradeCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MAGradeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if (!cell) {
        cell = [[MAGradeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier" cellForRowAtIndexPath:indexPath];
    }
    // Sets up attributes of each cell
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    QBFlatButton* userStateButton = nil;
    
    NSInteger cellCount = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    
    [self configureCell:cell row:indexPath.row];
    if (indexPath.row == 0) {
        UIView *cellView = cell.contentView;
        userStateButton = [[QBFlatButton alloc] initWithFrame:CGRectMake((cellView.frame.size.width - (80 + 20)), (1136/(cellCount * 4)), 80, ((1136 + (cellCount * cellCount))/(cellCount * 2)))];
        [userStateButton addTarget:self action:@selector(userStateButtonWasPressed)forControlEvents:UIControlEventTouchUpInside];
        userStateButton.faceColor = [UIColor clearColor];
        userStateButton.sideColor = [UIColor clearColor];
        
        userStateButton.radius = 6.0;
        userStateButton.margin = 4.0;
        userStateButton.depth = 0;
        userStateButton.alpha = 1.0;
        
        userStateButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
        [userStateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [userStateButton setTitle:@"Logout" forState:UIControlStateNormal];
        cell.userStateButton = userStateButton;
        [cellView addSubview:userStateButton];
        NSLog(@"went thru magradetableview");
    }
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell row:(NSInteger *)row {
    int rowNumber = row;
}


@end
