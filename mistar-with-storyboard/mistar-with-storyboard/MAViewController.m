//
//  MAViewController.m
//  mistar-with-storyboard
//
//  Created by Andrew Breckenridge on 4/17/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "MAViewController.h"

@interface MAViewController () <
    MFMailComposeViewControllerDelegate,
    MFMessageComposeViewControllerDelegate,
    UINavigationControllerDelegate
>

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *blurredImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) BOOL loggedIn;
@property (nonatomic, assign) int *loginFailCount;

@end

@implementation MAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"eyyyy im here");

    self.loggedIn = [[self displayContent] boolValue];
    
    NSLog(@"login status: %d", self.loggedIn);
    
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

-(void) writeToTextFileWithContent:(NSString *)contentString{
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/config.txt",
                          documentsDirectory];
    //save content to the documents directory
    [contentString writeToFile:fileName
                    atomically:YES
                      encoding:NSStringEncodingConversionAllowLossy
                         error:nil];
}

-(NSString *) displayContent{
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/config.txt",
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    return content;
    
}


// Make that time *white*
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)userStateButtonWasPressed {
    NSLog(@"User State UIAlert triggered");
    
    if (self.loggedIn) {
        NSLog(@"log out here");
        [self writeToTextFileWithContent:@"0"];
        [self.tableView reloadData];
        NSLog(@"%@", [self displayContent]);
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
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Cancel"]) {
        NSLog(@"Client canceled");
    } else if ([title isEqualToString:@"Continue"]) {
        NSString *userPin = [alertView textFieldAtIndex:0].text;
        NSString *userPassword = [alertView textFieldAtIndex:1].text;
        NSLog(@"from vc Client is: %@ with credential: %@", userPin, userPassword);
        [self loginToMistarWithPin:userPin password:userPassword success:^{
            NSLog(@"successpoint from vc");
        } failure:^{
            NSLog(@"Some error in logging into Mistar and getting the UID");
        }];
        NSLog(@"returnpoint");
;        NSLog(@"gradeCliented");
    }
    
    if ([title isEqualToString:@"Text Andrew"]) {
        NSLog(@"Text Andrew hit");
        if ([MFMessageComposeViewController canSendText])
        {
            MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
            picker.messageComposeDelegate = self;
                
                // You can specify one or more preconfigured recipients.  The user has
                // the option to remove or add recipients from the message composer view
                // controller.
                /* picker.recipients = @[@"Phone number here"]; */
                
                // You can specify the initial message text that will appear in the message
                // composer view controller.
            picker.body = @"Hello from California!";
                
            [self presentViewController:picker animated:YES completion:NULL];
        } else {
            UIAlertView *noSMS = [[UIAlertView alloc] initWithTitle:@"Device not configured for iMessage" message:@"You can try emailing me at asbreckenridge@me.com" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [noSMS show];
        }
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    NSLog(@"Dismissing SMS view");
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)loginFailedAlertView {
    if (self.loginFailCount < 1) {
        UIAlertView *loginFailed = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Your username or password was incorrect, try logging in again" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [loginFailed show];
    } else {
        UIAlertView *loginFailed = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Your username or password was incorrect, you seem to be having problems logging in. Text me and I'll try and help ASAP" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Text Andrew", nil];
        [loginFailed show];
    }
    self.loginFailCount++;
    return;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    
    self.backgroundImageView.frame = bounds;
    self.blurredImageView.frame = bounds;
    self.tableView.frame = bounds;
}


#pragma mark - UITableViewDataSource

// mistarOverview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MIN(6,6) + 1; //TODO add getNumberOfClasses for people with 7 or 8
}


- (MAGradeCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.loggedIn = [[self displayContent] boolValue];
    NSLog(@"cellforrowatindexpath");
    
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
        
        if (self.loggedIn) {
            
            
            cell.textLabel.text = @"Andrew Breckenridge";
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];

            [userStateButton setTitle:@"Logout" forState:UIControlStateNormal];
        } else {
            [userStateButton setTitle:@"Login" forState:UIControlStateNormal];
            cell.textLabel.text = @"";
        }
        cell.userStateButton = userStateButton;
        [cellView addSubview:userStateButton];
    }
    
    
    
    return cell;
}

-(MAGradeCell *)fillCellWithRow:(NSNumber *)row {
    MAGradeCell *cell = [[MAGradeCell alloc] init];
    
    if (!self.loggedIn) {
        return cell;
    } else {
        //cell.textLabel.text =
        //cell.detailTextLabel.text =
        //REPLACE
        
        return cell;
    }
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
}

- (void)configureGradesCell:(UITableViewCell *)cell row:(NSInteger *)row {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    
    cell.imageView.image = nil;
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


#pragma mark - GradeReport

- (NSString *)percentEscapeString:(NSString *)string {
    NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)string,
                                                                                 (CFStringRef)@" ",
                                                                                 (CFStringRef)@":/?@!$&'()*+,;=",
                                                                                 kCFStringEncodingUTF8));
    return [result stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

- (NSArray *)loginToMistarWithPin:(NSString *)pin password:(NSString *)password success:(void (^)(void))successHandler failure:(void (^)(void))failureHandler{
    _cancel = false;
    
    //Create and send request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://mistar.oakland.k12.mi.us/novi/StudentPortal/Home/Login"]];
    
    __block NSArray *myResult = nil; //set Returner
    
    [request setHTTPMethod:@"POST"];
    
    NSString *postString = [NSString stringWithFormat:@"Pin=%@&Password=%@",
                            [self percentEscapeString:pin],
                            [self percentEscapeString:password]];
    NSData * postBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postBody];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        // do whatever with the data...and errors
        if ([data length] > 0 && error == nil) {
            NSError *parseError;
            NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSString *loggedInPage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (responseJSON) {
                NSLog(@"Returned as JSON, Good. %@", loggedInPage);
                
            } else {;
                NSLog(@"Response was not JSON (from login), it was = %@", loggedInPage);
            }
            
            if (![loggedInPage  isEqual:@"{\"msg\":\"\",\"valid\":\"1\"}"]) {
                NSLog(@"Mistar login error, returning NO");
                _cancel = true;
                NSLog(@"call login error here");
                [self loginFailedAlertView];
            } else {
                
                if (!_cancel) {
                    ///////////
                    NSMutableURLRequest *requestHome = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://mistar.oakland.k12.mi.us/novi/StudentPortal/Home/PortalMainPage"]];
                    [requestHome setHTTPMethod:@"GET"];            [NSURLConnection sendAsynchronousRequest:requestHome queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *homeResponse, NSData *homeData, NSError *homeError) {
                        // do whatever with the data...and errors
                        if ([homeData length] > 0 && homeError == nil) {
                            NSString *regexedString = [self userIDRegex:[[NSString alloc] initWithData:homeData encoding:NSUTF8StringEncoding ]];
                            NSString *userID = [self onlyNumbersRegex:regexedString];
                            NSLog(@"UserID is %@", userID);
                            
                            if (userID) {
                                // Request AJAX from mistar
                                NSMutableURLRequest *setStudentID = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://mistar.oakland.k12.mi.us/novi/StudentPortal/StudentBanner/SetStudentBanner/%@" , userID]]];
                                [setStudentID setHTTPMethod:@"GET"];
                                
                                [NSURLConnection sendAsynchronousRequest:setStudentID queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *studentIDResponse, NSData *studentIDData, NSError *studentIDError) {
                                    
                                    
                                    if ([studentIDData length] > 0 && studentIDError == nil) {
                                        //Get gradePage
                                        
                                        NSMutableURLRequest *requestGrades = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://mistar.oakland.k12.mi.us/novi/StudentPortal/Home/LoadProfileData/Assignments"]]; // Need to AJAXLoad this number (or something, idk)
                                        [requestGrades setHTTPMethod:@"GET"];
                                        [NSURLConnection sendAsynchronousRequest:requestGrades queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *gradeResponse, NSData *gradeData, NSError *gradeError) {
                                            
                                            if ([gradeData length] > 0 && gradeError == nil) {
                                                //the HTML response is = NSLog(@"the html%@",[[NSString alloc] initWithData:gradeData encoding:NSUTF8StringEncoding]);
                                                MAGradeParser *gradeParser = [[MAGradeParser alloc] init];
                                                myResult = [gradeParser parseWithData:gradeData];
                                                NSLog(@"after myResult");
                                                [self writeToTextFileWithContent:@"1"];
                                                [self viewDidLoad];
                                                
                                                
                                            } else {
                                                NSLog(@"grade Error = %@", gradeError);
                                            }
                                        }];
                                    } else {
                                        NSLog(@"Error setting studentID = %@", studentIDError);
                                    }
                                }];
                            } else {
                                NSLog(@"Error: parse error = %@", homeError);
                            }
                        } else {
                            NSLog(@"error: home error: %@", homeError);
                        }
                    }];
                    ///////
                }
            }
        } else {
            NSLog(@"Couldn't log in");
        }
    }];
    return myResult;
}

// Parsers
- (NSString *)onlyNumbersRegex:(NSString *)string {
    NSString *regexStr = @"\\d\\d\\d\\d\\d\\d\\d\\d";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:&error];
    
    __block NSString *myResult = nil; //Instanciate returner
    
    //Enumerate all matches
    if ((regex==nil) && (error!=nil)){
        return [NSString stringWithFormat:@"Regex failed for url: %@, error was: %@", string, error];
    } else {
        [regex enumerateMatchesInString:string
                                options:0
                                  range:NSMakeRange(0, [string length])
                             usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop){
                                 if (result!=nil){
                                     //Iterate ranges
                                     for (int i=0; i<[result numberOfRanges]; i++) {
                                         NSRange range = [result rangeAtIndex:i];
                                         //NSLog(@"%ld,%ld group #%d %@", range.location, range.length, i, (range.length==0 ? @"--" : [string substringWithRange:range]));
                                         myResult = [string substringWithRange:range];
                                         *stop = YES;
                                     }
                                 } else {
                                     myResult = @"Regex failed";
                                     *stop = YES;
                                 }
                             }];
    }
    return myResult;
}

- (NSString *)userIDRegex:(NSString *)string {
    
    //Create a regular expression
    NSString *regexStr = @"tr id=\"[0-9]*\"";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:&error];
    
    __block NSString *myResult = nil; //Instanciate returner
    
    //Enumerate all matches
    if ((regex==nil) && (error!=nil)){
        return [NSString stringWithFormat:@"Regex failed for url: %@, error was: %@", string, error];
    } else {
        [regex enumerateMatchesInString:string
                                options:0
                                  range:NSMakeRange(0, [string length])
                             usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop){
                                 if (result!=nil){
                                     //Iterate ranges
                                     for (int i=0; i<[result numberOfRanges]; i++) {
                                         NSRange range = [result rangeAtIndex:i];
                                         //NSLog(@"%ld,%ld group #%d %@", range.location, range.length, i, (range.length==0 ? @"--" : [string substringWithRange:range]));
                                         myResult = [string substringWithRange:range];
                                         *stop = YES;
                                     }
                                 } else {
                                     myResult = @"Regex failed";
                                     *stop = YES;
                                 }
                             }];
    }
    return myResult;
}


@end
