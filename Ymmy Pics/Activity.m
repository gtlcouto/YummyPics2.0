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

+ (void)followUser:(User *)toUser
{
    Activity *activity = [Activity object];
    activity.toUser = toUser;
    activity.fromUser = [User currentUser];
    activity.type = @"FOLLOW"; // ActivityTypeFollow

    [activity save];

}

+ (void)unfollowUser:(User *)toUser
{
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];

    [query whereKey:@"toUser" equalTo:toUser];
    [query whereKey:@"fromUser" equalTo:[User currentUser]];
    [query whereKey:@"type" equalTo:@"FOLLOW"];

    Activity *activity = [query getFirstObject];

    [activity deleteInBackground];
}

+ (void) commentOnMedia:(Media *)media withContent:(NSString *)content
{
    Activity *activity = [Activity object];
    activity.fromUser = [User currentUser];
    activity.media = media;
    activity.toUser = media.mediaOwner;
    activity.content = content;
    activity.type = @"COMMENT";

    [activity save];

}

+ (void) deleteCommentOnMedia:(Media *)media withContent:(NSString *)content
{
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
    [query whereKey:@"fromUser" equalTo:[User currentUser]];
    [query whereKey:@"content" equalTo:content];
    [query whereKey:@"type" equalTo:@"COMMENT"];

    Activity *activity  = [query getFirstObject];

    [activity deleteInBackground];
}

+ (void) editCommentOnMedia:(Media *)media withOldContent:(NSString *)oldContent andNewContent:(NSString *)newContent
{
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
    [query whereKey:@"fromUser" equalTo:[User currentUser]];
    [query whereKey:@"content" equalTo:oldContent];
    [query whereKey:@"type" equalTo:@"COMMENT"];

    Activity *activity  = [query getFirstObject];
    activity.content = newContent;

    [activity saveInBackground];
}









@end
