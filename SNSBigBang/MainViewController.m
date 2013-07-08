//
//  MainViewController.m
//  SNSBigBang
//
//  Created by 張 寧 on 2013/07/08.
//  Copyright (c) 2013年 張 寧. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()<UITabBarControllerDelegate>

@end

@implementation MainViewController

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
    self.delegate = self;
    [[[self navigationController] navigationBar] topItem].title = @"Renren";
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56, 40)];
//    [[button layer] setCornerRadius:8.0];
    [button setTitle:@"Login" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor redColor]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tabbar controller 

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    switch (self.selectedIndex + 1) {
        case 1:
        {
            [[[self navigationController] navigationBar] topItem].title = @"Weibo";
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56, 40)];
//            [[button layer] setCornerRadius:8.0];
            [button setTitle:@"Login" forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor redColor]];
        }
            break;
        case 2:
        {
            [[[self navigationController] navigationBar] topItem].title = @"WeChat";
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56, 40)];
//            [[button layer] setCornerRadius:8.0];
            [button setTitle:@"Login" forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor redColor]];
        }
            break;
            
        default:
            break;
    }
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
}

- (void)tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray *)viewControllers{
    NSLog(@"3%d",self.selectedIndex);
}
- (void)tabBarController:(UITabBarController *)tabBarController willEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed{
    NSLog(@"4%d",self.selectedIndex);
}
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed{
    NSLog(@"5%d",self.selectedIndex);
}


@end
