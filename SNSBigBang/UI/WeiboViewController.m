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

@property (weak, nonatomic) IBOutlet UITextView *statusTextView;

@end

@implementation WeiboViewController

@synthesize statusTextView;

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
    
    self.statusTextView.layer.borderWidth = 1.0;
    self.statusTextView.layer.cornerRadius = 4.0f;
    self.statusTextView.layer.borderColor = [[UIColor redColor] CGColor];
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

- (IBAction)getNews:(id)sender {
    [[SNSUtility shareInstanse] getNewsForWeibo:self];
}

- (IBAction)pushStatus:(id)sender {
    NSString *status = self.statusTextView.text;
    if (status != nil && status.length> 0) {
        [[SNSUtility shareInstanse] pushStatus:status withDelegate:self];
    }
}
@end
