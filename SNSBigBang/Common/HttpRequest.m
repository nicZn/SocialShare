//
//  SNSRequest.m
//  SNSBigBang
//
//  Created by 張 寧 on 2013/07/08.
//  Copyright (c) 2013年 張 寧. All rights reserved.
//

#import "HttpRequest.h"

static const NSTimeInterval kTimeoutInterval = 60.0;

@interface HttpRequest()

@property (nonatomic, strong)NSURL *httpURL;
@property (nonatomic, strong)NSString *httpMethod;
@property (nonatomic, strong)NSString *downloadFilePath;
@property (nonatomic, strong)NSMutableDictionary *param;
@property (nonatomic, strong)NSMutableURLRequest *request;
@property (nonatomic, strong)NSMutableData *receiveData;
@property (nonatomic, strong)NSMutableDictionary *userInfo;
@property (nonatomic)BOOL isDownloadFile;

@property (nonatomic, weak)id<HttpRequestDelegate>requestDelegate;

@end

@implementation HttpRequest

@synthesize httpURL;
@synthesize httpMethod;
@synthesize downloadFilePath = _downloadFilePath;
@synthesize param;
@synthesize request;
@synthesize receiveData;
@synthesize isDownloadFile;
@synthesize requestDelegate;

-(id)initWithURL:(NSString *)url andMethod:(NSString *)method{
    self = [super init];
    if (self) {
        self.request = [[NSMutableURLRequest alloc] init];
        [self.request setURL:[NSURL URLWithString:url]];
        [self.request setHTTPMethod:@"GET"];
        [self.request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [self.request setTimeoutInterval:kTimeoutInterval];
        [self.request setHTTPShouldHandleCookies:NO];
        self.receiveData = [[NSMutableData alloc] init];
        self.isDownloadFile = NO;
    }
    return self;
}

-(void)setDownloadFilePath:(NSString *)filePath{
    _downloadFilePath = filePath;
    self.isDownloadFile = YES;
}

-(void)setParams:(NSDictionary *)params{
    if (self.param) {
        [self.param addEntriesFromDictionary:params];
    }else{
        self.param = [NSMutableDictionary dictionaryWithDictionary:params];
    }
}

-(void)setHeader:(NSString *)value forKey:(NSString *)key{
    if (self.param) {
        [self.param setObject:[value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:key];
    }else{
        self.param = [NSMutableDictionary dictionaryWithObject:[value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]  forKey:key];
    }
}

-(void)setDelegate:(id<HttpRequestDelegate>)delegate{
    self.requestDelegate = delegate;
}

-(NSString *)getDownloadFilePath{
    if (isDownloadFile) {
        return _downloadFilePath;
    }
    else{
        return nil;
    }
}

-(void)start{
    if (self.param) {
        [self.request setAllHTTPHeaderFields:self.param];
    }
    [NSURLConnection sendAsynchronousRequest:self.request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response ,NSData* data, NSError* error ){
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (error || httpResponse.statusCode != 200) {
            if ([self.requestDelegate respondsToSelector:@selector(connectionFailed:withError:)]) {
                [self.requestDelegate connectionFailed:self withError:error];
            }
        }else{
            if (self.isDownloadFile) {
                [data writeToFile:self.downloadFilePath atomically:YES];
            }
            if ([self.requestDelegate respondsToSelector:@selector(connectionFinish:)]) {
                [self.requestDelegate connectionFinish:self];
            }
        }
        
    }];    
}



@end
