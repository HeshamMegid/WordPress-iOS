//
//  NSString+Util.m
//  WordPress
//
//  Created by Joshua Bassett on 18/06/09.
//

#import "NSString+Util.h"
#import <DiffMatchPatch/DiffMatchPatch.h>


@implementation NSString (Util)

- (bool)isEmpty {
    return self.length == 0;
}

- (NSString *)trim {
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

- (NSNumber *)numericValue {
    return [NSNumber numberWithUnsignedLongLong:[self longLongValue]];
}

- (NSString *)mergeDiffsWithString:(NSString *)stringToMerge {
    DiffMatchPatch *dmp = [[DiffMatchPatch alloc] init];
    // Represent each line by a single unicode character
    NSMutableArray *tempDiffs = [[dmp diff_linesToCharsForFirstString:self andSecondString:stringToMerge] mutableCopy];
    // Do the diff
    NSMutableArray *diffs = [dmp diff_mainOfOldString:tempDiffs[0] andNewString:tempDiffs[1] checkLines:NO];
    // Replace the Unicode characters with the original lines
    [dmp diff_chars:diffs toLines:tempDiffs[2]];
    
    // Construct a new string based on the diffs
    NSMutableString *newString = [[NSMutableString alloc] initWithString:@""];
    
    for (Diff *diff in diffs) {
        [newString appendString:diff.text];
    }
    
    return newString;
}

@end

@implementation NSObject (NumericValueHack)
- (NSNumber *)numericValue {
    if ([self isKindOfClass:[NSNumber class]]) {
        return (NSNumber *)self;
    }
	return nil;
}
@end