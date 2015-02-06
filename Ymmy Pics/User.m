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
@dynamic numberOfFollowers;
@dynamic numberOfFollows;
@dynamic numberOfPosts;



+ (void)load
{
    [self registerSubclass];
}



+ (User*) currentUser
{
    return (User*)[PFUser currentUser];
}

+ (User*) user
{
    return (User*)[PFUser user];
}


+ (void) retrieveUserWithUserName:(NSString *)text completion:(void (^)(NSArray *array))complete
{
    PFQuery *query = [User query];

    if (![text isEqualToString:@""])
    {
        [query whereKey:@"username" containsString:text];
    }

    NSArray *users = [query findObjects];

    complete(users);

    
}

+ (User *) retrieveUserWithName:(NSString *)name
{
    PFQuery *query = [User query];


    [query whereKey:@"username" containsString:name];


    User *user = (User *)[query getFirstObject];

    return user;
}

+ (void) addPictureInUser:(UIImage *)image
{
    User *user = [self currentUser];

    NSData *imageData = UIImageJPEGRepresentation(image, 0.2f);
    PFFile *file = [PFFile fileWithData:imageData];

    user.profilePictureMedium = file;
    user.profilePictureSmall = file;

    [user saveInBackground];

    
}










@end
