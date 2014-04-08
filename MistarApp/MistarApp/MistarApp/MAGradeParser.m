//
//  MAGradeParser.m
//  MistarApp
//
//  Created by Andrew Breckenridge on 3/26/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import "MAGradeParser.h"

@implementation MAGradeParser

- (NSArray *)parseWithData:(NSData *)data {
    
    TFHpple *tfhpple = [[TFHpple alloc] initWithData:data isXML:NO];
    
    NSString *xPathQuery = @"//tr/td[@valign=\"top\"]";
    NSArray *test = [tfhpple searchWithXPathQuery:xPathQuery];
    
//    for (TFHppleElement *element in test) {
//        NSString *match = [element text];
//        
//        NSLog(@"bishhh %@",match);
//    }

    NSArray *teachers = [self getTeachersWithData:data];
    NSArray *assignments = [self getAssignmentsWithData:data];
    NSArray *classes = [self getClassesWithData:data];
    NSArray *grades = [self getGradesWithData:data];
    
//    NSLog(@"teach %@",teachers);
//    NSLog(@"ass %@",assignments);
//    NSLog(@"class %@",classes);
//    NSLog(@"datA %@",grades);
    
    
//    for (TFHppleElement *item in teachers) {
//        NSLog(@"%@", item.text);
//        NSLog(@"%@", [[item.attributes objectForKey:@"href"] substringFromIndex:7]);
//    }
    
    
    //Do the assignments
    
    
//    for (TFHppleElement *item in classes) {
//        //NSLog(@"%@", item.text);
//    }
    
    for (TFHppleElement *item in grades) {
        NSLog(@"%@", item.text);
    }
    
    return test;
}

//- (NSArray *)getMasterView:(NSData *)data {
//    NSArray *classes = [self getClassesWithData:data];
//    NSArray *grades = [self getGradesWithData:data];
//    
//    NSMutableArray *returner = [[NSMutableArray alloc] initWithCapacity:6];
//    
//    for (int i = 0; i <= 6; i++) {
//        NSString *string = [NSString stringWithFormat:@"%@ |%@", classes[i], grades[i]];
//        returner[i] = string;
//    }
//    return returner;
//}
//
//- (NSArray *)getDetailViewForClass:(NSString *)class data:(NSData *)data {
//
//}


- (NSArray *)getTeachersWithData:(NSData *)data {
    TFHpple *tfhpple = [[TFHpple alloc] initWithData:data isXML:NO];
    NSString *xPathQuery = @"//a[@title=\"Send Email\"]";
    NSArray *test = [tfhpple searchWithXPathQuery:xPathQuery];
    
    return test;
}

- (NSArray *)getClassesWithData:(NSData *)data {
    TFHpple *tfhpple = [[TFHpple alloc] initWithData:data isXML:NO];
    NSString *xPathQuery = @"//td/\/b";
    NSArray *test = [tfhpple searchWithXPathQuery:xPathQuery];
    
    NSMutableArray *optimizedTest = [[NSMutableArray alloc] init];
    for (TFHppleElement *item in test) {
        if ([item.text rangeOfString:@"("].location != NSNotFound) {
            if ([item.text rangeOfString:@"Academic Advisory"].location == NSNotFound) {
                NSString *className = [[item.text substringFromIndex:3] substringToIndex:([item.text length] - 14)];
                [optimizedTest addObject:className];
            }
        }
    }
    
    return optimizedTest;
}

- (NSArray *)getAssignmentsWithData:(NSData *)data {
    TFHpple *tfhpple = [[TFHpple alloc] initWithData:data isXML:NO];
    NSString *xPathQuery = @"//tr/td[@valign=\"top\"]";
    NSArray *test = [tfhpple searchWithXPathQuery:xPathQuery];
    
    return test;
}

- (NSArray *)getGradesWithData:(NSData *)data {
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *regexStr = @"(<\/b>[A-F][+| |-]|<\/b>[A-F][+| |-] \(\d\d\.\d%\))";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:&error];
    
    NSArray *matches = [regex matchesInString:string options:0 range:(NSRange){0, [string length]}];
    
    for (NSTextCheckingResult *item in matches) {
        NSLog(@"%@", item);
    }
    
    return matches;
}


@end
