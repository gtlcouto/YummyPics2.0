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
#import "Media.h"
#import "Activity.h"
#import "DetailTableViewCell.h"
#import "HeaderTableViewCell.h"

@interface RootViewController () <FBLoginViewDelegate,UITableViewDataSource,UITableViewDelegate>


@property NSArray *testArray;
@property (weak, nonatomic) IBOutlet UITableView *newsFeedTableView;


@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    // Do any additional setup after loading the view, typically from a nib.
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
        [cell.likeButton setImage:[UIImage imageNamed:@"likedbar"] forState:UIControlStateNormal];
    }
    else
    {
        [cell.likeButton setImage:[UIImage imageNamed:@"likebar"] forState:UIControlStateNormal];
    }
    cell.likeButton.tag = indexPath.section;
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

    Media *media = self.testArray[sender.tag];

    if (![media checkIfMediaIsLiked])
    {

        [Activity likeMedia:media];
    }
    else
    {

        [Activity unlikeMedia:media];
    }
    NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:sender.tag];
    [self.newsFeedTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *CellIdentifier = @"headerCell";
    HeaderTableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (headerView == nil){
        [NSException raise:@"headerView == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
    }

    Media *media = self.testArray[section];

    headerView.userNameLabel.text = media.mediaOwner.username;
    headerView.customImageView.image = [Media getImageFromPFFile:media.mediaOwner.profilePictureMedium];
    headerView.backgroundColor = [UIColor whiteColor];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0;
}

    @end
