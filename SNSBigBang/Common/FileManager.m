//
//  FileManager.m
//  SNSBigBang
//
//  Created by 張 寧 on 2013/07/08.
//  Copyright (c) 2013年 張 寧. All rights reserved.
//

#import "FileManager.h"

static FileManager *singletonFileController = nil;
static NSString *s_userPoolDirectory = nil;


@interface FileManager()

@property (nonatomic) BOOL bInitial;
@property (nonatomic, strong) NSString *bundleDirectory;

@property (nonatomic, strong) NSString *renrenDirectory;
@property (nonatomic, strong) NSString *weiboDirectory;
@property (nonatomic, strong) NSString *wechatDirectory;

@property (nonatomic, strong) NSString *renrenAvatarDirectory;
@property (nonatomic, strong) NSString *weiboAvatarDirectory;
@property (nonatomic, strong) NSString *wechatAvatarDirectory;

@end

@implementation FileManager

@synthesize bInitial;
@synthesize bundleDirectory;
@synthesize renrenDirectory;
@synthesize weiboDirectory;
@synthesize wechatDirectory;

@synthesize renrenAvatarDirectory;
@synthesize weiboAvatarDirectory;
@synthesize wechatAvatarDirectory;

+(FileManager *)shareInstance{
    if (singletonFileController == nil) {
        singletonFileController = [[self alloc] init];
    }
    return singletonFileController;
}

+ (BOOL)tryToRelease
{
	if (singletonFileController != nil) {
        s_userPoolDirectory = nil;
		singletonFileController = nil;
		return YES;
	}
	
	return NO;
}

+ (NSString *)getUserPoolDirectory
{
    if (s_userPoolDirectory == nil) {
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSFileManager* osFileManager = [NSFileManager defaultManager];
        
        s_userPoolDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"userpool"];
        if ([osFileManager fileExistsAtPath:s_userPoolDirectory] == NO) {
            [osFileManager createDirectoryAtPath:s_userPoolDirectory withIntermediateDirectories:YES attributes:nil error:nil];
#ifdef _DEBUG_TRACE_LOG_
            NSLog(@"CreateUserPoolDirectory(%@): %@", res?@"Succeed":@"Failed", s_userPoolDirectory);
#endif
        }
    }
    
    return s_userPoolDirectory;
}

-(id)init{
    self = [super init];
    if (self.bInitial == NO) {
        NSFileManager *osFileManager = [NSFileManager defaultManager];
        self.bundleDirectory = [[NSBundle mainBundle] resourcePath];
        
        if (s_userPoolDirectory == nil) {
            [[self class] getUserPoolDirectory];
        }
        
        self.renrenDirectory = [s_userPoolDirectory stringByAppendingPathComponent:@"RenRen"];
        if (![osFileManager fileExistsAtPath:self.renrenDirectory]) {
            [osFileManager createDirectoryAtPath:self.renrenDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        self.weiboDirectory = [s_userPoolDirectory stringByAppendingPathComponent:@"Weibo"];
        if (![osFileManager fileExistsAtPath:self.weiboDirectory]) {
            [osFileManager createDirectoryAtPath:self.weiboDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        self.wechatDirectory = [s_userPoolDirectory stringByAppendingPathComponent:@"WeChat"];
        if (![osFileManager fileExistsAtPath:self.wechatDirectory]) {
            [osFileManager createDirectoryAtPath:self.wechatDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        self.renrenAvatarDirectory = [self.renrenDirectory stringByAppendingPathComponent:@"Avatar"];
        if (![osFileManager fileExistsAtPath:self.renrenAvatarDirectory]) {
            [osFileManager createDirectoryAtPath:self.renrenAvatarDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        self.weiboAvatarDirectory = [self.weiboDirectory stringByAppendingPathComponent:@"Avatar"];
        if (![osFileManager fileExistsAtPath:self.weiboAvatarDirectory]) {
            [osFileManager createDirectoryAtPath:self.weiboAvatarDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        self.wechatAvatarDirectory = [self.wechatDirectory stringByAppendingPathComponent:@"Avatar"];
        if (![osFileManager fileExistsAtPath:self.wechatAvatarDirectory]) {
            [osFileManager createDirectoryAtPath:self.wechatAvatarDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        bInitial = YES;
    }
    return self;
}

-(NSString *)getAvatarDirectory:(SNSType)type{
    switch (type) {
        case RenrenType:
            return self.renrenAvatarDirectory;
            break;
        case WeiboType:
            return self.weiboAvatarDirectory;
            break;
        case WeChatType:
            return self.wechatDirectory;
            break;
        default:
            break;
    }
    return nil;
}

-(NSURL *)getStoreFileURL{
    return [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"model.sqlite"];
}

-(NSURL *)getModelURL{
    return [[NSBundle mainBundle] URLForResource:@"LocalModel" withExtension:@"momd"];
}

-(BOOL)isFileExist:(NSString *)filePath{
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

@end
