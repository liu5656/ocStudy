//
//  Recorder.h
//  AudioDemo
//
//  Created by 刘健 on 16/8/17.
//  Copyright © 2016年 刘健. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

#define KNumberAudioQueueBuffers 3
#define KBufferDurationSeconds 0.1f

@interface Recorder : NSObject
{
    AudioQueueRef               audioQueue;
    AudioQueueBufferRef         audioBuffers[KNumberAudioQueueBuffers];
    AudioStreamBasicDescription recordFormat;
}

@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, strong) NSMutableArray *recordQueue;

- (void)startRecording;
- (void)stopRecording;


@end
