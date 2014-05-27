//
//  MAClass.h
//  mistar-with-storyboard
//
//  Created by Andrew Breckenridge on 5/22/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MAAssignment.h"

@interface MAClass : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *grade;

@property (nonatomic, strong) NSArray *assignments;
@property (nonatomic, strong) NSDictionary *teacher;

@end
