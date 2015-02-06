//
//  ProfileViewController.m
//  Ymmy Pics
//
//  Created by Gustavo Couto on 2015-02-04.
//  Copyright (c) 2015 Gustavo Couto. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileCollectionViewCell.h"
#import "User.h"
#import "Media.h"
#import "Activity.h"

@interface ProfileViewController () <UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *postsLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *profileCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *taskButton;
@property BOOL isButtonFollow;

@property NSArray *images;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];



    self.taskButton.layer.cornerRadius = 10.0f;
    self.taskButton.clipsToBounds = YES;
    self.taskButton.layer.borderWidth= 1.0f;
    self.taskButton.layer.borderColor = [UIColor blueColor].CGColor;

    if (!self.isNotCurrentUser)
    {
        self.user = [User currentUser];
        
    }
    else
    {
        if ([Activity checkIfUserIsFollowing:self.user])
        {
            [self changeButtonToFollowing];

        }
        else
        {
            [self changeButtonToFollow];
        }
    }

    self.imageView.image = [Media getImageFromPFFile:self.user.profilePictureMedium];


    
    self.imageView.layer.cornerRadius = 10.0f;
    self.imageView.clipsToBounds= YES;
    self.imageView.layer.borderWidth = 2.0f;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.borderColor = [UIColor blackColor].CGColor;

    self.navigationItem.title = self.user.username;

    [Media retrieveMediasFromUser:self.user withCompletion:^(NSArray *array){
        self.images = array;
        [self.profileCollectionView reloadData];
    }];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:true];


    [self reloadLabels];

    
}

- (void) reloadLabels
{
    self.postsLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[Media getNumberOfPosts:self.user]];


    self.followingLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[Activity getNumberOfFolloweesFromUser:self.user]];


    self.followersLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[Activity getNumberOfFollowersFromUser:self.user]];
}

- (void) changeButtonToFollow
{
    [self.taskButton setTitle:@"+ Follow" forState:UIControlStateNormal];
    self.taskButton.backgroundColor = [UIColor whiteColor];
    [self.taskButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.taskButton.layer.borderColor = [UIColor blueColor].CGColor;
    self.isButtonFollow = true;
}

- (void) changeButtonToFollowing
{
    [self.taskButton setTitle:@"Following" forState:UIControlStateNormal];
    self.taskButton.backgroundColor = [UIColor blueColor];
    [self.taskButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.taskButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.isButtonFollow = false;
}



- (IBAction)onProfileImageTapped:(id)sender {

    if (!self.isNotCurrentUser)
    {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:picker animated:YES completion:NULL];

    }

}
- (IBAction)onButtonTapped:(id)sender
{
    if (self.isNotCurrentUser)
    {
        if(self.isButtonFollow)
        {
            [Activity followUser:self.user withCompletion:^(BOOL succeeded) {
                if (succeeded)
                {
                    [self changeButtonToFollowing];
                }
            }];
        }
        else
        {
            [Activity unfollowUser:self.user withCompletion:^(BOOL succeeded) {
                if (succeeded)
                {
                    [self changeButtonToFollow];
                }
            }];
        }


    }
    [self reloadLabels];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    [User addPictureInUser:chosenImage];


    [picker dismissViewControllerAnimated:YES completion:NULL];

    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

    Media *media = self.images[indexPath.row];
    cell.imageView.image = [Media getImageFromPFFile:media.mediaFile];

    return cell;
}


@end
