//
//  TencentWeiboViewController.m
//  SNSBigBang
//
//  Created by 張 寧 on 2013/07/11.
//  Copyright (c) 2013年 張 寧. All rights reserved.
//

#import "TencentWeiboViewController.h"
#import "SNSUtility.h"
#import "SNSNewsCellView.h"
#import "DetailInfoViewController.h"


@interface TencentWeiboViewController ()<UITableViewDataSource ,UITableViewDelegate ,SNSDelegate ,SNSCellDelegate>

@property (nonatomic) UITableView *NewsTableView;
@property (nonatomic, strong) NSMutableArray *newsCache;

@property (nonatomic) BOOL isShowMoreMenu;

@end

@implementation TencentWeiboViewController

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
    self.NewsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 92) style:UITableViewStylePlain];
    self.NewsTableView.dataSource = self;
    self.NewsTableView.delegate = self;
    [self.view addSubview:self.NewsTableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [[SNSUtility shareInstanse] getNews:TencentType withDelegate:self];
    //    [[[self navigationController] navigationBar] topItem].title = @"Renren";
    //    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56, 40)];
    //    [[button layer] setCornerRadius:8.0];
    //    [button setTitle:@"Login" forState:UIControlStateNormal];
    //    [button setBackgroundColor:[UIColor redColor]];
    //    [button addTarget:self action:@selector(authUser:) forControlEvents:UIControlEventTouchUpInside];
    //    [[[[self navigationController] navigationBar] topItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:button]];
}

-(void)viewDidAppear:(BOOL)animated{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button Action


#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}

#pragma mark - table data delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsCache.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SNSNewsCellView *cell = [[SNSNewsCellView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    [cell loadDataFromCache:[self.newsCache objectAtIndex:indexPath.row] withDelegate:self];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexPath = [self.NewsTableView indexPathForSelectedRow];
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        DetailInfoViewController *vc = [segue destinationViewController];
        [vc loadUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:[self.newsCache objectAtIndex:indexPath.row],@"Cell",[NSNumber numberWithInteger:RenrenType],@"Type",nil]];
    }
}


#pragma mark - sns delegate

-(void)receiveNews:(NSMutableArray *)newsArray{
    self.newsCache = newsArray;
    [self.NewsTableView reloadData];
}
@end
