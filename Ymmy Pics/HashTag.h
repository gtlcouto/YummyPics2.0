//
//  HashTag.h
//  Ymmy Pics
//
//  Created by Diego Cichello on 2/2/15.
//  Copyright (c) 2015 Gustavo Couto. All rights reserved.
//

#import <Parse/Parse.h>

@interface HashTag : PFObject<PFSubclassing>

@property PFRelation *mediasWithHashTag;
@property NSString *hashTag;

@end
