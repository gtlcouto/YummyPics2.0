//
//  Activity.m
//  Ymmy Pics
//
//  Created by Diego Cichello on 2/2/15.
//  Copyright (c) 2015 Gustavo Couto. All rights reserved.
//

#import "Activity.h"

@implementation Activity



@dynamic toUser;
@dynamic fromUser;
@dynamic createdAt;
@dynamic updatedAt;
@dynamic media;
@dynamic content;
@dynamic type;

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"Activity";
}


+ (void) retrieveAllCommentsFromMedia:(Media *)media withCompletion:(void (^)(NSArray *array))complete
{
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];

    [query whereKey:@"media" equalTo:media];
    [query whereKey:@"type" equalTo:@"COMMENT"];


    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        complete(objects);
    }];
}


+ (BOOL) checkIfUserIsFollowing:(User *)user
{
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];

    [query whereKey:@"toUser" equalTo:user];
    [query whereKey:@"fromUser" equalTo:[User currentUser]];
    [query whereKey:@"type" equalTo:@"FOLLOW"];

    if ([query getFirstObject])
    {
        return true;
    }
    else
    {
        return false;
    }

}


+ (void) likeMedia:(Media *)media
{
    Activity *activity = [Activity object];
    activity.fromUser = [User currentUser];
    activity.toUser = media.mediaOwner;
    activity.type = @"LIKE";
    activity.media = media;

    [activity saveInBackground];
}

+ (void) unlikeMedia:(Media *)media
{
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];


    [query whereKey:@"fromUser" equalTo:[User currentUser]];
    [query whereKey:@"type" equalTo:@"LIKE"];
    [query whereKey:@"media" equalTo:media];


    Activity *activity = (Activity *)[query getFirstObject];

    [activity deleteInBackground];
}

+ (void)followUser:(User *)toUser withCompletion:(void (^)(BOOL succeeded))complete
{
    Activity *activity = [Activity object];
    activity.toUser = toUser;
    activity.fromUser = [User currentUser];
    activity.type = @"FOLLOW"; // ActivityTypeFollow





    [activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            complete(true);
        }
        else
        {
            complete(false);
        }
    }];

}

+ (void)getAllYourActivitiesWithBlock:(void (^)(BOOL succeeded))complete
{
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];

    [query whereKey:@"toUser" equalTo:[User currentUser]];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

    }];
}

+ (void)unfollowUser:(User *)toUser withCompletion:(void (^)(BOOL succeeded))complete
{
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];

    [query whereKey:@"toUser" equalTo:toUser];
    [query whereKey:@"fromUser" equalTo:[User currentUser]];
    [query whereKey:@"type" equalTo:@"FOLLOW"];

    Activity *activity = (Activity *)[query getFirstObject];



    [activity deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (succeeded)
        {
            complete(true);
        }
        else
        {
            complete(false);
        }
    }];
}

+ (NSUInteger) getNumberOfFolloweesFromUser:(User *)user
{
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];

    [query whereKey:@"fromUser" equalTo:user];
    [query whereKey:@"type" equalTo:@"FOLLOW"];

    return [query findObjects].count;

}



+ (NSUInteger) getNumberOfFollowersFromUser:(User *)user
{
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];

    [query whereKey:@"toUser" equalTo:user];
    [query whereKey:@"type" equalTo:@"FOLLOW"];

    return [query findObjects].count;

}

+ (NSUInteger) getNumberOfLikesOnMedia:(Media *)media
{
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];

    [query whereKey:@"media" equalTo:media];
    [query whereKey:@"type" equalTo:@"LIKE"];

    return [query findObjects].count;
}

+ (void) commentOnMedia:(Media *)media withContent:(NSString *)content withCompletion:(void (^)(BOOL succeded))complete
{
    Activity *activity = [Activity object];
    activity.fromUser = [User currentUser];
    activity.media = media;
    activity.toUser = media.mediaOwner;
    activity.content = content;
    activity.type = @"COMMENT";

    [activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            complete(true);
        }
        else
        {
            complete(false);
        }
    }];

}

+ (void) deleteCommentOnMedia:(Media *)media withContent:(NSString *)content
{
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
    [query whereKey:@"fromUser" equalTo:[User currentUser]];
    [query whereKey:@"content" equalTo:content];
    [query whereKey:@"type" equalTo:@"COMMENT"];

    Activity *activity  = (Activity *)[query getFirstObject];

    [activity deleteInBackground];
}

+ (void) editCommentOnMedia:(Media *)media withOldContent:(NSString *)oldContent andNewContent:(NSString *)newContent
{
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
    [query whereKey:@"fromUser" equalTo:[User currentUser]];
    [query whereKey:@"content" equalTo:oldContent];
    [query whereKey:@"type" equalTo:@"COMMENT"];

    Activity *activity  = (Activity *)[query getFirstObject];
    activity.content = newContent;

    [activity saveInBackground];
}









@end
