//
//  MAProgressReportViewController.m
//  mistar-with-storyboard
//
//  Created by Andrew Breckenridge on 4/27/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import "MAProgressReportViewController.h"

@interface MAProgressReportViewController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation MAProgressReportViewController


- (void)viewDidLoad
{
    NSLog(@"Opened progress report");
    
    UIViewController *detailViewControl = [[UIViewController alloc] init];
    
    UITableView *detailTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    detailTableView.backgroundColor = [UIColor clearColor];
    detailTableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
    detailTableView.pagingEnabled = YES;
    
    
    detailTableView.delegate = self;
    detailTableView.dataSource = self;
    
    // Set progress report as the view controller
    [self.navigationController pushViewController:detailViewControl animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    detailViewControl.view.backgroundColor = [UIColor blackColor];
    
    
    UIImage *background = [UIImage imageNamed:@"bg"];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:background];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [detailViewControl.view addSubview:backgroundImageView];
    [detailViewControl.view addSubview:detailTableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"resuseIdentifier"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    cell.textLabel.text = [[self getAssignmentsFromFile] objectAtIndex:(NSUInteger)indexPath.row-1];
    
    return cell;
}

- (NSArray *)getAssignmentsFromFile {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"/userdata.txt"];
    
    NSDictionary *contentDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    NSArray *assignments = [contentDict objectForKey:@"assignments"];
    
    return  assignments;
}

@end
