//
//  Recorder.m
//  AudioDemo
//
//  Created by 刘健 on 16/8/17.
//  Copyright © 2016年 刘健. All rights reserved.
//

#import "Recorder.h"
#import "RecorderClient.h"

static const int bufferByteSize = 1600;

@implementation Recorder

- (instancetype)init
{
    if (self = [super init]) {
        
        AudioSessionInitialize(NULL, NULL, NULL, (__bridge void *)(self));
        UInt32 sessionCategory = kAudioSessionCategory_PlayAndRecord;
        AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
        AudioSessionSetActive(YES);
        
        // 录音格式
        memset(&recordFormat, 0, sizeof(recordFormat));

        
        UInt32 size = sizeof(recordFormat.mChannelsPerFrame);
        AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareInputNumberChannels, &size, &recordFormat.mChannelsPerFrame);
        recordFormat.mSampleRate = 16000;
        recordFormat.mFormatID = kAudioFormatLinearPCM;
        recordFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
        recordFormat.mFramesPerPacket = 1;
        recordFormat.mChannelsPerFrame = 1;
        recordFormat.mBitsPerChannel = 16;
        recordFormat.mBytesPerPacket = 2;
        recordFormat.mBytesPerFrame = 2;
        
        // 创建audioQueue,设置回调函数
        AudioQueueNewInput(&recordFormat, inputBufferHandler, (__bridge void * _Nullable)(self), NULL, NULL, 0, &audioQueue);
        
    }
    return self;
}

// 回调函数
static int leftTimes = 0;
void inputBufferHandler(void *inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer, const AudioTimeStamp *inStartTime,
                        UInt32 inNumPackets, const AudioStreamPacketDescription *inPacketDesc)
{
    NSLog(@"inNumPackets ----%d", inNumPackets);
    Recorder *recorder = (__bridge Recorder *)inUserData;
    if (inNumPackets > 0){
        
        int pcmSize = inBuffer->mAudioDataByteSize;
        char *pcmData = (char *)inBuffer->mAudioData;
        NSData *data = [[NSData alloc] initWithBytes:pcmData length:pcmSize];
        [recorder.recordQueue addObject:data];
        
        AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);

        if (!recorder.isRecording) {
            [RecorderClient sharedInstance].operation.setToStopped = YES;
        }
        
//        if (!recorder.isRecording) {
//            leftTimes++;
//            NSLog(@"此时lefttime:%d",leftTimes);
//        }
//        
//        if (3 == leftTimes) {
//            [RecorderClient sharedInstance].operation.setToStopped = YES;
//            leftTimes = 0;
//        }
    }
}

- (void)startRecording
{
    AudioQueueStart(audioQueue, NULL);
    // 创建缓冲器
    for (int i = 0; i < KNumberAudioQueueBuffers; i++) {
        AudioQueueAllocateBuffer(audioQueue, bufferByteSize, &audioBuffers[i]);
        AudioQueueEnqueueBuffer(audioQueue, audioBuffers[i], 0, NULL);
    }
    _isRecording = YES;
}


- (void)stopRecording
{
    if (_isRecording) {
        self.isRecording = NO;
        AudioQueueStop(audioQueue, true);
        NSLog(@"audioqueue已经暂停");
//        AudioQueueDispose(audioQueue, true);
        
    }
}

- (NSMutableArray *)recordQueue
{
    if (!_recordQueue) {
        _recordQueue = [NSMutableArray array];
    }
    return _recordQueue;
}

@end
