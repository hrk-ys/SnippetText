//
//  KeyboardViewController.m
//  SnippetKeyboard
//
//  Created by Hiroki Yoshifuji on 2014/09/24.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import "KeyboardViewController.h"
#import "SPTSnippet.h"

@interface KeyboardViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSArray* dataSource;
@property (weak, nonatomic) IBOutlet UIButton *snippetButton;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *delButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *modeLabel;
@property (weak, nonatomic) IBOutlet UISwitch *modeSwitch;


@end

@implementation KeyboardViewController

- (void)setupToolButton:(UIButton*)button {
    [button.layer setCornerRadius:3.0f];
    [button.layer setShadowColor:[UIColor blackColor].CGColor];
    [button.layer setShadowOffset:CGSizeMake(1, 1)];
    button.layer.shadowOpacity = 0.5f;
    button.layer.shadowRadius = 1.0f;

}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCoreData];
    
    self.dataSource = [SPTSnippet findAllSortedBy:@"orderNum" ascending:YES];

    UINib* nib = [UINib nibWithNibName:@"ListItemView" bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    
    [_snippetButton setClipsToBounds:YES];
    [self setupToolButton:_snippetButton];
    [self setupToolButton:_leftButton];
    [self setupToolButton:_rightButton];
    [self setupToolButton:_delButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

- (void)selectionWillChange:(id <UITextInput>)textInput
{
//    NSLog(@"selectionWillChange:%@", textInput);
}
- (void)selectionDidChange:(id <UITextInput>)textInput
{
//    NSLog(@"selectionDidChange:%@", textInput);
}

- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
//    NSLog(@"textWillChange:%@", textInput);
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
//    NSLog(@"textDidChange:%@", textInput);

}






#pragma mark - Table

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Snippet Text";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    SPTSnippet* snippet = self.dataSource[indexPath.row];
    
    cell.textLabel.text = snippet.title && snippet.title.length > 0 ? snippet.title : snippet.content;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPTSnippet* snippet = self.dataSource[indexPath.row];
    
    if (_modeSwitch.on) {
        [self.textDocumentProxy insertText:snippet.content];
    } else {
        UIPasteboard *pastebd = [UIPasteboard generalPasteboard];
        [pastebd setValue:snippet.content forPasteboardType:@"public.utf8-plain-text"];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark - Button Action


- (IBAction)tappedSnippetButton:(id)sender {
    [self advanceToNextInputMode];
//    [self.extensionContext openURL:[NSURL URLWithString:@"snippet-text"] completionHandler:nil];
}

- (IBAction)tappedNextButton:(id)sender {
    [self advanceToNextInputMode];
}
- (IBAction)tappedFirstButton:(id)sender {
    NSObject<UITextDocumentProxy>* proxy = self.textDocumentProxy;
    [proxy adjustTextPositionByCharacterOffset:proxy.documentContextBeforeInput.length * -1];
}

- (IBAction)tappedEndButton:(id)sender {
    NSObject<UITextDocumentProxy>* proxy = self.textDocumentProxy;
    [proxy adjustTextPositionByCharacterOffset:proxy.documentContextAfterInput.length];
}

- (IBAction)tappedLeftButton:(id)sender {
    NSObject<UITextDocumentProxy>* proxy = self.textDocumentProxy;
    [proxy adjustTextPositionByCharacterOffset:-1];
}

- (IBAction)tappedRightButton:(id)sender {
    NSObject<UITextDocumentProxy>* proxy = self.textDocumentProxy;
    [proxy adjustTextPositionByCharacterOffset:1];
}

- (IBAction)tappedAllDelButton:(id)sender {
    NSObject<UITextDocumentProxy>* proxy = self.textDocumentProxy;
    // 効かない
    // [proxy adjustTextPositionByCharacterOffset:proxy.documentContextAfterInput.length];
    while (proxy.documentContextBeforeInput.length > 0) {
        [proxy deleteBackward];
    }
}

- (IBAction)tappedDelButton:(id)sender {
    [self.textDocumentProxy deleteBackward];
}

- (IBAction)changedMode:(id)sender {
    _modeLabel.title = _modeSwitch.on ? @"挿入" : @"コピー";
}

#pragma mark - Snippet data

- (void)setupCoreData
{
    NSString* storeName = @"SnippetText.sqlite";
    NSURL *storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.net.hrk-ys.SnippetText"];

    if ([NSPersistentStoreCoordinator MR_defaultStoreCoordinator] != nil) return;
    
    NSManagedObjectModel *model = [NSManagedObjectModel MR_defaultManagedObjectModel];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    
//    NSDictionary *options = [[coordinator class] MR_autoMigrationOptions];
    storeURL = [storeURL URLByAppendingPathComponent:storeName];
    [coordinator MR_addSqliteStoreNamed:storeURL withOptions:nil];
    
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:coordinator];
    
    [NSManagedObjectContext MR_initializeDefaultContextWithCoordinator:coordinator];
}

@end
