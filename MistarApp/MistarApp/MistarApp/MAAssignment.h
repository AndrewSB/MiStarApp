//
//  MAAssignment.h
//  MistarApp
//
//  Created by Andrew Breckenridge on 3/26/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAAssignment : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *assignmentName;
@property (nonatomic, strong) NSNumber *totalPoints;
@property (nonatomic, strong) NSNumber *recievedPoints;

@end
