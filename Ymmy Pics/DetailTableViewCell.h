//
//  DetailTableViewCell.h
//  Ymmy Pics
//
//  Created by Gustavo Couto on 2015-02-03.
//  Copyright (c) 2015 Gustavo Couto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTweetLabel.h"

@interface DetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *customImageView;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet STTweetLabel *captionTextField;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@end
