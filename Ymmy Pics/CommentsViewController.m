//
//  CommentsViewController.m
//  Ymmy Pics
//
//  Created by Diego Cichello on 2/5/15.
//  Copyright (c) 2015 Gustavo Couto. All rights reserved.
//

#import "CommentsViewController.h"
#import "CommentTableViewCell.h"
#import "Activity.h"

@interface CommentsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property NSMutableArray *comments;

@end

@implementation CommentsViewController



-(void) viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    self.comments = [NSMutableArray new];

}
- (IBAction)onSendButtonTapped:(id)sender
{
    [Activity commentOnMedia:self.media withContent:self.textField.text withCompletion:^(BOOL succeeded) {
        [Activity retrieveAllCommentsFromMedia:self.media withCompletion:^(NSArray *array) {
            self.comments = [array mutableCopy];
            [self.tableView reloadData];
        }];
    }];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:true];
    [Activity retrieveAllCommentsFromMedia:self.media withCompletion:^(NSArray *array) {
        self.comments = [array mutableCopy];
        [self.tableView reloadData];
    }];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:true];
    [self.textField becomeFirstResponder];
}


- (void)keyboardWillShow:(NSNotification *)notification { // UIKeyboardWillShowNotification

    NSDictionary *info = [notification userInfo];
    NSValue *keyboardFrameValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [keyboardFrameValue CGRectValue];

    CGFloat keyboardHeight = keyboardFrame.size.height;

    // constrBottom is a constraint defining distance between bottom edge of tableView and bottom edge of its superview

    // or constrBottom.constant = -keyboardHeight - in case if you create constrBottom in code (NSLayoutConstraint constraintWithItem:...:toItem:...) and set views in inverted order

    [UIView animateWithDuration:animationDuration animations:^{
        self.bottomConstraint.constant = -keyboardHeight+50 ;
        [self.view setNeedsLayout];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    Activity *activity = self.comments[indexPath.row];

    User * user = (User *)[[User query] getObjectWithId:activity.fromUser.objectId];

    cell.userNameLabel.text = user.username;
    cell.commentLabel.text = activity.content;
    cell.profilePictureImageView.image = [Media getImageFromPFFile:activity.fromUser.profilePictureMedium];
    cell.timeStamp.text = [self getDateString:activity];

    return cell;
}

- (NSString *) getDateString:(Activity *)activity
{
    NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:activity.createdAt];

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.comments.count;

}

@end
