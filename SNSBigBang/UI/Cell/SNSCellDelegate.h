//
//  SNSCellDelegate.h
//  SNSBigBang
//
//  Created by 張 寧 on 2013/07/10.
//  Copyright (c) 2013年 張 寧. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RenrenCell;
@class WeiboCell;

@protocol SNSCellDelegate <NSObject>

-(void)commentRenren:(RenrenCell *)renrenCell;

-(void)commentWeibo:(WeiboCell *)renrenCell;
@end
