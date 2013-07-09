//
//  Comments.h
//  SNSBigBang
//
//  Created by 張 寧 on 2013/07/09.
//  Copyright (c) 2013年 張 寧. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Feed, User;

@interface Comments : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) User *owner;
@property (nonatomic, retain) Feed *feedto;

@end
