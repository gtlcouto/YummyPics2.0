//
//  Media.m
//  Ymmy Pics
//
//  Created by Diego Cichello on 2/2/15.
//  Copyright (c) 2015 Gustavo Couto. All rights reserved.
//

#import "Media.h"
#import "Activity.h"
#import "HashTag.h"

@implementation Media

@dynamic mediaFile;
@dynamic caption;
@dynamic mediaOwner;
@dynamic mediaImage;

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"Media";
}

+(void)addMedia:(UIImage *)mediaImage withCaption:(NSString *)caption withCompletion:(void (^)(BOOL succeeded))complete
{
    NSData *imageData = UIImageJPEGRepresentation(mediaImage, 0.4);
    PFFile *file = [PFFile fileWithData:imageData];

    Media *media = [Media object];
    media.mediaFile = file;
    media.mediaOwner = [User currentUser];
    media.caption = caption;




    [media saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (succeeded)
        {
            [HashTag searchForHashTag:media.caption onMedia:media];
        }
        complete(true);
    }];


}

+ (void) retrieveMediasFromUser:(User *)user withCompletion:(void (^)(NSArray *array))complete
{

    PFQuery *userQuery = [PFQuery queryWithClassName:@"Media"];
    [userQuery whereKey:@"mediaOwner" equalTo:user];
    [userQuery addDescendingOrder:@"createdAt"];

    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {


        complete(objects);
    }];

    

}

+ (NSUInteger) getNumberOfPosts:(User *)user
{

    PFQuery *userQuery = [PFQuery queryWithClassName:@"Media"];
    [userQuery whereKey:@"mediaOwner" equalTo:user];
    //[userQuery addDescendingOrder:@"createdAt"];

    return [userQuery findObjects].count;
    
    
    
}

+ (void) retrieveFollowedPeopleMedias:(void (^)(NSArray *))complete
{
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
    [query whereKey:@"fromUser" equalTo:[User currentUser]];
    [query whereKey:@"type" equalTo:@"FOLLOW"];

    PFQuery *userQuery = [PFQuery queryWithClassName:@"Media"];
    [userQuery whereKey:@"mediaOwner" matchesKey:@"toUser" inQuery:query];
    
    [userQuery addDescendingOrder:@"createdAt"];
    userQuery.limit = 10;

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


    Activity *activity = (Activity *)[query getFirstObject];

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
