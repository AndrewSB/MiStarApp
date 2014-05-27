//
//  MAAssignment.m
//  MistarApp
//
//  Created by Andrew Breckenridge on 3/26/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import "MAAssignment.h"

@implementation MAAssignment

- (id)initWithDate:(NSString *)date assignmentName:(NSString *)assignmentName totalPoints:(NSNumber *)totalPoints recievedPoints:(NSNumber *)recievedPoints classAverage:(NSNumber *)classAverage extraCredit:(NSNumber *)extraCredit notGraded:(NSNumber *)notGraded {
    
    NSDateFormatter *dateF = [[NSDateFormatter alloc] init];
    [dateF setDateFormat:@"MM/dd/yyyy"];
    
    self.date = [dateF dateFromString:date];

    self.assignmentName = assignmentName;
    
    self.totalPoints = [NSNumber numberWithInteger:[totalPoints integerValue]];
    self.recievedPoints = [NSNumber numberWithInteger:[recievedPoints integerValue]];
    
    self.classAverage = classAverage;
    
    self.extraCredit = extraCredit;
    self.notGraded = notGraded;
    
    return self;
}

- (id)initWithDate:(NSString *)date assignmentName:(NSString *)assignmentName totalPoints:(NSNumber *)totalPoints recievedPoints:(NSNumber *)recievedPoints {
    NSDateFormatter *dateF = [[NSDateFormatter alloc] init];
    [dateF setDateFormat:@"MM/dd/yyyy"];
    
    self.date = [dateF dateFromString:date];
    self.assignmentName = assignmentName;
    self.totalPoints = totalPoints;
    self.recievedPoints = recievedPoints;
    
    return self;
}


- (void)logObject {
    NSLog(@"%@ %@ %@ %@", self.date, self.assignmentName, self.totalPoints, self.recievedPoints);
}


@end
