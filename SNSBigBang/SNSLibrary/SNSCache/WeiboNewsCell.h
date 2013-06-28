//
//  WeiboNewsCell.h
//  SNSBigBang
//
//  Created by 張 寧 on 2013/06/28.
//  Copyright (c) 2013年 張 寧. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiboNewsCell : NSObject

@property (nonatomic) NSInteger user_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *headURL;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate * time;

@end
