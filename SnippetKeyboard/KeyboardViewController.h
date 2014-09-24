//
//  KeyboardViewController.h
//  SnippetKeyboard
//
//  Created by Hiroki Yoshifuji on 2014/09/24.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MR_ENABLE_ACTIVE_RECORD_LOGGING 0
#define MR_SHORTHAND
#import "CoreData+MagicalRecord.h"


@interface KeyboardViewController : UIInputViewController

@end

@interface NSPersistentStore (MagicalRecordEX)
+ (NSString *)MR_applicationStorageDirectory;
@end

@interface NSPersistentStoreCoordinator (MagicalRecordEX)
+ (NSDictionary *) MR_autoMigrationOptions;
@end
