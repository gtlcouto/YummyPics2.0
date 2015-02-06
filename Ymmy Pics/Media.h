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

@property (retain) PFFile *mediaFile;
@property (retain) NSString *caption;
@property (retain,nonatomic) User *mediaOwner;
@property (retain) UIImage *mediaImage;


+ (void) addMedia:(UIImage *)mediaImage withCaption:(NSString *)caption withCompletion:(void (^)(BOOL succeeded))complete;
+ (void) retrieveFollowedPeopleMedias:(void (^)(NSArray *array))complete;
+ (void) retrieveMediasFromUser:(User*)user withCompletion:(void (^)(NSArray *array))complete;

+(UIImage *)getImageFromPFFile:(PFFile *)file;
- (BOOL) checkIfMediaIsLiked;
+ (NSUInteger) getNumberOfPosts:(User *)user;


@end
