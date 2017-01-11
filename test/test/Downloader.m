//
//  Downloader.m
//  fa
//
//  Created by lj on 16/3/16.
//  Copyright © 2016年 lj. All rights reserved.
//

#import "Downloader.h"

#define wifi 20000

@interface Downloader()<NSURLConnectionDataDelegate>


@property (nonatomic, strong) NSFileHandle *fileHandler;
@property (nonatomic, copy) NSString *destinationPath;
@property (nonatomic, copy) NSString *urlStr;

@property (nonatomic, assign) long long currentLength;
@property (nonatomic, assign) long long fileSize;
@property (nonatomic, assign) long long lastBytesLocation;

@property (nonatomic, copy) void (^failureBlock)(CZLErrMsg *error);
@property (nonatomic, copy) void(^successfulBlock)(NSString *downLoadFilePath);
@property (nonatomic, copy) void (^progressBlock)(long long totalBytesWritten, long long totalBytesExpectedToWrite);

@property (nonatomic, assign) NSURLConnection *connection;

@end

@implementation Downloader

- (instancetype)init
{
    if (self = [super init]) {
        _currentLength = 0;
    }
    return self;
}


- (void)download:(NSString *)url
           begin:(long long)begin
          length:(long long)length
         failure:(void (^)(CZLErrMsg *error))failureBlock
    successBlock:(void(^)(NSString *downLoadFilePath))successfulBlock
        progress:(void (^)(long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock
{
    
    _failureBlock = failureBlock;
    _successfulBlock = successfulBlock;
    _progressBlock = progressBlock;
    
    _fileSize = begin + length;
    
    _urlStr = [@"" stringByAppendingString:url];
    NSString *path = [self creatFileAtCachePath];
    if (!path) return;
    _destinationPath = path;
    // 设置缓存策略,超时时间,url
    _currentLength = begin;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    request.HTTPMethod = @"GET";
    [request setValue:[NSString stringWithFormat:@"%lld-%lld",_currentLength,_currentLength + wifi] forHTTPHeaderField:@"Range"];
    _connection = [NSURLConnection connectionWithRequest:request delegate:self];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *response2 = (NSHTTPURLResponse *)response;
    NSLog(@"didReceiveResponse----%@",response2.allHeaderFields);
//    self.fileSize = [[response2.allHeaderFields objectForKey:@"filesize"] longLongValue];
    NSString *range = [response2.allHeaderFields objectForKey:@"Range"];
    self.lastBytesLocation = [[[range componentsSeparatedByString:@"-"] lastObject] longLongValue];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError----%@",error);
    _failureBlock([[CZLErrMsg alloc] init].netWorkErr);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.fileHandler seekToFileOffset:self.currentLength];
    [self.fileHandler writeData:data];
    self.currentLength += data.length;
    _progressBlock(self.currentLength, self.fileSize);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.lastBytesLocation < self.fileSize) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
        request.HTTPMethod = @"GET";
        [request setValue:[NSString stringWithFormat:@"%lld-%lld",_currentLength,_currentLength + wifi] forHTTPHeaderField:@"Range"];
        _connection = [NSURLConnection connectionWithRequest:request delegate:self];
    }else{
        // 完成下载
        _successfulBlock(_destinationPath);
    }
}


- (void)start
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    request.HTTPMethod = @"GET";
    [request setValue:[NSString stringWithFormat:@"%lld-%lld",_currentLength,_currentLength + wifi] forHTTPHeaderField:@"Range"];
    _connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)cancle
{
    [self.connection cancel];
    self.connection = nil;
}

- (NSString *)creatFileAtCachePath {
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *destPath = [caches stringByAppendingPathComponent:[_urlStr lastPathComponent]];
    
    BOOL result = [[NSFileManager defaultManager] createFileAtPath:destPath contents:nil attributes:nil];
    return destPath;
}


- (NSFileHandle *)fileHandler {
    if (!_fileHandler) {
        _fileHandler = [NSFileHandle fileHandleForWritingAtPath:_destinationPath];
    }
    return _fileHandler;
}


@end
