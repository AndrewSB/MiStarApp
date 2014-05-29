//
//  MAAssignment.m
//  MistarApp
//
//  Created by Andrew Breckenridge on 3/26/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import "MAAssignment.h"

@implementation MAAssignment

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    self.date = [coder decodeObjectForKey:@"date"];
    self.assignmentName = [coder decodeObjectForKey:@"assignmentName"];
    self.totalPoints = [coder decodeObjectForKey:@"totalPoints"];
    self.recievedPoints = [coder decodeObjectForKey:@"totalPoints"];
    self.classAverage = [coder decodeObjectForKey:@"classAverage"];
    self.extraCredit = [coder decodeObjectForKey:@"extraCredit"];
    self.notGraded = [coder decodeObjectForKey:@"notGraded"];
    
    return self;
}

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


- (NSString *)logObject {
    return [NSString stringWithFormat:@"%@ %@ %@ %@", self.date, self.assignmentName, self.totalPoints, self.recievedPoints];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.date forKey:@"date"];
    [coder encodeObject:self.assignmentName forKey:@"assignmentName"];
    [coder encodeObject:self.totalPoints forKey:@"totalPoints"];
    [coder encodeObject:self.recievedPoints forKey:@"recievedPoints"];
    [coder encodeObject:self.classAverage forKey:@"classAverage"];
    [coder encodeObject:self.extraCredit forKey:@"extraCredit"];
    [coder encodeObject:self.notGraded forKey:@"notGraded"];
}



@end
