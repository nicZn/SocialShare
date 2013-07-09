//
//  DataController.h
//  SNSBigBang
//
//  Created by 張 寧 on 2013/07/09.
//  Copyright (c) 2013年 張 寧. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataController : NSObject


+(DataController *)shareInstance;

-(void)addUsers:(NSArray *)usersArray;
-(void)addUser:(NSDictionary *)userInfo;
-(void)deleleUser:(NSInteger)userId;

-(void)addFeeds:(NSArray *)feedsArray;
-(void)addFeed:(NSDictionary *)feedInfo;
-(void)deleteFeed:(NSInteger)feedId;
-(void)deleteFeedOfUser:(NSInteger)userId;
@end
