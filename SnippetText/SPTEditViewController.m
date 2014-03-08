//
//  SPTEditViewController.m
//  SnippetText
//
//  Created by Hiroki Yoshifuji on 2014/03/08.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import "SPTEditViewController.h"

#import <BlocksKit.h>

@interface SPTEditViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *titleWrapView;

@property (nonatomic) BOOL isCreateMode;

@property (nonatomic) NSManagedObjectContext* context;
@end

@implementation SPTEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.isCreateMode = self.snippet ? NO : YES;
    
    if (self.isCreateMode) {
        self.title = @"Add Snippet";
        
        self.context = [NSManagedObjectContext MR_context];
        self.snippet = [SPTSnippet createInContext:self.context];
        self.snippet.orderNum = @([SPTSnippet countOfEntities] + 1);
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(tappedCloseButton)];
        
    } else {
        self.title = @"Edit Snippet";
        self.context = self.snippet.managedObjectContext;
        
        self.titleField.text = self.snippet.title;
        self.textView.text = self.snippet.content;
    }
    
    [self setupCornerRadius:self.titleWrapView];
    [self setupCornerRadius:self.textView];
    
    
    [self.textView becomeFirstResponder];
}

- (void)setupCornerRadius:(UIView*)view
{
    view.layer.cornerRadius = 5.0f;
    view.layer.borderColor = [UIColor whiteColor].CGColor;
    view.layer.borderWidth = 1.0f;
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)close {
    if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)tappedDoneButton:(id)sender {
    NSString* title = self.titleField.text;
    NSString* content = self.textView.text;
    
    if (content.length == 0) {
        [UIAlertView showMessage:@"Textが入力されていません"];
        return;
    }
    
    self.snippet.title = title;
    self.snippet.content = content;
    
    [self.context saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        
        
        NSString* message = self.isCreateMode ? @"Snippetを登録しました" : @"Snippetを更新しました";
        [JDStatusBarNotification showWithStatus:message dismissAfter:3.f];
        [self close];
    }];
}

- (void)tappedCloseButton
{
    [self close];
}


@end
