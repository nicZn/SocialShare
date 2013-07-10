//
//  WeiboCell.m
//  SNSBigBang
//
//  Created by 張 寧 on 2013/07/05.
//  Copyright (c) 2013年 張 寧. All rights reserved.
//

#import "WeiboCell.h"
#import "NZNotificationCenter.h"
#import "FileManager.h"
#import "HttpManager.h"

@interface WeiboCell()

//@property (nonatomic, strong) UIImage *avatarImage;
@property (nonatomic, strong) NSString *avatarFile;
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation WeiboCell

@synthesize avatarFile;


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(3,3, 44, 44)];
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
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

-(void)loadDataFromCache:(WeiboNewsCell *)dataCell{
    self.frame = CGRectMake(0, 0, 320, 100);
    self.avatarFile = [[[FileManager shareInstance] getAvatarDirectory:WeiboType] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",dataCell.name]];
    [self.avatarView setContentMode:UIViewContentModeScaleToFill];
    if([[FileManager shareInstance] isFileExist:self.avatarFile]){
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
    self.statusLabel.frame = CGRectMake(50, nameLabelSize.height + 5, statusLabelSize.width, statusLabelSize.height > 45.0?45:statusLabelSize.height);
    NSLog(@"%f,%f,%f",nameLabelSize.height+5,self.statusLabel.frame.size.width,self.statusLabel.frame.size.height);
    self.statusLabel.font = font;
    self.statusLabel.numberOfLines = 4;
    self.statusLabel.text = dataCell.content;
    [self addSubview:self.statusLabel];
    
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

@end
