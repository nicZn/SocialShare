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
#import "FileManager.h"

static HttpManager *singletonHttpManager = nil;

@interface HttpManager()<HttpRequestDelegate>

@property (nonatomic, strong)NSOperationQueue *operationQueue;

// only for download file
@property (nonatomic, strong)NSMutableDictionary *finishDictionary;
@property (nonatomic, strong)NSMutableDictionary *inQueueDictionary;

@end

@implementation HttpManager

@synthesize operationQueue = _operationQueue;
@synthesize finishDictionary = _finishDictionary;
@synthesize inQueueDictionary = _inQueueDictionary;

+(HttpManager *)shareInstance{
    if (singletonHttpManager == nil) {
        singletonHttpManager = [[self alloc] init];
    }
    return singletonHttpManager;
}

+(void)tryToRelease{
    if(singletonHttpManager){
        [singletonHttpManager.operationQueue cancelAllOperations];
        singletonHttpManager.operationQueue = nil;
        [singletonHttpManager.finishDictionary removeAllObjects];
        singletonHttpManager.finishDictionary = nil;
        [singletonHttpManager.inQueueDictionary removeAllObjects];
        singletonHttpManager.inQueueDictionary = nil;
    }
    singletonHttpManager = nil;
}

-(id)init{
    self = [super init];
    if (self) {
        self.operationQueue = [[NSOperationQueue alloc] init];
        self.finishDictionary = [NSMutableDictionary dictionary];
        self.inQueueDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)downloadAvatar:(NSString *)urlString path:(NSString *)filePath{
    HttpRequest * request = [[HttpRequest alloc] initWithURL:urlString andMethod:@"GET"];
    if ([[self.finishDictionary allKeys] containsObject:urlString]) {
        if ([[self.finishDictionary objectForKey:urlString] containsObject:filePath]) {
            [[NZNotificationCenter shareInstance] postNotification:@"avatarDownloadFinished" withUserInfo:[NSDictionary dictionaryWithObject:filePath forKey:@"downloadFilePath"] waitUtilDone:NO];
        }else{
            NSMutableSet *set = [self.finishDictionary objectForKey:urlString];
            NSString *finishedFilePath = [set anyObject];
            if ([[FileManager shareInstance] copyFile:finishedFilePath toFile:filePath]) {
                [set addObject:filePath];
                [self.finishDictionary setObject:set forKey:urlString];
            }
        }
        return ;
    }else if([self.inQueueDictionary objectForKey:urlString]){
        NSMutableSet * set = [self.inQueueDictionary objectForKey:urlString];
        [set addObject:filePath];
        [self.inQueueDictionary setObject:set forKey:urlString];
        return ;
    }
    [self.inQueueDictionary setObject:[NSMutableSet setWithObject:filePath] forKey:urlString];
    [request setDownloadFilePath:filePath];
    [request setDelegate:self];
    [self.operationQueue addOperation:request];
}

-(void)downloadImage:(NSString *)urlString{
    HttpRequest *request = [[HttpRequest alloc] initWithURL:urlString andMethod:@"GET"];
    [request setDownloadFilePath:@"tmp"];
    [request setDelegate:self];
    [self.operationQueue addOperation:request];
}


#pragma mark - Http Request Delegate

-(void)connectionFinish:(HttpRequest *)request{
    [[NZNotificationCenter shareInstance] postNotification:@"avatarDownloadFinished" withUserInfo:[NSDictionary dictionaryWithObject:[request getDownloadFilePath] forKey:@"downloadFilePath"] waitUtilDone:NO];
    NSString *urlString = [request getURLString];
    NSMutableArray *filePathArray = [NSMutableArray arrayWithArray:[[self.inQueueDictionary objectForKey:urlString] allObjects]];
    if (filePathArray && filePathArray.count > 0) {
        [filePathArray removeObject:[request getDownloadFilePath]];
        for (NSString *filePath in filePathArray) {
            [[NZNotificationCenter shareInstance] postNotification:@"avatarDownloadFinished" withUserInfo:[NSDictionary dictionaryWithObject:filePath forKey:@"downloadFilePath"] waitUtilDone:NO];
        }
    }
    [self.finishDictionary setObject:[self.inQueueDictionary objectForKey: urlString] forKey:urlString];
    [self.inQueueDictionary removeObjectForKey:urlString];
}

-(void)connectionFailed:(HttpRequest *)request withError:(NSError *)error{
    
}

@end
