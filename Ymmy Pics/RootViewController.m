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
#import "DetailTableViewCell.h"
#import "HeaderTableViewCell.h"

@interface RootViewController () <FBLoginViewDelegate,UITableViewDataSource,UITableViewDelegate>


@property NSArray *testArray;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    // Do any additional setup after loading the view, typically from a nib.
    self.testArray = [[NSArray alloc] initWithObjects:@"one", @"two", nil];



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
    cell.customImageView.image = [UIImage imageNamed:@"riodejaneiro"];
    if (cell == nil){
        [NSException raise:@"headerView == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
    }


    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.testArray.count;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *CellIdentifier = @"headerCell";
    HeaderTableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (headerView == nil){
        [NSException raise:@"headerView == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
    }

    headerView.userNameLabel.text = self.testArray[section];
    headerView.backgroundColor = [UIColor cyanColor];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0;
}

    @end
