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
        NSLog(@"You've reached the point where you get stuff");
        NSMutableArray *gradesArray = [[NSMutableArray alloc] initWithCapacity:6];
        
        MAClass *one = [[MAClass alloc] initWithName:@"IB Math SL 2" grade:@"A-" percentage:@90.2];
        MAClass *two = [[MAClass alloc] initWithName:@"IB History HL 2" grade:@"B-" percentage:@80.4];
        MAClass *three = [[MAClass alloc] initWithName:@"IB French SL 2" grade:@"A" percentage:@94.2];
        MAClass *four = [[MAClass alloc] initWithName:@"AP Physics E&M" grade:@"B" percentage:@73.8];
        MAClass *five = [[MAClass alloc] initWithName:@"IB Computer Science HL 2" grade:@"A-" percentage:@91.1];
        MAClass *six = [[MAClass alloc] initWithName:@"IB English HL 2" grade:@"A" percentage:@93.6];

        [gradesArray addObject:one];
        [gradesArray addObject:two];
        [gradesArray addObject:three];
        [gradesArray addObject:four];
        [gradesArray addObject:five];
        [gradesArray addObject:six];
        
        _gradesArray = gradesArray;
    } failure:^{
        NSLog(@"Some error in logging into Mistar and getting the UID");
    }];
    return _gradesArray;
}

@end
