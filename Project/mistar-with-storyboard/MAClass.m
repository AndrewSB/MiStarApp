//
//  MAClass.m
//  mistar-with-storyboard
//
//  Created by Andrew Breckenridge on 5/22/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import "MAClass.h"

@implementation MAClass

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    self.name = [coder decodeObjectForKey:@"name"];
    self.grade = [coder decodeObjectForKey:@"grade"];
    self.assignments = [coder decodeObjectForKey:@"assignments"];
    self.teacher = [coder decodeObjectForKey:@"teacher"];
    
    return self;
}

- (id)initWithName:(NSString *)name grade:(NSString *)grade assignments:(NSArray *)assignments
{
    self. name = name;
    self.grade = grade;
    self.assignments = assignments;
    
    return [super init];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.grade forKey:@"grade"];
    [coder encodeObject:self.assignments forKey:@"assignments"];
    [coder encodeObject:self.teacher forKey:@"teacher"];
}

- (NSArray *)logClass {
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    [returnArray addObject:self.name];
    [returnArray addObject:self.grade];
    
    for (MAAssignment *ass in self.assignments) {
        [returnArray addObject:[ass logObject]];
    }
    [returnArray addObject:self.teacher];
    
    return [returnArray mutableCopy];
}

@end
