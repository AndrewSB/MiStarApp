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
    [returnArray addObject:self.assignments];
    [returnArray addObject:self.teacher];
    
    return [returnArray mutableCopy];
}

@end
