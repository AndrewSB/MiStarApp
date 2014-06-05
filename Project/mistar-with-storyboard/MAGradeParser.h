//
//  MAGradeParser.h
//  MistarApp
//
//  Created by Andrew Breckenridge on 3/26/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TFHpple.h"

#import "MAAssignment.h"

#import "MAClass.h"


@interface MAGradeParser : NSObject

- (NSDictionary *)parseWithData:(NSData *)data;

- (NSArray *)splitClassesWithData:(NSData *)data;
- (NSString *)getClassNameWithString:(NSString *)string;
- (NSString *)getGradeWithString:(NSString *)string;
- (NSDictionary *)getTeachersWithData:(NSData *)data;
- (NSArray *)getAssignmentsWithData:(NSData *)data;
- (NSString *)getProgressReportWithData:(NSData *)data;


@end
