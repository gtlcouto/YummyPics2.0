//
//  HashTag.h
//  Ymmy Pics
//
//  Created by Gustavo Couto on 2015-02-06.
//  Copyright (c) 2015 Gustavo Couto. All rights reserved.
//

#import <Parse/Parse.h>
#import "Media.h"

@interface HashTag : PFObject<PFSubclassing>

@property (retain,nonatomic) NSString *hashTag;
@property (retain,nonatomic) PFRelation *mediasWithHashTag;
@property (retain,nonatomic) NSDate *createdAt;
@property (retain,nonatomic) NSDate *updatedAt;

+ (NSString *)parseClassName;

+ (void) retrieveHashTagsWithText:(NSString *)text  withCompletion:(void (^)(NSArray *array))complete;
+ (HashTag *)retrieveHashTagWithName:(NSString *)name;
+ (void) searchForHashTag:(NSString *)text onMedia:(Media *)media;

@end
