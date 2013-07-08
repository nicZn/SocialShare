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

-(NSString *)getAvatarDirectory:(SNSType)type;

-(BOOL)isFileExist:(NSString *)filePath;
@end
