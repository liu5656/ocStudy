
//
//  HWH264Encoder.m
//  FFMpegTest
//
//  Created by 刘健 on 2017/4/7.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import "HWH264Encoder.h"
#import <VideoToolbox/VideoToolbox.h>

@interface HWH264Encoder()
{
    int frameID;
    VTCompressionSessionRef encodingSession;
}
@property (nonatomic, strong) dispatch_queue_t encodeQueue;


@end

@implementation HWH264Encoder

+ (instancetype)sharedInstance {
    static HWH264Encoder *encoder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        encoder = [[HWH264Encoder alloc] init];
    });
    return encoder;
}

void didCompressH264(void * CM_NULLABLE outputCallbackRefCon, void * CM_NULLABLE sourceFrameRefCon, OSStatus status, VTEncodeInfoFlags infoFlags,CM_NULLABLE CMSampleBufferRef sampleBuffer ) {
    
}

- (void)convertSampleBufferToH264:(CMSampleBufferRef)sampleBuffer andCompletionBlock:(completionBlock)block {
    
}


- (void)initialVideoToolBox {
    _encodeQueue = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(_encodeQueue, ^{
        frameID = 0;
        int width = 1280, height = 720;
        OSStatus status = VTCompressionSessionCreate(NULL, width, height, kCMVideoCodecType_H264, NULL, NULL, NULL, didCompressH264, (__bridge void *)self, &encodingSession);
        if (status != noErr) {
            NSLog(@"h264: unable to create a h264 session");
        }
        
        VTSessionSetProperty(encodingSession, kVTCompressionPropertyKey_RealTime, kCFBooleanTrue);
        VTSessionSetProperty(encodingSession, kVTCompressionPropertyKey_ProfileLevel, kVTProfileLevel_H264_Baseline_AutoLevel);
        
        // 设置关键帧(GOPsize)间隔
        int frameInterval = 40;
        CFNumberRef frameIntervalRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &frameInterval);
        VTSessionSetProperty(encodingSession, kVTCompressionPropertyKey_MaxKeyFrameInterval, frameIntervalRef);
        
        // 设置码率上限bps
        int bitRate = width * height * 3 * 4 * 4;
        CFNumberRef bitRateRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &bitRate);
        VTSessionSetProperty(encodingSession, kVTCompressionPropertyKey_AverageBitRate, bitRateRef);
        VTCompressionSessionPrepareToEncodeFrames(encodingSession);
        
    });
}

























@end
