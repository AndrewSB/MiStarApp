//
//  MAGradeReport.h
//  MistarApp
//
//  Created by Andrew Breckenridge on 3/23/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAGradeParser.h"

@interface MAGradeReport : NSObject

- (NSString *)percentEscapeString:(NSString *)string;
- (void)loginToMistarWithPin:(NSString *)pin password:(NSString *)password success:(void (^)(void))successHandler failure:(void (^)(void))failureHandler;

@end
