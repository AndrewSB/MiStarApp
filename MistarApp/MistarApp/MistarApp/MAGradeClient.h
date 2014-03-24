//
//  MAGradeClient.h
//  MistarApp
//
//  Created by Andrew Breckenridge on 3/23/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAGradeReport.h"

@interface MAGradeClient : NSObject

- (BOOL)provideLoginWithPin:(NSString *)pin password:(NSString *)password;

@property (nonatomic, strong) NSString *OneName;
@property (nonatomic, strong) NSString *OneGrade;
@property (nonatomic, strong) NSString *TwoName;
@property (nonatomic, strong) NSString *TwoGrade;
@property (nonatomic, strong) NSString *ThreeName;
@property (nonatomic, strong) NSString *ThreeGrade;
@property (nonatomic, strong) NSString *FourName;
@property (nonatomic, strong) NSString *FourGrade;
@property (nonatomic, strong) NSString *FiveName;
@property (nonatomic, strong) NSString *FiveGrade;
@property (nonatomic, strong) NSString *SixName;
@property (nonatomic, strong) NSString *SixGrade;

@end
