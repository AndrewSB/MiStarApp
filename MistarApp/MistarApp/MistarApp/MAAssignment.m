//
//  MAAssignment.m
//  MistarApp
//
//  Created by Andrew Breckenridge on 3/26/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import "MAAssignment.h"

@implementation MAAssignment

- (id)initWithName:(NSString *)name date:(NSDate *)date total:(NSNumber *)total recieved:(NSNumber *)recieved {
    
    _assignmentName = name;
    _date = date;
    _totalPoints = total;
    _recievedPoints = recieved;
    return self;
}

@end
