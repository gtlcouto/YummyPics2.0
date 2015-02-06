//
//  Media.m
//  Ymmy Pics
//
//  Created by Diego Cichello on 2/2/15.
//  Copyright (c) 2015 Gustavo Couto. All rights reserved.
//

#import "Media.h"
#import "Activity.h"

@implementation Media

@dynamic mediaFile;
@dynamic caption;
@dynamic mediaOwner;

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"Media";
}

+(void)addMedia:(UIImage *)mediaImage withCaption:(NSString *)caption;
{
    NSData *imageData = UIImagePNGRepresentation(mediaImage);
    PFFile *file = [PFFile fileWithData:imageData];

    Media *media = [Media object];
    media.mediaFile = file;
    media.mediaOwner = [User currentUser];
    media.caption = caption;

    [User currentUser].numberOfPosts = [NSNumber numberWithInt:([[User currentUser].numberOfPosts intValue] +1)];

    [[User currentUser] saveInBackground];

    [media saveInBackground];


}

+ (void) retrieveMediasFromUser:(User *)user withCompletion:(void (^)(NSArray *array))complete
{

    PFQuery *userQuery = [PFQuery queryWithClassName:@"Media"];
    [userQuery whereKey:@"mediaOwner" equalTo:user];
    [userQuery addAscendingOrder:@"createdAt"];

    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        complete(objects);
    }];

    

}

+ (void) retrieveFollowedPeopleMedias:(void (^)(NSArray *))complete
{
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
    [query whereKey:@"fromUser" equalTo:[User currentUser]];
    [query whereKey:@"type" equalTo:@"FOLLOW"];

    PFQuery *userQuery = [PFQuery queryWithClassName:@"Media"];
    [userQuery whereKey:@"mediaOwner" matchesKey:@"fromUser" inQuery:query];
    
    [userQuery addAscendingOrder:@"createdAt"];

    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        complete(objects);
    }];


    
    
}

+ (UIImage *)getImageFromPFFile:(PFFile *)file
{
    NSData *data = [file getData];
    return [UIImage imageWithData:data];
}

- (BOOL) checkIfMediaIsLiked
{
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];

    [query whereKey:@"media" equalTo:self];
    [query whereKey:@"type" equalTo:@"LIKE"];
    [query whereKey:@"fromUser" equalTo:[User currentUser]];


    Activity *activity = [query getFirstObject];

    if (activity)
    {
        return YES;
    }
    else
    {
        return NO;
    }

}




@end
