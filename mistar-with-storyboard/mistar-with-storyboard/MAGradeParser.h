//
//  MAGradeParser.h
//  MistarApp
//
//  Created by Andrew Breckenridge on 3/26/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFHpple.h"
#import "MAGradeReport.h"
#import "MAAssignment.h"
#import "MAClass.h"
#import "MAStudent.h"


@interface MAGradeParser : NSObject

- (NSArray *)parseWithData:(NSData *)data;

- (NSArray *)getMasterView:(NSData *)data;
- (NSArray *)getDetailViewForClass:(NSString *)class data:(NSData *)data;
- (NSArray *)getTeachersWithData:(NSData *)data;
- (NSArray *)getClassesWithData:(NSData *)data;
- (NSArray *)getAssignmentsWithData:(NSData *)data;
- (NSArray *)getGradesWithData:(NSData *)data;

@end
