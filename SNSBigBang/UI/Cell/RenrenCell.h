//
//  RenrenCell.h
//  SNSBigBang
//
//  Created by 張 寧 on 2013/07/01.
//  Copyright (c) 2013年 張 寧. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RenrenNewsCell.h"
#import "SNSCellDelegate.h"

@interface RenrenCell : UITableViewCell

-(void)loadDataFromCache:(RenrenNewsCell *)dataCell withDelegate:(id<SNSCellDelegate>)delegate;

@end
