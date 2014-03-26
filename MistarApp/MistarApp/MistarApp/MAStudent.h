//
//  MAStudent.h
//  MistarApp
//
//  Created by Andrew Breckenridge on 3/25/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAAssignment.h"

@interface MAStudent : NSObject


- (MAStudent *)loginToMistarWithPin:(NSString *)pin password:(NSString *)password;

@property (nonatomic, strong) NSArray *classes;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *attendances;


@end
