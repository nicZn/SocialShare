//
//  SNSRequest.h
//  SNSBigBang
//
//  Created by 張 寧 on 2013/07/08.
//  Copyright (c) 2013年 張 寧. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HttpRequest;
@protocol HttpRequestDelegate <NSObject>

@required
-(void)connectionFinish:(HttpRequest *)request;

-(void)connectionFailed:(HttpRequest *)request withError:(NSError *)error;

@optional

-(void)downloadedLength:(NSInteger)finishedLength withTotalLength:(NSInteger)totalLength;

@end

@interface HttpRequest : NSOperation

-(id)initWithURL:(NSString *)url andMethod:(NSString *)method;

-(void)setDownloadFilePath:(NSString *)filePath;

-(void)setParams:(NSDictionary *)params;

-(void)setDelegate:(id<HttpRequestDelegate>)delegate;

-(NSString *)getDownloadFilePath;

@end


