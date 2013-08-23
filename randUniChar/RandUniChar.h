//
//  RandUniChar.h
//  RandUniChar
//
//  Created by azu on 2013/08/22.
//  Copyright (c) 2013 azu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RandUniChar : NSObject

- (NSString *)randomStringInAlphabet:(NSUInteger)length;
- (NSString *)randomStringInJapanese:(NSUInteger) length;
@end
