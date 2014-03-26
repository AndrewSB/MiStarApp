//
//  MAGradeClient.h
//  MistarApp
//
//  Created by Andrew Breckenridge on 3/23/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAGradeReport.h"
#import "MAClass.h"

@interface MAGradeClient : NSObject

- (NSMutableArray *)provideLoginWithPin:(NSString *)pin password:(NSString *)password;
@property (nonatomic, strong) NSMutableArray *gradesArray;

@end
