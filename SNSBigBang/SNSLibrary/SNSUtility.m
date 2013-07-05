//
//  SNSUtility.m
//  SNSBigBang
//
//  Created by 張 寧 on 2013/06/25.
//  Copyright (c) 2013年 張 寧. All rights reserved.
//

#import "SNSUtility.h"
#import "Renren.h"
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"
#import "RenrenNewsCell.h"
#import "WeiboNewsCell.h"

static SNSUtility * singleSNSUtility = nil;

@interface SNSUtility()

@property (nonatomic) SinaWeibo *weibo;
@property (nonatomic, weak) id<SNSDelegate> renrenDelegate;
@property (nonatomic, weak) id<SNSDelegate> weiboDelegate;
@property (nonatomic, weak) id<SNSDelegate> weixinDelegate;

@end

@implementation SNSUtility

@synthesize weibo;

+(SNSUtility *)shareInstanse{
    if(singleSNSUtility == nil){
        singleSNSUtility = [[SNSUtility alloc] init];
    }
    return singleSNSUtility;
}

-(id)init{
    self = [super init];
    if (self) {
        [self loadAuthInfo];
    }
    return self;
}

#pragma mark - auth info

-(void)loadAuthInfo{
    NSDictionary *sinaweiboInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"SinaWeiboAuthData"];
    self.weibo = [[SinaWeibo alloc] initWithAppKey:WeiboAppKey appSecret:WeiboSecertKey appRedirectURI:WeiboRedirectURI andDelegate:self];
    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
    {
        self.weibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        self.weibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        self.weibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    }
}

-(void)saveSinaAuthInfo{
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              self.weibo.accessToken, @"AccessTokenKey",
                              self.weibo.expirationDate, @"ExpirationDateKey",
                              self.weibo.userID, @"UserIDKey",
                              self.weibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)removeSinaAuthInfo{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - sns method

-(void)getNews:(SNSType) type withDelegate:(id<SNSDelegate>)delegate{
    switch (type) {
        case RenrenType:
        {
            if (!delegate) {
                return ;
            }
            self.renrenDelegate = delegate;
            if([[Renren sharedRenren] isSessionValid]){
                NSMutableDictionary * params = [NSMutableDictionary dictionary];
                [params setObject:@"feed.get" forKey:@"method"];
                [params setObject:@"10" forKey:@"type"];
                [[[Renren sharedRenren] requestWithParams:params andDelegate:singleSNSUtility] connect];
            }else{
                [[Renren sharedRenren] authorizationWithPermisson:[[NSArray alloc] initWithObjects:@"read_user_feed status_update", nil] andDelegate:singleSNSUtility];
            }
        }
            break;
        case WeiboType:
        {
            if (!delegate) {
                return ;
            }
            self.weiboDelegate = delegate;
            if([self.weibo isAuthValid]){
                NSMutableDictionary * params = [NSMutableDictionary dictionary];
                [params setObject:WeiboAppKey forKey:@"appkey"];
                [[weibo requestWithURL:@"statuses/friends_timeline.json" params:params httpMethod:@"GET" delegate:singleSNSUtility] connect];
            }else{
                [self.weibo logIn];
            }
        }
            break;
        case WeiXinType:
        {
            
        }
            break;
        default:
            break;
    }
}

-(void)pushStatus:(NSString *)status withType:(SNSType)type andDelegate:(id<SNSDelegate>)delegate{
    
}


-(void)sendRenrenStatus:(NSString *)status withDelegate:(id<SNSDelegate>) delegate{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:@"status.set" forKey:@"method"];
    [params setObject:status forKey:@"status"];
    [params setObject:@"1.0" forKey:@"v"];
    [[[Renren sharedRenren] requestWithParams:params andDelegate:singleSNSUtility] connect];
}



#pragma mark - Weibo


-(void)getNewsForWeibo:(id<SNSDelegate>)delegate{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:WeiboAppKey forKey:@"appkey"];
    [[weibo requestWithURL:@"statuses/friends_timeline.json" params:params httpMethod:@"GET" delegate:singleSNSUtility] connect];
}

-(void)pushStatus:(NSString *)status withDelegate:(id<SNSDelegate>)delegate{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:[[NSString alloc] initWithCString:[status cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding] forKey:@"status"];
    [[weibo requestWithURL:@"statuses/update.json" params:params httpMethod:@"POST" delegate:singleSNSUtility] connect];
}


#pragma mark - Renren Delegate
/**
 * 接口请求成功，第三方开发者实现这个方法
 * @param renren 传回代理服务器接口请求的Renren类型对象。
 * @param response 传回接口请求的响应。
 */
- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse*)response{
        NSArray * info = [response rootObject];  // json response string
        NSMutableArray * newsArray = [NSMutableArray array];
        for (NSDictionary *single in info) {
            RenrenNewsCell *singleInfo = [[RenrenNewsCell alloc] init];
            singleInfo.name = [single objectForKey:@"name"];
            singleInfo.headURL = [single objectForKey:@"headurl"];
            singleInfo.user_id = [[single objectForKey:@"actor_id"] integerValue];
            singleInfo.content = [single objectForKey:@"message"];
            [newsArray addObject:singleInfo];
        }
        if ([self.renrenDelegate respondsToSelector:@selector(receiveNews:)] && newsArray.count > 0) {
            [self.renrenDelegate receiveNews:newsArray];
        }
}

/**
 * 接口请求失败，第三方开发者实现这个方法
 * @param renren 传回代理服务器接口请求的Renren类型对象。
 * @param response 传回接口请求的错误对象。
 */
- (void)renren:(Renren *)renren requestFailWithError:(ROError*)error{
    NSLog(@"request error");
}

/**
 * renren取消Dialog时调用，第三方开发者实现这个方法
 * @param renren 传回代理授权登录接口请求的Renren类型对象。
 */
- (void)renrenDialogDidCancel:(Renren *)renren{
    NSLog(@"dialog cancel");
}


/**
 * 授权登录成功时被调用，第三方开发者实现这个方法
 * @param renren 传回代理授权登录接口请求的Renren类型对象。
 */
- (void)renrenDidLogin:(Renren *)renren{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:@"feed.get" forKey:@"method"];
    [params setObject:@"10" forKey:@"type"];
    [[renren requestWithParams:params andDelegate:singleSNSUtility] connect];
}

/**
 * 用户登出成功后被调用 第三方开发者实现这个方法
 * @param renren 传回代理登出接口请求的Renren类型对象。
 */
- (void)renrenDidLogout:(Renren *)renren{
    NSLog(@"logout");
}

/**
 * 授权登录失败时被调用，第三方开发者实现这个方法
 * @param renren 传回代理授权登录接口请求的Renren类型对象。
 */
- (void)renren:(Renren *)renren loginFailWithError:(ROError*)error{
    NSLog(@"Login Fail!");
}


#pragma mark - Weibo Delegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo{
    [self saveSinaAuthInfo];
}


- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo{
    [self removeSinaAuthInfo];
}


- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo{
    
}


- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error{
    
}


- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error{
    
}


#pragma mark


/*
 don't use now , so 
 */

//- (void)request:(SinaWeiboRequest *)request didReceiveResponse:(NSURLResponse *)response{
//    NSLog(@"get all response: %@",response);
//}
//
//- (void)request:(SinaWeiboRequest *)request didReceiveRawData:(NSData *)data{
//    NSLog(@"get all data: %@",data);
//}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"error: %@",error);
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{
    NSDictionary *dataDict = (NSDictionary *)result;
    NSArray *statusArray = [dataDict objectForKey:@"statuses"];
    NSMutableArray *statusInfo = [NSMutableArray array];
    for (NSDictionary *dict in statusArray) {
        WeiboNewsCell *cell = [[WeiboNewsCell alloc] init];
        cell.name = [[dict objectForKey:@"user"] objectForKey:@"screen_name"];
        cell.content = [dict objectForKey:@"text"];
        cell.headURL = [[dict objectForKey:@"user"] objectForKey:@"profile_image_url"];
        cell.user_id = [[[dict objectForKey:@"user"] objectForKey:@"id"] integerValue];
        cell.time = [dict objectForKey:@"created_at"];
        [statusInfo addObject:cell];
    }
    [self.weiboDelegate receiveNews:statusInfo];
}



@end
