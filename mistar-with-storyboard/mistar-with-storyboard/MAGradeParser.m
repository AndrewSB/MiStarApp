//
//  MAGradeParser.m
//  MistarApp
//
//  Created by Andrew Breckenridge on 3/26/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import "MAGradeParser.h"

@implementation MAGradeParser


//TFHpple *tfhpple = [[TFHpple alloc] initWithData:data isXML:NO];
//
//NSString *xPathQuery = @"//tr/td[@valign=\"top\"]";
//NSArray *test = [tfhpple searchWithXPathQuery:xPathQuery];
//
//for (TFHppleElement *element in test) {
//    NSString *match = [element text];
//    
//    NSLog(@"bishhh %@",match);
//}
//
//NSArray *teachers = [self getTeachersWithData:data];
//NSArray *assignments = [self getAssignmentsWithData:data];
//NSArray *classes = [self getClassesWithData:data];
//NSArray *grades = [self getGradesWithData:data];

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


- (NSArray *)parseWithData:(NSData *)data {
    NSArray *classes = [self splitClassesWithData:data];
    NSArray *classArray = [self getClassesWithData:data];
    NSArray *teacherArray = [self getTeachersWithData:data];
    
    NSLog(@"class is %@", [[teacherArray objectAtIndex:1] name1]);
    
    int i = 0;
    for (NSString *string in classes) {
        NSLog(@"%d %@ %@", i, [[teacherArray objectAtIndex:i] name], [[teacherArray objectAtIndex:i] email]);
        
        i++;
    }
    
    return classes;
}

-(NSArray *)splitClassesWithData:(NSData *)data {
    NSString *htmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSMutableArray *classes = [[NSMutableArray alloc] init];
    
    NSUInteger length = [htmlString length];
    NSRange range = NSMakeRange(0, length);
    while(range.location != NSNotFound)
    {
        range = [htmlString rangeOfString: @"lblperiod" options:0 range:range];
        if(range.location != NSNotFound)
        {
            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
            NSNumber *toAdd = [NSNumber numberWithInteger:range.location];
            [classes addObject:toAdd];
        }
    }
    
    int counter = 0;
    NSNumber *count = [NSNumber numberWithInteger:[classes count] - 1];
    NSMutableArray *classArray = [NSMutableArray arrayWithCapacity:[classes count]];
    
    for (NSNumber *i in classes) {
        int loc = [[classes objectAtIndex:counter] intValue];
        int len = -loc;
        
        if ([count intValue] > [[NSNumber numberWithInt:(counter)] intValue]) {
            NSRange range = NSMakeRange(loc, (len + [[classes objectAtIndex:(counter+1)] intValue]));
            NSString *rangeString = [htmlString substringWithRange:range];
            
            if ([rangeString rangeOfString:@"Academic Adviso"].location == NSNotFound) {
                [classArray addObject:htmlString];
            } else {
                NSLog(@"disinclude AA");
            }
            
        } else {
            NSRange range = NSMakeRange(loc, ([htmlString length] + len));
            htmlString = [htmlString substringWithRange:range];
    
            [classArray addObject:htmlString];
        }
        counter++;
    }
    return [classArray copy];
}

- (NSArray *)getTeachersWithData:(NSData *)data {
    TFHpple *tfhpple = [[TFHpple alloc] initWithData:data isXML:NO];
    NSString *xPathQuery = @"//a[@title=\"Send Email\"]";
    NSArray *test = [tfhpple searchWithXPathQuery:xPathQuery];
    NSMutableArray *teacherArray;
    
    for (TFHppleElement *item in test) {
        MATeacher *teacher = [[MATeacher alloc] initWithName:item.text email:[[item.attributes objectForKey:@"href"] substringFromIndex:7]];
        NSLog(@"%@ %@", teacher.name, teacher.email);
        [teacherArray addObject:teacher];
    }
    return [teacherArray mutableCopy];
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
    NSString *searchString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *regexStr = @"(<\\/b>[A-F][+| |-]|<\\/b>[A-F][+| |-] \\(\\d\\d\\.\\d%\\))";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:&error];
    
    NSArray *matches = [regex matchesInString:searchString options:0 range:(NSRange){0, [searchString length]}];
    
    for (NSTextCheckingResult *match in matches) {
        NSString* matchText = [searchString substringWithRange:[match range]];
        NSLog(@"match: %@", matchText);
    }
    
    return matches;
}


@end
