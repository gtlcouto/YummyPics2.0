//
//  FacebookViewController.m
//  Ymmy Pics
//
//  Created by Diego Cichello on 2/4/15.
//  Copyright (c) 2015 Gustavo Couto. All rights reserved.
//

#import "FacebookViewController.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "User.h"

@interface FacebookViewController() <FBLoginViewDelegate>





@end

@implementation FacebookViewController


- (void) viewDidLoad
{
    [super viewDidLoad];
    //    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    //    testObject[@"foo"] = @"bar";
    //    [testObject saveInBackground];
    //
    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile", @"email",]];
    loginView.center = self.view.center;
    [self.view addSubview:loginView];





    // facebook login delegate
    loginView.delegate = self;

}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    NSLog(@"Hello");
    
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    NSLog(error.description);
}
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    NSLog(@"%@",user[@"first_name"]);




//    PFQuery *query = [User query];
//
//    [query whereKey:@"email" equalTo:user[@"email"]];
//
//    NSArray *users = [query findObjects];
//    User *newUser = users.firstObject;




    User *tempUser = [User currentUser];

    NSLog(@"My user name is %@",tempUser.firstName);

    tempUser.firstName = user[@"first_name"];
    tempUser.lastName = user[@"last_name"];
    tempUser.email = user[@"email"];
    tempUser.facebookId = user[@"id"];








    NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=normal", user[@"id"]]];
    NSURL *pictureURLSmall = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=small", user[@"id"]]];
    NSData *imageData = [NSMutableData dataWithContentsOfURL:pictureURL];
    NSData *imageData2 = [NSMutableData dataWithContentsOfURL:pictureURLSmall];

    tempUser.profilePictureMedium = [PFFile fileWithData:imageData];
    tempUser.profilePictureSmall = [PFFile fileWithData:imageData2];
    tempUser.username = @"test908";
    tempUser.password = @"blabla";


    [tempUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            NSLog(@"Worked!");
        }
        else
        {
            NSLog(error.description);
        }
    }];
    
    
    
    
    

}

@end
