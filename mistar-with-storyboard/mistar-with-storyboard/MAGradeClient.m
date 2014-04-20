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


- (NSMutableArray *)provideLoginWithPin:(NSString *)pin password:(NSString *)password {
    MAGradeReport *gradeReport = [[MAGradeReport alloc] init];
    NSLog(@"Got these details %@ & %@", pin, password);
    [gradeReport loginToMistarWithPin:pin password:password success:^{
        NSLog(@"successpoint");
    } failure:^{
        NSLog(@"Some error in logging into Mistar and getting the UID");
    }];
    NSLog(@"returnpoint");
    return _gradesArray;
}

@end
