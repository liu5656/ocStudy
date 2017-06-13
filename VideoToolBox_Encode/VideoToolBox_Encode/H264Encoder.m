//
//  H264Encoder.m
//  VideoToolBox_Encode
//
//  Created by lj on 17/2/14.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import "H264Encoder.h"


@interface H264Encoder()
{
    
    dispatch_queue_t mEncodeQueue;
    VTCompressionSessionRef EncodingSession;
    CMFormatDescriptionRef format;
    
    int frameID;
    NSFileHandle *fileHandle;
}

@end

@implementation H264Encoder



+ (instancetype)sharedInstance {
    static H264Encoder *encoder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        encoder = [[H264Encoder alloc] initToolBox];
    });
    return encoder;
}


- (instancetype)initToolBox
{
    if (self = [super init]) {
        mEncodeQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"abc.h264"];
        [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
        [[NSFileManager defaultManager] createFileAtPath:file contents:nil attributes:nil];
        fileHandle = [NSFileHandle fileHandleForWritingAtPath:file];
        [self initVideoToolBox];

    }
    return self;
}

#pragma mark videotoolbox
- (void)initVideoToolBox {
    dispatch_sync(mEncodeQueue, ^{
        frameID = 0;
        int width = 1920, height = 1080;
        OSStatus status = VTCompressionSessionCreate(NULL,width,height,kCMVideoCodecType_H264,NULL,NULL,NULL,didCompressH264,(__bridge void *)(self),&EncodingSession);
        if (status !=0) {
            NSLog(@"h264: unable to create a h264 session");
            return ;
        }
        
        
//        // ProfileLevel，h264的协议等级，不同的清晰度使用不同的ProfileLevel。
//        VTSessionSetProperty(_vEnSession, kVTCompressionPropertyKey_ProfileLevel, kVTProfileLevel_H264_Main_AutoLevel);
//        // 设置码率
//        VTSessionSetProperty(_vEnSession, kVTCompressionPropertyKey_AverageBitRate, (__bridge CFTypeRef)@(self.videoConfig.bitrate));
//        // 设置实时编码
//        VTSessionSetProperty(_vEnSession, kVTCompressionPropertyKey_RealTime, kCFBooleanTrue);
        // 关闭重排Frame，因为有了B帧（双向预测帧，根据前后的图像计算出本帧）后，编码顺序可能跟显示顺序不同。此参数可以关闭B帧。
//        VTSessionSetProperty(_vEnSession, kVTCompressionPropertyKey_AllowFrameReordering, kCFBooleanFalse);
//        // 关键帧最大间隔，关键帧也就是I帧。此处表示关键帧最大间隔为2s。
//        VTSessionSetProperty(_vEnSession, kVTCompressionPropertyKey_MaxKeyFrameInterval, (__bridge CFTypeRef)@(self.videoConfig.fps * 2));
        
//        VTSessionSetProperty(EncodingSession, kVTCompressionPropertyKey_AllowFrameReordering, kCFBooleanFalse);
        
        // 设置实时编码输出(避免延迟)
        VTSessionSetProperty(EncodingSession, kVTCompressionPropertyKey_RealTime, kCFBooleanTrue);
        VTSessionSetProperty(EncodingSession, kVTCompressionPropertyKey_ProfileLevel, kVTProfileLevel_H264_Baseline_AutoLevel);
        
        // 设置关键帧(GOPsize)间隔
        int frameInterval = 40;
        CFNumberRef frameIntervalRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &frameInterval);
        VTSessionSetProperty(EncodingSession, kVTCompressionPropertyKey_MaxKeyFrameInterval, frameIntervalRef);
        
//        // 设置期望帧率
//        int fps = 10;
//        CFNumberRef fpsRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &fps);
//        VTSessionSetProperty(EncodingSession, kVTCompressionPropertyKey_ExpectedFrameRate, fpsRef);
        
        // 设置码率上限bps
        int bitRate = width * height * 3 * 4 * 4;
        CFNumberRef bitRateRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &bitRate);
        VTSessionSetProperty(EncodingSession, kVTCompressionPropertyKey_AverageBitRate, bitRateRef);
        
        // 设置码率均值bps
//        int bitRateLimit = width * height * 3 * 4;
//        CFNumberRef bitRateLimitRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &bitRateLimit);
//        VTSessionSetProperty(EncodingSession, kVTCompressionPropertyKey_DataRateLimits, bitRateLimitRef);
        
        // tell the encoder ready to start
        VTCompressionSessionPrepareToEncodeFrames(EncodingSession);
    });
}


- (void)encode:(CMSampleBufferRef)sampleBuffer {
    
    if (!fileHandle) {
        NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"abc.h264"];
        [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
        [[NSFileManager defaultManager] createFileAtPath:file contents:nil attributes:nil];
        fileHandle = [NSFileHandle fileHandleForWritingAtPath:file];

        [self initVideoToolBox];
        
    }
    
    dispatch_sync(mEncodeQueue, ^{
        CVImageBufferRef imageBuffer = (CVImageBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
        // 帧时间,如果不设置会导致时间轴过长
        CMTime presentionTieStamp = CMTimeMake(frameID++, 1000);
        VTEncodeInfoFlags flags;
        OSStatus status = VTCompressionSessionEncodeFrame(EncodingSession,
                                                          imageBuffer,
                                                          presentionTieStamp,
                                                          kCMTimeInvalid,
                                                          NULL, NULL, &flags);
        if (status != noErr) {
            NSLog(@"h264: VTCompressionSessionEncodeFrame failed with %d", (int)status);
            VTCompressionSessionInvalidate(EncodingSession);
            CFRelease(EncodingSession);
            EncodingSession = NULL;
            return;
        }
        NSLog(@"h264: VTCompressionSessionEncodeFrame success");
    });
}

// 编码完成回调
void didCompressH264(void * CM_NULLABLE outputCallbackRefCon,void * CM_NULLABLE sourceFrameRefCon,OSStatus status,VTEncodeInfoFlags infoFlags,CM_NULLABLE CMSampleBufferRef sampleBuffer ) {
    NSLog(@"didCompressH264 calles with status %d infoFlages %d", (int)status, (int)infoFlags);
    if (status != 0) {
        return;
    }
    
    if (!CMSampleBufferDataIsReady(sampleBuffer)) {
        NSLog(@"didCompressH264 data is not ready");
        return;
    }
    
    H264Encoder *encoder = (__bridge H264Encoder *)outputCallbackRefCon;
    CFDictionaryRef infoRef = CFArrayGetValueAtIndex(CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, true), 0);
    bool keyFrame = !CFDictionaryContainsKey(infoRef,kCMSampleAttachmentKey_NotSync);
    // 判断当前帧是否为关键帧 sps pps
    if (keyFrame) {
        CMFormatDescriptionRef format = CMSampleBufferGetFormatDescription(sampleBuffer);
        size_t sparameterSetSize, sparameterSetCount;
        const uint8_t *sparameterSet;
        OSStatus statusCode = CMVideoFormatDescriptionGetH264ParameterSetAtIndex(format,
                                                                                 0,
                                                                                 &sparameterSet,
                                                                                 &sparameterSetSize,
                                                                                 &sparameterSetCount,
                                                                                 0);
        if (statusCode == noErr) {
            // found pps
            size_t pparameterSetSize, pparameterSetCount;
            const uint8_t *pparameterSet;
            OSStatus  status = CMVideoFormatDescriptionGetH264ParameterSetAtIndex(format,
                                                                                  1,
                                                                                  &pparameterSet,
                                                                                  &pparameterSetSize,
                                                                                  &pparameterSetCount,
                                                                                  0);
            if (status == noErr) {
                NSData *sps = [NSData dataWithBytes:sparameterSet length:sparameterSetSize];
                NSData *pps = [NSData dataWithBytes:pparameterSet length:pparameterSetSize];
                if (encoder) {
                    [encoder gotSpsPps:sps pps:pps];
                }
            }
            
        }
    }
    
    CMBlockBufferRef dataBuffer = CMSampleBufferGetDataBuffer(sampleBuffer);
    size_t length, totalLength;
    char *dataPointer;
    OSStatus statusCodeRet = CMBlockBufferGetDataPointer(dataBuffer, 0, &length, &totalLength, &dataPointer);
    if (statusCodeRet == noErr) {
        size_t bufferOffset = 0;
        static const int AVCCHeaderLength = 4; // 返回的nalu数据前四个字节不是0001的startcode,而是打断模式的帧长度length
        
        // 循环获取nalu数据
        while (bufferOffset < totalLength - AVCCHeaderLength) {
            uint32_t NALUnitLength = 0;
            // read the Nal Unit length
            memcpy(&NALUnitLength, dataPointer + bufferOffset, AVCCHeaderLength);
            
            // 从大端转系统端
            NALUnitLength = CFSwapInt32BigToHost(NALUnitLength);
            
            //            NSData *data = [NSData dataWithBytes:dataPointer + bufferOffset + AVCCHeaderLength length:NALUnitLength];
            NSData* data = [[NSData alloc] initWithBytes:(dataPointer + bufferOffset + AVCCHeaderLength) length:NALUnitLength];
            [encoder gotEncodeData:data isKeyFrame:keyFrame];
            
            // move to the next nal unit in the block buffer;
            bufferOffset += AVCCHeaderLength + NALUnitLength;
        }
    }
}

- (void)gotSpsPps:(NSData *)sps pps:(NSData *)pps {
    NSLog(@"gotSpsPps %d %d",(int)[sps length],(int)pps.length);
    const char bytes[] = "\x00\x00\x00\x01";
    size_t length = (sizeof bytes) - 1; // string literals has implicit rrailing '\0'
    NSData *byteHeader = [NSData dataWithBytes:bytes length:length];
    [fileHandle writeData:byteHeader];
    [fileHandle writeData:sps];
    [fileHandle writeData:byteHeader];
    [fileHandle writeData:pps];
}

- (void)gotEncodeData:(NSData *)data isKeyFrame:(BOOL)isKeyFrame {
    NSLog(@"gotEncodeData %d",(int)data.length);
    if (fileHandle != NULL) {
        const char bytes[] = "\x00\x00\x00\x01";
        size_t length = sizeof(bytes) - 1;
        NSData *byteHeader = [NSData dataWithBytes:bytes length:length];
        [fileHandle writeData:byteHeader];
        [fileHandle writeData:data];
    }
}

- (void)endViedoToolBox
{
    VTCompressionSessionCompleteFrames(EncodingSession, kCMTimeInvalid);
    VTCompressionSessionInvalidate(EncodingSession);
    CFRelease(EncodingSession);
    EncodingSession = NULL;
    
    [fileHandle closeFile];
    fileHandle = NULL;
}




@end
