//
//  MAAssignment.m
//  MistarApp
//
//  Created by Andrew Breckenridge on 3/26/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import "MAAssignment.h"

@implementation MAAssignment

- (id)initWithDate:(NSString *)dateAssigned dateSubmitted:(NSString *)dateSubmitted assignmentName:(NSString *)assignmentName totalPoints:(NSNumber *)totalPoints recievedPoints:(NSNumber *)recievedPoints extraCredit:(NSNumber *)extraCredit notGraded:(NSNumber *)notGraded {
    
    NSDateFormatter *dateF = [[NSDateFormatter alloc] init];
    [dateF setDateFormat:@"MM/dd/yyyy"];
    
    _dateAssigned = [dateF dateFromString:dateAssigned];
    _dateSubmitted = [dateF dateFromString:dateSubmitted];

    _assignmentName = assignmentName;
    
    _totalPoints = [NSNumber numberWithInteger:[totalPoints integerValue]];
    _recievedPoints = [NSNumber numberWithInteger:[recievedPoints integerValue]];
    
    _extraCredit = extraCredit;
    _notGraded = notGraded;
    
    return self;
}


@end
