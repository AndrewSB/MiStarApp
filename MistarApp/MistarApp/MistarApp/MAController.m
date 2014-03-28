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
        pinTextField.keyboardAppearance = UIKeyboardAppearanceDark;
        passwordTextField.keyboardAppearance = UIKeyboardAppearanceDark;
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
        if ([userPin isEqualToString:@"2345"]) {
                NSLog(@"Outer");
                UIAlertView *loginFailed = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Your username or password was incorrect, try logging in again" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [loginFailed show];
            return;
        }
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
        return MIN(6,6) + 1; //TODO add getNumberOfClasses for people with 7 or 8
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

    [self configureCell:cell row:indexPath.row section:indexPath.section];
    
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
        
        UITableView *detailTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        detailTableView.backgroundColor = [UIColor clearColor];
        detailTableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
        detailTableView.pagingEnabled = YES;
        
        
        detailTableView.delegate = self;
        detailTableView.dataSource = self;
        
        MAGradeCell *cell = [[MAGradeCell alloc] init];
        int row = -indexPath.row;
        int section = 2;
        
        [self configureCell:(UITableView *)detailTableView row:row section:2];
        
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
}

#pragma mark - UITableViewDelegate

- (void)configureHeaderCell:(UITableViewCell *)cell title:(NSString *)title {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = nil;
    cell.imageView.image = nil;
}


- (void)configureDetailCell:(UITableViewCell *)cell row:(NSInteger *)row {
    cell.imageView.image = nil;
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
    int rowNumber = row;
    switch (rowNumber) {
        case 0:{
            cell.textLabel.text = @"2/4     Signed Course Procedure";
            cell.detailTextLabel.text = @"5\n5";
            cell.imageView.image = nil;
            break;
        }
        case 1:{
            cell.textLabel.text = @"2/11    QUIZ Act One & Drama Terms";
            cell.detailTextLabel.text = @"22\n29";
            cell.imageView.image = nil;
            break;
        }
        case 2:{
            cell.textLabel.text = @"2/13    Act III Writes";
            cell.detailTextLabel.text = @"15\n16";
            cell.imageView.image = nil;
            break;
        }
        case 3:{
            cell.textLabel.text = @"3/6    Movie Review-Crucible";
            cell.detailTextLabel.text = @"10\n10";
            cell.imageView.image = nil;
            break;
        }
        case 4:{
            cell.textLabel.text = @"2/20    Discussion-The Crucible";
            cell.detailTextLabel.text = @"15\n15";
            cell.imageView.image = nil;
            break;
        }
            
        default:{
            cell.textLabel.text = @"2/13    Act III Writes";
            cell.detailTextLabel.text = @"15\n16";
            cell.imageView.image = nil;
            break;
        }
    }
    
}

- (void)configureGradesCell:(UITableViewCell *)cell row:(NSInteger *)row {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    
    
    cell.imageView.image = nil;
}


- (void)configureCell:(UITableViewCell *)cell row:(NSInteger *)row section:(NSInteger *)section {
    int rowNumber = row;
    int sectionNumber = section;
    
    if (section == 0) {
        if (row == -1) {
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
            cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
            cell.imageView.image = nil;
            
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.detailTextLabel.numberOfLines = 2;
            cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
            
            cell.textLabel.text = @"SMD"; //Replace with name
            cell.detailTextLabel.text = @"A-\n90.2";
            cell.imageView.image = nil;
        } else if (row == 0) {
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
            cell.textLabel.text = @"Andrew Breckenridge"; //Replace with name
            cell.detailTextLabel.text = nil;
            cell.imageView.image = nil;
        } else if (row == 1) {
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
            cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
            cell.imageView.image = nil;
            
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.detailTextLabel.numberOfLines = 2;
            cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
            
            cell.textLabel.text = @"IB Math SL 2"; //Replace with name
            cell.detailTextLabel.text = @"A-\n90.2";
            cell.imageView.image = nil;

        } else if (row == 2) {
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
            cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
            cell.imageView.image = nil;
            
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.detailTextLabel.numberOfLines = 2;
            cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
            
            cell.textLabel.text = @"IB 20thCen Wrld Hist HL2"; //Replace with name
            cell.detailTextLabel.text = @"B\n94.4";
            cell.imageView.image = nil;

        } else if (row == 3) {
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
            cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
            cell.imageView.image = nil;
            
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.detailTextLabel.numberOfLines = 2;
            cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
            
            cell.textLabel.text = @"IB French SL 2"; //Replace with name
            cell.detailTextLabel.text = @"A\n94.2";
            cell.imageView.image = nil;
            
        } else if (row == 4) {
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
            cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
            cell.imageView.image = nil;
            
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.detailTextLabel.numberOfLines = 2;
            cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
            
            cell.textLabel.text = @"AP Physics C: Elec & Mag"; //Replace with name
            cell.detailTextLabel.text = @"A-\n80.2";
            cell.imageView.image = nil;
            
        } else if (row == 5) {
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
            cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
            cell.imageView.image = nil;
            
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.detailTextLabel.numberOfLines = 2;
            cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
            
            cell.textLabel.text = @"IB Computer Science HL 2"; //Replace with name
            cell.detailTextLabel.text = @"A\n95.2";
            cell.imageView.image = nil;
            
        } else if (row == 6) {
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
            cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
            cell.imageView.image = nil;
            
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.detailTextLabel.numberOfLines = 2;
            cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
            
            cell.textLabel.text = @"IB English HL 2"; //Replace with name
            cell.detailTextLabel.text = @"A\n93.6";
            cell.imageView.image = nil;
            
        }
    } else if (section == 1) {
        if (row == 0) {
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
            cell.textLabel.text = @"Suck Breckenridge"; //Replace with name
            cell.detailTextLabel.text = nil;
            cell.imageView.image = nil;
        } else if (row == 1) {
            
        } else if (row == 2) {
            
        } else if (row == 3) {
            
        } else if (row == 4) {
            
        } else if (row == 5) {
            
        } else if (row == 6) {
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
            cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
            cell.imageView.image = nil;
            
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.detailTextLabel.numberOfLines = 2;
            cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
            
            cell.textLabel.text = @"IB Englishe HL 2"; //Replace with name
            cell.detailTextLabel.text = @"A\n93.6";
            cell.imageView.image = nil;
        }
    } else if (section == 2) {
        if (row == 0) {
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
            cell.textLabel.text = @"Lol Breckenridge"; //Replace with name
            cell.detailTextLabel.text = nil;
            cell.imageView.image = nil;
        } else if (row == 1) {
            
        } else if (row == 2) {
            
        } else if (row == 3) {
            
        } else if (row == 4) {
            
        } else if (row == 5) {
            
        } else if (row == 6) {
            
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
