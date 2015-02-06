//
//  HashTagViewController.m
//  Ymmy Pics
//
//  Created by Gustavo Couto on 2015-02-06.
//  Copyright (c) 2015 Gustavo Couto. All rights reserved.
//

#import "HashTagViewController.h"
#import "ProfileCollectionViewCell.h"

@interface HashTagViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property NSArray *medias;

@end

@implementation HashTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.hashTag.hashTag;

    PFRelation *relation = [self.hashTag relationForKey:@"mediasWithHashTag"];

    PFQuery * query = [relation query];
    self.medias = [query findObjects];

    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    Media * media = [self.medias objectAtIndex:indexPath.row];

    cell.imageView.image = [Media getImageFromPFFile:media.mediaFile];

    return cell;
}


- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.medias.count;
}



@end
