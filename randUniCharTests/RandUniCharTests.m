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
@end

@interface RandString : NSObject {
    NSUInteger length;
}
- (NSString *)nextString;
+ (instancetype)sharedInstance;
- (NSString *)stringFromIndex:(NSInteger)index;
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
@interface CaptalAlphabet : WordsString
@end
@interface LowerCaseAlphabet : WordsString
@end


@implementation RandUniCharTests {
    RandUniChar *randUniChar;
}

- (void)setUp {
    [super setUp];
    
    randUniChar = [[RandUniChar alloc] init];
}

- (NSString *)firstString:(NSRange)range instance:(RandString *)instance {
    return [instance stringFromIndex:0];
}
- (NSString *)lastString:(NSRange)range instance:(RandString *)instance {
    return [instance stringFromIndex:(range.length - 1)];
}

//- (void)testExample {
//    for (NSUInteger i = 1; i < 50; i++) {
//        NSString *string = [randUniChar randomStringInJapanese:i];
//        printf("len : %d , string = %s\n",i , [string UTF8String]);
//        STAssertEquals(string.length, i, @"same length");
//    }
//}
//- (void)testAlphabet {
//    for (NSUInteger i = 1; i < 50; i++) {
//        NSString *string = [randUniChar randomStringInAlphabet:i];
//        printf("len : %d , string = %s\n",i , [string UTF8String]);
//        STAssertEquals(string.length, i, @"same length");
//    }
//}

- (void)testFirstHiragana {
    WordsString *instance = [Hiragana sharedInstance];
    NSRange range = [instance rangeValue];
    NSString *result = [self firstString:range instance:instance];
    STAssertEqualObjects(result, @"ぁ", @"first Hiragana");
}
- (void)testLastHiragana {
    WordsString *instance = [Hiragana sharedInstance];
    NSRange range = [instance rangeValue];
    NSString *result = [self lastString:range instance:instance];
    STAssertEqualObjects(result, @"ん", @"last Hiragana");
}
- (void)testFirstKatakana {
    WordsString *instance = [Katakana sharedInstance];
    NSRange range = [instance rangeValue];
    NSString *result = [self firstString:range instance:instance];
    STAssertEqualObjects(result, @"ァ", @"first Katakana");
}
- (void)testLastKatakana {
    WordsString *instance = [Katakana sharedInstance];
    NSRange range = [instance rangeValue];
    NSString *result = [self lastString:range instance:instance];
    STAssertEqualObjects(result, @"ヶ", @"last Katakana");
}
//常用漢字
- (void)testFirstKanji {
    WordsString *instance = [Kanji3 sharedInstance];
    NSRange range = [instance rangeValue];
    NSString *result = [self firstString:range instance:instance];
    STAssertEqualObjects(result, @"㐀", @"first Kanji");
}

- (void)testFirstCaptalAlphabet {
    WordsString *instance = [CaptalAlphabet sharedInstance];
    NSRange range = [instance rangeValue];
    NSString *result = [self firstString:range instance:instance];
    STAssertEqualObjects(result, @"A", @"first CaptalAlphabet");
}
- (void)testLastCaptalAlphabet {
    WordsString *instance = [CaptalAlphabet sharedInstance];
    NSRange range = [instance rangeValue];
    NSString *result = [self lastString:range instance:instance];
    STAssertEqualObjects(result, @"Z", @"last CaptalAlphabet");
}
- (void)testFirstLowerCaseAlphabet {
    WordsString *instance = [LowerCaseAlphabet sharedInstance];
    NSRange range = [instance rangeValue];
    NSString *result = [self firstString:range instance:instance];
    STAssertEqualObjects(result, @"a", @"first LowerCaseAlphabet");
}
- (void)testLastLowerCaseAlphabet {
    WordsString *instance = [LowerCaseAlphabet sharedInstance];
    NSRange range = [instance rangeValue];
    NSString *result = [self lastString:range instance:instance];
    STAssertEqualObjects(result, @"z", @"last LowerCaseAlphabet");
}


@end
