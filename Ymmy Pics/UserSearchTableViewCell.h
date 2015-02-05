//
//  UserSearchTableViewCell.h
//  Ymmy Pics
//
//  Created by Gustavo Couto on 2015-02-04.
//  Copyright (c) 2015 Gustavo Couto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserSearchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImage1;
@property (weak, nonatomic) IBOutlet UIImageView *userImage2;
@property (weak, nonatomic) IBOutlet UIImageView *userImage3;

@end
