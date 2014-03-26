//
//  MAClass.m
//  MistarApp
//
//  Created by Andrew Breckenridge on 3/25/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import "MAClass.h"

@implementation MAClass

- (id)initWithName:(NSString *)name grade:(NSString *)grade percentage:(NSNumber *)percentage {
    self.name = name;
    self.grade = grade;
    self.percentage = percentage;
    
    return self;
}

@end
