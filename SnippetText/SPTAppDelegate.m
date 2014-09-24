//
//  SPTAppDelegate.m
//  SnippetText
//
//  Created by Hiroki Yoshifuji on 2014/03/08.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import "SPTAppDelegate.h"

#import <GAI.h>


@implementation SPTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
#ifdef DEBUG
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
#endif
    
    // Initialize tracker.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-42236549-4"];

    [self setupCoreData];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [JDStatusBarNotification setDefaultStyle:^JDStatusBarStyle *(JDStatusBarStyle *style) {
            style.barColor = [UIColor colorWithWhite:0.888 alpha:1.000];
            style.textColor = [UIColor blackColor];
            return style;
        }];
    });
    
    // Override point for customization after application launch.
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

- (void)setupCoreData
{
//    [MagicalRecord setupAutoMigratingCoreDataStack];    return;
    NSString* storeName = [MagicalRecord defaultStoreName];
    NSURL* fileUrl = [NSPersistentStore MR_urlForStoreName:storeName];

    NSURL *storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.net.hrk-ys.SnippetText"];

    NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:[fileUrl path]]) {
        
        NSString* dir = [NSPersistentStore MR_applicationStorageDirectory];


        NSError* error = nil;
        for (NSString* file in [fm contentsOfDirectoryAtPath:dir error:nil]) {
            [fm moveItemAtPath:[dir stringByAppendingPathComponent:file]
                        toPath:[[storeURL URLByAppendingPathComponent:file] path]
                        error:&error];
        }
        
        [[NSFileManager defaultManager] moveItemAtURL:fileUrl toURL:storeURL error:&error];
    }

    if ([NSPersistentStoreCoordinator MR_defaultStoreCoordinator] != nil) return;
    
    NSManagedObjectModel *model = [NSManagedObjectModel MR_defaultManagedObjectModel];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    

    NSDictionary *options = [[coordinator class] MR_autoMigrationOptions];
    storeURL = [storeURL URLByAppendingPathComponent:storeName];
    [coordinator MR_addSqliteStoreNamed:storeURL withOptions:options];

    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:coordinator];
    
    [NSManagedObjectContext MR_initializeDefaultContextWithCoordinator:coordinator];
}

@end
