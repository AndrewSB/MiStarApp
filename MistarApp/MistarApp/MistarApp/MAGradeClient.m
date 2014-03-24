//
//  MAGradeClient.m
//  MistarApp
//
//  Created by Andrew Breckenridge on 3/23/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

// Use TClient

#import "MAGradeClient.h"

@implementation MAGradeClient

// Synthesize all the main returners
@synthesize OneName;
@synthesize OneGrade;
@synthesize TwoName;
@synthesize TwoGrade;
@synthesize ThreeName;
@synthesize ThreeGrade;
@synthesize FourName;
@synthesize FourGrade;
@synthesize FiveName;
@synthesize FiveGrade;
@synthesize SixName;
@synthesize SixGrade;


- (BOOL)provideLoginWithPin:(NSString *)pin password:(NSString *)password {
    MAGradeReport *gradeReport = [[MAGradeReport alloc] init];
    NSLog([NSString stringWithFormat:@"Got these details %@ & %@", pin, password]);
    [gradeReport loginToMistarWithPin:pin password:password success:^{
        NSLog(@"You've reached the point where you get shit");
    } failure:^{
        NSLog(@"Some error in logging into Mistar and getting the UID");
    }];
    return true;
}





@end
