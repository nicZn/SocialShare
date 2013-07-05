//
//  WeiboViewController.m
//  SNSBigBang
//
//  Created by 張 寧 on 2013/06/26.
//  Copyright (c) 2013年 張 寧. All rights reserved.
//

#import "WeiboViewController.h"
#import "SNSUtility.h"
#import "WeiboCell.h"

@interface WeiboViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) UITableView *NewsTableView;
@property (nonatomic, strong) NSMutableArray *newsCache;

@end

@implementation WeiboViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.NewsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.NewsTableView.dataSource = self;
    self.NewsTableView.delegate = self;
    [self.view addSubview:self.NewsTableView];
}

-(void)viewWillAppear:(BOOL)animated{
//    [[[self navigationController] navigationBar] topItem].title = @"Weibo";
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56, 40)];
//    [[button layer] setCornerRadius:8.0];
//    [button setTitle:@"Login" forState:UIControlStateNormal];
//    [button setBackgroundColor:[UIColor redColor]];
//    [button addTarget:self action:@selector(loginWeibo:) forControlEvents:UIControlEventTouchUpInside];
//	[[[[self navigationController] navigationBar] topItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:button]];
//    
//    self.statusTextView.layer.borderWidth = 1.0;
//    self.statusTextView.layer.cornerRadius = 4.0f;
//    self.statusTextView.layer.borderColor = [[UIColor redColor] CGColor];
    [[SNSUtility shareInstanse] getNews:WeiboType withDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - sns delegate

-(void)receiveNews:(NSMutableArray *)newsArray{
    self.newsCache = newsArray;
    if (self.newsCache != nil && [self.newsCache count] > 0) {
        [self.NewsTableView reloadData];
    }
}

#pragma mark - tableView delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64.0f;
}

#pragma mark - tableView Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsCache.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeiboCell *cell = [[WeiboCell alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    [cell loadDataFromCache:[self.newsCache objectAtIndex:indexPath.row]];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}




@end
