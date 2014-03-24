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

@property (nonatomic, strong) NSDateFormatter *hourlyFormatter;
@property (nonatomic, strong) NSDateFormatter *dailyFormatter;

@end

@implementation MAController

- (id)init {
    if (self = [super init]) {
        _hourlyFormatter = [[NSDateFormatter alloc] init];
        _hourlyFormatter.dateFormat = @"h a";
        
        _dailyFormatter = [[NSDateFormatter alloc] init];
        _dailyFormatter.dateFormat = @"EEEE";
    }
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
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    // Store screenHeight for later layout
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    UIImage *background = [UIImage imageNamed:@"bg"];
    
    // Add static image bg
    self.backgroundImageView = [[UIImageView alloc] initWithImage:background];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backgroundImageView];
    
    // Add blurred layer to image when tableView goes in front of it
    self.blurredImageView = [[UIImageView alloc] init];
    self.blurredImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.blurredImageView.alpha = 0;
    [self.blurredImageView setImageToBlur:background blurRadius:10 completionBlock:nil];
    [self.view addSubview:self.blurredImageView];
    
    // Create tableView
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
    self.tableView.pagingEnabled = YES;
    [self.view addSubview:self.tableView];
    
    CGRect headerFrame = [UIScreen mainScreen].bounds;
    CGFloat inset = 20; // For padding
    
    CGFloat temperatureHeight = 110;
    CGFloat hiloHeight = 40;
    CGFloat iconHeight = 30;
//    CGFloat mistarHeight = 100;
    
    CGRect hiloFrame = CGRectMake(inset,
                                  headerFrame.size.height - hiloHeight,
                                  headerFrame.size.width - (2 * inset),
                                  hiloHeight);
    
    CGRect temperatureFrame = CGRectMake(inset,
                                         headerFrame.size.height - (temperatureHeight + hiloHeight),
                                         headerFrame.size.width - (2 * inset),
                                         temperatureHeight);
    
    CGRect iconFrame = CGRectMake(inset,
                                  temperatureFrame.origin.y - iconHeight,
                                  iconHeight,
                                  iconHeight);

//    CGRect mistarFrame = CGRectMake((inset / 2),
//                                    220,
//                                    (self.view.bounds.size.width - (4 * inset)),
//                                    mistarHeight);

    
    CGRect conditionsFrame = iconFrame;
    conditionsFrame.size.width = self.view.bounds.size.width - (((2 * inset) + iconHeight) + 10);
    conditionsFrame.origin.x = iconFrame.origin.x + (iconHeight + 10);

    
    
    UIView *header = [[UIView alloc] initWithFrame:headerFrame];
    header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = header;
    
    // bottom left
    UILabel *temperatureLabel = [[UILabel alloc] initWithFrame:temperatureFrame];
    temperatureLabel.backgroundColor = [UIColor clearColor];
    temperatureLabel.textColor = [UIColor whiteColor];
    temperatureLabel.text = @"0°";
    temperatureLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:120];
    [header addSubview:temperatureLabel];
    
    // bottom left
    UILabel *hiloLabel = [[UILabel alloc] initWithFrame:hiloFrame];
    hiloLabel.backgroundColor = [UIColor clearColor];
    hiloLabel.textColor = [UIColor whiteColor];
    hiloLabel.text = @"0° / 0°";
    hiloLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:28];
    [header addSubview:hiloLabel];
 
    // top
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 30)];
    cityLabel.backgroundColor = [UIColor clearColor];
    cityLabel.textColor = [UIColor whiteColor];
    cityLabel.text = @"Loading...";
    cityLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cityLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:cityLabel];
    
    UILabel *conditionsLabel = [[UILabel alloc] initWithFrame:conditionsFrame];
    conditionsLabel.backgroundColor = [UIColor clearColor];
    conditionsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    conditionsLabel.textColor = [UIColor whiteColor];
    [header addSubview:conditionsLabel];
    
    // Add Mistar login fields
//    UILabel *mistarLabel = [[UILabel alloc] initWithFrame:CGRectMake(mistarFrame.origin.x, (mistarFrame.origin.y - (iconHeight + 5)), mistarFrame.size.width, mistarFrame.size.height)];
//    mistarLabel.backgroundColor = [UIColor clearColor];
//    mistarLabel.textColor = [UIColor whiteColor];
//    mistarLabel.text = @"Login To Zangle";
//    mistarLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24];
//    [header addSubview:mistarLabel];
//    
//    _loginField = [[UITextField alloc] initWithFrame:mistarFrame];
//    _loginField.delegate = self;
//    _loginField.backgroundColor = [UIColor clearColor];
//    _loginField.textColor = [UIColor whiteColor];
//    _loginField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
//    _loginField.borderStyle = UITextBorderStyleNone;
//    _loginField.autocorrectionType = UITextAutocorrectionTypeNo;
//    _loginField.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    _loginField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    _loginField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Student ID" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
//    [header addSubview:_loginField];
//    
//    _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(mistarFrame.origin.x, (mistarFrame.origin.y + iconHeight), mistarFrame.size.width, mistarFrame.size.height)];
//    _passwordField.delegate = self;
//    _passwordField.backgroundColor = [UIColor clearColor];
//    _passwordField.textColor = [UIColor whiteColor];
//    _passwordField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
//    _passwordField.borderStyle = UITextBorderStyleNone;
//    _passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
//    _passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    _passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    _passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
//    _passwordField.secureTextEntry = YES;
//    [header addSubview:_passwordField];
    
    
    
    
    // Add weather icons
    // bottom left
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:iconFrame];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    iconView.backgroundColor = [UIColor clearColor];
    [header addSubview:iconView];
    
    
    [[RACObserve([MAManager sharedManager], currentCondition)
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(MACondition *newCondition) {
         temperatureLabel.text = [NSString stringWithFormat:@"%.0f°",newCondition.temperature.floatValue];
         conditionsLabel.text = [newCondition.condition capitalizedString];
         cityLabel.text = [newCondition.locationName capitalizedString];
         iconView.image = [UIImage imageNamed:[newCondition imageName]];
     }];
    
    RAC(hiloLabel, text) = [[RACSignal combineLatest:@[
                                                       RACObserve([MAManager sharedManager], currentCondition.tempHigh),
                                                       RACObserve([MAManager sharedManager], currentCondition.tempLow)]
                                              reduce:^(NSNumber *hi, NSNumber *low) {
                                                  return [NSString  stringWithFormat:@"%.0f° / %.0f°",hi.floatValue,low.floatValue];
                                              }]
                            deliverOn:RACScheduler.mainThreadScheduler];
    
    [[RACObserve([MAManager sharedManager], hourlyForecast)
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(NSArray *newForecast) {
         [self.tableView reloadData];
     }];
    
    [[RACObserve([MAManager sharedManager], dailyForecast)
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(NSArray *newForecast) {
         [self.tableView reloadData];
     }];
    [[MAManager sharedManager] findCurrentLocation];
}

// Make that time *white*
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)loginButtonWasPressed {
    NSLog(@"Login UIAlert triggered");
    //UI Alert
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
    
};

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    MAGradeClient *gradeClient = [[MAGradeClient alloc] init];
    
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Cancel"])
    {
        NSLog(@"Client canceled");
    }
    else if([title isEqualToString:@"Continue"])
    {
        NSString *userPin = [alertView textFieldAtIndex:0].text;
        NSString *userPassword = [alertView textFieldAtIndex:1].text;
        NSLog([NSString stringWithFormat:@"Client is: %@ with credential: %@", userPin, userPassword]);
        
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

// 3 sections, (1 = mistarOverview) (2 = hourlyForecast) (3 = dailyForecast)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 12) {
        return MAX(6,6) + 1; //TODO add getNumberOfClasses for people with 7 or 8 classes
    } else if (section == 0) {
        return MIN([[MAManager sharedManager].hourlyForecast count], 6) + 1;
    } else {
        return MIN([[MAManager sharedManager].dailyForecast count], 6) + 1;
    }

}

- (MAGradeCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    MAGradeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
//    // Redefine layout variables in method from `viewDidLoad`
    CGFloat inset = 20; // For padding
    
    
    if (! cell) {
        cell = [[MAGradeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier cellForRowAtIndexPath:indexPath];
    }
    

    // Sets up attributes of each cell
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    QBFlatButton* loginButton = nil;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self configureHeaderCell:cell title:@"Grades"];
                
                UIView *cellView = cell.contentView;
                loginButton = [[QBFlatButton alloc] initWithFrame:CGRectMake((cellView.frame.size.width - (80 + inset)), 18, 80, (cellView.frame.size.height -(cellView.frame.size.height/2)))];
                [loginButton addTarget:self action:@selector(loginButtonWasPressed)forControlEvents:UIControlEventTouchUpInside];
                loginButton.faceColor = [UIColor grayColor];
                loginButton.sideColor = [UIColor clearColor];
                
                loginButton.radius = 6.0;
                loginButton.margin = 4.0;
                loginButton.depth = 3.0;
                loginButton.alpha = 0.3;
                
                loginButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
                [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [loginButton setTitle:@"Login" forState:UIControlStateNormal];
                [cellView addSubview:loginButton];
        } else {
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            MAGradeClient *grade = [[MAGradeClient alloc] init];
            [self configureGradesCell:cell grade:grade];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self configureHeaderCell:cell title:@"Hourly Forecast"];
        }
        else {
            // Get hourly weather and configure using method
            MACondition *weather = [MAManager sharedManager].hourlyForecast[indexPath.row - 1];
            [self configureHourlyCell:cell weather:weather];
        }
    }
    else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self configureHeaderCell:cell title:@"Daily Forecast"];
        }
        else if (indexPath.section == 2) {
            // Get daily weather and configure using method
            MACondition *weather = [MAManager sharedManager].dailyForecast[indexPath.row - 1];
            [self configureDailyCell:cell weather:weather];
        }
    }

    return cell;
}

#pragma mark - UITableViewDelegate


- (void)configureHeaderCell:(UITableViewCell *)cell title:(NSString *)title {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = @"";
    cell.imageView.image = nil;
}

- (void)configureGradesCell:(UITableViewCell *)cell grade:(MAGradeClient *)grade {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    
    cell.textLabel.text = @"class";
    cell.detailTextLabel.text = @"A+";
    
    cell.imageView.image = nil;
}


- (void)configureHourlyCell:(UITableViewCell *)cell weather:(MACondition *)weather {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    cell.textLabel.text = [self.hourlyFormatter stringFromDate:weather.date];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f°",weather.temperature.floatValue];
    cell.imageView.image = [UIImage imageNamed:[weather imageName]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
}


- (void)configureDailyCell:(UITableViewCell *)cell weather:(MACondition *)weather {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    cell.textLabel.text = [self.dailyFormatter stringFromDate:weather.date];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f° / %.0f°",
                                 weather.tempHigh.floatValue,
                                 weather.tempLow.floatValue];
    cell.imageView.image = [UIImage imageNamed:[weather imageName]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger cellCount = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    return self.screenHeight / (CGFloat)cellCount;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 1
    CGFloat height = scrollView.bounds.size.height;
    CGFloat position = MAX(scrollView.contentOffset.y, 0.0);
    // 2
    CGFloat percent = MIN(position / height, 1.0);
    // 3
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
