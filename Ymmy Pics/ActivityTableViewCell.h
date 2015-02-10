//
//  ActivityTableViewCell.h
//  Ymmy Pics
//
//  Created by Gustavo Couto on 2015-02-06.
//  Copyright (c) 2015 Gustavo Couto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTweetLabel.h"

@interface ActivityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIImageView *mediaImage;
@property (weak, nonatomic) IBOutlet STTweetLabel *activityText;

@end
