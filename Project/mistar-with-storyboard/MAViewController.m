//
//  MAViewController.m
//  mistar-with-storyboard
//
//  Created by Andrew Breckenridge on 4/17/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "MAViewController.h"

@interface MAViewController () <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate, NSURLSessionDelegate, UITableViewDelegate, UITableViewDataSource, MZFormSheetBackgroundWindowDelegate>


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

@end

@implementation MAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"eyyyy im here");
    self.screenName = @"Main Screen";
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]) {
        
    }
    else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    self.loggedIn = [[self displayContent] boolValue];
    
    NSLog(@"login status: %d", self.loggedIn);
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;

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
    [self.tableView reloadData];
    
    
    
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
    NSLog(@"User State UIAlert triggered");
    
    if (self.loggedIn) {
        UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"Log out?" message:@"This will also quit the app" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Logout", nil];
        [logoutAlert show];
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
        
        
        NSLog(@"returnpoint");
;       NSLog(@"gradeCliented");
    }
    
    if ([title isEqualToString:@"Text Andrew"] || [title isEqualToString:@"Message Andrew"] || [title isEqualToString:@"Contact Developer"] || [title isEqualToString:@"Text Andrew for help"]) {
        NSLog(@"Text Andrew hit");
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
            picker.body = @"Hey Andrew, I was using your Zangle app and I was having problems with ";
                
            [self presentViewController:picker animated:YES completion:NULL];
        } else {
            UIAlertView *noSMS = [[UIAlertView alloc] initWithTitle:@"Device not configured for iMessage" message:@"You can try emailing me, asbreckenridge@me.com" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [noSMS show];
            
            UIAlertView *nameAndSchoolAlert = [[UIAlertView alloc] initWithTitle:@"Include your name and school" message:@"Please also include your name and the school you go to in the message. Really just speeds things up" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [nameAndSchoolAlert show];
        }
    }

    if ([title isEqualToString:@"Logout"]) {
        NSLog(@"log out here");
        [self writeToTextFileWithContent:@"0"];
        [self writeDictToFileWithContent:[[NSDictionary alloc] init]];
        [self.tableView reloadData];
        exit(0);
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    NSLog(@"Dismissing SMS view");
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
        NSLog(@"content was nil");
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
            NSLog(@"found %@", [content substringWithRange:range]);
            
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
        NSLog(@"readin %@", strn);
    }
    
    return [arr mutableCopy];
}

- (void)writeDictToFileWithContent:(NSDictionary *)contentDict {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"/userdata.txt"];
    
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:contentDict];
    [data writeToFile:filePath atomically:YES];

}

- (NSDictionary *)readFromDict {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"/userdata.txt"];
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
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
        
        
        if ([classes count] > (NSUInteger)row) {
            cell.textLabel.text = [[classes objectAtIndex:(NSUInteger)row] name];
            
            cell.detailTextLabel.numberOfLines = 2;
            cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
            cell.detailTextLabel.text = [[classes objectAtIndex:(NSUInteger)row] grade];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"modal"];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    
    formSheet.presentedFormSheetSize = CGSizeMake(300, 298);
    // formSheet.transitionStyle = MZFormSheetTransitionStyleSlideFromTop;
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;

    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
        // Passing data
        UINavigationController *navController = (UINavigationController *)presentedFSViewController;
        navController.topViewController.title = @"PASSING DATA";
    };
    formSheet.transitionStyle = MZFormSheetTransitionStyleCustom;
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
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
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.URLCache = NULL;
    
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:config delegate: nil delegateQueue:[NSOperationQueue mainQueue]];
    
    
    NSLog(@"logging in");
    _cancel = false;
    __block NSDictionary *myDictResult = nil; //set Returner as a block so it's assignable *in* the completion block
    [SVProgressHUD show];
    
    
    NSMutableURLRequest *homeRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://mistar.oakland.k12.mi.us/novi/StudentPortal/Home/Login"]]];
    [homeRequest setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [homeRequest setHTTPMethod:@"POST"];
    
    NSString *postString = [NSString stringWithFormat:@"Pin=%@&Password=%@",
                            [self percentEscapeString:pin],
                            [self percentEscapeString:password]];
    NSData * postBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [homeRequest setHTTPBody:postBody];
    
    
    NSURLSessionDataTask *homeTask = [defaultSession dataTaskWithRequest:homeRequest completionHandler:^(NSData *homeData, NSURLResponse *homeResponse, NSError *homeError) {
        if ([homeData length] > 0 && homeError == nil) {
            NSString *loggedInPage = [[NSString alloc] initWithData:homeData encoding: NSUTF8StringEncoding];
            
            if (![loggedInPage isEqual:@"{\"msg\":\"\",\"valid\":\"1\"}"]) {
            	NSLog(@"Mistar login error, returning NO");
                _cancel = true;
                NSLog(@"call login error here");
                [self loginFailedAlertView];
            } else if (!_cancel) {
            	NSMutableURLRequest *userPinRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://mistar.oakland.k12.mi.us/novi/StudentPortal/Home/PortalMainPage"]];
                [homeRequest setHTTPMethod:@"GET"];
                [userPinRequest setCachePolicy:NSURLRequestReloadIgnoringCacheData];
                
                NSURLSessionDataTask *userPinTask = [defaultSession dataTaskWithRequest:userPinRequest completionHandler:^(NSData *userPinData, NSURLResponse *userPinResponse, NSError *userPinError) {
                    if ([userPinData length] > 0 && userPinError == nil) {
                        NSString *userNameString = [[NSString alloc] initWithData:userPinData encoding:NSUTF8StringEncoding];
                        NSError *userNameRegexError = nil;
                        
                        __block NSString *userNameRegexResult = nil;
                        NSString *userID = nil;
                        
                        //Get the client's name
                        NSRegularExpression *userNameRegex = [NSRegularExpression regularExpressionWithPattern:@"l>&nbsp;.*" options:0 error:&userNameRegexError];
                        if (!((userNameRegex==nil) && (userNameRegexError!=nil))) {
                            [userNameRegex enumerateMatchesInString:userNameString options:0 range:NSMakeRange(0, [userNameString length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                if (result!=nil) {
                                //Iterate ranges and stop after the first one
                                    for (int i=0; i<[result numberOfRanges]; i++) {
                                        NSRange range = [result rangeAtIndex:i];
                                        userNameRegexResult = [userNameString substringWithRange:range];
                                        *stop = YES;
                                    }
                                } else {
                                    userNameRegexResult = @"Regex failed";
                                    *stop = YES;
                                }
                            }];
                            
                            userNameRegexResult = [userNameRegexResult substringWithRange:NSMakeRange(8, [userNameRegexResult length] - 1 - 3 - 8)];
                            self.userNAME = userNameRegexResult;
                            [self writeNameToFileWithContent:userNameRegexResult];
                            NSLog(@"userpin regex:%@", self.userNAME);
                            
                            //Now get the userPin
                            NSError *userPinRegexError = nil;
                            NSRegularExpression *userPinRegex = [NSRegularExpression regularExpressionWithPattern:@"tr id=\"[0-9]*\"" options:0 error:&userPinError];
                            
                            __block NSString *userPinRegexResult = nil; //Instanciate returner
                            
                            //Enumerate all matches
                            if ((userPinRegex!=nil) && (userPinRegexError==nil)) {
                                [userPinRegex enumerateMatchesInString:userNameString options:0 range:NSMakeRange(0, [userNameString length]) usingBlock:^(NSTextCheckingResult *userPinResult, NSMatchingFlags flags, BOOL *stop){
                                    if (userPinResult!=nil){
                                    //Iterate ranges and stop after the first one
                                        for (int i=0; i<[userPinResult numberOfRanges]; i++) {
                                            NSRange range = [userPinResult rangeAtIndex:i];
                                            userPinRegexResult = [userNameString substringWithRange:range];
                                            *stop = YES;
                                        }
                                    } else {
                                        userPinRegexResult = @"Regex failed";
                                        *stop = YES;
                                    }
                                }];
                            }
                            NSString *regexedString = userPinRegexResult;
                            userID = [self onlyNumbersRegex:regexedString];
                            NSLog(@"UserID is %@", userID);
                        } else NSLog(@"error with getting the userPin regex");
                        
                        if (userID) {
                            NSLog(@"userID accepted");
                            NSMutableURLRequest *setStudentIDRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://mistar.oakland.k12.mi.us/novi/StudentPortal/StudentBanner/SetStudentBanner/%@" , userID]]];
                            [setStudentIDRequest setHTTPMethod:@"GET"];
                            [setStudentIDRequest setCachePolicy:NSURLRequestReloadIgnoringCacheData];
                            
                            NSURLSessionDataTask *setStudentIDTask = [defaultSession dataTaskWithRequest:setStudentIDRequest completionHandler:^(NSData *setStudentIDData, NSURLResponse *setStudentIDResponse, NSError *setStudentIDError){
                                if ([setStudentIDData length] > 0 && setStudentIDError == nil) {
                                    NSMutableURLRequest *requestGradesRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://mistar.oakland.k12.mi.us/novi/StudentPortal/Home/LoadProfileData/Assignments"]];
                                    [requestGradesRequest setHTTPMethod:@"GET"];
                                    [requestGradesRequest setCachePolicy:NSURLRequestReloadIgnoringCacheData];
                                    
                                    NSURLSessionDataTask *requestGradesTask = [defaultSession dataTaskWithRequest:requestGradesRequest completionHandler:^(NSData *requestGradesData, NSURLResponse *requestGradesResponse, NSError *requestGradesError) {
                                        if ([requestGradesData length] > 0 && requestGradesError == nil) {
                                            NSLog(@"the html%@",[[NSString alloc] initWithData:requestGradesData encoding:NSUTF8StringEncoding]);
                                            MAGradeParser *gradeParser = [[MAGradeParser alloc] init];
                                            myDictResult = [gradeParser parseWithData:requestGradesData];
                                            NSLog(@"after myResult");
                                            NSLog(@"mydicktresult: %@", myDictResult);
                                            [self writeDictToFileWithContent:myDictResult];
                                            [self writeToTextFileWithContent:[NSString stringWithFormat:@"1 %@ %@", pin, password]];
                                            [self.tableView reloadData];
                                            [self viewDidLoad];
                                            [SVProgressHUD dismiss];
                                            
                                            NSDictionary *innerDict = [self readFromDict];
                                            for (MAClass *class in [innerDict objectForKey:@"classes"]) {
                                                NSLog(@"the class is %@", [class logClass]);
                                            }
                                        }
                                    }];
                                    [requestGradesTask resume];
                                    
                                } else NSLog(@"Error with setStudentID request is either < 0 or there was an error:%@", setStudentIDError);
                                
                            }];
                            [setStudentIDTask resume];
                        }
                        
                    } else NSLog(@"error with getting the userPin data");
                }];
                [userPinTask resume];
        
            } else NSLog(@"Error with logging into mistar, recieved: %@", homeData);
        } else NSLog(@"Error with homeData or it's length:%@", homeError);
    }];
    [homeTask resume];

    defaultSession = NULL;
    
    return myDictResult;
}
                                      
- (void)refreshMistar {
    if (self.loggedIn) {
        NSArray *pinAndPass = [self getPinAndPass];
        [self loginToMistarWithPin:[pinAndPass objectAtIndex:0] password:[pinAndPass objectAtIndex:1]];
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
                                         NSLog(@"%ld,%ld group #%d %@", (unsigned long)range.location, (unsigned long)range.length, i, (range.length==0 ? @"--" : [string substringWithRange:range]));
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
