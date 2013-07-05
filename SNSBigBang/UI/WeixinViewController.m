//
//  WeixinViewController.m
//  SNSBigBang
//
//  Created by 張 寧 on 2013/06/26.
//  Copyright (c) 2013年 張 寧. All rights reserved.
//

#import "WeixinViewController.h"
#import "WXApi.h"

@interface WeixinViewController ()

@end

@implementation WeixinViewController

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
}

-(void)viewWillAppear:(BOOL)animated{
//    [[[self navigationController] navigationBar] topItem].title = @"WeChat";
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56, 40)];
//    [[button layer] setCornerRadius:8.0];
//    [button setTitle:@"Login" forState:UIControlStateNormal];
//    [button setBackgroundColor:[UIColor redColor]];
//    [button addTarget:self action:@selector(loginWeChat:) forControlEvents:UIControlEventTouchUpInside];
//	[[[[self navigationController] navigationBar] topItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:button]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action

-(IBAction)loginWeChat:(id)sender{
    
}

@end
