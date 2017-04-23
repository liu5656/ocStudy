//
//  ViewController.m
//  FFMpegTest
//
//  Created by 刘健 on 2017/3/23.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

#import "FFMpeg-arm64/include/libavcodec/avcodec.h"
#import "FFMpeg-arm64/include/libavutil/avutil.h"
#import "FFMpeg-arm64/include/libavformat/avformat.h"
#import "FFMpeg-arm64/include/libswscale/swscale.h"

#import <CoreTelephony/CoreTelephonyDefines.h>
#import <CallKit/CallKit.h>


@interface ViewController ()
{
    AVFormatContext *pFormatCtx;
    int             i, videoindex;
    AVCodecContext *pCodecCtx;
    AVCodec         *pCodec;
    FILE            *fp_yuv;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self showAllCodec];
}

- (void)showAllCodec {
    av_register_all();
    AVCodec *codec = av_codec_next(NULL);
    while (codec) {
        NSLog(@"codec 名字打印:%s", codec->long_name);
        codec = av_codec_next(codec);
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
