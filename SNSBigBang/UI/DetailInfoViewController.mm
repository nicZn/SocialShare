//
//  DetailInfoViewController.m
//  SNSBigBang
//
//  Created by 張 寧 on 2013/07/10.
//  Copyright (c) 2013年 張 寧. All rights reserved.
//

#import "DetailInfoViewController.h"
#import "NewsCacheElement.h"
#import "FileManager.h"

@interface DetailInfoViewController ()<BMKGeneralDelegate>

@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, strong) UIImageView *headImageView;

@end

@implementation DetailInfoViewController
@synthesize userInfo = _userInfo;
@synthesize headImageView =_headImageView;

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
    if (self.userInfo != nil) {
        [self refreshViewByInfo];
    }
}

-(void)refreshViewByInfo{
    //load data to view
    SNSType type = (SNSType)[[self.userInfo objectForKey:@"Type"] intValue];
    switch (type) {
        case RenrenType:
            self.navigationItem.title = @"RenRen";
            break;
        case WeiboType:
            self.navigationItem.title = @"Weibo";
            break;
        case WeChatType:
            self.navigationItem.title = @"WeChat";
            break;
        case TencentType:
            self.navigationItem.title = @"Tencent Weibo";
            break;
        default:
            break;
    }
    
    NewsCacheElement *element = [self.userInfo objectForKey:@"Cell"];
    self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    self.headImageView.layer.cornerRadius = 5.0f;
    self.headImageView.layer.masksToBounds = YES;
    [self.headImageView setContentMode:UIViewContentModeScaleToFill];
    self.headImageView.image = [UIImage imageWithContentsOfFile:[[[FileManager shareInstance] getAvatarDirectory:type] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",element.user_id]]];
    [self.view addSubview:self.headImageView];
    
    BMKMapView *mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(10, 75, 300, 225)];
    mapView.delegate = nil;
    [mapView setMapType:BMKMapTypeSatellite];
    [mapView setCompassPosition:CGPointMake(121.0f, 31.0f)];
    [self.view addSubview:mapView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - segue

-(void)loadUserInfo:(NSDictionary *)userInfoDict{
    self.userInfo = [NSMutableDictionary dictionaryWithDictionary:userInfoDict];
}
- (void)viewDidUnload {
    [self setHeadImageView:nil];
    [super viewDidUnload];
}


@end
