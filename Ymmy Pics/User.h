//
//  User.h
//  Ymmy Pics
//
//  Created by Diego Cichello on 2/2/15.
//  Copyright (c) 2015 Gustavo Couto. All rights reserved.
//

#import <Parse/Parse.h>

@interface User : PFUser<PFSubclassing>


@property (retain) NSString *firstName;
@property (retain) NSString *lastName;
@property (retain) NSString *facebookId;
@property (retain) PFFile *profilePictureMedium;
@property (retain) PFFile *profilePictureSmall;
@property (retain) NSNumber *numberOfPosts;
@property (retain) NSNumber *numberOfFollows;
@property (retain) NSNumber *numberOfFollowers;

+ (void) retrieveUserWithUserName:(NSString *)text completion:(void (^)(NSArray *array))complete;
+ (User *) retrieveUserWithName:(NSString *)name;
+ (void) addPictureInUser:(UIImage *)image;

+ (User*) user;



@end
