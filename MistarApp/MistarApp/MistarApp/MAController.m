//
//  MAController.m
//  MistarApp
//
//  Created by Andrew Breckenridge on 3/23/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import "MAController.h"
#import <LBBlurredImage/UIImageView+LBBlurredImage.h>

@interface MAController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *blurredImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) BOOL loggedIn;

@end

@implementation MAController
@synthesize loggedIn;

- (id)init {
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:0.85f];

    
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    UIImage *background = [UIImage imageNamed:@"bg"];
    
    // Add static image bg
    self.backgroundImageView = [[UIImageView alloc] initWithImage:background];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backgroundImageView];
    
    // Create tableView
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
    self.tableView.pagingEnabled = YES;
    [self.view addSubview:self.tableView];
}

// Make that time *white*
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)userStateButtonWasPressed {
    NSLog(@"User State UIAlert triggered");
    
    if (loggedIn) {
        // Logout
    } else {
        // Login Alert
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login To Zangle"
                                                        message:@"Enter your Zangle information"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Continue", nil];
        
        alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        UITextField *pinTextField = [alert textFieldAtIndex:0];
        UITextField *passwordTextField = [alert textFieldAtIndex:1];
        pinTextField.keyboardType = UIKeyboardTypeNumberPad;
        pinTextField.placeholder = @"Student ID";
        passwordTextField.placeholder = @"Password";
        
        [alert show];
    }
};

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    MAGradeClient *gradeClient = [[MAGradeClient alloc] init];
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Cancel"]) {
        NSLog(@"Client canceled");
    } else if ([title isEqualToString:@"Continue"]) {
        NSString *userPin = [alertView textFieldAtIndex:0].text;
        NSString *userPassword = [alertView textFieldAtIndex:1].text;
        NSLog(@"Client is: %@ with credential: %@", userPin, userPassword);
        
        [gradeClient provideLoginWithPin:userPin password:userPassword];
    }
}

//- (BOOL)userEnteredData {
//    if (_loginField.text.length > 0 && _passwordField.text.length > 0) {
//        NSLog(@"Would have submitted passwd");
//        return TRUE;
//    } else return FALSE;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    
    self.backgroundImageView.frame = bounds;
    self.blurredImageView.frame = bounds;
    self.tableView.frame = bounds;
}


#pragma mark - UITableViewDataSource

// 1 = mistarOverview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return MAX(6,6) + 1; //TODO add getNumberOfClasses for people with 7 or 8
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
        userStateButton = [[QBFlatButton alloc] initWithFrame:CGRectMake((cellView.frame.size.width - (80 + 20)), (self.screenHeight/(cellCount * 4)), 80, ((self.screenHeight + (cellCount * cellCount))/(cellCount * 2)))];
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
    }
        return cell;
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row != 0) {
        // Open progress report
        NSLog(@"Opened progress report");
        
        UIViewController *detailViewControl = [[UIViewController alloc] init];
        
        UITableView *detailTableView = [[MAGradeTableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        detailTableView.backgroundColor = [UIColor clearColor];
        detailTableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
        detailTableView.pagingEnabled = YES;
        
        // Set progress report as the view controller
        [self.navigationController pushViewController:detailViewControl animated:YES];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
        //self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
        detailViewControl.view.backgroundColor = [UIColor whiteColor];

    }
}

#pragma mark - UITableViewDelegate

- (void)configureHeaderCell:(UITableViewCell *)cell title:(NSString *)title {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = nil;
    cell.imageView.image = nil;
}

- (void)configureGradesCell:(UITableViewCell *)cell row:(NSInteger *)row {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    
    MAGradeClient *gradeClient = [[MAGradeClient alloc] init];
    
    cell.imageView.image = nil;
}


- (void)configureCell:(UITableViewCell *)cell row:(NSInteger *)row {
    int rowNumber = row;
    switch (rowNumber) {
        case 0: { // i.e. it's the header
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
            cell.textLabel.text = @"Andrew Breckenridge"; //Replace with name
            cell.detailTextLabel.text = nil;
            cell.imageView.image = nil;
            break;
        }
            
        default: {
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
            cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
            cell.imageView.image = nil;
            
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.detailTextLabel.numberOfLines = 2;
            cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
            
            switch (rowNumber) {
                case 1: {
                    
                    break;
                }
                 
                case 2: {
                    
                    break;
                }
                    
                case 3: {
                    
                    break;
                }
                    
                case 4: {
                    
                    break;
                }
                    
                case 5: {
                    
                    break;
                }
                    
                case 6: {
                    
                    break;
                }
                    
                case 7: {
                    
                    break;
                }
                    
                case 8: {
                    
                    break;
                }
                    
                default: {
                    
                    break;
                }
            }
            break;
        }
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger cellCount = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    return self.screenHeight / (CGFloat)cellCount;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat height = scrollView.bounds.size.height;
    CGFloat position = MAX(scrollView.contentOffset.y, 0.0);
    CGFloat percent = MIN(position / height, 1.0);
    self.blurredImageView.alpha = percent;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
