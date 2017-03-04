//
//  VideoUploader.m
//  UploadDownloadTools
//
//  Created by 刘健 on 2017/3/4.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import "VideoUploader.h"

#define PerFrame 20000
#define SERVER @"http://192.168.77.123:8080/WebAPI/" // 本地

@interface VideoUploader ()
@property (nonatomic, strong) NSURLSessionUploadTask *task;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, strong) NSMutableURLRequest *request;

@property (nonatomic, strong) VideoInfo *video;
@property (nonatomic,assign) long long fileSize;
@property (nonatomic, strong) NSFileHandle *fileHandler;

@property (nonatomic, copy) void (^failure)(NSError *error, VideoInfo *video);
@property (nonatomic, copy) void (^successBlock)(NSString *downLoadFilePath, VideoInfo *video);
@property (nonatomic, copy) void (^progress)(long long totalBytesWritten, long long totalBytesExpectedToWrite, VideoInfo *video);

@end

@implementation VideoUploader

- (void)upload:(NSString *)urlPath
destinationVideo:(VideoInfo *)video
       failure:(void (^)(NSError *error, VideoInfo *video))failureBlock
  successBlock:(void(^)(NSString *downLoadFilePath, VideoInfo *video))successfulBlock
      progress:(void (^)(long long totalBytesWritten, long long totalBytesExpectedToWrite, VideoInfo *video))progressBlock {
    _video = video;
    _urlStr = urlPath;
    _failure = failureBlock;
    _successBlock = successfulBlock;
    _progress = progressBlock;
    _fileSize = [self fileSizeAtPath:video.path];
    NSMutableDictionary *header = [self getHTTPHeaderJsonModel];
    for (NSString *key in header.allKeys) {
        [self.request setValue:[header valueForKey:key] forHTTPHeaderField:key];
    }
    
    NSData *data = [self.fileHandler readDataOfLength:PerFrame];
    __weak typeof(self) weakSelf = self;
    _task = [self.session uploadTaskWithRequest:self.request fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            if ((_video.curUploLocation + PerFrame) < _fileSize) {
                [weakSelf continueToUploadWithData:data andTotalBytesWritten:(_video.curUploLocation + PerFrame) andTotalBytesExpectedToWrite:_fileSize];
            }else{
                [weakSelf uploadSuccessfulHandler:data];
            }
        }else{
            [weakSelf uploadFailureHandler:error];
        }
    }];
    [_task resume];
}


- (void)resume {
    if (self.task) {
        [self.task resume];
    }else{
        [self upload:_urlStr destinationVideo:_video failure:_failure successBlock:_successBlock progress:_progress];
    }
}

- (void)suspend {
    [self.task suspend];
}

- (void)onceMoreTimeWithFileID:(NSString *)fileid
{
    __weak typeof(self) weakSelf = self;
    NSData *data = [self.fileHandler readDataOfLength:PerFrame];
    
    [self.request setValue:fileid forHTTPHeaderField:@"fileid"];
    NSMutableDictionary *header = [self getHTTPHeaderJsonModel];
    for (NSString *key in header.allKeys) {
        [self.request setValue:[header valueForKey:key] forHTTPHeaderField:key];
    }
    
    
    _task = [self.session uploadTaskWithRequest:self.request fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            if (_video.curUploLocation + PerFrame< _fileSize) {
                [weakSelf continueToUploadWithData:data andTotalBytesWritten:(_video.curUploLocation + PerFrame) andTotalBytesExpectedToWrite:_fileSize];
            }else{
                _video.curUploLocation = (_fileSize - 1);
                [self uploadSuccessfulHandler:data];
            }
        }else{
            [self uploadFailureHandler:error];
        }
    }];
    [_task resume];
}

- (void)uploadFailureHandler:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_failure) {
            NSLog(@"上传失败:%@",error);
            _failure(error, _video);
        }
    });
}

- (void)uploadSuccessfulHandler:(NSData *)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSString *downloadPath = [dict objectForKey:@"result"];
        
        if (_successBlock) {
            _progress(_fileSize, _fileSize, _video);
            _successBlock(downloadPath, _video);
            NSLog(@"成功上传:%lld--fileid:%@",_video.curUploLocation,downloadPath);
        }
    });
}

- (void)continueToUploadWithData:(NSData *)data andTotalBytesWritten:(long long)totalBytesWritten andTotalBytesExpectedToWrite:(long long)totalBytesExpectedToWrite
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    long long location = [self.fileHandler offsetInFile];
    NSLog(@"--单次上传量:%lld-%lld",_video.curUploLocation,_video.curUploLocation + PerFrame - 1);
    NSLog(@"__单次上传后句柄位置:%lld\n",location);
    _video.curUploLocation += PerFrame;
    [self onceMoreTimeWithFileID:[dict objectForKey:@"result"]];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_progress) {
            _progress(totalBytesWritten, totalBytesExpectedToWrite, _video);
        }
    });
}


#pragma mark utils
- (long long)fileSizeAtPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:path];
    if (isExist) {
        return [[fileManager attributesOfItemAtPath:path error:nil] fileSize];
    }else{
        return 0;
    }
}

- (NSMutableDictionary *)getHTTPHeaderJsonModel {
    
    NSMutableDictionary *header = [NSMutableDictionary dictionary];
#warning lack userid
    [header setObject:@"user10000" forKey:@"userid"];
    
    NSString *rangeStr = nil;
    if (_fileSize > (_video.curUploLocation + PerFrame)) {
         rangeStr = [NSString stringWithFormat:@"%lld-%lld", _video.curUploLocation,_video.curUploLocation + PerFrame - 1];
    }else{
        rangeStr = [NSString stringWithFormat:@"%lld-%lld", _video.curUploLocation,_fileSize - 1];
    }
    _video.range = rangeStr;
    [header setObject:_video.toJSONString forKey:@"videoinfo"];
    [header setObject:@"multipart/form-data" forKey:@"Content-Type"];
    return header;
}


#pragma mark get
- (NSMutableURLRequest *)request {
    if (!_request) {
        _request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[SERVER stringByAppendingString:_urlStr]]];
        _request.HTTPMethod = @"POST";
        _request.timeoutInterval = 60;
    }
    return _request;
}

- (NSURLSession *)session {
    if (!_session) {
        _session = [NSURLSession sharedSession];
    }
    return _session;
}

- (NSFileHandle *)fileHandler
{
    if (!_fileHandler) {
        _fileHandler = [NSFileHandle fileHandleForReadingAtPath:_video.path];
    }
    return _fileHandler;
}



@end
