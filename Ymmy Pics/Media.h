//
//  Media.h
//  Ymmy Pics
//
//  Created by Diego Cichello on 2/2/15.
//  Copyright (c) 2015 Gustavo Couto. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"

@interface Media : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property PFFile *mediaFile;
@property NSString *caption;
@property User *mediaOwner;


+(void)addMedia:(PFFile *)media fromUser:(User *)user;

@end
