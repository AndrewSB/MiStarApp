//
//  MAClass.m
//  MistarApp
//
//  Created by Andrew Breckenridge on 3/25/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import "MAClass.h"

@implementation MAClass

- (id)initWithName:(NSString *)name grade:(NSString *)grade percentage:(NSNumber *)percentage assignments:(NSMutableArray *)assignments teacher:(MATeacher *)teacher {
    self.name = name;
    self.grade = grade;
    self.percentage = percentage;
    self.assignments = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithArray:assignments]];
    self.teacher = teacher;
    
    return self;
}

@end