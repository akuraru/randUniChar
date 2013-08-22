//
//  RandUniChar.m
//  RandUniChar
//
//  Created by azu on 2013/08/22.
//  Copyright (c) 2013 azu. All rights reserved.
//

#import "RandUniChar.h"

@implementation RandUniChar
typedef struct {
    const UTF32Char fromChar;
    const UTF32Char toChar;
} CharMapping;

- (NSString *)randomStringInJapanese:(NSUInteger) length {
    NSArray *arrayRange = [self japaneseRangeArray];
    // FIXME: Doesn't actually random
    NSMutableString *results = [NSMutableString string];
    for (NSUInteger i = 0; i < length; i++) {
        NSRange pickupRange = [arrayRange[arc4random_uniform([arrayRange count])] rangeValue];
        UniChar uniChar = [self randomUniCharFromRange:pickupRange];
        [results appendString:[self stringFromUniChar:uniChar]];
    }
    return results;
}

- (NSArray *)japaneseRangeArray {
    NSArray *arrayRanges = @[
        [self kanjiRangeArray],
        [self katakanaRangeArray],
        [self hiraganaRangeArray]
    ];
    NSMutableArray *flattedArray = [NSMutableArray array];
    for (NSArray *array in arrayRanges) {
        [flattedArray addObjectsFromArray:array];
    }
    return flattedArray;
}

// http://tama-san.com/?p=196
- (NSArray *)kanjiRangeArray {
    CharMapping mapping_array[] = {
        {0x3220, 0x3244},
        {0x3280, 0x32B0},
        {0x3400, 0x9FFF},
        {0xF900, 0xFAFF},
        {0x20000, 0x2FFFF},// surrogate pair
    };
    return [self arrayRangeForCharMapping:mapping_array size:sizeof(mapping_array) / sizeof(mapping_array[0])];
}

// https://sites.google.com/site/michinobumaeda/misc/unicodecodechars
- (NSArray *)katakanaRangeArray {
    CharMapping mapping_array[] = {
        {0x30A1, 0x30F6}
    };
    return [self arrayRangeForCharMapping:mapping_array size:sizeof(mapping_array) / sizeof(mapping_array[0])];

}

- (NSArray *)hiraganaRangeArray {
    CharMapping mapping_array[] = {
        {0x3041, 0x3093},
    };
    return [self arrayRangeForCharMapping:mapping_array size:sizeof(mapping_array) / sizeof(mapping_array[0])];
}

#pragma mark -

- (NSArray *)arrayRangeForCharMapping:(CharMapping *) mapping_array size:(int) size {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < size; i++) {
        NSRange range = [self rangeForCharMapping:mapping_array[i]];
        [array addObject:[NSValue valueWithRange:range]];
    }
    return array;
}

- (NSRange)rangeForCharMapping:(CharMapping) charMapping {
    return [self rangeOfUniCharFrom:(UniChar)charMapping.fromChar toChar:(UniChar)charMapping.toChar];
}

- (NSRange)rangeOfUniCharFrom:(UniChar) formChar toChar:(UniChar) toChar {
    return NSMakeRange(formChar, toChar - formChar);
}

- (UniChar)randomUniCharFromRange:(NSRange) uniCharRange {
    return (UniChar)((arc4random() % uniCharRange.length) + uniCharRange.location);
}

- (NSString *)stringFromUniChar:(UniChar) uniChar {
    // FIXME: wrong???
    if (CFStringIsSurrogateHighCharacter(uniChar) ||
        CFStringIsSurrogateLowCharacter(uniChar)) {
        UTF32Char inputChar = uniChar;// my UTF-32 character
        inputChar -= 0x10000;
        unichar highSurrogate = (unichar)(inputChar >> 10); // leave the top 10 bits
        highSurrogate += 0xD800;
        unichar lowSurrogate = (unichar)(inputChar & 0x3FF); // leave the low 10 bits
        lowSurrogate += 0xDC00;
        return [NSString stringWithCharacters:(unichar[]){highSurrogate, lowSurrogate} length:2];
    }
    return [NSString stringWithCharacters:&uniChar length:1];
}
@end
