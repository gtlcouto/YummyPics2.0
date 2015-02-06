//
//  LoginViewController.m
//  Ymmy Pics
//
//  Created by Gustavo Couto on 2015-02-04.
//  Copyright (c) 2015 Gustavo Couto. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>
#import "User.h"
#import "Activity.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)onSignUpButtonPressed:(id)sender {

    [self signup];
    
}


- (void)signup {
    User *user = [User user];
    user.username = self.userTextField.text;
    user.password = self.passwordTextField.text;
    user.email = self.emailTextField.text;
    UIAlertView * signUpAlert = [UIAlertView new];
    [signUpAlert addButtonWithTitle:@"Okay"];


    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {

            signUpAlert.title = @"Sucess!";
            signUpAlert.message = @"Your registration was sucessful, an email has been sent to you to confirm your registration. Please validate your email before attempting to log in";
            [signUpAlert show];
            [Activity followUser:[User currentUser] withCompletion:^(BOOL succeeded) {

            }];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"%@", errorString);
            signUpAlert.title = @"Sorry";
            signUpAlert.message = [NSString stringWithFormat:@"We couldn't complete your registration, %@", errorString];
            [signUpAlert show];
            // Show the errorString somewhere and let the user try again.
            [self dismissViewControllerAnimated:YES completion:nil];
        }

    }];
}

@end
