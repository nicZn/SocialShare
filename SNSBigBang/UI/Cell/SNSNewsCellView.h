//
//  SNSNewsCellView.h
//  SNSBigBang
//
//  Created by 張 寧 on 2013/07/10.
//  Copyright (c) 2013年 張 寧. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNSCellDelegate.h"
#import "NewsCacheElement.h"

@interface SNSNewsCellView : UITableViewCell

@property (nonatomic)SNSType type;

-(void)loadDataFromCache:(NewsCacheElement *)dataCell withDelegate:(id<SNSCellDelegate>)snsCellDelegate;

@end
