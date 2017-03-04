//
//  Uploader.m
//  fa
//
//  Created by lj on 16/3/17.
//  Copyright © 2016年 lj. All rights reserved.
//

#import "Uploader.h"
#define wifi 20000
#define SERVER @"http://192.168.77.123:8080/WebAPI/"

@interface Uploader()<NSURLSessionTaskDelegate>

@property (nonatomic, strong) NSFileHandle *fileHandler;

@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, copy) NSString *uploadPath;

@property (nonatomic, assign) long long currentLength;
@property (nonatomic, assign) long long fileSize;

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSMutableURLRequest *request;

@property (nonatomic, copy) void (^failure)(NSError *error);
@property (nonatomic, copy) void (^successBlock)(NSString *downLoadFilePath);
//@property (nonatomic, weak) void (^progress)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);
@property (nonatomic, copy) void (^progress)(long long totalBytesWritten, long long totalBytesExpectedToWrite);
@end


@implementation Uploader


- (void)upload:(NSString *)url
destinationPath:(NSString *)uploadPath
         begin:(long long)begin
           end:(long long)end
       headers:(NSMutableDictionary *)headers
       failure:(void (^)(NSError *error))failureBlock
  successBlock:(void(^)(NSString *downLoadFilePath))successfulBlock
      progress:(void (^)(long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock
{
    
    _failure = failureBlock;
    _successBlock = successfulBlock;
    _progress = progressBlock;
    
    _urlStr = [SERVER stringByAppendingString:url];
    _uploadPath = uploadPath;
    long long length = [self fileSizeAtPath:_uploadPath];
    if (length) {
        _fileSize = length;
    }else{
        return;
    }
    
    long long location = [self.fileHandler offsetInFile];
    NSLog(@"最初句柄位置:%lld",location);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_urlStr]];
    _request = request;
    [request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:[NSString stringWithFormat:@"%lld",_fileSize] forHTTPHeaderField:@"fileSize"];
    for (NSString *key in headers.allKeys) {
        NSString *value = [headers objectForKey:key];
//        value = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [request setValue:value forHTTPHeaderField:key];
    }
    if (_fileSize > wifi) {
//        [request setValue:[NSString stringWithFormat:@"%lld-%lld",_currentLength,_currentLength + wifi - 1] forHTTPHeaderField:@"Range"];
    }
    
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 60;
    NSURLSession *session = [NSURLSession sharedSession];
    _session = session;
    NSData *data = [self.fileHandler readDataOfLength:wifi];
    __weak typeof(self) weakSelf = self;
    NSURLSessionUploadTask *task = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            if ((_currentLength + wifi) < _fileSize) {
                [weakSelf continueToUploadWithData:data andTotalBytesWritten:(_currentLength + wifi) andTotalBytesExpectedToWrite:_fileSize];
            }else{
                [weakSelf uploadSuccessfulHandler:data];
            }
        }else{
            [weakSelf uploadFailureHandler:error];
        }
    }];
    
    [task resume];
}

- (void)onceMoreTimeWithFileID:(NSString *)fileid
{
    __weak typeof(self) weakSelf = self;
    NSData *data = [self.fileHandler readDataOfLength:wifi];
    long long location = [self.fileHandler offsetInFile];
    
    [self.request setValue:fileid forHTTPHeaderField:@"fileid"];
    [self.request setValue:[NSString stringWithFormat:@"%lld-%lld",_currentLength,location - 1] forHTTPHeaderField:@"Range"];
    
    NSURLSessionUploadTask *task = [self.session uploadTaskWithRequest:self.request fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            if (_currentLength + wifi< _fileSize) {
                [weakSelf continueToUploadWithData:data andTotalBytesWritten:(_currentLength + wifi) andTotalBytesExpectedToWrite:_fileSize];
            }else{
                [self uploadSuccessfulHandler:data];
            }
        }else{
            [self uploadFailureHandler:error];
        }
    }];
    [task resume];
}



- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    NSLog(@"task:%@--bytesSent:%lld--totalBytesSent:%lld--totalBytesExpectedToSend:%lld",task,bytesSent,totalBytesSent,totalBytesExpectedToSend);
}

- (void)start
{
    
}
- (void)cancle
{

}


- (NSFileHandle *)fileHandler
{
    if (!_fileHandler) {
        _fileHandler = [NSFileHandle fileHandleForReadingAtPath:_uploadPath];
    }
    return _fileHandler;
}

- (long long)fileSizeAtPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:path];
    if (isExist) {
        return [[fileManager attributesOfItemAtPath:path error:nil] fileSize];
    }else{
        return 0;
    }
}

- (void)uploadFailureHandler:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_failure) {
            NSLog(@"上传失败:%@",error);
            _failure(error);
        }
    });
}

- (void)uploadSuccessfulHandler:(NSData *)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSString *downloadPath = [dict objectForKey:@"result"];
        
        if (_successBlock) {
            _successBlock(downloadPath);
            NSLog(@"成功上传:%lld--fileid:%@",_currentLength,downloadPath);
        }
    });
}

- (void)continueToUploadWithData:(NSData *)data andTotalBytesWritten:(long long)totalBytesWritten andTotalBytesExpectedToWrite:(long long)totalBytesExpectedToWrite
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    long long location = [self.fileHandler offsetInFile];
    NSLog(@"第一次上传后句柄位置:%lld",location);
    
    NSLog(@"--单次上传量:%lld-%lld",_currentLength,_currentLength + wifi - 1);
    _currentLength += wifi;
    [self onceMoreTimeWithFileID:[dict objectForKey:@"result"]];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_progress) {
            _progress(totalBytesWritten, totalBytesExpectedToWrite);
        }
    });
}

@end
