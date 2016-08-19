//
//  Mp3EncodeOperation.m
//  AudioDemo
//
//  Created by 刘健 on 16/8/17.
//  Copyright © 2016年 刘健. All rights reserved.
//

#import "Mp3EncodeOperation.h"
#import <lame/lame.h>


// 全局指针
lame_t lame;

@implementation Mp3EncodeOperation



- (void)main
{
    
    // mp3压缩参数
    lame = lame_init();
    lame_set_num_channels(lame, 1);
    lame_set_in_samplerate(lame, 16000);
    lame_set_brate(lame, 128);
    lame_set_mode(lame, 1);
    lame_set_quality(lame, 2);
    lame_init_params(lame);
    
    NSMutableData *mp3Datas = [[NSMutableData alloc] init];
    
    while (true) {
        
        NSData *audioData = nil;
        @synchronized(_recordQueue){// begin @synchronized
            
            if (_recordQueue.count > 0) {
                // 获取队头数据
                audioData = [_recordQueue objectAtIndex:0];
                [_recordQueue removeObjectAtIndex:0];
                //NSLog(@"_recordQueue");
            }
        }// end @synchronized
        
        if (audioData != nil) {
            NSLog(@"待转码的数据长度:%ld",audioData.length);
            short *recordingData = (short *)audioData.bytes;
            int pcmLen = audioData.length;
            int nsamples = pcmLen / 2;
            
            unsigned char buffer[pcmLen];
            // mp3 encode
            int recvLen = lame_encode_buffer(lame, recordingData, recordingData, nsamples, buffer, pcmLen);
            // add NSMutable
            [mp3Datas appendBytes:buffer length:recvLen];
            
            
            
        }else{
            if (_setToStopped) {
                //NSLog(@"break");
                break;
//            }else{
//                [NSThread sleepForTimeInterval:0.05];
                //NSLog(@"sleep");
            }
        }
        
    }
    
    // save to file
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"recording.mp3"];
    [mp3Datas writeToFile:filePath atomically:YES];
    NSLog(@"%ld---path:%@", mp3Datas.length, filePath);
    
    lame_close(lame);
    
}


@end

