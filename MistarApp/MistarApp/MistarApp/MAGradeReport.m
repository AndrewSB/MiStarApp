//
//  MAGradeReport.m
//  MistarApp
//
//  Created by Andrew Breckenridge on 3/23/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

//Use TParse

#import "MAGradeReport.h"

@implementation MAGradeReport

- (NSString *)percentEscapeString:(NSString *)string {
    NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)string,
                                                                                 (CFStringRef)@" ",
                                                                                 (CFStringRef)@":/?@!$&'()*+,;=",
                                                                                 kCFStringEncodingUTF8));
    return [result stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

- (void)loginToMistarWithPin:(NSString *)pin password:(NSString *)password success:(void (^)(void))successHandler failure:(void (^)(void))failureHandler{
    //Create and send request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://mistar.oakland.k12.mi.us/novi/StudentPortal/Home/Login"]];
    
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
                                        NSLog(@"%@",[[NSString alloc] initWithData:gradeData encoding:NSUTF8StringEncoding]);
                                        MAGradeParser *gradeParser = [[MAGradeParser alloc] init];
                                        [gradeParser parseWithData:gradeData];
                                        
                                        
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
                }
                else {
                    NSLog(@"error: home error: %@", homeError);
                }
                
            }];
            ///////
        }
        else {
            NSLog(@"Couldn't log in");
        }
    }];
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
