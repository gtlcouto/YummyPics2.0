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


+ (void) addMedia:(UIImage *)mediaImage withCaption:(NSString *)caption;
+ (void) retrieveFollowedPeopleMedias:(void (^)(NSArray *array))complete;
+ (void) retrieveMediasFromUser:(User*)user withCompletion:(void (^)(NSArray *array))complete;

+(UIImage *)getImageFromPFFile:(PFFile *)file;
- (BOOL) checkIfMediaIsLiked;


@end
