//
//  SPTAppDelegate.h
//  SnippetText
//
//  Created by Hiroki Yoshifuji on 2014/03/08.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

@interface NSPersistentStore (MagicalRecordEX)
+ (NSString *)MR_applicationStorageDirectory;
@end

@interface NSPersistentStoreCoordinator (MagicalRecordEX)
+ (NSDictionary *) MR_autoMigrationOptions;
@end
