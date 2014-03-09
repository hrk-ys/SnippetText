//
//  SPTEditViewController.m
//  SnippetText
//
//  Created by Hiroki Yoshifuji on 2014/03/08.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import "SPTEditViewController.h"

@interface SPTEditViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *titleWrapView;
@property (weak, nonatomic) IBOutlet UISwitch *secretSwitch;

@property (weak, nonatomic) IBOutlet UIView *secretInputView;

@property (nonatomic) BOOL isCreateMode;
@property (weak, nonatomic) IBOutlet UIView *contentWrapView;
@property (weak, nonatomic) IBOutlet UITextField *contentField;

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
    self.screenName = @"EditView";
    
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
        self.contentField.text = self.snippet.content;
        self.secretSwitch.on = self.snippet.secretValue;
    }
    
    [self setupCornerRadius:self.titleWrapView];
    [self setupCornerRadius:self.textView];
    [self setupCornerRadius:self.contentWrapView];
    
    [self updateContentInputViews];
    
}

- (void)setupCornerRadius:(UIView*)view
{
    view.layer.cornerRadius = 3.0f;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.borderWidth = 1.0f;
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
}

- (void)updateContentInputViews
{
    if (self.secretSwitch.on) {
        self.textView.hidden = YES;
        self.secretInputView.hidden = NO;
        
        self.contentField.text = self.textView.text;
        
        if (![self.contentField isFirstResponder] && ![self.titleField isFirstResponder]) {
            [self.contentField becomeFirstResponder];
        }
    } else {
        self.textView.hidden = NO;
        self.secretInputView.hidden = YES;
        
        self.textView.text = self.contentField.text;
        if (![self.textView isFirstResponder] && ![self.titleField isFirstResponder]) {
            [self.textView becomeFirstResponder];
        }
    }
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

- (IBAction)secretValueChanged:(id)sender {
    [self updateContentInputViews];
}



- (IBAction)tappedDoneButton:(id)sender {
    BOOL secure = self.secretSwitch.on;
    NSString* title = self.titleField.text;
    NSString* content = secure ? self.contentField.text : self.textView.text;
    
    if (content.length == 0) {
        [UIAlertView showMessage:@"Textが入力されていません"];
        return;
    }
    if (secure && title.length == 0) {
        [UIAlertView showMessage:@"Titleが入力されていません"];
        return;
    }
    
    self.snippet.title = title;
    self.snippet.content = content;
    self.snippet.secret = @(secure);
    
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
