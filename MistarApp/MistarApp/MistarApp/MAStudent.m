//
//  MAStudent.m
//  MistarApp
//
//  Created by Andrew Breckenridge on 3/25/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import "MAStudent.h"

@implementation MAStudent

- (id)initWithName:(NSString *)name {
    _name = name;
    _classes = [[NSMutableArray alloc] initWithCapacity:6];
    
    return self;
}

@end
