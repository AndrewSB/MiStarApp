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
    
    NSMutableArray *returnClasses = [[NSMutableArray alloc] init];
    
    for (NSString *class in classes) {
        NSData *classData = [class dataUsingEncoding:NSUTF8StringEncoding];
        MAClass *maclass = [[MAClass alloc] init];
        
        maclass.name = [self getClassNameWithString:class];
        maclass.grade = [self getGradeWithString:class];
        maclass.teacher = [self getTeachersWithData:classData];
        maclass.assignments = [self getAssignmentsWithData:classData];
        NSLog(@"Should have parsed everything");
        [returnClasses addObject:maclass];
    }
    
    return [[NSDictionary alloc] initWithObjectsAndKeys:[returnClasses mutableCopy], @"classes", nil];
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
                ////NSLog(@"disinclude AA");
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

- (NSString *)getClassNameWithString:(NSString *)string {
    string = [string substringFromIndex:41];
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\(\\d\\d\\d\\d\\)" options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, 40)];
    NSUInteger endNameRange = [[matches objectAtIndex:0] range].location;
    
    return [string substringWithRange:NSMakeRange(0, endNameRange)];
}

- (NSString *)getGradeWithString:(NSString *)string {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(<\/b>[ABCDEF]){1}[ +-]?[^A]......" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    if ([matches count] == 0) {
        NSLog(@"No grade matches");
        return @" ";
    } else {
        string = [[string substringWithRange:[[matches objectAtIndex:0] range]] substringFromIndex:4];
        if ([string characterAtIndex:1] == '+' || [string characterAtIndex:1] == '-') {
            if ([string characterAtIndex:4] == '(') {
                string = [NSString stringWithFormat:@"%@\n%@",[string substringToIndex:1],[string substringWithRange:NSMakeRange(5, 4)]];
            } else {
                string = [string substringToIndex:2];
            }
        } else {
            if ([string characterAtIndex:3] == '(') {
                string = [NSString stringWithFormat:@"%@\n%@",[string substringToIndex:1],[string substringWithRange:NSMakeRange(4, 4)]];
            } else {
                string = [string substringToIndex:1];
            }
        }
        NSLog(@"returned this grade: %@", string);
        return string;
    }
}

- (NSDictionary *)getTeachersWithData:(NSData *)data {
    TFHpple *tfhpple = [[TFHpple alloc] initWithData:data isXML:NO];
    NSString *xPathQuery = @"//a[@title=\"Send Email\"]";
    NSArray *test = [tfhpple searchWithXPathQuery:xPathQuery];
    TFHppleElement *element = [test objectAtIndex:0];
    NSString *name = element.text;
    NSUInteger commaLocation = [name rangeOfString:@","].location;
    name = [NSString stringWithFormat:@"%@ %@", [name substringFromIndex:(commaLocation + 2)], [name substringToIndex:commaLocation]];
    
    NSDictionary *teacher = [[NSDictionary alloc] initWithObjectsAndKeys:name, @"name", [[element.attributes objectForKey:@"href"] substringFromIndex:7], @"email", nil];
  
    return teacher;
}

- (NSArray *)getAssignmentsWithData:(NSData *)data {
    TFHpple *tfhpple = [[TFHpple alloc] initWithData:data isXML:NO];
    NSString *xPathQuery = @"//tr/td[@valign=\"top\"]";
    NSArray *test = [tfhpple searchWithXPathQuery:xPathQuery];
    NSMutableArray *assignments = [[NSMutableArray alloc] init];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:1];
    
    MAAssignment *assignment = [[MAAssignment alloc] init];
    int count = 0;
    BOOL flag = true;
    NSString *newAssignmentBlock = @"";
    
    NSString *curDate = nil;
    NSString *curName = nil;
    NSNumber *curPoints = nil;
    NSNumber *curScore = nil;
    
    for (TFHppleElement *element in test) {
        if (flag) {
            newAssignmentBlock = element.text;
            flag = false;
            //NSLog(@"Split here");
        }
        if ([element.text isEqualToString:newAssignmentBlock]) {
            //Create new assignment, if there was an old one add to array
            if (curName) {
                assignment = nil;
                assignment = [[MAAssignment alloc] initWithDate:curDate assignmentName:curName totalPoints:curPoints recievedPoints:curScore];
                [assignments addObject:assignment];
                curDate = nil;
                curName = nil;
                curScore = nil;
                curPoints = nil;
            }
            else {
                
            }
            count = 0;
        }
        switch (count) {
            case 1: {
                curDate = element.text;
                break;
            }
            case 2: {
                break;
            }
            case 3: {
                curName = element.text;
                break;
            }
            case 4: {
                curPoints = [numberFormatter numberFromString:element.text];
                //NSLog(@"curPoints is %@", curPoints);
                break;
            }
            case 5: {
                curScore = [numberFormatter numberFromString:element.text];
                //NSLog(@"curScore is %@", curScore);
                break;
            }
            default: {
                break;
            }
        }
        //NSLog(@"Logged text:%@", element.text);
        
        count++;
    }
    if (curName) {
        assignment = nil;
        assignment = [[MAAssignment alloc] initWithDate:curDate assignmentName:curName totalPoints:curPoints recievedPoints:curScore];
        [assignments addObject:assignment];
        curDate = nil;
        curName = nil;
        curScore = nil;
        curPoints = nil;
    }
    return [assignments mutableCopy];
}

@end
