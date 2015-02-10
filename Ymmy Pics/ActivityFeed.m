//
//  ActivityFeed.m
//  Ymmy Pics
//
//  Created by Gustavo Couto on 2015-02-06.
//  Copyright (c) 2015 Gustavo Couto. All rights reserved.
//

#import "ActivityFeed.h"
#import "ActivityTableViewCell.h"
#import "Activity.h"
#import "User.h"
#import "ProfileViewController.h"
@interface ActivityFeed () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray * activityArray;

@end

@implementation ActivityFeed


-(void)viewDidLoad
{
    [super viewDidLoad];


}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Activity getAllYourActivitiesWithBlock:^(NSArray *array) {
        self.activityArray = array;
        [self.tableView reloadData];
    }];

}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.activityArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    Activity * myActivity = [self.activityArray objectAtIndex:indexPath.row];
    User *user = (User *)[[User query] getObjectWithId:myActivity.fromUser.objectId];
    cell.userImage.image = [Media getImageFromPFFile:user.profilePictureMedium];
    Media * media = myActivity.media;

    if ([myActivity.type  isEqual: @"COMMENT"])
    {
        cell.activityText.text = [NSString stringWithFormat:@"@%@ just commented on your picture.", user.username];
        cell.mediaImage.image = [Media getImageFromPFFile:media.mediaFile];
    } else if ([myActivity.type  isEqual: @"LIKE"])
    {
        cell.activityText.text = [NSString stringWithFormat:@"@%@ just liked one of your pictures.", user.username];
        cell.mediaImage.image = [Media getImageFromPFFile:media.mediaFile];
    } else if ([myActivity.type  isEqual: @"FOLLOW"])
    {
        cell.activityText.text = [NSString stringWithFormat:@"@%@ just followed you", user.username];
        cell.mediaImage.image = [UIImage imageNamed:@"followbackbutton"];
        cell.mediaImage.contentMode = UIViewContentModeScaleAspectFit;
        
    }

    [cell.activityText setDetectionBlock:^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {


        if (hotWord == STTweetHashtag)
        {
            [self performSegueWithIdentifier:@"HashTagSegue" sender:string];
        }
        else if (hotWord == STTweetHandle)
        {
            [self performSegueWithIdentifier:@"toProfileSegue" sender:string];
        }
        
    }];

    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier  isEqual: @"toProfileSegue"]) {
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
}

@end
