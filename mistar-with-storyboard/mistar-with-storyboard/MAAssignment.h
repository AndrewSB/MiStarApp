//
//  MAAssignment.h
//  MistarApp
//
//  Created by Andrew Breckenridge on 3/26/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAAssignment : NSObject

@property (nonatomic, strong) NSDate *dateAssigned;
@property (nonatomic, strong) NSDate *dateSubmitted;
@property (nonatomic, strong) NSString *assignmentName;
@property (nonatomic, strong) NSNumber *totalPoints;
@property (nonatomic, strong) NSNumber *recievedPoints;

@property (nonatomic, strong) NSNumber *extraCredit;
@property (nonatomic, strong) NSNumber *notGraded;


- (id)initWithDate:(NSString *)dateAssigned dateSubmitted:(NSString *)dateSubmitted assignmentName:(NSString *)assignmentName totalPoints:(NSNumber *)totalPoints recievedPoints:(NSNumber *)recievedPoints extraCredit:(NSNumber *)extraCredit notGraded:(NSNumber *)notGraded;


@end