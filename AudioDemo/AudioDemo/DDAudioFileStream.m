//
//  DDAudioFileStream.m
//  AudioDemo
//
//  Created by 刘健 on 2017/5/22.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import "DDAudioFileStream.h"

@interface DDAudioFileStream()
{
    AudioFileStreamID fileStreamID;
    
    UInt32 filesize;
    UInt32 bitrate;
    
}


@end

@implementation DDAudioFileStream

+ (instancetype)sharedInstance {
    static DDAudioFileStream *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[DDAudioFileStream alloc] init];
    });
    return shared;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (BOOL)initializeAudioFileStream:(AudioFileTypeID)filetype { // 初始化audilfilestream
    OSStatus status = AudioFileStreamOpen((__bridge void *)self, AudioFileStreamPropertyListenerCallback, AudioFileStreamPacketsCallback, filetype, &fileStreamID);
    if (status == noErr) {
        return YES;
    }else{
        NSLog(@"-------inititalize audio file stream failed");
        return NO;
    }
}
void AudioFileStreamPropertyListenerCallback(void *inClientData, AudioFileStreamID inAudioFileStream, AudioFileStreamPropertyID inPropertyID, AudioFileStreamPropertyFlags *ioFlags) { // 解析歌曲信息回调
    DDAudioFileStream *audioFile = (__bridge DDAudioFileStream *)inClientData;
    [audioFile handleAudioFileProperty:inPropertyID];
    
}

- (void)handleAudioFileProperty:(AudioFileStreamPropertyID)inPropertyID {
    if (inPropertyID == kAudioFileStreamProperty_BitRate) {
        UInt32 bitRate;
        UInt32 bitRateSize = sizeof(bitRate);
        OSStatus status = AudioFileStreamGetProperty(fileStreamID, inPropertyID, &bitRateSize, &bitRate);
        if (status != noErr) {
            [self handleError:status andAudioFileStreamPropertyID:inPropertyID];
        }else{
            NSLog(@"解析音频文件码率:%d", bitRate);
        }
    }else if (inPropertyID == kAudioFileStreamProperty_DataOffset) {
        UInt32 offset;
        UInt32 offsetSize = sizeof(UInt32);
        OSStatus status = AudioFileStreamGetProperty(fileStreamID, inPropertyID, &offsetSize, &offset);
        if (status != noErr) {
            [self handleError:status andAudioFileStreamPropertyID:inPropertyID];
        }else{
            NSLog(@"文件偏移:%d", offset);
        }
    }else if (inPropertyID == kAudioFileStreamProperty_DataFormat) {
        AudioStreamBasicDescription basicDescription;
        UInt32 size = sizeof(basicDescription);
        OSStatus status = AudioFileStreamGetProperty(fileStreamID, inPropertyID, &size, &basicDescription);
        if (status != noErr) {
            [self handleError:status andAudioFileStreamPropertyID:inPropertyID];
        }else{
            NSLog(@"采样率:%f", basicDescription.mSampleRate);
        }
    
    }else if (inPropertyID == kAudioFileStreamProperty_FormatList) {
        
    }else if (inPropertyID == kAudioFileStreamProperty_AudioDataByteCount) {
        UInt64 audioDataByteCount;
        UInt32 byteCountSize = sizeof(audioDataByteCount);
        OSStatus status = AudioFileStreamGetProperty(fileStreamID, kAudioFileStreamProperty_AudioDataByteCount, &byteCountSize, &audioDataByteCount);
        if (status != noErr) {
            [self handleError:status andAudioFileStreamPropertyID:inPropertyID];
        }else{
            NSLog(@"获取总得音频总数:%lld", audioDataByteCount);
        }
    }
}

- (void)handleError:(OSStatus)status andAudioFileStreamPropertyID:(AudioFileStreamPropertyID)propertyID {
    NSString *result = nil;
    switch (status) {
        case kAudioFileStreamError_UnsupportedFileType:
            result = @"kAudioFileStreamError_UnsupportedFileType";
            break;
        case kAudioFileStreamError_UnsupportedDataFormat:
            result = @"kAudioFileStreamError_UnsupportedDataFormat";
            break;
        case kAudioFileStreamError_UnsupportedProperty:
            result = @"kAudioFileStreamError_UnsupportedProperty";
            break;
        case kAudioFileStreamError_BadPropertySize:
            result = @"kAudioFileStreamError_BadPropertySize";
            break;
        case kAudioFileStreamError_NotOptimized:
            result = @"kAudioFileStreamError_NotOptimized";
            break;
        case kAudioFileStreamError_InvalidPacketOffset:
            result = @"kAudioFileStreamError_InvalidPacketOffset";
            break;
        case kAudioFileStreamError_InvalidFile:
            result = @"kAudioFileStreamError_InvalidFile";
            break;
        case kAudioFileStreamError_ValueUnknown:
            result = @"kAudioFileStreamError_ValueUnknown";
            break;
        case kAudioFileStreamError_DataUnavailable:
            result = @"kAudioFileStreamError_DataUnavailable";
            break;
        case kAudioFileStreamError_IllegalOperation:
            result = @"kAudioFileStreamError_IllegalOperation";
            break;
        case kAudioFileStreamError_UnspecifiedError:
            result = @"kAudioFileStreamError_UnspecifiedError";
            break;
        case kAudioFileStreamError_DiscontinuityCantRecover:
            result = @"kAudioFileStreamError_DiscontinuityCantRecover";
            break;
        default:
            break;
    }
    NSLog(@"%c错误:%@", propertyID, result);
}

void AudioFileStreamPacketsCallback(void *inClientData,UInt32 inNumberBytes, UInt32 inNumberPackets, const void *inInputData, AudioStreamPacketDescription *inPacketDescriptions) { // 解析帧回调
    DDAudioFileStream *audiofile = (__bridge DDAudioFileStream *)inClientData;
    [audiofile handleAudioFileStreamPackets:inInputData numberOfBytes:inNumberBytes numberOfPackets:inNumberPackets PacktsDescription:inPacketDescriptions];
}

- (void)handleAudioFileStreamPackets:(const void *)packets numberOfBytes:(UInt32)inNumberBytes numberOfPackets:(UInt32)inNumberPackets PacktsDescription:(AudioStreamPacketDescription *)packetsDescriptions {
    if (inNumberPackets == 0 || inNumberBytes == 0) {
        return;
    }
    UInt32 bytePerPacket = inNumberBytes / inNumberPackets;
    AudioStreamPacketDescription *description = (AudioStreamPacketDescription *)malloc(inNumberPackets * sizeof(AudioStreamPacketDescription));
    for (int i = 0; i < inNumberPackets; i++) {
        UInt32 packetOffset = bytePerPacket * i;
        description[i].mStartOffset = packetOffset;
        description[i].mVariableFramesInPacket = 0;
        if (i == inNumberPackets - 1) {
            description[i].mDataByteSize = inNumberBytes - packetOffset;
        }else{
            description[i].mDataByteSize = bytePerPacket;
        }
    }
    packetsDescriptions = description;
    
    for (int i = 0; i < inNumberPackets; i++) {
        AudioStreamPacketDescription packetD = packetsDescriptions[i];
        UInt32 packetOffset = (UInt32)packetD.mStartOffset;
        NSData *packet = [NSData dataWithBytes:packets + packetOffset length:packetD.mDataByteSize];
        NSLog(@"parsed audio data length:%ld", packet.length);
    }
    
    
}


- (void)parseAudioData:(NSData *)audio andFileType:(AudioFileTypeID)fileType andCompletion:(void (^)(NSData *parsedData, NSError *error))completion {
    filesize = (UInt32)audio.length;
    [self initializeAudioFileStream:fileType];
    OSStatus status = AudioFileStreamParseBytes(fileStreamID, filesize, audio.bytes, 0);
    if (status == noErr) {
        
    }else if (status == kAudioFileStreamError_NotOptimized) {
        NSLog(@"文件头不存在");
    }else {
        NSLog(@"音频数据解析错误");
    }
    
    
}



@end
