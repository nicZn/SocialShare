//
//  WeiboViewController.m
//  SNSBigBang
//
//  Created by 張 寧 on 2013/06/26.
//  Copyright (c) 2013年 張 寧. All rights reserved.
//

#import "WeiboViewController.h"
#import "SNSUtility.h"

@interface WeiboViewController ()

@end

@implementation WeiboViewController

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
    
}

-(void)viewWillAppear:(BOOL)animated{
    [[[self navigationController] navigationBar] topItem].title = @"Weibo";
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56, 40)];
    [[button layer] setCornerRadius:8.0];
    [button setTitle:@"Login" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor redColor]];
    [button addTarget:self action:@selector(loginWeibo:) forControlEvents:UIControlEventTouchUpInside];
	[[[[self navigationController] navigationBar] topItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:button]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button Action

-(IBAction)loginWeibo:(id)sender{
    [[SNSUtility shareInstanse] authWeiboWithDelegate:self];
}

@end
