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
#import "CommentsViewController.h"
#import "HashTagViewController.h"
#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "User.h"
#import "Media.h"
#import "Activity.h"
#import "DetailTableViewCell.h"
#import "HeaderTableViewCell.h"

@interface RootViewController () <FBLoginViewDelegate,UITableViewDataSource,UITableViewDelegate>


@property NSArray *testArray;
@property NSMutableArray *imagesArray;
@property (weak, nonatomic) IBOutlet UITableView *newsFeedTableView;


@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
//    // Do any additional setup after loading the view, typically from a nib.
//    [Media retrieveFollowedPeopleMedias:^(NSArray *array) {
//        self.testArray = array;
//        [self.newsFeedTableView reloadData];
//    }];
    self.imagesArray = [NSMutableArray new];



}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:true];
    [Media retrieveFollowedPeopleMedias:^(NSArray *array) {
        self.testArray = array;


        [self.newsFeedTableView reloadData];
    }];

}

#pragma mark - TableView Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"detailCell";
    DetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Media *media = self.testArray[indexPath.section];

    if ([media checkIfMediaIsLiked])
    {
        [cell.likeButton setImage:[UIImage imageNamed:@"Likedbar"] forState:UIControlStateNormal];
    }
    else
    {
        [cell.likeButton setImage:[UIImage imageNamed:@"likebar"] forState:UIControlStateNormal];
    }

    cell.captionTextField.text = media.caption;
    cell.likesLabel.text = [NSString stringWithFormat:@"%lu likes",(unsigned long)[Activity getNumberOfLikesOnMedia:media]];

    [cell.captionTextField setDetectionBlock:^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
       

        if (hotWord == STTweetHashtag)
        {
            [self performSegueWithIdentifier:@"HashTagSegue" sender:string];
        }
        else if (hotWord == STTweetHandle)
        {
            [self performSegueWithIdentifier:@"ProfileSegue" sender:string];
        }

    }];

    cell.likeButton.tag = indexPath.section;
    cell.commentButton.tag = indexPath.section;
    
    cell.customImageView.image = [Media getImageFromPFFile:media.mediaFile];
    if (cell == nil){
        [NSException raise:@"headerView == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
    }


    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.testArray.count;
}


- (IBAction)onLikeButtonPressed:(UIButton *)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:sender.tag];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];

    Media *media = self.testArray[sender.tag];

    if (![media checkIfMediaIsLiked])
    {

        [Activity likeMedia:media];
    }
    else
    {

        [Activity unlikeMedia:media];
    }

    [self.newsFeedTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *CellIdentifier = @"headerCell";
    HeaderTableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (headerView == nil){
        [NSException raise:@"headerView == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
    }

    Media *media = self.testArray[section];

    User *user = (User *)[[User query] getObjectWithId:media.mediaOwner.objectId];


    headerView.userNameLabel.text = user.username ;
    headerView.customImageView.image = [Media getImageFromPFFile:user.profilePictureMedium];

    headerView.timeStampLabel.text = [self getDateString:media];

    headerView.backgroundColor = [UIColor whiteColor];
    return headerView;
}

- (NSString *) getDateString:(Media *)media
{
    NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:media.createdAt];

    if (secondsBetween <60)
    {
        return [NSString stringWithFormat:@"%.0fs",secondsBetween];
    }
    else if (secondsBetween< 3600)
    {
        return [NSString stringWithFormat:@"%.0fm",secondsBetween/60];
    }
    else if (secondsBetween<86400)
    {
        return [NSString stringWithFormat:@"%.0fh",secondsBetween/3600];
    }
    else
    {
        return [NSString stringWithFormat:@"%.0fd",secondsBetween/86400];
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"HashTagSegue"])
    {
        HashTagViewController *vc = segue.destinationViewController;
        NSString *string = sender;
        string = [string stringByReplacingOccurrencesOfString:@"#" withString:@""];


        vc.hashTag = [HashTag retrieveHashTagWithName:string];
    }
    else if ([segue.identifier isEqualToString:@"ProfileSegue"])
    {
        ProfileViewController *vc = segue.destinationViewController;
        NSString *string = sender;
        string = [string stringByReplacingOccurrencesOfString:@"@" withString:@""];

        vc.user = [User retrieveUserWithName:string];
        if ([vc.user isEqual:[User currentUser]])
        {
            vc.isNotCurrentUser = false;
        }
        else
        {
            vc.isNotCurrentUser = true;
        }
    }
    else
    {
    UIButton *button = sender;
    CommentsViewController *vc = segue.destinationViewController;
    vc.media = self.testArray[button.tag];
    }
}

    @end
