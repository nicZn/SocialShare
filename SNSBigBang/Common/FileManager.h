//
//  FileManager.h
//  SNSBigBang
//
//  Created by 張 寧 on 2013/07/08.
//  Copyright (c) 2013年 張 寧. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

+(FileManager *)shareInstance;
+ (BOOL)tryToRelease;

-(NSString *)getTempDirectory;

-(NSString *)getAvatarDirectory:(SNSType)type;

-(BOOL)isFileExist:(NSString *)filePath;

-(NSURL *)getStoreFileURL;
-(NSURL *)getModelURL;

-(BOOL)copyFile:(NSString *)sourceFilePath toFile:(NSString *)toFilePath;
@end
