//
//  DBHandler.m
//  dataBases
//
//  Created by 王凡 on 16/5/30.
//  Copyright © 2016年 王凡. All rights reserved.
//


#import "DBHandler.h"
#import "UserInfo.h"
#import "VideoInfo.h"

//#define FriendSymbol @"friendsymbol"
//#define ChannelSymbol @"channelsymbol"
//
//#define ChannelListSymbol @"channellistsymbol"
//#define FriendListSymbol @"FriendListSymbol"
//
//#define PendingFriendMessageSymbol @"PendingFriendMessageSymbol"
//#define PendingChannelMessageSymbol @"PendingChannelMessageSymbol"
//#define PendingMessageSymbol @"PendingMessageSymbol"
//#define ConversationHistory @"ConversationHistory"

#define VideoUploaderList @"VideoUploaderList"
#define RecordVidelList @"RecordVidelList"

#define NumberPerPage 10

@interface DBHandler ()



@end

@implementation DBHandler

+(instancetype) getInstance
{
    static DBHandler *toolInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        toolInstance = [[self alloc] init];
    });
    return toolInstance;
}

-(instancetype)init
{
    self = [super init];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/tmp.db"];
    _db = [FMDatabase databaseWithPath:path];
    [self openDB];
    return self;
}


-(void)openDB{
    if (![_db open]) {
        return;
    }
}



// 初始化表
- (BOOL)databaseInitializeTableWithSQL:(NSString *)sqlString
{
    return [_db executeStatements:sqlString];
}

// 增删改
- (BOOL)databaseHandleWithAddDeleteUpdate:(NSString *)sqlString
{
    return [_db executeUpdate:sqlString];
}

// 查
- (FMResultSet *)databaseQueryWithSQL:(NSString *)sqlString
{
    return [_db executeQuery:sqlString];
}

// 查个数
- (int)getNumberForQuery:(NSString *)sqlString
{
    return [_db intForQuery:sqlString];
}


//**
// *  录制视频列表
// *
- (BOOL)initRecordVideoTable
{
    NSString *tablename = [[UserInfo sharedInstance].userid stringByAppendingString:RecordVidelList];
    
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(id INTEGER PRIMARY KEY AUTOINCREMENT, path TEXT NOT NULL, curUploLocation INTEGER, filesize INTEGER, fileid TEXT, startlongitude FLOAT, startlatitude FLOAT, startmark TEXT, endlongitude FLOAT, endlatitude FLOAT, endmark TEXT,tiemstart INTEGER, timeend INTEGER)", tablename];
    BOOL result = NO;
    if ([self databaseInitializeTableWithSQL:sql]) {
        result = YES;
    }else{
        NSLog(@"视频录制列表初始化失败:%@",tablename);
    }
    return result;
}

- (BOOL)addVideoToUploadListTable:(VideoInfo *)model
{
    [self initRecordVideoTable];
    NSString *tablename = [[UserInfo sharedInstance].userid stringByAppendingString:VideoUploaderList];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (path, curUploLocation, filesize, fileid, startlongitude, startlatitude, startmark , endlongitude , endlatitude, endmark, tiemstart, timeend) VALUES ('%@', %lld, %lld, '%@', %f, %f, '%@', %f, %f, '%@', %lld, %lld)",
                     tablename, model.path, model.curUploLocation, model.filesize,
                     model.fileid, model.pointstart.longitude, model.pointstart.latitude,
                     model.pointstart.mark, model.pointend.longitude, model.pointend.latitude, model.pointend.mark,
                     model.timestart, model.timeend];
    BOOL result = [self databaseHandleWithAddDeleteUpdate:sql];
    if (!result) {
        NSLog(@"视频录制列表添加信息失败:%@",model);
    }
    return result;
}

- (BOOL)deleteRecordVideoByMessageid:(NSString *)messageid // messageid为空就会删除所有的录制视频
{
    NSString *tablename = [[UserInfo sharedInstance].userid stringByAppendingString:VideoUploaderList];
    NSString *sql = nil;
    if (messageid) {
        sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE id=%d", tablename, messageid.intValue];
    }else{
        sql = [NSString stringWithFormat:@"DELETE FROM %@", tablename];
    }
    BOOL result = [self databaseHandleWithAddDeleteUpdate:sql];
    if (!result) {
        NSLog(@"录制视频信息列表删除单个好友失败:%@",messageid);
    }
    return result;
}

- (BOOL)updateRecordVideoWithDictionary:(NSMutableDictionary *)info messageid:(NSString *)messageid
{
    NSString *tablename = [[UserInfo sharedInstance].userid stringByAppendingString:VideoUploaderList];
    BOOL result = [self updateTable:tablename withChangeInfo:info byMessageid:messageid];
    return result;
}

- (NSMutableArray *)getAllRecordVideo
{
    NSString *tablename = [[UserInfo sharedInstance].userid stringByAppendingString:VideoUploaderList];
    NSMutableArray *array = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", tablename];
    FMResultSet *s = [self databaseQueryWithSQL:sql];
    [array removeAllObjects];
    while ([s next]) {
        VideoInfo *item = [[VideoInfo alloc]initWithDictionary:[s resultDictionary] error:nil];
        if (item) {
            [array insertObject:item atIndex:0];
        }
    }
    return array;
}



#pragma mark common function
- (BOOL)updateTable:(NSString *)tablename withChangeInfo:(NSDictionary *)info byMessageid:(NSString *)messageid
{
    NSMutableString *changeInfo = [NSMutableString string];
    for (NSString *key in info.allKeys) {
        id value = [info valueForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            [changeInfo appendFormat:@"%@='%@'", key, value];
        }else{
            [changeInfo appendFormat:@"%@=%@", key, value];
        }
        
    }
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ set %@ WHERE id=%d", tablename, changeInfo , messageid.intValue];
    BOOL result = [self databaseHandleWithAddDeleteUpdate:sql];
    if (!result) {
        NSLog(@"待处理好友信息数据库更新失败:%@", messageid);
    }
    return result;
}

- (NSString *)getMaxidWithTablename:(NSString *)tablename
{
    NSString *maxid = nil;
    NSString *sql2 = [NSString stringWithFormat:@"SELECT MAX(id) FROM %@", tablename];
    FMResultSet *s = [self databaseQueryWithSQL:sql2];
    while ([s next]) {
        NSDictionary *dic = [s resultDictionary];
        maxid = [dic valueForKey:@"MAX(id)"];
    }
    return maxid;
}

@end
