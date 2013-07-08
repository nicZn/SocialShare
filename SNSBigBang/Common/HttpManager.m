//
//  HttpManager.m
//  SNSBigBang
//
//  Created by 張 寧 on 2013/07/08.
//  Copyright (c) 2013年 張 寧. All rights reserved.
//

#import "HttpManager.h"
#import "HttpRequest.h"
#import "NZNotificationCenter.h"

static HttpManager *singletonHttpManager = nil;

@interface HttpManager()<HttpRequestDelegate>

@property (nonatomic, strong)NSOperationQueue *operationQueue;


@end

@implementation HttpManager

@synthesize operationQueue;

+(HttpManager *)shareInstance{
    if (singletonHttpManager == nil) {
        singletonHttpManager = [[self alloc] init];
    }
    return singletonHttpManager;
}

-(id)init{
    self = [super init];
    if (self) {
        self.operationQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

-(void)downloadAvatar:(NSString *)urlString path:(NSString *)filePath{
    HttpRequest * request = [[HttpRequest alloc] initWithURL:urlString andMethod:@"GET"];
    [request setDownloadFilePath:filePath];
    [request setDelegate:self];
    [self.operationQueue addOperation:request];
}


#pragma mark - Http Request Delegate

-(void)connectionFinish:(HttpRequest *)request{
    NSLog(@"finish request:%@",request);
    [[NZNotificationCenter shareInstance] postNotification:@"avatarDownloadFinished" withUserInfo:[NSDictionary dictionaryWithObject:[request getDownloadFilePath] forKey:@"downloadFilePath"] waitUtilDone:NO];
}

-(void)connectionFailed:(HttpRequest *)request withError:(NSError *)error{
    
}

@end
