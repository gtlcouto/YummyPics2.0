//
//  TakePhotoViewController.m
//  Ymmy Pics
//
//  Created by Gustavo Couto on 2015-02-04.
//  Copyright (c) 2015 Gustavo Couto. All rights reserved.
//

#import "TakePhotoViewController.h"
#import "DBCameraViewController.h"
#import "DBCameraContainerViewController.h"
#import "DBCameraLibraryViewController.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "Media.h"

@interface TakePhotoViewController () <DBCameraViewControllerDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property BOOL isImageAdded;

@end

@implementation TakePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.delegate = self;
    self.textView.text = @"Write a caption...";
    self.textView.textColor = [UIColor lightGrayColor];
    self.textView.layer.borderWidth = 1.0f;
    self.textView.layer.borderColor = [UIColor grayColor].CGColor;
    self.textView.layer.cornerRadius = 10.0f;
    self.textView.clipsToBounds = YES;
    self.isImageAdded = true;


}
-(void)viewDidAppear:(BOOL)animated
{
    if (self.isImageAdded)
    {
        self.isImageAdded = false;
        [self openCamera];
    }



}


- (void) openCamera
{
    DBCameraContainerViewController *cameraContainer = [[DBCameraContainerViewController alloc] initWithDelegate:self];
    [cameraContainer setFullScreenMode];

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cameraContainer];
    [nav setNavigationBarHidden:YES];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void) openCameraWithoutSegue
{
    DBCameraViewController *cameraController = [DBCameraViewController initWithDelegate:self];
    [cameraController setUseCameraSegue:NO];

    DBCameraContainerViewController *container = [[DBCameraContainerViewController alloc] initWithDelegate:self];
    [container setCameraViewController:cameraController];
    [container setFullScreenMode];

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:container];
    [nav setNavigationBarHidden:YES];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void) openCameraWithoutContainer
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[DBCameraViewController initWithDelegate:self]];
    [nav setNavigationBarHidden:YES];
    [self presentViewController:nav animated:YES completion:nil];
}

//Use your captured image
#pragma mark - DBCameraViewControllerDelegate

- (void) camera:(id)cameraViewController didFinishWithImage:(UIImage *)image withMetadata:(NSDictionary *)metadata
{
    self.imageView.image=image;
    [cameraViewController restoreFullScreenMode];
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];

}

- (void) dismissCamera:(id)cameraViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
    [cameraViewController restoreFullScreenMode];
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
    self.isImageAdded = true;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Write a caption..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Write a caption...";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

- (void) openCameraWithForceQuad
{
    DBCameraViewController *cameraController = [DBCameraViewController initWithDelegate:self];
    [cameraController setForceQuadCrop:YES];

    DBCameraContainerViewController *container = [[DBCameraContainerViewController alloc] initWithDelegate:self];
    [container setCameraViewController:cameraController];
    [container setFullScreenMode];

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:container];
    [nav setNavigationBarHidden:YES];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void) openLibrary
{
    DBCameraLibraryViewController *vc = [[DBCameraLibraryViewController alloc] init];
    [vc setDelegate:self]; //DBCameraLibraryViewController must have a DBCameraViewControllerDelegate object
    //    [vc setForceQuadCrop:YES]; //Optional
    //    [vc setUseCameraSegue:YES]; //Optional
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [nav setNavigationBarHidden:YES];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)onPostButtonPressed:(id)sender
{
    [Media addMedia:self.imageView.image withCaption:self.textView.text withCompletion:^(BOOL succeeded) {
        [self.textView resignFirstResponder];
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
        self.isImageAdded = true;
    }];


}



@end
