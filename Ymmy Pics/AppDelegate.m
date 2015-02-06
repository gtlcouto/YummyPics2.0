//
//  AppDelegate.m
//  Ymmy Pics
//
//  Created by Gustavo Couto on 2015-02-02.
//  Copyright (c) 2015 Gustavo Couto. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "User.h"
#import "Media.h"
#import "Activity.h"
#import "HashTag.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


// Added to enable Parse
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/iOS
    [Parse enableLocalDatastore];

    // Initialize Parse.
    [Parse setApplicationId:@"5J0RZGSskEBBflzbI887NA3HVIifHSngVkeQem0G"
                  clientKey:@"mqP4pUu4pvlTJpisxtNoG0r2PV1PlV25rMwWhWpZ"];


    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    // ...

    [User registerSubclass];
    [Media registerSubclass];
    [Activity registerSubclass];
    [HashTag registerSubclass];
    return true;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
