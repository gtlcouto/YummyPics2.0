//
//  HashTag.m
//  Ymmy Pics
//
//  Created by Gustavo Couto on 2015-02-06.
//  Copyright (c) 2015 Gustavo Couto. All rights reserved.
//

#import "HashTag.h"
#import "Media.h"
#import <Parse/Parse.h>

@implementation HashTag

@dynamic mediasWithHashTag;
@dynamic hashTag;
@dynamic createdAt;
@dynamic updatedAt;


+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"HashTag";
}

+ (void) addHashTag:(NSString *)hashTagText onMedia:(Media *)media
{
    HashTag *hashTag = [HashTag object];
    hashTag.hashTag = hashTagText;
    PFRelation *relation = [hashTag relationForKey:@"mediasWithHashTag"];
    [relation addObject:media];

    [hashTag saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {

    }];

}

+ (void) retrieveHashTagsWithText:(NSString *)text  withCompletion:(void (^)(NSArray *array))complete
{
    PFQuery *query = [PFQuery queryWithClassName:@"HashTag"];

    if (![text isEqualToString: @""])
    {
        [query whereKey:@"hashTag" containsString:text];
    }

    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {


        complete(objects);
    }];


}

+ (HashTag *)retrieveHashTagWithName:(NSString *)name
{
    PFQuery *query = [PFQuery queryWithClassName:@"HashTag"];
    [query whereKey:@"hashTag" containsString:name];

    HashTag *hashTag = (HashTag *)[query getFirstObject];

    return hashTag;
}

+ (void) searchForHashTag:(NSString *)text onMedia:(Media *)media
{
    //NSString *string = @"#pingpong #delicia #blablabla huehuehuehue #hue #pong";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?:\\s|\\A)[##]+([A-Za-z0-9-_]+)" options:0 error:nil];
    NSArray* matches = [regex matchesInString:text options:0 range:NSMakeRange(0, [text length])];

    for (NSTextCheckingResult *match in matches)
    {
        NSString* matchText = [text substringWithRange:[match range]];
        if ([self checkIfHashTagAlreadyExists:matchText])
        {
            [self addMediaOnHashTag:matchText onMedia:media];
        }
        else
        {
            [self addHashTag:matchText onMedia:media];
        }
    }

}

+ (BOOL) checkIfHashTagAlreadyExists:(NSString *)text
{
    PFQuery *query = [PFQuery queryWithClassName:@"HashTag" ];
    [query whereKey:@"hashTag" containsString:text];

    NSArray *array = [query findObjects];

    if (array.count >0)
    {
        return true;
    }
    else
    {
        return false;
    }
}

+ (void) addMediaOnHashTag:(NSString *)text onMedia:(Media *)media
{
    PFQuery *query = [PFQuery queryWithClassName:@"HashTag"];
    [query whereKey:@"hashTag" containsString:text];

    HashTag *hashTag = (HashTag *)[query getFirstObject];
    [hashTag.mediasWithHashTag addObject:media];

    [hashTag saveInBackground];
}




@end
