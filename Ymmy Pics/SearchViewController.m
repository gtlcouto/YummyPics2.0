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
#import "User.h"
#import "Media.h"
#import "Activity.h"

@interface SearchViewController () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property NSArray *users;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [User retrieveUserWithUserName:self.searchBar.text completion:^(NSArray *array) {
        self.users = array;
        [self.tableView reloadData];
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     UserSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell"];

    User *user = [self.users objectAtIndex:indexPath.row];

    cell.usernameLabel.text = user.username;
    cell.profileImageView.image = [Media getImageFromPFFile:user.profilePictureMedium];
    cell.profileImageView.layer.cornerRadius = 3.0;
    cell.profileImageView.clipsToBounds = true;


    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.users.count;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [User retrieveUserWithUserName:self.searchBar.text completion:^(NSArray *array) {
        self.users = array;
        [self.tableView reloadData];
    }];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ProfileViewController *vc = segue.destinationViewController;
    NSIndexPath *path = self.tableView.indexPathForSelectedRow;
    vc.user = self.users[path.row];
    vc.isNotCurrentUser = true;

}



@end
