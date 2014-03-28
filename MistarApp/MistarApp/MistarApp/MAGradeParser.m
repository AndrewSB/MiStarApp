//
//  MAGradeParser.m
//  MistarApp
//
//  Created by Andrew Breckenridge on 3/26/14.
//  Copyright (c) 2014 Andrew Breckenridge. All rights reserved.
//

#import "MAGradeParser.h"

@implementation MAGradeParser

- (void)parseWithData:(NSData *)data {
    
    TFHpple *tfhpple = [[TFHpple alloc] initWithData:data isXML:NO];
    
    NSString *xPathQuery = @"//tr/td[@valign=\"top\"]";
    NSArray *test = [tfhpple searchWithXPathQuery:xPathQuery];
    
    for (TFHppleElement *element in test) {
        NSString *match = [element text];
        
        NSLog(@"%@",match);
    }
    
    
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
    
    for (TFHppleElement *element in test) {
        NSString *match = [element text];
        
        NSLog(@"%@",match);
    }
    return test;
}

- (NSArray *)getClassesWithData:(NSData *)data {
    TFHpple *tfhpple = [[TFHpple alloc] initWithData:data isXML:NO];
    NSString *xPathQuery = @"//tr/td[@valign=\"top\"]";
    NSArray *test = [tfhpple searchWithXPathQuery:xPathQuery];
    NSMutableArray *tester = [[NSMutableArray alloc] initWithArray:test];
    
    NSMutableIndexSet *discardedItems = [NSMutableIndexSet indexSet];
    NSUInteger *index = 0;
    
    for (TFHppleElement *element in tester) {
        NSString *match = [element text];
        if ([match rangeOfString:@"("].location == NSNotFound) {
            [discardedItems addIndex:*index];
        }
        index++;
    }
    [tester removeObjectsAtIndexes:discardedItems];
    
    return tester;
}

//- (NSArray *)getAssignmentsWithData:(NSData *)data {
//    TFHpple *tfhpple = [[TFHpple alloc] initWithData:data isXML:NO];
//    NSString *xPathQuery = @"//tr/td[@valign=\"top\"]";
//    NSArray *test = [tfhpple searchWithXPathQuery:xPathQuery];
//    
//    for (TFHppleElement *element in test) {
//        NSString *match = [element text];
//        
//        NSLog(@"%@",match);
//    }
//
//}

- (NSArray *)getGradesWithData:(NSData *)data {
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *regexStr = @""; //@"(<\/b>[A-F][+| |-]|<\/b>[A-F][+| |-] \(\d\d\.\d%\))";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:&error];
    
    __block NSMutableArray *result = nil; //Instanciate returner
    
    //Enumerate all matches
    if ((regex==nil) && (error!=nil)){
        return [[NSArray alloc] initWithObjects:nil];
    } else {
        [regex enumerateMatchesInString:string
                                options:0
                                  range:NSMakeRange(0, [string length])
                             usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop){
                                 if (result!=nil){
                                     //Iterate ranges
                                     for (int i=0; i<[result numberOfRanges]; i++) {
                                         NSRange range = [result rangeAtIndex:i];
                                         //NSLog(@"%ld,%ld group #%d %@", range.location, range.length, i, (range.length==0 ? @"--" : [string substringWithRange:range]));
                                         //myResult = [string substringWithRange:range];
                                         *stop = YES;
                                     }
                                 } else {
                                    //
                                     //myResult = @"Regex failed";
                                     *stop = YES;
                                 }
                             }];
    }
    return result;

}


@end
