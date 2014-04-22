//
//  MATeacher.h
//  mistar-with-storyboard
//
//  Created by Andrew Breckenridge on 4/20/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MATeacher : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *email;

- (id)initWithName:(NSString *)name email:(NSString *)email;

@end
