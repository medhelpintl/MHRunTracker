//
//  RTAppDelegate.m
//  MHRunTracker
//
//  Created by Winfred Raguini on 10/29/12.
//  Copyright (c) 2012 Winfred Raguini. All rights reserved.
//

#import "RTAppDelegate.h"
#import "MHUser.h"
#import "MHHealthData.h"
#import "RTTrackerViewController.h"

@implementation RTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Initialize RestKit
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURLString:@"http://localhost:3000"];
    
    // Enable automatic network activity indicator management
    objectManager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    
    // Setup our object mappings
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[MHUser class]];
    [userMapping mapKeyPath:@"id" toAttribute:@"userID"];
    [userMapping mapKeyPath:@"screen_name" toAttribute:@"screenName"];
    [userMapping mapAttributes:@"name", nil];
    
    RKObjectMapping *healthDataMapping = [RKObjectMapping mappingForClass:[MHHealthData class]];
    [healthDataMapping mapKeyPathsToAttributes:@"id", @"healthDataID",
     @"type", @"dataType",
     @"value", @"value",
     @"start_time", @"startTime",
     @"end_time", @"endTime",
     nil];
    [healthDataMapping mapRelationship:@"user" withMapping:userMapping];
    
    RKObjectMapping* healthDataSerializeMapping = [healthDataMapping inverseMapping];
  	[objectManager.mappingProvider setSerializationMapping:healthDataSerializeMapping forClass:[MHHealthData class]];
    
    // Update date format so that we can parse dates properly
    // Wed Sep 29 15:31:08 +0000 2010
    [RKObjectMapping addDefaultDateFormatterForString:@"E MMM d HH:mm:ss Z y" inTimeZone:nil];
    
    // Register our mappings with the provider using a resource path pattern
    [objectManager.mappingProvider setObjectMapping:healthDataMapping forResourcePathPattern:@"/health_data/:id_or_search"];
    
    // Grab the reference to the router from the manager
    RKObjectRouter *router = [RKObjectManager sharedManager].router;
    
    // Define a default resource path for all unspecified HTTP verbs
    [router routeClass:[MHHealthData class] toResourcePath:@"/health_data" forMethod:RKRequestMethodPOST];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[RTTrackerViewController alloc] initWithNibName:@"RTViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
