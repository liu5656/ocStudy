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

#import "HWH264Encoder.h"


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
    [HWH264Encoder sharedInstance];
    // Do any additional setup after loading the view, typically from a nib.
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"nwn" ofType:@"mp4"];
//    const char *filepath = [path UTF8String];
//    
//    av_register_all();
//    avformat_network_init();
//    pFormatCtx = avformat_alloc_context();
//    if (avformat_open_input(&pFormatCtx, filepath, NULL, NULL) != 0) {
//        printf("couldn't open input stream.\n");
//        exit(1);
//    }
//    
//    if (avformat_find_stream_info(pFormatCtx, NULL) < 0) {
//        printf("couldn't find stream infomation.\n");
//        exit(1);
//    }
//    videoindex = -1;
//    for (i = 0; i < pFormatCtx->nb_streams; i++) {
//        if (pFormatCtx->streams[i]->codec->codec_type == AVMEDIA_TYPE_VIDEO) {
//            videoindex = i;
//            break;
//        }
//    }
//    if (videoindex == -1) {
//        printf("Didn't find a video stream.\n");
//        exit(1);
//    }
//    
//    pCodecCtx = pFormatCtx->streams[videoindex]->codec;
//    pCodec = avcodec_find_decoder(pCodecCtx->codec_id);
//    if (pCodec == NULL) {
//        printf("codec net found.\n");
//        exit(1);
//    }
//    
//    if (avcodec_open2(pCodecCtx, pCodec, NULL) < 0) {
//        printf("could not open codec.\n");
//        exit(1);
//    }
//    AVFrame *pFrame,*pFrameYUV;
//    pFrame = avcodec_alloc_frame();
//    pFrameYUV = avcodec_alloc_frame();
//    uint8_t *out_buffer;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
