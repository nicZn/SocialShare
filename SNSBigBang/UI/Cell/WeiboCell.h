//
//  WeiboCell.h
//  SNSBigBang
//
//  Created by 張 寧 on 2013/07/05.
//  Copyright (c) 2013年 張 寧. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboNewsCell.h"


@interface WeiboCell : UITableViewCell

-(void)loadDataFromCache:(WeiboNewsCell *)dataCell;

@end
