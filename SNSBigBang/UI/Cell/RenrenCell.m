//
//  RenrenCell.m
//  SNSBigBang
//
//  Created by 張 寧 on 2013/07/01.
//  Copyright (c) 2013年 張 寧. All rights reserved.
//

#import "RenrenCell.h"
#import "HttpManager.h"
#import "FileManager.h"
#import "NZNotificationCenter.h"


@interface RenrenCell()

@property (nonatomic, strong) NSString *avatarFile;
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) id<SNSCellDelegate> delegate;
@property (nonatomic, strong) UIView *moreMenu;

@end

@implementation RenrenCell

@synthesize avatarFile;
@synthesize avatarView;
@synthesize nameLabel;
@synthesize statusLabel;
@synthesize moreButton;
@synthesize delegate;

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(3,3, 44, 44)];
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 3, 270, 20)];
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 25, 270, 25)];
        [self addSubview:self.avatarView];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadDataFromCache:(RenrenNewsCell *)dataCell withDelegate:(id<SNSCellDelegate>)delegate{
    self.frame = CGRectMake(0, 0, 320, 100);
    self.delegate = delegate;
    self.avatarFile = [[[FileManager shareInstance] getAvatarDirectory:RenrenType] stringByAppendingPathComponent:[[dataCell.headURL componentsSeparatedByString:@"/"] lastObject]];
    [self.avatarView setContentMode:UIViewContentModeScaleToFill];
    if ([[FileManager shareInstance] isFileExist:self.avatarFile]) {
        self.avatarView.image = [UIImage imageWithContentsOfFile:self.avatarFile];
    }else{
        [[NZNotificationCenter shareInstance] addObserver:self forNotification:@"avatarDownloadFinished" withSelector:@selector(avatarDownloadFinished:)];
        [[HttpManager shareInstance] downloadAvatar:dataCell.headURL path:self.avatarFile];
    }
    
    UIFont *font = [UIFont fontWithName:@"Arial" size:16.0];
    CGSize size = CGSizeMake(270, 960);
    CGSize nameLabelSize = [dataCell.name sizeWithFont:font constrainedToSize:size];
    self.nameLabel.frame = CGRectMake(50, 3, nameLabelSize.width, nameLabelSize.height);
    self.nameLabel.font = font;
    self.nameLabel.text = dataCell.name;
    [self addSubview:self.nameLabel];
    
    font = [UIFont fontWithName:@"Arial" size:12.0];
    size = CGSizeMake(270, 960);
    CGSize statusLabelSize = [dataCell.content sizeWithFont:font constrainedToSize:size];

    self.statusLabel.frame = CGRectMake(50, nameLabelSize.height + 5, statusLabelSize.width, statusLabelSize.height > 45.0?45.0:statusLabelSize.height);
    self.statusLabel.font = font;
    self.statusLabel.numberOfLines = 3;
    self.statusLabel.text = dataCell.content;
    [self addSubview:self.statusLabel];
    
    self.moreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.moreButton.frame = CGRectMake(290,68, 23, 30);
    [self.moreButton setTitle:@"M" forState:UIControlStateNormal];
    [self.moreButton addTarget:self action:@selector(clickMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.moreButton];
    
    [self loadMoreMenu];
}

#pragma mark - UI Method

-(void)loadMoreMenu{
    self.moreMenu = [[UIView alloc] initWithFrame:CGRectMake(128, 68, 160, 30)];
    self.moreMenu.layer.borderColor = [[UIColor brownColor] CGColor];
    self.moreMenu.layer.borderWidth = 3.0f;
    self.moreMenu.layer.cornerRadius = 4.0f;
    self.moreMenu.backgroundColor = [UIColor blueColor];
    UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    likeButton.frame = CGRectMake(5, 4, 70, 22);
    likeButton.layer.cornerRadius = 5.0f;
    likeButton.layer.borderColor = [[UIColor blackColor] CGColor];
    likeButton.layer.borderWidth = 1.0f;
    likeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    likeButton.layer.masksToBounds = NO;
    [likeButton setTitle:@"Like" forState:UIControlStateNormal];
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    commentButton.frame = CGRectMake(80, 4, 70, 22);
    commentButton.layer.masksToBounds = YES;
    commentButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [commentButton setTitle:@"Comment" forState:UIControlStateNormal];
    [self.moreMenu addSubview:likeButton];
    [self.moreMenu addSubview:commentButton];
    self.moreMenu.hidden = YES;
    [self insertSubview:self.moreMenu belowSubview:self.moreButton];
}

#pragma mark - Notification method

-(void)avatarDownloadFinished:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *avatarPath = [userInfo objectForKey:@"downloadFilePath"];
    if (avatarPath != nil && [self.avatarFile isEqualToString:avatarPath]) {
        [[NZNotificationCenter shareInstance] removeObserver:self forNotification:@"avatarDownloadFinished"];
        self.avatarView.image = [UIImage imageWithContentsOfFile:self.avatarFile];
    }
}

-(IBAction)clickMoreButton:(id)sender{
    if (self.moreMenu.hidden) {
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.5f];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [animation setType:@"moveIn"];
        [animation setSubtype: kCATransitionFromRight];
        self.moreMenu.hidden = NO;
        [self.moreMenu.layer addAnimation:animation forKey:@"animation"];
    }else{
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.5f];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [animation setType:@"reveal"];
        [animation setSubtype: kCATransitionFromLeft];
        self.moreMenu.hidden = YES;
        [self.moreMenu.layer addAnimation:animation forKey:@"animation"];
    }
    
}

@end
