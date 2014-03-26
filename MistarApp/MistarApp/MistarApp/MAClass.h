//
//  MAClass.h
//  MistarApp
//
//  Created by Andrew Breckenridge on 3/25/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAClass : NSObject

@property (nonatomic, assign) NSString *name;
@property (nonatomic, assign) NSString *grade;
@property (nonatomic, assign) NSNumber *percentage;

- (id)initWithName:(NSString *)name grade:(NSString *)grade percentage:(NSNumber *)percentage;

@end
