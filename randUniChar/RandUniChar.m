//
//  RandUniChar.m
//  RandUniChar
//
//  Created by azu on 2013/08/22.
//  Copyright (c) 2013 azu. All rights reserved.
//

#import "RandUniChar.h"

#define mSharedInstance + (instancetype)sharedInstance {\
    static id _instance;\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance = [self new];\
    });\
    return _instance;\
}
#define cWordStringInheritance(name, from, to) @interface name : WordsString\
@end\
@implementation name \
mSharedInstance\
- (id)init {\
    self = [super init];\
    if (self) {\
[self setRange:(CharMapping){from, to}];\
}\
return self;\
}\
@end

typedef struct {
    const UTF32Char fromChar;
    const UTF32Char toChar;
} CharMapping;

@interface RandString : NSObject {
    NSUInteger length;
}
- (NSString *)nextString;
+ (instancetype)sharedInstance;
- (NSUInteger)length;
- (NSString *)stringFromIndex:(NSInteger)index;
@end
@implementation RandString
+ (instancetype)sharedInstance {
    return nil;
}
- (NSString *)nextString {
    return @"";
}
- (NSUInteger)length {
    return length;
}
- (NSString *)stringFromIndex:(NSInteger)index {
    return @"";
}
@end
@interface WordsString :RandString {
    NSUInteger location;
}
- (void)setRange:(CharMapping)charMapping;
@end
@implementation WordsString
- (void)setRange:(CharMapping)charMapping {
    location = charMapping.fromChar;
    length = charMapping.toChar - charMapping.fromChar + 1;
}
- (NSRange)rangeValue {
    return NSMakeRange(location, length);
}
- (NSString *)nextString {
    return [self stringFromIndex:[self randomIndex]];
}
- (NSInteger)randomIndex {
    return (arc4random_uniform(length));
}

- (NSString *)stringFromIndex:(NSInteger)index {
    UniChar uniChar = index + location;
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
@interface SetString : RandString {
    NSArray *words;
}
- (void)setWords:(NSArray *)w;
@end
@implementation SetString
- (NSString *)nextString {
    return [self stringFromIndex:arc4random_uniform(length)];
}
- (NSString *)stringFromIndex:(NSInteger)index {
    for (RandString *rs in words) {
        if (index < rs.length) {
            return [rs stringFromIndex:index];
        } else {
            index -= rs.length;
        }
    }
    return @"";
}
- (void)setWords:(NSArray *)w {
    words = w;
    length = [self sumLength:w];
}
- (NSInteger)sumLength:(NSArray *)w {
    NSInteger l = 0;
    for (RandString *rs in w) {
        l += [rs length];
    }
    return l;
}
@end
cWordStringInheritance(Hiragana, 0x3041, 0x3093)
cWordStringInheritance(Katakana, 0x30A1, 0x30F6)
cWordStringInheritance(Kanji1, 0x3220, 0x3244)
cWordStringInheritance(Kanji2, 0x3280, 0x32B0)
cWordStringInheritance(Kanji3, 0x3400, 0x9FFF)
cWordStringInheritance(Kanji4, 0xF900, 0xFAFF)
cWordStringInheritance(Kanji5, 0x20000, 0x2FFFF)

@interface Japanese : SetString
@end
@implementation Japanese
mSharedInstance
- (id)init {
    self = [super init];
    if (self) {
        [self setWords:@[
         [Hiragana sharedInstance],
         [Katakana sharedInstance],
         [Kanji1 sharedInstance],
         [Kanji2 sharedInstance],
         [Kanji3 sharedInstance],
         [Kanji4 sharedInstance],
         [Kanji5 sharedInstance],
        ]];
    }
    return self;
}
@end

@implementation RandUniChar
- (NSString *)randomStringInJapanese:(NSUInteger) length {
    RandString *arrayRange = [Japanese sharedInstance];
    // FIXME: Doesn't actually random
    NSMutableString *results = [NSMutableString string];
    for (NSUInteger i = 0; i < length; i++) {
        NSString *s = [arrayRange nextString];
        if (s.length == 1) {
            [results appendString:s];
        } else {
            i--;
        }
    }
    return results;
}
@end
