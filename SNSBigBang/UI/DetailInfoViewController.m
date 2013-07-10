//
//  DetailInfoViewController.m
//  SNSBigBang
//
//  Created by 張 寧 on 2013/07/10.
//  Copyright (c) 2013年 張 寧. All rights reserved.
//

#import "DetailInfoViewController.h"

@interface DetailInfoViewController ()

@property (nonatomic, strong) NSMutableDictionary *userInfo;

@end

@implementation DetailInfoViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - segue

-(void)loadUserInfo:(NSDictionary *)userInfoDict{
    self.userInfo = [NSMutableDictionary dictionaryWithDictionary:userInfoDict];
}
@end
