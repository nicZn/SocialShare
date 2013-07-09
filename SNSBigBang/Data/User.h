//
//  User.h
//  SNSBigBang
//
//  Created by 張 寧 on 2013/07/09.
//  Copyright (c) 2013年 張 寧. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comments, Feed;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * avatarFilePath;
@property (nonatomic, retain) NSString * avatarUrl;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * snstype;
@property (nonatomic, retain) NSSet *feeds;
@property (nonatomic, retain) NSSet *comments;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addFeedsObject:(Feed *)value;
- (void)removeFeedsObject:(Feed *)value;
- (void)addFeeds:(NSSet *)values;
- (void)removeFeeds:(NSSet *)values;

- (void)addCommentsObject:(Comments *)value;
- (void)removeCommentsObject:(Comments *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

@end
