//
//  User.m
//  Ymmy Pics
//
//  Created by Diego Cichello on 2/2/15.
//  Copyright (c) 2015 Gustavo Couto. All rights reserved.
//

#import "User.h"

@implementation User

@dynamic firstName;
@dynamic lastName;
@dynamic email;
@dynamic profilePictureMedium;
@dynamic profilePictureSmall;
@dynamic username;
@dynamic password;
@dynamic facebookId;



+ (void)load
{
    [self registerSubclass];
}



+ (User*) currentUser
{
    return (User*)[PFUser user];
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
