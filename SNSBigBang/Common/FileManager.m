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

@property (nonatomic, strong) NSString *avatarDirectory;
@property (nonatomic, strong) NSString *configDirectory;

@end

@implementation FileManager

@synthesize bInitial;
@synthesize bundleDirectory;

@synthesize avatarDirectory = _avatarDirectory;
@synthesize configDirectory = _configDirectory;

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
        
        self.avatarDirectory = [s_userPoolDirectory stringByAppendingPathComponent:@"Avatar"];
        if (![osFileManager fileExistsAtPath:self.avatarDirectory]) {
            [osFileManager createDirectoryAtPath:self.avatarDirectory withIntermediateDirectories:YES attributes:nil error:nil];
            [self initInsideFilePath:self.avatarDirectory];
        }

        self.configDirectory = [s_userPoolDirectory stringByAppendingPathComponent:@"Config"];
        if (![osFileManager fileExistsAtPath:self.configDirectory]) {
            [osFileManager createDirectoryAtPath:self.configDirectory withIntermediateDirectories:YES attributes:nil error:nil];
            [self initInsideFilePath:self.configDirectory];
        }

        
        bInitial = YES;
    }
    return self;
}

-(void)initInsideFilePath:(NSString *)directory{
    NSFileManager *osFileManager = [NSFileManager defaultManager];
    NSString* renrenDirectory = [directory stringByAppendingPathComponent:@"RenRen"];
    if (![osFileManager fileExistsAtPath:renrenDirectory]) {
        [osFileManager createDirectoryAtPath:renrenDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString* weiboDirectory = [directory stringByAppendingPathComponent:@"Weibo"];
    if (![osFileManager fileExistsAtPath:weiboDirectory]) {
        [osFileManager createDirectoryAtPath:weiboDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString* wechatDirectory = [directory stringByAppendingPathComponent:@"WeChat"];
    if (![osFileManager fileExistsAtPath:wechatDirectory]) {
        [osFileManager createDirectoryAtPath:wechatDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString* tencentDirectory = [directory stringByAppendingPathComponent:@"Tencent"];
    if (![osFileManager fileExistsAtPath:tencentDirectory]) {
        [osFileManager createDirectoryAtPath:tencentDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

-(NSString *)getTempDirectory{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
}

-(NSString *)getAvatarDirectory:(SNSType)type{
    switch (type) {
        case RenrenType:
            return [self.avatarDirectory stringByAppendingPathComponent:@"RenRen"];
            break;
        case WeiboType:
            return [self.avatarDirectory stringByAppendingPathComponent:@"Weibo"];
            break;
        case WeChatType:
            return [self.avatarDirectory stringByAppendingPathComponent:@"WeCaht"];
            break;
        case TencentType:
            return [self.avatarDirectory stringByAppendingPathComponent:@"Tencent"];
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

-(BOOL)copyFile:(NSString *)sourceFilePath toFile:(NSString *)toFilePath{
    NSFileManager *osFileManager = [NSFileManager defaultManager];
    if (![osFileManager fileExistsAtPath:sourceFilePath]) {
        return NO;
    }
    if ([osFileManager fileExistsAtPath:toFilePath]) {
        [osFileManager removeItemAtPath:toFilePath error:nil];
    }
    return [osFileManager copyItemAtPath:sourceFilePath toPath:toFilePath error:nil];
}

@end
