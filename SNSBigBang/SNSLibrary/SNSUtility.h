//
//  SNSUtility.h
//  SNSBigBang
//
//  Created by 張 寧 on 2013/06/25.
//  Copyright (c) 2013年 張 寧. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Renren.h"
#import "SinaWeibo.h"

//Weixin config
#define WeixinAppId  @"wxd25b2dd6207a36f7"
#define WeixinAppKey @"f36df7f35cc9385a9b260b45210898f4"


//Renren config
//#define RenrenAppId     @"237526"
//#define RenrenAppKey    @"7627857571a64196bdf72f5e33762869"
//#define RenrenSecertKey @"731a2b281dcd4e8fa5148dd9b7e00755"


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
-(void)authSuccess:(SNSType) type withInfo:(NSDictionary *)userInfo;

@end

@interface SNSUtility : NSObject<RenrenDelegate,SinaWeiboDelegate,SinaWeiboRequestDelegate,SinaWeiboAuthorizeViewDelegate>

+(SNSUtility *)shareInstanse;

-(void)authRenrenWithDelegate:(id<SNSDelegate>) delegate;
-(void)getNewsForRenren;
-(void)sendRenrenStatus:(NSString *)status withDelegate:(id<SNSDelegate>) delegate;


-(void)authWeiboWithDelegate:(id<SNSDelegate>) delegate;
-(void)getNewsForWeibo:(id<SNSDelegate>)delegate;
-(void)pushStatus:(NSString *)status withDelegate:(id<SNSDelegate>)delegate;
@end
