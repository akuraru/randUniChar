//
//  RandUniCharTests.m
//  RandUniCharTests
//
//  Created by azu on 2013/08/22.
//  Copyright (c) 2013 azu. All rights reserved.
//

#import "RandUniCharTests.h"
#import "RandUniChar.h"

@implementation RandUniCharTests

- (void)setUp {
    [super setUp];

    // Set-up code here.
}

- (void)tearDown {
    // Tear-down code here.

    [super tearDown];
}

- (void)testExample {
    RandUniChar *randUniChar = [[RandUniChar alloc] init];
    for (NSUInteger i = 1; i < 50; i++) {
        NSString *string = [randUniChar randomStringInJapnese:i];
        NSLog(@"string = %@", string);
    }
}

@end
