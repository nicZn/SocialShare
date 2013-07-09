//
//  Feed.h
//  SNSBigBang
//
//  Created by 張 寧 on 2013/07/09.
//  Copyright (c) 2013年 張 寧. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Feed : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSNumber * snsType;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) User *owner;

@end
