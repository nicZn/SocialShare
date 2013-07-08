//
//  HttpManager.m
//  SNSBigBang
//
//  Created by 張 寧 on 2013/07/08.
//  Copyright (c) 2013年 張 寧. All rights reserved.
//

#import "HttpManager.h"
#import "HttpRequest.h"

static HttpManager *singletonHttpManager = nil;

@interface HttpManager()<HttpRequestDelegate>

@property (nonatomic, strong)dispatch_queue_t dispatch_queue;
@end

@implementation HttpManager

@synthesize dispatch_queue;

+(HttpManager *)shareInstance{
    if (singletonHttpManager == nil) {
        singletonHttpManager = [[self alloc] init];
    }
    return singletonHttpManager;
}

-(id)init{
    self = [super init];
    if (self) {
        self.dispatch_queue = dispatch_queue_create("Http donwload queue", NULL);
    }
    return self;
}

-(void)downloadAvatar:(NSString *)urlString path:(NSString *)filePath{
    dispatch_async(self.dispatch_queue, ^(){
        HttpRequest * request = [[HttpRequest alloc] initWithURL:urlString andMethod:@"GET"];
        [request setDownloadFilePath:filePath];
        [request connect];
    });
}


#pragma mark - Http Request Delegate

-(void)connectionFinish:(HttpRequest *)request{
    NSLog(@"finish request:%@",request);
}

-(void)connectionFailed:(HttpRequest *)request withError:(NSError *)error{
    
}

@end
