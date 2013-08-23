//
//  RandUniCharTests.m
//  RandUniCharTests
//
//  Created by azu on 2013/08/22.
//  Copyright (c) 2013 azu. All rights reserved.
//

#import "RandUniCharTests.h"
#import "RandUniChar.h"

@interface RandUniChar ()
- (NSArray *)hiraganaRangeArray;
- (NSArray *)katakanaRangeArray;
- (NSArray *)kanjiRangeArray;
- (NSString *)stringFromUniChar:(UniChar)uniChar;
@end

@interface RandString : NSObject {
    NSUInteger length;
}
- (NSString *)nextString;
+ (instancetype)sharedInstance;
@end
@interface WordsString :RandString {
    NSUInteger location;
}
- (NSRange)rangeValue;
@end
@interface Hiragana : WordsString
@end
@interface Katakana : WordsString
@end
@interface Kanji3 : WordsString
@end

@implementation RandUniCharTests {
    RandUniChar *randUniChar;
}

- (void)setUp {
    [super setUp];
    
    randUniChar = [[RandUniChar alloc] init];
}

- (NSString *)firstString:(NSRange)range {
    return [randUniChar stringFromUniChar:range.location];
}
- (NSString *)lastString:(NSRange)range {
    return [randUniChar stringFromUniChar:(range.location + range.length - 1)];
}

- (void)testExample {
    for (NSUInteger i = 1; i < 50; i++) {
        NSString *string = [randUniChar randomStringInJapanese:i];
        NSLog(@"string = %@", string);
        STAssertEquals(string.length, i, @"same length");
    }
}

- (void)testFirstHiragana {
    NSRange range = [[Hiragana sharedInstance] rangeValue];
    NSString *result = [self firstString:range];
    STAssertEqualObjects(result, @"ぁ", @"first Hiragana");
}
- (void)testLastHiragana {
    NSRange range = [[Hiragana sharedInstance] rangeValue];
    NSString *result = [self lastString:range];
    STAssertEqualObjects(result, @"ん", @"last Hiragana");
}
- (void)testFirstKatakana {
    NSRange range = [[Katakana sharedInstance] rangeValue];
    NSString *result = [self firstString:range];
    STAssertEqualObjects(result, @"ァ", @"first Katakana");
}
- (void)testLastKatakana {
    NSRange range = [[Katakana sharedInstance] rangeValue];
    NSString *result = [self lastString:range];
    STAssertEqualObjects(result, @"ヶ", @"last Katakana");
}
//常用漢字
- (void)testFirstKanji {
    NSRange range = [[Kanji3 sharedInstance] rangeValue];
    NSString *result = [self firstString:range];
    STAssertEqualObjects(result, @"㐀", @"first Kanji");
}


@end
