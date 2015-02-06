//
//  SearchViewController.m
//  Ymmy Pics
//
//  Created by Gustavo Couto on 2015-02-04.
//  Copyright (c) 2015 Gustavo Couto. All rights reserved.
//

#import "SearchViewController.h"
#import "UserSearchTableViewCell.h"
#import "ProfileViewController.h"
#import "HashTagViewController.h"
#import "User.h"
#import "Media.h"
#import "Activity.h"
#import "HashTag.h"

@interface SearchViewController () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITableView *hashTagTableView;
@property BOOL isUserSearch;

@property NSArray *searchUsersArray;
@property NSArray *searchHashTagsArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hashTagRight;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isUserSearch = true;
    [User retrieveUserWithUserName:self.searchBar.text completion:^(NSArray *array) {
        self.searchUsersArray = array;
        [self.tableView reloadData];
    }];
    [HashTag retrieveHashTagsWithText:self.searchBar.text withCompletion:^(NSArray *array) {
        self.searchHashTagsArray = array;
        [self.hashTagTableView reloadData];
        self.isUserSearch = false;
    }];


}

- (IBAction)onSegmentViewControlChanged:(UISegmentedControl*)sender
{
    if (sender.selectedSegmentIndex == 0)
    {


        [UIView animateWithDuration:0.5 animations:^{
            self.leftContraint.constant = -16;
            self.rightConstraint.constant = -16;
            self.hashTagRight.constant = -416;
            [self.view layoutIfNeeded];
        }];
    }
    else if (sender.selectedSegmentIndex == 1)
    {

        [UIView animateWithDuration:0.5 animations:^{
            self.leftContraint.constant = -416;
            self.rightConstraint.constant = 368;
            self.hashTagRight.constant = -16;
            [self.view layoutIfNeeded];
        }];
    }
    [self.tableView reloadData];
    [self.hashTagTableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (tableView.tag == 0)
    {

        UserSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell"];


        User *user = [self.searchUsersArray objectAtIndex:indexPath.row];

        cell.usernameLabel.text = user.username;
        cell.profileImageView.image = [Media getImageFromPFFile:user.profilePictureMedium];
        cell.profileImageView.layer.cornerRadius = 3.0;
        cell.profileImageView.clipsToBounds = true;
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HashCell"];
        HashTag *hashTag = [self.searchHashTagsArray objectAtIndex:indexPath.row];
        cell.textLabel.text = hashTag.hashTag;
        return cell;
    }



}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==0)
    {
        return self.searchUsersArray.count;
    }
    else
    {
        return self.searchHashTagsArray.count;
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [User retrieveUserWithUserName:[self.searchBar.text lowercaseString] completion:^(NSArray *array) {
        self.searchUsersArray = array;
        [self.tableView reloadData];
    }];
    [HashTag retrieveHashTagsWithText:[self.searchBar.text lowercaseString] withCompletion:^(NSArray *array) {
        self.searchHashTagsArray = array;
        [self.hashTagTableView reloadData];
        self.isUserSearch = false;
    }];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ProfileSegue"])
    {
        ProfileViewController *vc = segue.destinationViewController;
        NSIndexPath *path = self.tableView.indexPathForSelectedRow;
        vc.user = self.searchUsersArray[path.row];
        vc.isNotCurrentUser = true;
    }
    else if ([segue.identifier isEqualToString:@"HashTagSegue"])

    {
        HashTagViewController *vc = segue.destinationViewController;
        NSIndexPath *path = self.hashTagTableView.indexPathForSelectedRow;
        vc.hashTag = self.searchHashTagsArray[path.row];
    }

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}



@end
