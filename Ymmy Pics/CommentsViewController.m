//
//  CommentsViewController.m
//  Ymmy Pics
//
//  Created by Diego Cichello on 2/5/15.
//  Copyright (c) 2015 Gustavo Couto. All rights reserved.
//

#import "CommentsViewController.h"

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
    self.comments = [NSMutableArray arrayWithObjects:@"1",@"2",@"1",@"2",@"1",@"2",@"1",@"2",@"1",@"2",@"1",@"2",@"1",@"2", nil];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    cell.textLabel.text = self.comments[indexPath.row];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.comments.count;

}

@end
