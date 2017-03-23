//
//  Mp3EncodeClient.m
//  AudioDemo
//
//  Created by 刘健 on 16/8/17.
//  Copyright © 2016年 刘健. All rights reserved.
//

#import "RecorderClient.h"

@interface RecorderClient()

@property (nonatomic, strong) Recorder *recorder;

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSMutableArray *recordQueue;
@end

@implementation RecorderClient

+ (instancetype)sharedInstance
{
    static RecorderClient *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[RecorderClient alloc] init];
    });
    return sharedInstance;
}


- (void)startRecording
{
    self.operation = [[Mp3EncodeOperation alloc] init];
    self.operation.recordQueue = self.recordQueue;
    [self.operationQueue addOperation:self.operation];
    
    [self recorder];
    [self.recorder startRecording];
}


- (void)stopRecording
{
    [self.recorder stopRecording];
//    self.operation.setToStopped = YES;
}


#pragma mark get
- (NSOperationQueue *)operationQueue
{
    if (!_operationQueue) {
        _operationQueue = [[NSOperationQueue alloc] init];
    }
    return _operationQueue;
}

- (Recorder *)recorder
{
    if (!_recorder) {
        _recorder = [[Recorder alloc] init];
        self.recorder.recordQueue = self.recordQueue;
    }
    return _recorder;
}

- (NSMutableArray *)recordQueue
{
    if (!_recordQueue) {
        _recordQueue = [NSMutableArray array];
    }
    return _recordQueue;
}



@end
