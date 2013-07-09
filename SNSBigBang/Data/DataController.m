//
//  DataController.m
//  SNSBigBang
//
//  Created by 張 寧 on 2013/07/09.
//  Copyright (c) 2013年 張 寧. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "DataController.h"
#import "FileManager.h"
#import "User.h"
#import "Feed.h"

static DataController * singletonDataController = nil;

@interface DataController()

@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property(nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic, strong) NSMutableDictionary *usersDict;
@property(nonatomic, strong) NSMutableDictionary *feedsDict;

@property (nonatomic, strong) NSOperationQueue *saveQueue;

@end

@implementation DataController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize usersDict = _usersDict;
@synthesize feedsDict = _feedsDict;


+(DataController *)shareInstance{
    if (singletonDataController == nil) {
        singletonDataController = [[self alloc] init];
    }
    return  singletonDataController;
}

-(id)init{
    self = [super init];
    if (self) {
        //init data
        self.saveQueue = [[NSOperationQueue alloc] init];
        [self loadData];
        [self startSaveThread];
    }
    return self;
}

-(void)loadData{
    NSArray *users = [self sortEntity:@"User" withKey:nil andValue:nil];
    NSArray *feeds = [self sortEntity:@"Feed" withKey:nil andValue:nil];
    self.usersDict = [NSMutableDictionary dictionary];
    self.feedsDict = [NSMutableDictionary dictionary];
    for (User* user in users) {
        [self.usersDict setObject:user forKey:user.id];
    }
    for (Feed *feed in feeds) {
        [self.feedsDict setObject:feed forKey:feed.id];
    }
}

-(void)startSaveThread{
    [self.saveQueue addOperationWithBlock:^(void){
        while (1) {
            NSLog(@"Data save info!");
            [NSThread sleepForTimeInterval:60*10];
            [self saveContext];
        }
    }];
}


#pragma mark - Data Model Init

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if(_persistentStoreCoordinator!=nil)
    {
        return _persistentStoreCoordinator;
    }
    NSURL *storeURL=[[FileManager shareInstance] getStoreFileURL];
    
    NSError *error;
    _persistentStoreCoordinator=[[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:[self managedObjectModel]];
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"创建存储协调器错误了：%@",error);
    }
    return _persistentStoreCoordinator;
}

-(NSManagedObjectContext *)managedObjectContext
{
    if(_managedObjectContext!=nil)
    {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator=[self persistentStoreCoordinator];
    if(coordinator!=nil)
    {
        _managedObjectContext=[[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

-(NSManagedObjectModel *)managedObjectModel
{
    if(_managedObjectModel!=nil)
    {
        return _managedObjectModel;
    }
    NSURL *storeURL=[[FileManager shareInstance] getModelURL];
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:storeURL];
}

-(void)saveContext
{
    NSError *error;
    NSManagedObjectContext *managedObjectContext=self.managedObjectContext;
    if(managedObjectContext!=nil)
    {
        NSLog(@"%@",[NSNumber numberWithBool:[managedObjectContext hasChanges]]);
        if([managedObjectContext hasChanges]&&![managedObjectContext save:&error])
        {
            NSLog(@"保存数据时出错了:%@",error);
        }
    }
}

-(NSArray *)sortEntity:(NSString *)entityName withKey:(NSString *)keyName andValue:(id)value{
    if(entityName == nil || (keyName == nil && value != nil))
        return nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    if (nil != value) {
        request.predicate = [NSPredicate predicateWithFormat:[keyName stringByAppendingString:@" = %@"],value];
        
    }
    if (keyName != nil) {
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:keyName ascending:YES];
        request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    }
    
    NSError *error = nil;
    
    NSArray *matches = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        
        return nil;
    }
    return matches;
}

#pragma mark - User Method

-(void)addUsers:(NSArray *)usersArray{
    for (NSDictionary *userInfo in usersArray) {
        [self addUser:userInfo];
    }
}

-(void)addUser:(NSDictionary *)userInfo{
    NSNumber *userId = [userInfo objectForKey:@"id"];
    if ([[self.usersDict allKeys] containsObject:userId]) {
        //check should update
        User *user = [self.usersDict objectForKey:userId];
        user.name = [userInfo objectForKey:@"name"];
        user.avatarUrl = [userInfo objectForKey:@"avatarUrl"];
    }else{
        User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
        user.id = userId;
        user.name = [userInfo objectForKey:@"name"];
        user.avatarUrl = [userInfo objectForKey:@"avatarUrl"];
        user.avatarFilePath = [userInfo objectForKey:@"avatarFile"];
        user.snstype = [userInfo objectForKey:@"snsType"];
        [self.usersDict setObject:user forKey:userId];
        [self saveContext];
    }
}

-(void)deleleUser:(NSInteger)userId{
    User *user = [self.usersDict objectForKey:[NSNumber numberWithInteger:userId]];
    [self.usersDict removeObjectForKey:[NSNumber numberWithInteger:userId]];
    if (user) {
        [self.managedObjectContext deleteObject:user];
        [self deleteFeedOfUser:userId];
        [self saveContext];
    }
}

#pragma mark - Feed Method

-(void)addFeeds:(NSArray *)feedsArray{
    for (NSDictionary *feedInfo in feedsArray) {
        [self addFeed:feedInfo];
    }
}

-(void)addFeed:(NSDictionary *)feedInfo{
    NSNumber *feedId = [feedInfo objectForKey:@"id"];
    if (![[self.feedsDict allKeys] containsObject:feedId]) {
        Feed *feed = [NSEntityDescription insertNewObjectForEntityForName:@"Feed" inManagedObjectContext:self.managedObjectContext];
        feed.id = feedId;
        feed.content = [feedInfo objectForKey:@"content"];
        feed.owner = [self.usersDict objectForKey:[feedInfo objectForKey:@"userId"]];
        [self saveContext];
    }
}

-(void)deleteFeed:(NSInteger)feedId{
    Feed *feed = [self.feedsDict objectForKey:[NSNumber numberWithInteger:feedId]];
    if (feed) {
        [self.managedObjectContext deleteObject:feed];
    }
}

-(void)deleteFeedOfUser:(NSInteger)userId{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Feed"];
    request.predicate = [NSPredicate predicateWithFormat:@"whichUser.id = %@",[NSNumber numberWithInteger:userId]];
    NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSError *error = nil;
    NSArray *matches = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        return ;
    }
    
    for (Feed *feed in matches) {
        [self.managedObjectContext deleteObject:feed];
    }
    [self saveContext];
}

@end
