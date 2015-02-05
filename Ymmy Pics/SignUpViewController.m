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
    User *user = [User currentUser];
    user.username = self.userTextField.text;
    user.password = self.passwordTextField.text;
    user.email = self.emailTextField.text;

    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"%@", errorString);
            // Show the errorString somewhere and let the user try again.
        }

    }];
}

@end
