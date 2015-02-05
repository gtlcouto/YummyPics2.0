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
    return (User*)[PFUser currentUser];
}


+ (void) retrieveUserWithUserName:(NSString *)text completion:(void (^)(NSArray *))complete
{
    PFQuery *query = [PFQuery queryWithClassName:@"User"];

    if (![text isEqualToString:@""])
    {
        [query whereKey:@"fromUser" containsString:text];
    }

    NSArray *users = [query findObjects];

    complete(users);

    
}










@end
