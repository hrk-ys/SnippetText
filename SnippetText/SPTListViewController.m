//
//  SPTViewController.m
//  SnippetText
//
//  Created by Hiroki Yoshifuji on 2014/03/08.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import "SPTListViewController.h"
#import "SPTEditViewController.h"


#import <GADBannerView.h>
#import <GADRequest.h>

@interface SPTListViewController ()
<UITableViewDataSource, UITableViewDelegate, GADBannerViewDelegate>

@property (nonatomic) NSMutableArray             *dataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) GADBannerView *adMobView;
@property (nonatomic) BOOL           adMobIsVisible;
@end

@implementation SPTListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.dataSource = [SPTSnippet findAllSortedBy:@"orderNum" ascending:YES].mutableCopy;
    
    self.adMobView                    = [[GADBannerView alloc] init];
    self.adMobView.height             = 0;
    self.adMobView.delegate           = self;
    self.adMobView.adUnitID           = @"ca-app-pub-1525765559709019/5252864142";
    self.adMobView.rootViewController = self;
    self.adMobView.adSize             = kGADAdSizeSmartBannerPortrait;
    GADRequest *request = [GADRequest request];
#ifdef DEBUG
    request.testDevices = [NSArray arrayWithObjects:
                           GAD_SIMULATOR_ID,
                           nil];
#endif
    [self.adMobView loadRequest:request];
    self.adMobView.hidden = YES;
    [self.view addSubview:self.adMobView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSArray *dataSource = [SPTSnippet findAllSortedBy:@"orderNum" ascending:YES];
    if (dataSource.count == self.dataSource.count) {
        for (UITableViewCell *cell in self.tableView.visibleCells) {
            [self configureCell:cell];
        }
    } else {
        self.dataSource = dataSource.mutableCopy;
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (SPTSnippet *)snippetAtIndexPath:(NSIndexPath *)indexPath
{
    return self.dataSource[indexPath.row - 1];
}

- (void)configureCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) { return; }
    
    SPTSnippet *snippet = [self snippetAtIndexPath:indexPath];
    UILabel    *label   = (UILabel *) [cell viewWithTag:1];
    label.text = snippet.title && snippet.title.length > 0 ? snippet.title : snippet.content;
    
    [cell setNeedsLayout];
}

- (void)configureCell:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self configureCell:cell indexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AddCell" forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        
        [self configureCell:cell indexPath:indexPath];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0) {
        SPTSnippet *snippet = [self snippetAtIndexPath:indexPath];
        
        UIPasteboard *pastebd = [UIPasteboard generalPasteboard];
        [pastebd setValue:snippet.content forPasteboardType:@"public.utf8-plain-text"];
        
        [JDStatusBarNotification showWithStatus:@"クリップボードにコピーしました" dismissAfter:3.f];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row != 0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        SPTSnippet *snippet = [self snippetAtIndexPath:indexPath];
        
        NSManagedObjectContext *context = snippet.managedObjectContext;
        [self.dataSource removeObject:snippet];
        
        [context deleteObject:snippet];
        [context saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row != 0;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    SPTSnippet *snippet = [self snippetAtIndexPath:sourceIndexPath];
    
    NSUInteger minIndex = MIN(sourceIndexPath.row, destinationIndexPath.row) - 1;
    NSUInteger maxIndex = MAX(sourceIndexPath.row, destinationIndexPath.row) - 1;
    
    NSUInteger orderNo = [[(SPTSnippet *) self.dataSource[minIndex] orderNum] integerValue];
    
    NSMutableArray *array = self.dataSource.mutableCopy;
    
    [array removeObjectAtIndex:sourceIndexPath.row - 1];
    [array insertObject:snippet atIndex:destinationIndexPath.row - 1];
    
    self.dataSource = [NSArray arrayWithArray:array].mutableCopy;
    
    for (NSUInteger i = minIndex; i <= maxIndex; i++) {
        SPTSnippet *s = self.dataSource[ i ];
        s.orderNum = @(orderNo);
        orderNo++;
    }
    
    [[NSManagedObjectContext MR_defaultContext] saveToPersistentStoreAndWait];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"edit"]) {
        UIView          *view = sender;
        UITableViewCell *cell;
        int              i = 0;
        while (![view isKindOfClass:[UITableViewCell class]]) {
            view = view.superview;
            if (i > 10) { break; }
        }
        cell = (UITableViewCell *) view;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        SPTEditViewController *vc = (SPTEditViewController *) segue.destinationViewController;
        vc.snippet = [self snippetAtIndexPath:indexPath];
    }
}

- (IBAction)tappedEditButton:(id)sender
{
    [self.tableView setEditing:!self.tableView.editing];
    
    UIBarButtonItem *editButton = self.navigationItem.rightBarButtonItem;
    if (self.tableView.editing) {
        editButton.title = @"Cancel";
    } else {
        editButton.title = @"Edit";
    }
}

#pragma mark -
#pragma mark admod

- (void)adViewDidReceiveAd:(GADBannerView *)banner
{
    LOGTrace;
    if (self.adMobIsVisible) { return; }
    
    self.adMobIsVisible = YES;
    
    self.adMobView.originY = self.view.height;
    self.adMobView.hidden  = NO;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.adMobView.originY -= self.adMobView.height;
                     } completion:^(BOOL finished) {
                         UIEdgeInsets insets = self.tableView.scrollIndicatorInsets;
                         insets.bottom = -self.adMobView.height;
                         self.tableView.scrollIndicatorInsets = insets;
                     }];
}

- (void)adView:(GADBannerView *)banner didFailToReceiveAdWithError:(GADRequestError *)error
{
    LOGTrace;
    if (!self.adMobIsVisible) { return; }
    self.adMobIsVisible = NO;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.adMobView.originY = self.view.height;
                     } completion:^(BOOL finished) {
                         self.adMobView.hidden = YES;
                         UIEdgeInsets insets = self.tableView.scrollIndicatorInsets;
                         insets.bottom = 0;
                         self.tableView.scrollIndicatorInsets = insets;
                     }];
}

@end
