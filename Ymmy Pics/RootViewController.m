//
//  ViewController.m
//  Ymmy Pics
//
//  Created by Gustavo Couto on 2015-02-02.
//  Copyright (c) 2015 Gustavo Couto. All rights reserved.
//
/*
 ChangeLog
 Feb 2, 2015 - Added Parse Frameworks
 Feb 2, 2015 - Added Facebook SDK
 */


#import "RootViewController.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "User.h"

@interface RootViewController () <FBLoginViewDelegate>

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.




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


- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    NSLog(error.description);
}
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    NSLog(@"%@",user[@"first_name"]);
    User *tempUser = [User currentUser];

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
