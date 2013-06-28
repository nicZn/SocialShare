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

static SNSUtility * singleSNSUtility = nil;

@interface SNSUtility()

@property (nonatomic) SinaWeibo *weibo;

@end

@implementation SNSUtility

@synthesize weibo;

+(SNSUtility *)shareInstanse{
    if(singleSNSUtility == nil){
        singleSNSUtility = [[SNSUtility alloc] init];
    }
    return singleSNSUtility;
}

#pragma mark - Renren

-(void) authRenrenWithDelegate:(id<SNSDelegate>)delegate{
    if(![[Renren sharedRenren] isSessionValid]){
        [[Renren sharedRenren] authorizationWithPermisson:[[NSArray alloc] initWithObjects:@"read_user_feed status_update", nil] andDelegate:singleSNSUtility];
    }
    else{
        
    }
}

-(void)getNewsForRenren{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:@"feed.get" forKey:@"method"];
    [params setObject:@"10" forKey:@"type"];
    [[[Renren sharedRenren] requestWithParams:params andDelegate:singleSNSUtility] connect];
}

-(void)sendRenrenStatus:(NSString *)status withDelegate:(id<SNSDelegate>) delegate{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:@"status.set" forKey:@"method"];
    [params setObject:status forKey:@"status"];
    [params setObject:@"1.0" forKey:@"v"];
    [[[Renren sharedRenren] requestWithParams:params andDelegate:singleSNSUtility] connect];
}



#pragma mark - Weibo

-(void)authWeiboWithDelegate:(id<SNSDelegate>)delegate{
    weibo = [[SinaWeibo alloc] initWithAppKey:WeiboAppKey appSecret:WeiboSecertKey appRedirectURI:WeiboRedirectURI andDelegate:singleSNSUtility];
    [weibo logIn];
}

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
    for (NSDictionary *single in info) {
        NSLog(@"%@",[single objectForKey:@"name"]);
        
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
    NSLog(@"%@",renren);
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
    
}


- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo{
    
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
    NSLog(@"get all result: %@",result);
}

@end
