//
//  Media.m
//  Ymmy Pics
//
//  Created by Diego Cichello on 2/2/15.
//  Copyright (c) 2015 Gustavo Couto. All rights reserved.
//

#import "Media.h"

@implementation Media

@dynamic mediaFile;
@dynamic caption;
@dynamic mediaOwner;

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"Media";
}

+(void)addMedia:(PFFile *)mediaFile withCaption:(NSString *)caption;
{
    Media *media = [Media object];
    media.mediaFile = mediaFile;
    media.mediaOwner = [User currentUser];
    media.caption = caption;

    [media saveInBackground];


}

+ (void) retrieveFollowedPeopleMedias:(void (^)(NSArray *))complete
{
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
    [query whereKey:@"fromUser" equalTo:[User currentUser]];
    [query whereKey:@"type" equalTo:@"FOLLOW"];

    PFQuery *userQuery = [PFQuery queryWithClassName:@"Media"];
    [userQuery whereKey:@"mediaOwner" matchesKey:@"fromUser" inQuery:query];
    [userQuery addAscendingOrder:@"createdAt"];

    NSArray *mediaFromFollowedPeople  = [userQuery findObjects];

    complete(mediaFromFollowedPeople);
    
    
}




@end
