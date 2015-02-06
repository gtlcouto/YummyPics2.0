//
//  Activity.h
//  Ymmy Pics
//
//  Created by Diego Cichello on 2/2/15.
//  Copyright (c) 2015 Gustavo Couto. All rights reserved.
//

#import <Parse/Parse.h>
#import "User.h"
#import "Media.h"

@interface Activity : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property (retain) User *toUser;
@property (retain) User *fromUser;
@property (retain) Media *media;
@property (retain) NSString *content;
@property (retain) NSString *type;
@property (retain,nonatomic) NSDate *createdAt;
@property (retain,nonatomic) NSDate *updatedAt;



+ (void) likeMedia:(Media *)media;
+ (void) unlikeMedia:(Media *)media;
+ (void) commentOnMedia:(Media *)media withContent:(NSString *)content withCompletion:(void (^)(BOOL succeded))complete;

+ (void) followUser:(User *)toUser withCompletion:(void (^)(BOOL succeeded))complete;
+ (void) unfollowUser:(User *)toUser withCompletion:(void (^)(BOOL succeeded))complete;
+ (void) retrieveAllCommentsFromMedia:(Media *)media withCompletion:(void (^)(NSArray *array))complete;
+ (NSUInteger) getNumberOfFolloweesFromUser:(User *)user;
+ (NSUInteger) getNumberOfFollowersFromUser:(User *)user;
+ (NSUInteger) getNumberOfLikesOnMedia:(Media *)media;
+ (BOOL) checkIfUserIsFollowing:(User *)user;




@end
