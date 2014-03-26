//
//  MAStudent.m
//  MistarApp
//
//  Created by Andrew Breckenridge on 3/25/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import "MAStudent.h"

@implementation MAStudent

//- (UIWebView *)loadWebViewWithRequest:(NSMutableURLRequest *)request size:(CGRect)size {
//    UIWebView *webview = [[UIWebView alloc]initWithFrame:size];
//    NSURL *urlValue = [NSURL URLWithString:@"https://www.yahoo.com"];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlValue];
//    NSString *newUserAgent = @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1700.107 Safari/537.36";
//    [request setValue:newUserAgent forHTTPHeaderField:@"User-Agent"];
//
//    
//    NSString *url=@"https://mistar.oakland.k12.mi.us/novi/StudentPortal/Home/Login";
//    NSURL *nsurl=[NSURL URLWithString:url];
//    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        // do whatever with the data...and errors
//        if ([data length] > 0 && error == nil) {
//            NSError *parseError;
//            NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
//            NSString *loggedInPage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            if (responseJSON) {
//                NSLog(@"Returned as JSON, Good. %@", loggedInPage);
//            } else {;
//                NSLog(@"Response was not JSON (from login), it was = %@", loggedInPage);
//            }
//
//            NSMutableURLRequest *newRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://mistar.oakland.k12.mi.us/novi/StudentPortal/Home/PortalMainPagez"]];
//            [newRequest setHTTPMethod:@"GET"];
//
//            [webview loadRequest:newRequest];
//        }
//    }];
//    
//    return webview;
//}



- (MAStudent *)loginToMistarWithPin:(NSString *)pin password:(NSString *)password {
    NSMutableArray *classesMutable = [[NSMutableArray alloc] init];
    
    NSMutableArray *periodOne = [[NSMutableArray alloc] init];
    NSMutableArray *periodTwo = [[NSMutableArray alloc] init];
    NSMutableArray *periodThree = [[NSMutableArray alloc] init];
    NSMutableArray *periodFour = [[NSMutableArray alloc] init];
    NSMutableArray *periodFive = [[NSMutableArray alloc] init];
    NSMutableArray *periodSix = [[NSMutableArray alloc] init];
    
    
    
    _classes = [[NSArray alloc] initWithArray:classesMutable];
    
    
    return self;
}



@end
