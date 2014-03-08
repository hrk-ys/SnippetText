//
//  SPTNaviViewController.m
//  SnippetText
//
//  Created by Hiroki Yoshifuji on 2014/03/08.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import "SPTNaviViewController.h"

@interface SPTNaviViewController ()

@end

@implementation SPTNaviViewController

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
    
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor] }];
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.000 alpha:0.700]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor whiteColor]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
