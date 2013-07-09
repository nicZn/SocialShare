//
//  BasicViewController.m
//  SNSBigBang
//
//  Created by 張 寧 on 2013/07/09.
//  Copyright (c) 2013年 張 寧. All rights reserved.
//

#import "BasicViewController.h"

@interface BasicViewController ()

@property (nonatomic, strong)UIView *leftView;
@property (nonatomic, strong)UIView *rightView;

@end

@implementation BasicViewController

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
    
	[self.view addSubview:self.leftView];
    [self.view addSubview:self.rightView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



@end
