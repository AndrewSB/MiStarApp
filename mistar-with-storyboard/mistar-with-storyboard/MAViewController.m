//
//  MAViewController.m
//  mistar-with-storyboard
//
//  Created by Andrew Breckenridge on 4/17/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "MAViewController.h"

@interface MAViewController () <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *blurredImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat screenHeight;

@property UIScrollView *scrollView;
@property UIView *borderView;
@property UIView *resizedView;
@property float borderSize;

@property (nonatomic, assign) BOOL loggedIn;
@property (nonatomic, assign) int *loginFailCount;

@property NSString *userNAME;

@property FBShimmeringView *shimmeringView;

@end

@implementation MAViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    //NSLog(@"eyyyy im here");
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]) {
        // app already launched
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"This app is in BETA"
                                                        message:@"Our team will be providing extensive support, send us anything: bug reports, feature improvements, like a joke, whatever.\n\nWe  plan to keep working on this app and have it 100% stable and out of beta by the end of this school year. We'll be adding a ton of other features, like being able to see all your assignments and adding support for other schools that use Mistar as soon as we can.\n\nThe app is open sourced, contact me for more information."
                                                       delegate:self
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:@"Never show again", @"Text Andrew", nil];

        [alert show];

    }
    
    
    self.loggedIn = [[self displayContent] boolValue];
    
    //NSLog(@"login status: %d", self.loggedIn);
    
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
    
    
    
    self.borderSize = 50;
    
    self.borderView = [[UIView alloc] initWithFrame:CGRectMake(320/2-self.borderSize/2, -(self.borderSize+10), self.borderSize, self.borderSize)];
    self.borderView.layer.masksToBounds = YES;
    self.borderView.layer.cornerRadius = self.borderView.frame.size.width/2;;
    self.borderView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.borderView.layer.borderWidth = 3;
    self.borderView.backgroundColor = [UIColor clearColor];
    [self.tableView addSubview:self.borderView];
    
    self.resizedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.borderSize, self.borderSize)];
    self.resizedView.layer.masksToBounds = YES;
    self.resizedView.layer.cornerRadius = self.resizedView.frame.size.width/2;;
    self.resizedView.backgroundColor = [UIColor whiteColor];
    [self.borderView addSubview:self.resizedView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    
    self.backgroundImageView.frame = bounds;
    self.blurredImageView.frame = bounds;
    self.tableView.frame = bounds;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - UIAlert methods

- (void)userStateButtonWasPressed {
    //NSLog(@"User State UIAlert triggered");
    
    if (self.loggedIn) {
        UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"Log out?" message:@"This will also quit the app" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Logout", nil];
        [logoutAlert show];
        //NSLog(@"%@", [self displayContent]);
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
        //NSLog(@"Client canceled");
    } else if ([title isEqualToString:@"Continue"]) {
        NSString *userPin = [alertView textFieldAtIndex:0].text;
        NSString *userPassword = [alertView textFieldAtIndex:1].text;
        //NSLog(@"from vc Client is: %@ with credential: %@", userPin, userPassword);
        [self writeDictToFileWithContent:[[NSDictionary alloc] init]];
        
        //Easter egg and test account
        if ([userPin isEqualToString:@"6969"]) {
            
            NSArray *classes = [[NSArray alloc] initWithObjects:@"Math", @"English", @"History", @"Social Studies", @"Science", @"Language", nil];
            NSArray *grades = [[NSArray alloc] initWithObjects:[[NSDictionary alloc] initWithObjectsAndKeys:@"A", @"grade", @"94.4%", @"percents", nil], [[NSDictionary alloc] initWithObjectsAndKeys:@"A-", @"grade", @"91.4%", @"percents", nil], [[NSDictionary alloc] initWithObjectsAndKeys:@"A+", @"grade", @"99.4%", @"percents", nil], [[NSDictionary alloc] initWithObjectsAndKeys:@"B+", @"grade", @"89.4%", @"percents", nil], [[NSDictionary alloc] initWithObjectsAndKeys:@"A", @"grade", @"96.4%", @"percents", nil], [[NSDictionary alloc] initWithObjectsAndKeys:@"A", @"grade", @"97.2%", @"percents", nil], nil];
            
            NSArray *teachers = [[NSArray alloc] initWithObjects:[[NSDictionary alloc] initWithObjectsAndKeys:@"A", @"Name", @"91.4%", @"Email", nil], nil];
            
            NSDictionary *easterEggDict = [[NSDictionary alloc] initWithObjectsAndKeys:classes, @"classes", grades, @"grades", teachers, @"teachers", nil];
            
            
            [self writeDictToFileWithContent:easterEggDict];
            [self writeToTextFileWithContent:[NSString stringWithFormat:@"1"]];
            [self viewDidLoad];
            self.userNAME = @"John Appleseed";
            [self writeNameToFileWithContent:self.userNAME];
        } else {
            [self loginToMistarWithPin:userPin password:userPassword];
        }
        
        
        //NSLog(@"returnpoint");
;       //NSLog(@"gradeCliented");
    }
    
    if ([title isEqualToString:@"Text Andrew"] || [title isEqualToString:@"Message Andrew"] || [title isEqualToString:@"Contact Developer"]) {
        //NSLog(@"Text Andrew hit");
        if ([MFMessageComposeViewController canSendText])
        {
            MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
            picker.messageComposeDelegate = self;
            
            picker.recipients = @[@"2483456497"];
                
                // You can specify one or more preconfigured recipients.  The user has
                // the option to remove or add recipients from the message composer view
                // controller.
                /* picker.recipients = @[@"Phone number here"]; */
                
                // You can specify the initial message text that will appear in the message
                // composer view controller.
            picker.body = @"Hey Andrew, I was using your Zangle app and I was having problems with/ think you should _____";
                
            [self presentViewController:picker animated:YES completion:NULL];
        } else {
            UIAlertView *noSMS = [[UIAlertView alloc] initWithTitle:@"Device not configured for iMessage" message:@"You can try emailing me at asbreckenridge@me.com" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [noSMS show];
        }
    }
    
    if ([title isEqualToString:@"Never show again"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if ([title isEqualToString:@"Logout"]) {
        //NSLog(@"log out here");
        [self writeToTextFileWithContent:@"0"];
        [self writeDictToFileWithContent:[[NSDictionary alloc] init]];
        [self.tableView reloadData];
        exit(0);
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    //NSLog(@"Dismissing SMS view");
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)loginFailedAlertView {
    [SVProgressHUD dismiss];
    [self writeToTextFileWithContent:@"0"];
    self.loggedIn = NO;
    UIAlertView *loginFailed = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Couldn't log in, check your usernamame and password. If you seem to be having problems with the app, text me and I'll try help" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Contact Developer", nil];
        [loginFailed show];
    return;
}


#pragma mark - IO methods

- (void)writeToTextFileWithContent:(NSString *)contentString{
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

- (NSString *)displayContent {
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/config.txt", documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    return content;
    
}

- (NSArray *)getPinAndPass {
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/config.txt", documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    
    if (content == nil) {
        //NSLog(@"content was nil");
        return nil;
    }
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    NSString *toFind = @" ";
    NSRange searchRange = NSMakeRange(0, [content length]);
    do {
        // Search for next occurrence
        NSRange range = [content rangeOfString:toFind options:0 range:searchRange];
        if (range.location != NSNotFound) {
            // If found, range contains the range of the current iteration
            //NSLog(@"found %@", [content substringWithRange:range]);
            
            [arr addObject:[NSNumber numberWithInt:(int)range.location]];
            
            // Reset search range for next attempt to start after the current found range
            searchRange.location = range.location + range.length;
            searchRange.length = [content length] - searchRange.location;
        } else {
            // If we didn't find it, we have no more occurrences
            break;
        }
    } while (1);
    
    [arr insertObject:[content substringWithRange:NSMakeRange([arr[0] intValue]+1, [arr[1] intValue] - 1 - [arr[0] intValue])] atIndex:0];
    [arr insertObject:[content substringWithRange:NSMakeRange([arr[2] intValue]+1, [content length] - 1 - [arr[2] intValue])] atIndex:1];
    [arr removeLastObject];
    [arr removeLastObject];
    
    for (NSString *strn in arr) {
        //NSLog(@"aaa%@", strn);
    }
    
    return [arr mutableCopy];
}

- (void)writeDictToFileWithContent:(NSDictionary *)contentDict {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"/userdata.txt"];
    
    
    [contentDict writeToFile:filePath atomically:YES];

}

- (NSDictionary *)readFromDict {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"/userdata.txt"];
    
    NSDictionary *contentDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    return contentDict;
}

- (void)writeNameToFileWithContent:(NSString *)name {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"/username.txt"];
    
    
    [name writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];

}

- (NSString *)getUserNAME {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"/username.txt"];
    
    NSString *userNAME = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    self.userNAME = userNAME;
    return userNAME;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[[self readFromDict] objectForKey:@"grades"] count]) {
        return [[[self readFromDict] objectForKey:@"grades"] count] + 1;
    } else {
        return 7;
    }
    
}

- (MAGradeCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.loggedIn = [[self displayContent] boolValue];
    
    MAGradeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    
    if (!cell) {
        cell = [[MAGradeCell alloc] initWithReuseID:@"CellIdentifier" cellForRowAtIndexPath:indexPath];
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
        
        userStateButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        [userStateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        
        
        if (self.loggedIn) {
            cell.textLabel.text = [[self readFromDict] objectForKey:@"Name"];
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];

            [userStateButton setTitle:@"Logout" forState:UIControlStateNormal];
            cell.textLabel.text = [self getUserNAME];
        } else {
            [userStateButton setTitle:@"Login" forState:UIControlStateNormal];
            cell.textLabel.text = @"";
        }
        cell.userStateButton = userStateButton;
        [cellView addSubview:userStateButton];
    } else {
        cell = [self fillCellWithRow:(NSInteger *)(indexPath.row-1)];
    }
    
    
    
    return cell;
}

- (MAGradeCell *)fillCellWithRow:(NSInteger *)row {
    MAGradeCell *cell = [[MAGradeCell alloc] initWithReuseID:@"CellIdentifier" cellForRowAtIndexPath:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    if (!self.loggedIn) {
        return cell;
    } else {
        NSDictionary *userData = [self readFromDict];
        
        NSArray *classes = [userData objectForKey:@"classes"];
        NSArray *grades = [userData objectForKey:@"grades"];
        
        
        if ([grades count] > (NSUInteger)row) {
            cell.textLabel.text = [classes objectAtIndex:(NSUInteger)row];
            
            cell.detailTextLabel.numberOfLines = 2;
            cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
            if ([grades objectAtIndex:(NSUInteger)row] && [grades objectAtIndex:(NSUInteger)row]) {
                NSString *letterGrade = [[grades objectAtIndex:(NSUInteger)row] objectForKey:@"grade"];
                NSString *percentGrade = [[grades objectAtIndex:(NSUInteger)row] objectForKey:@"percents"];
                
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@     \n%@", letterGrade, percentGrade];
                //[cell.detailTextLabel sizeToFit];
                
                if ([percentGrade isEqualToString:@" "] || [percentGrade isEqualToString:@""]) {
                    //NSLog(@"righted %@.", cell.detailTextLabel.text);
                }
            }
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row != 0) {
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        //MAProgressReportViewController *progressReport = [[MAProgressReportViewController alloc] init];
                //the popover will be presented from the  view
        //NSLog(@"Opened progress report with class name %@, number %ld", selectedCell.textLabel.text, (long)indexPath.row);
    }
}


#pragma mark - UITableViewDelegate

- (void)configureHeaderCell:(UITableViewCell *)cell title:(NSString *)title {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = nil;
    cell.imageView.image = nil;
}

- (void)configureGradesCell:(UITableViewCell *)cell row:(NSInteger *)row {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    
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
    
    CGFloat o = -scrollView.contentOffset.y*.7;
    self.resizedView.frame = CGRectMake(o, o, self.borderSize-2*o, self.borderSize-2*o);
    self.resizedView.layer.cornerRadius = self.resizedView.frame.size.width/2;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)sv willDecelerate:(BOOL)decelerate {
    
    CGFloat o = -sv.contentOffset.y*.7;
    if (o>=50) {
        
        [UIView animateWithDuration:.5 animations:^{
            self.borderView.frame = CGRectMake(0, -195, 320, 320);
            self.resizedView.frame = CGRectMake(0, 0, 320, 320);
        }];
        [UIView animateWithDuration:.3 animations:^{
            self.borderView.alpha = 0;
        }];
        
        [self refreshMistar];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.borderView.frame = CGRectMake(320/2-self.borderSize/2, -(self.borderSize+10), self.borderSize, self.borderSize);
    self.resizedView.frame = CGRectMake(0, 0, 50, 50);
    self.borderView.alpha = 1;
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

- (NSDictionary *)loginToMistarWithPin:(NSString *)pin password:(NSString *)password {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    //NSLog(@"logging in");
    _cancel = false;
    __block NSDictionary *myDictResult = nil; //set Returner
    [SVProgressHUD show];
    
    //Create and send request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://mistar.oakland.k12.mi.us/novi/StudentPortal/Home/Login"]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
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
                //NSLog(@"Returned as JSON, Good. %@", loggedInPage);
                
            } else {;
                //NSLog(@"Response was not JSON (from login), it was = %@", loggedInPage);
            }
            
            if (![loggedInPage  isEqual:@"{\"msg\":\"\",\"valid\":\"1\"}"]) {
                //NSLog(@"Mistar login error, returning NO");
                _cancel = true;
                //NSLog(@"call login error here");
                [self loginFailedAlertView];
            } else {
                
                if (!_cancel) {
                    ///////////
                    NSMutableURLRequest *requestHome = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://mistar.oakland.k12.mi.us/novi/StudentPortal/Home/PortalMainPage"]];
                    [requestHome setHTTPMethod:@"GET"];
                    [requestHome setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
                    
                    [NSURLConnection sendAsynchronousRequest:requestHome queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *homeResponse, NSData *homeData, NSError *homeError) {
                        // do whatever with the data...and errors
                        if ([homeData length] > 0 && homeError == nil) {
                            NSString *homepageString = [[NSString alloc] initWithData:homeData encoding:NSUTF8StringEncoding];
                            NSString *regexStr = @"l>&nbsp;.*";
                            NSError *error = nil;
                            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:&error];
                            
                            __block NSString *myResult = nil; //Instanciate returner
                            NSString *userID;
                            //Enumerate all matches
                            if (!((regex==nil) && (error!=nil))){
                                [regex enumerateMatchesInString:homepageString
                                                        options:0
                                                          range:NSMakeRange(0, [homepageString length])
                                                     usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop){
                                                         if (result!=nil){
                                                             //Iterate ranges
                                                             for (int i=0; i<[result numberOfRanges]; i++) {
                                                                 NSRange range = [result rangeAtIndex:i];
                                                                 myResult = [homepageString substringWithRange:range];
                                                                 *stop = YES;
                                                             }
                                                         } else {
                                                             myResult = @"Regex failed";
                                                             *stop = YES;
                                                         }
                                                     }];
                            
                                myResult = [myResult substringWithRange:NSMakeRange(8, [myResult length] - 1 - 3 - 8)];
                                self.userNAME = myResult;
                                [self writeNameToFileWithContent:myResult];
                                
                                
                                //Create a regular expression
                                NSString *regexStr = @"tr id=\"[0-9]*\"";
                                NSError *error = nil;
                                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:&error];
                                
                                __block NSString *myResult = nil; //Instanciate returner
                                
                                //Enumerate all matches
                                if ((regex==nil) && (error!=nil)){} else {
                                    [regex enumerateMatchesInString:homepageString
                                                            options:0
                                                              range:NSMakeRange(0, [homepageString length])
                                                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop){
                                                             if (result!=nil){
                                                                 //Iterate ranges
                                                                 for (int i=0; i<[result numberOfRanges]; i++) {
                                                                     NSRange range = [result rangeAtIndex:i];
                                                                     myResult = [homepageString substringWithRange:range];
                                                                     *stop = YES;
                                                                 }
                                                             } else {
                                                                 myResult = @"Regex failed";
                                                                 *stop = YES;
                                                             }
                                                         }];
                                }
                                NSString *regexedString = myResult;
                                userID = [self onlyNumbersRegex:regexedString];
                                //NSLog(@"UserID is %@", userID);
                            }
                            
                            
                            
                            if (userID) {
                                // Request AJAX from mistar
                                NSMutableURLRequest *setStudentID = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://mistar.oakland.k12.mi.us/novi/StudentPortal/StudentBanner/SetStudentBanner/%@" , userID]]];
                                [setStudentID setHTTPMethod:@"GET"];
                                [setStudentID setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
                                
                                [NSURLConnection sendAsynchronousRequest:setStudentID queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *studentIDResponse, NSData *studentIDData, NSError *studentIDError) {
                                    
                                    
                                    if ([studentIDData length] > 0 && studentIDError == nil) {
                                        //Get gradePage
                                        
                                        NSMutableURLRequest *requestGrades = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://mistar.oakland.k12.mi.us/novi/StudentPortal/Home/LoadProfileData/Assignments"]];
                                        [requestGrades setHTTPMethod:@"GET"];
                                        [requestGrades setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
                                        [NSURLConnection sendAsynchronousRequest:requestGrades queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *gradeResponse, NSData *gradeData, NSError *gradeError) {
                                            
                                            if ([gradeData length] > 0 && gradeError == nil) {
                                                //NSLog(@"the html%@",[[NSString alloc] initWithData:gradeData encoding:NSUTF8StringEncoding]);
                                                MAGradeParser *gradeParser = [[MAGradeParser alloc] init];
                                                myDictResult = [gradeParser parseWithData:gradeData];
                                                //NSLog(@"after myResult");
                                                NSLog(@"mydicktresult: %@", myDictResult);
                                                [self writeDictToFileWithContent:myDictResult];
                                                [self writeToTextFileWithContent:[NSString stringWithFormat:@"1 %@ %@", pin, password]];
                                                [self viewDidLoad];
                                                
                                                NSMutableURLRequest *logout = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://mistar.oakland.k12.mi.us/novi/StudentPortal/Home/Logout"]];
                                                [logout setHTTPMethod:@"GET"];
                                                [logout setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
                                                [NSURLConnection sendAsynchronousRequest:requestGrades queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *logoutResponse, NSData *logoutData, NSError *logoutError) {
                                                
                                                    if (logoutError == nil) {
                                                        [SVProgressHUD dismiss];
                                                        //NSLog(@"loggedout");
                                                    } else {
                                                        //NSLog(@"logout failed");
                                                    }
                                                }];
                                                
                                            } else {
                                                //NSLog(@"grade Error = %@", gradeError);
                                            }
                                        }];
                                    } else {
                                        //NSLog(@"Error setting studentID = %@", studentIDError);
                                    }
                                }];
                            } else {
                                //NSLog(@"Error: parse error = %@", homeError);
                            }
                        } else {
                            //NSLog(@"error: home error: %@", homeError);
                        }
                    }];
                    ///////
                }
            }
        } else {
            //NSLog(@"Couldn't log in");
            [self loginFailedAlertView];
        }
    }];
    return myDictResult;
}

- (void)refreshMistar {
    if (self.loggedIn) {
        NSArray *pinAndPass = [self getPinAndPass];
        [self loginToMistarWithPin:[pinAndPass objectAtIndex:0] password:[pinAndPass objectAtIndex:1]];
        self.shimmeringView.shimmering = YES;
    }
}

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
                                         ////NSLog(@"%ld,%ld group #%d %@", range.location, range.length, i, (range.length==0 ? @"--" : [string substringWithRange:range]));
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
