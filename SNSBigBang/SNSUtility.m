//
//  SNSUtility.m
//  SNSBigBang
//
//  Created by 張 寧 on 2013/06/25.
//  Copyright (c) 2013年 張 寧. All rights reserved.
//

#import "SNSUtility.h"
#import "Config.h"

#import "RennSDK/RennSDK.h"
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"
#import "TCWBEngine.h"

#import "NewsCacheElement.h"

//Renren config
#define RenrenAppId     @"237526"
#define RenrenAppKey    @"7627857571a64196bdf72f5e33762869"
#define RenrenSecertKey @"731a2b281dcd4e8fa5148dd9b7e00755"

//Tencent Weibo
#define TCWBAppKey       @"801384032"
#define TCWBAppSecertKey @"2fda5d0b3f5a3870b31c1bdce64ed62f"
#define TCWBAppRedirectUrl  @"http://t.qq.com/wangzizn"


static SNSUtility * singleSNSUtility = nil;

@interface SNSUtility()<RennLoginDelegate,RennServiveDelegate,SinaWeiboDelegate,SinaWeiboRequestDelegate>

@property (nonatomic) SinaWeibo *weibo;
@property (nonatomic, strong) TCWBEngine *wbEngine;
@property (nonatomic, weak) id<SNSDelegate> renrenDelegate;
@property (nonatomic, weak) id<SNSDelegate> weiboDelegate;
@property (nonatomic, weak) id<SNSDelegate> weChatDelegate;
@property (nonatomic, weak) id<SNSDelegate> tencentDelegate;

@end

@implementation SNSUtility

@synthesize weibo;
@synthesize wbEngine;
@synthesize renrenDelegate;
@synthesize weiboDelegate;
@synthesize weChatDelegate;

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
    [RennClient initWithAppId:RenrenAppId apiKey:RenrenAppKey secretKey:RenrenSecertKey];
    [RennClient setScope:@"read_user_blog read_user_photo read_user_status read_user_album read_user_comment read_user_share publish_blog publish_share send_notification photo_upload status_update create_album publish_comment publish_feed operate_like"];
    
    NSDictionary *sinaweiboInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"SinaWeiboAuthData"];
    self.weibo = [[SinaWeibo alloc] initWithAppKey:WeiboAppKey appSecret:WeiboSecertKey appRedirectURI:WeiboRedirectURI andDelegate:self];
    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
    {
        self.weibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        self.weibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        self.weibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    }
    
    //TencentWeibo
    self.wbEngine = [[TCWBEngine alloc] initWithAppKey:TCWBAppKey andSecret:TCWBAppSecertKey andRedirectUrl:TCWBAppRedirectUrl];
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

-(void)getSelfInfo:(SNSType)type withDelegate:(id<SNSDelegate>)delegate{
    self.renrenDelegate = delegate;
    GetUserParam * userParam = [[GetUserParam alloc] init];
    userParam.userId = [RennClient uid];
    [RennClient sendAsynRequest:userParam delegate:self];
}


-(void)getNews:(SNSType)type withDelegate:(id<SNSDelegate>)delegate{
    switch (type) {
        case RenrenType:
        {
            if (!delegate) {
                return ;
            }
            self.renrenDelegate = delegate;
            if([RennClient isLogin]){
                [self sendRennGetFeed];
            }else{
                [RennClient loginWithDelegate:self];
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
                [self getTimeLineOfWeibo];
            }else{
                [self.weibo logIn];
            }
        }
            break;
        case WeChatType:
        {
            
        }
            break;
        case TencentType:
        {
            if (!delegate) {
                return ;
            }
            self.tencentDelegate = delegate;
            if (![self.wbEngine isAuthorizeExpired]) {
                [self.wbEngine getHomeTimelinewithFormat:@"json" pageFlag:0 pageTime:@"0" reqNum:20 type:0 andContentType:0 parReserved:nil delegate:self onSuccess:@selector(getTencentHomeLine:) onFailure:@selector(getTencentHomeLineFailed:)];
            }else{
                [self.wbEngine setRootViewController:(UIViewController *)delegate];
                [self.wbEngine logInWithDelegate:self onSuccess:@selector(onSuccessLogin) onFailure:@selector(onFailureLogin:)];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - sns share
-(void)shareUrl:(NSDictionary *)infoDict withType:(SNSType)type{
    switch (type) {
        case RenrenType:
        {
            PutShareUrlParam *shareUrlParm = [[PutShareUrlParam alloc] init];
            shareUrlParm.comment = [[infoDict objectForKey:@"comment"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            shareUrlParm.url = [infoDict objectForKey:@"url"];
            [RennClient sendAsynRequest:shareUrlParm delegate:self];
        }
            break;
        case WeiboType:
        {
            NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
            [param setObject:[[infoDict objectForKey:@"comment"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"status"];
            [param setObject:[infoDict objectForKey:@"url"] forKey:@"url"];
            [[self.weibo requestWithURL:@"statuses/upload_url_text.json" params:param httpMethod:@"POST" delegate:self] connect];
        }
        case WeChatType:
        {
            
        }
            break;
        case TencentType:
        {
            [self.wbEngine postPictureURLTweetWithFormat:@"json" content:[[infoDict objectForKey:@"comment"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] clientIP:self.wbEngine.ip_iphone picURL:[infoDict objectForKey:@"url"] compatibleFlag:@"0" longitude:nil andLatitude:nil parReserved:nil delegate:self onSuccess:@selector(postShareFinish:) onFailure:@selector(postFailed:)];
        }
            break;
        default:
            break;
    }
}

-(void)sendRennGetFeed{
    ListFeedParam *param = [[ListFeedParam alloc] init];
    [param setPageSize:10];
    [RennClient sendAsynRequest:param delegate:self];
}

-(void)getTimeLineOfWeibo{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:WeiboAppKey forKey:@"appkey"];
    [self.weibo requestWithURL:@"statuses/friends_timeline.json" params:params httpMethod:@"GET" delegate:self];
}

-(void)pushStatus:(NSString *)status withType:(SNSType)type andDelegate:(id<SNSDelegate>)delegate{
    switch (type) {
        case RenrenType:
        {
            PutStatusParam *statusParam = [[PutStatusParam alloc] init];
            statusParam.content = status;
            [RennClient sendAsynRequest:statusParam delegate:self];
        }
            break;
        case WeiboType:
        {
            NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
            [param setObject:status forKey:@"status"];
            [[self.weibo requestWithURL:@"statuses/update.json" params:param httpMethod:@"POST" delegate:self] connect];
        }
            break;
        case WeChatType:
        {
            
        }
            break;
        case TencentType:
        {
            [self.wbEngine postTextTweetWithFormat:@"json" content:status clientIP:self.wbEngine.ip_iphone longitude:nil andLatitude:nil parReserved:nil delegate:self onSuccess:@selector(postShareFinish:) onFailure:@selector(postFailed:)];
        }
            break;
        default:
            break;
    }
}

-(void)getFriendsList:(SNSType)type{
    switch (type) {
        case RenrenType:
        {
            ListFriendParam *friendParam = [[ListFriendParam alloc] init];
            friendParam.userId = [RennClient uid];
            [RennClient sendAsynRequest:friendParam delegate:self];
        }
            break;
        case WeiboType:
        {
            [self.weibo requestWithURL:@"friendships/friends.json" params:[NSMutableDictionary dictionaryWithObject:self.weibo.userID forKey:@"uid"] httpMethod:@"GET" delegate:self];
        }
            break;
        case WeChatType:
        {
            
        }
            break;
        case TencentType:
        {
            [self.wbEngine getFriendIdolListWithFormat:@"json" reqNum:0 startIndex:0 andInstall:0 parReserved:nil delegate:self onSuccess:@selector(postShareFinish:) onFailure:@selector(postFailed:)];
        }
            break;
            
        default:
            break;
    }
}

-(void)postComment:(NSString *)comment withEntryId:(NSString *)entryId entryOwnerId:(NSString *)ownerId snsType:(SNSType)type{
    
}

#pragma mark - read data method

-(void)readTimeLineInfo:(id)result withType:(SNSType)type{
    NSArray *statusArray = (NSArray *)result;
    id delegate = nil;
    NSMutableArray *elementArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSDictionary *statusInfo in statusArray) {
        NewsCacheElement *element = [[NewsCacheElement alloc] init];
        switch (type) {
            case RenrenType:
            {
                delegate = self.renrenDelegate;
                NSDictionary *userInfo = [[statusInfo objectForKey:@"sourceUser"] isKindOfClass:[NSDictionary class]]?[statusInfo objectForKey:@"sourceUser"]:nil;
                if (userInfo) {
                    element.name = [userInfo objectForKey:@"name"];
                    element.headURL = [[[userInfo objectForKey:@"avatar"] objectAtIndex:0] objectForKey:@"url"];
                    element.user_id = [NSString stringWithFormat:@"%@", [userInfo objectForKey:@"id"]];
                    element.content = [statusInfo objectForKey:@"message"];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                    element.time = [dateFormatter dateFromString:[statusInfo objectForKey:@"time"]];
                    element.type = type;
                    dateFormatter = nil;
                    [elementArray addObject:element];
                }
                
            }
                break;
            case WeiboType:
            {
                delegate = self.weiboDelegate;
                element.name = [[statusInfo objectForKey:@"user"] objectForKey:@"screen_name"];
                element.content = [statusInfo objectForKey:@"text"];
                element.headURL = [[statusInfo objectForKey:@"user"] objectForKey:@"profile_image_url"];
                element.user_id = [NSString stringWithFormat:@"%@", [[statusInfo objectForKey:@"user"] objectForKey:@"id"]];
                element.time = [statusInfo objectForKey:@"created_at"];
                element.type = WeiboType;
                [elementArray addObject:element];
            }
                break;
            case WeChatType:
            {
                
            }
                break;
            case TencentType:
            {
                delegate = self.tencentDelegate;
                element.type = TencentType;
                element.name = [statusInfo objectForKey:@"nick"];
                element.content = [statusInfo objectForKey:@"text"];
                element.user_id = [statusInfo objectForKey:@"openid"];
                element.time = [NSDate dateWithTimeIntervalSince1970:[[statusInfo objectForKey:@"timestamp"] integerValue]];
                element.headURL = [statusInfo objectForKey:@"head"];
                [elementArray addObject:element];
                
            }
                break;
                
            default:
                break;
        }
    }
    if ([delegate respondsToSelector:@selector(receiveNews:)] && elementArray.count > 0) {
        [delegate receiveNews:elementArray];
    }
}



#pragma mark - Renren Delegate

-(void)rennLoginSuccess{
    [self sendRennGetFeed];
}

- (void)rennService:(RennService *)service requestSuccessWithResponse:(id)response
{
    if ([service.type isEqualToString:kRennServiceTypeListFeed]) {
        NSArray * info = response; 
        [self readTimeLineInfo:info withType:RenrenType];
    }
    else if([service.type isEqualToString:kRennServiceTypeGetUser]){
        NSLog(@"renren user info:%@",response);
    }
}

- (void)rennService:(RennService *)service requestFailWithError:(NSError*)error
{
    NSLog(@"requestFailWithError:%@", [error description]);

}




#pragma mark - Weibo Delegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo{
    [self saveSinaAuthInfo];
    [self getTimeLineOfWeibo];
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


#pragma mark - weibo request delegate


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
    if (statusArray == nil || statusArray.count < 1) {
        return ;
    }
    [self readTimeLineInfo:statusArray withType:WeiboType];
}

#pragma mark - Tencent Weibo

-(void)onSuccessLogin{
    [self.wbEngine getHomeTimelinewithFormat:@"json" pageFlag:0 pageTime:@"0" reqNum:20 type:0 andContentType:0 parReserved:nil delegate:self onSuccess:@selector(getTencentHomeLine:) onFailure:@selector(getTencentHomeLineFailed:)];
}

- (void)onFailureLogin:(NSError *)error{
    NSLog(@"error: %@",error);
}

-(void)getTencentHomeLine:(id)result{
    NSArray * status = [[result objectForKey:@"data"] objectForKey:@"info"];
    if (status == nil || status.count < 1) {
        return ;
    }
    [self readTimeLineInfo:status withType:TencentType];
}

-(void)getTencentHomeLineFailed:(NSError *)error{
    NSLog(@"error: %@",error);
}

-(void)postShareFinish:(id)result{
    
}

-(void)postFailed:(NSError *)error{
    NSLog(@"Tencent post failed; error: %@",error);
}

@end
