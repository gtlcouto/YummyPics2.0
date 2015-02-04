//
//  HashTag.m
//  Ymmy Pics
//
//  Created by Diego Cichello on 2/2/15.
//  Copyright (c) 2015 Gustavo Couto. All rights reserved.
//

#import "HashTag.h"

@implementation HashTag

@dynamic mediasWithHashTag;
@dynamic hashTag;

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"HashTag";
}

@end
