//
//  DDAudioQueue.m
//  MCSimpleAudioPlayerDemo
//
//  Created by 刘健 on 2017/5/22.
//  Copyright © 2017年 Chengyin. All rights reserved.
//

#import "DDAudioQueue.h"
#import <AudioToolbox/AudioToolbox.h>

@interface DDAudioQueue ()
{
    AudioQueueRef quque;
}

@end

@implementation DDAudioQueue

+ (instancetype)sharedInstance {
    static DDAudioQueue *shared;
    dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[DDAudioQueue alloc] init];
    });
    return shared;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}


void AudioQueueBufferCallback(void * __nullable inUserData, AudioQueueRef inAQ,AudioQueueBufferRef inBuffer) {
    
}

- (void)initializeAudioQueue:(AudioStreamPacketDescription)descrption {
    AudioQueueNewOutput(&descrption, AudioQueueBufferCallback, (__bridge void *)self, NULL, NULL, 0, &quque);
}

@end
