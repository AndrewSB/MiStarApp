//
//  MAGradeParser.m
//  MistarApp
//
//  Created by Andrew Breckenridge on 3/26/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import "MAGradeParser.h"

@implementation MAGradeParser

- (NSDictionary *)parseWithData:(NSData *)data {
    NSArray *classes = [self splitClassesWithData:data];
    NSArray *classArray = [self getClassesWithData:data];
    NSArray *teacherArray = [self getTeachersWithData:data];
    NSArray *gradeArray = [self getGradesWithData:data];
    
    NSMutableArray *percentArray = [[NSMutableArray alloc] init];
    for (NSString *str in classes) {
        NSLog(@"classstr is %@", str);
        [percentArray addObject:[self getPercentageFromClassString:str]];
    }
    
    
    NSString *name = [self getNameFromStringWithData:data];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:classArray, @"classes",
                          teacherArray, @"teachers",
                          gradeArray, @"grades",
                          nil];
    
    return dict;
}

- (NSArray *)splitClassesWithData:(NSData *)data {
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
                [classArray addObject:rangeString];
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
    NSMutableArray *teacherArray = [[NSMutableArray alloc] init];
    
    for (TFHppleElement *item in test) {
        NSDictionary *teacher = [[NSDictionary alloc] initWithObjectsAndKeys:@"Name", item.text, @"Email", [[item.attributes objectForKey:@"href"] substringFromIndex:7], nil];
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
    
    return [optimizedTest mutableCopy];
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
    NSMutableArray *returnerMatches = [[NSMutableArray alloc] init];
    
    for (NSTextCheckingResult *match in matches) {
        NSString* matchText = [searchString substringWithRange:[match range]];
        matchText = [matchText substringFromIndex:4];
        [returnerMatches addObject:matchText];
    }
    
    return [returnerMatches copy];
}

- (NSString *)getPercentageFromClassString:(NSString *)string {
    NSString *percentage;
    
    NSString *regexStr = @"\([0-9][0-9]\.[0-9]%\)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:nil];
    NSArray *matches = [regex matchesInString:string options:0 range:(NSRange){0, [string length]}];
    
    for (NSTextCheckingResult *match in matches) {
        NSString *matchText = [string substringWithRange:[match range]];
        NSLog(@"matchtext %@", matchText);
        if (matchText) {
            percentage = matchText;
        } else {
            percentage = nil;
        }
    }
    
    return percentage;
}

- (NSString *)getNameFromStringWithData:data {
    NSString *name;
    
    return name;
}


@end
