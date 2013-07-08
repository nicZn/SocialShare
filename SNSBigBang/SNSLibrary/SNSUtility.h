//
//  SNSUtility.h
//  SNSBigBang
//
//  Created by 張 寧 on 2013/06/25.
//  Copyright (c) 2013年 張 寧. All rights reserved.
//

#import <Foundation/Foundation.h>

//Weixin config
//#define WeixinAppId  @"wxd25b2dd6207a36f7"
#define WeixinAppKey @"f36df7f35cc9385a9b260b45210898f4"





//Weibo config

#define WeiboAppKey      @"3094941605"
#define WeiboSecertKey   @"1ae5122b9dfe1c102aae56cc33f98b67"
#define WeiboRedirectURI @"http://www.sina.com"

typedef enum {
    RenrenType = 0,
    WeiXinType = 1,
    WeiboType  = 2
    } SNSType;

@protocol SNSDelegate <NSObject>

@required
-(void)receiveNews:(NSMutableArray *)newsArray;

@required

@end

@interface SNSUtility : NSObject

+(SNSUtility *)shareInstanse;

-(void)getNews:(SNSType) type withDelegate:(id<SNSDelegate>)delegate;
-(void)pushStatus:(NSString *)status withType:(SNSType)type andDelegate:(id<SNSDelegate>)delegate ;
@end
