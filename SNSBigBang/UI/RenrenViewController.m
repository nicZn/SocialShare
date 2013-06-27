//
//  RenrenViewController.m
//  SNSBigBang
//
//  Created by 張 寧 on 2013/06/25.
//  Copyright (c) 2013年 張 寧. All rights reserved.
//

#import "RenrenViewController.h"

@interface RenrenViewController ()

@property (weak, nonatomic) IBOutlet UITextView *StatusTextView;

@end

@implementation RenrenViewController

@synthesize StatusTextView;

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
    [[[self navigationController] navigationBar] topItem].title = @"Renren";
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56, 40)];
    [[button layer] setCornerRadius:8.0];
    [button setTitle:@"Login" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor redColor]];
    [button addTarget:self action:@selector(authUser:) forControlEvents:UIControlEventTouchUpInside];
    [[[[self navigationController] navigationBar] topItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:button]];
    self.StatusTextView.layer.borderWidth = 1.0;
    self.StatusTextView.layer.cornerRadius = 4.0f;
    self.StatusTextView.layer.borderColor = [[UIColor redColor] CGColor];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button Action

-(IBAction)authUser:(id)sender{
    [[SNSUtility shareInstanse] authRenrenWithDelegate:self];
}

-(IBAction)getNews:(id)sender{
    [[SNSUtility shareInstanse] getNewsForRenren];
}

- (IBAction)sendStatus:(id)sender {
    NSString * status = self.StatusTextView.text;
    if (status != nil && status.length > 0) {
        [[SNSUtility shareInstanse] sendRenrenStatus:status withDelegate:self];
    }
}
#pragma mark - delegate
#pragma mark - SNS AUTH
-(void)authSuccess:(SNSType)type withInfo:(NSDictionary *)userInfo{
    
}

@end
