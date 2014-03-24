//
//  TParse.m
//  Tester
//
//  Created by Andrew Breckenridge on 3/22/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import "TParse.h"
#import "TFHpple.h"

@implementation TParse

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


- (void)parseForUserID:(NSString *)noString success:(void (^)(void))successHandler failure:(void (^)(void))failureHandler {
    //Get the Data you need to parse for (i.e. user main page returned as a block of NSData.
    TClient *client = [[TClient alloc] init];
    [client loginToMistarWithPin:@"20014204" password:@"yuiop" success:^{
        [client getUserID:^(NSString *result) {
            NSString *userIDWithHTML = [self userIDRegex:result];
            NSString *userID = [self onlyNumbersRegex:userIDWithHTML];
            NSLog(@"UserID parsed from HTML %@", userID);
            
//            [client getUserData:userID success:^{
//                
//                
//            }failure:^{
//                
//            }];
            
        }];
    } failure:^{
        NSLog(@"login failed from controller");
    }];
}



@end
