//
//  LoginViewController.m
//  Ymmy Pics
//
//  Created by Gustavo Couto on 2015-02-04.
//  Copyright (c) 2015 Gustavo Couto. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "User.h"
#import "Activity.h"
#import "HashTag.h"


@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}
//UNCOMMENT THS WHEN LOGIN IS DONE
-(void)viewDidAppear:(BOOL)animated
{
    

    User *currentUser = [User currentUser];
    if (currentUser) {
        [self performSegueWithIdentifier:@"toTabSegue" sender:nil];
    }
}
- (IBAction)onForgotPasswordButtonPressed:(id)sender {

    UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"Enter Your Email" message:nil preferredStyle:UIAlertControllerStyleAlert];

    [alertcontroller addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        nil;
    }];

    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Okay"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   UITextField * textField = alertcontroller.textFields.firstObject;
                                   [PFUser requestPasswordResetForEmailInBackground:textField.text];



                               }];


    [alertcontroller addAction:okAction];

    [self presentViewController:alertcontroller animated:YES completion:^{
        nil;
    }];

}

- (IBAction)onLoginButtonPressed:(id)sender {
        // show the signup or login screen
    NSString * username = [NSString stringWithFormat:@"%@", self.userTextField.text];
    NSString * password = [NSString stringWithFormat:@"%@", self.passwordTextField.text];
    UIAlertView * loginAlert = [UIAlertView new];
    loginAlert.title = @"Login Failed";
    [loginAlert addButtonWithTitle:@"Okay"];


    [User logInWithUsernameInBackground:username password:password
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            if (![[user objectForKey:@"emailVerified"] boolValue]) {
                                                // Refresh to make sure the user did not recently verify
                                                [user fetch];
                                                if (![[user objectForKey:@"emailVerified"] boolValue]) {
                                                    loginAlert.message = @"Please Verify your email before logging in";
                                                    [loginAlert show];
                                                    return;
                                                }
                                            }
                                             [self performSegueWithIdentifier:@"toTabSegue" sender:nil];
                                        } else {
                                            NSLog(@"%@", error.description);

                                            loginAlert.message = @"Username or password not corrent, please try again or sign up!";
                                            [loginAlert show];
                                        }
                                    }];

}



@end
