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

+ (void) addPictureInUser:(UIImage *)image
{
    User *user = [self currentUser];

    NSData *imageData = UIImagePNGRepresentation(image);
    PFFile *file = [PFFile fileWithData:imageData];

    user.profilePictureMedium = file;
    user.profilePictureSmall = file;

    [user saveInBackground];

    
}










@end
