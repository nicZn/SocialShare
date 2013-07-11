//
//  NewsCacheElement.h
//  SNSBigBang
//
//  Created by 張 寧 on 2013/07/10.
//  Copyright (c) 2013年 張 寧. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsCacheElement : NSObject

@property (nonatomic) NSString* user_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *headURL;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate * time;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic) SNSType type;

@end
