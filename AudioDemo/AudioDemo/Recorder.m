//
//  Recorder.m
//  AudioDemo
//
//  Created by 刘健 on 16/8/17.
//  Copyright © 2016年 刘健. All rights reserved.
//

#import "Recorder.h"

static const int bufferByteSize = 1600;
static const int sampleRate = 16000;
static const int bitsPerChannel = 16;

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
        recordFormat.mSampleRate = sampleRate;
        
        UInt32 size = sizeof(recordFormat.mChannelsPerFrame);
        AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareInputNumberChannels, &size, &recordFormat.mChannelsPerFrame);
        recordFormat.mFormatID = kAudioFormatLinearPCM;
        // if we want pcm, default to signed 16-bit little-endian
        recordFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
        recordFormat.mBitsPerChannel = bitsPerChannel;
        recordFormat.mBytesPerPacket = recordFormat.mBytesPerFrame = (recordFormat.mBitsPerChannel / 8) * recordFormat.mChannelsPerFrame;
        recordFormat.mFramesPerPacket = 1;
        
        // 创建audioQueue,设置回调函数
        AudioQueueNewInput(&recordFormat, inputBufferHandler, (__bridge void * _Nullable)(self), NULL, NULL, 0, &audioQueue);
        
        // 创建缓冲器
        for (int i = 0; i < KNumberAudioQueueBuffers; i++) {
            AudioQueueAllocateBuffer(audioQueue, bufferByteSize, &audioBuffers[i]);
            AudioQueueEnqueueBuffer(audioQueue, audioBuffers[i], 0, NULL);
        }
    }
    return self;
}

// 回调函数
void inputBufferHandler(void *inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer, const AudioTimeStamp *inStartTime,
                        UInt32 inNumPackets, const AudioStreamPacketDescription *inPacketDesc)
{
    Recorder *recorder = (__bridge Recorder *)inUserData;
    if (inNumPackets > 0 && recorder.isRecording){
        
        int pcmSize = inBuffer->mAudioDataByteSize;
        char *pcmData = (char *)inBuffer->mAudioData;
        NSData *data = [[NSData alloc] initWithBytes:pcmData length:pcmSize];
        [recorder.recordQueue addObject:data];
        
        AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
    }
}

- (void)startRecording
{
    AudioQueueStart(audioQueue, NULL);
    _isRecording = YES;
}


- (void)stopRecording
{
    if (_isRecording) {
        _isRecording = NO;
        AudioQueueStop(audioQueue, true);
        AudioQueueDispose(audioQueue, true);
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
