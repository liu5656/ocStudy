//
//  DecodeViewController.m
//  FFMpegTest
//
//  Created by 刘健 on 2017/3/24.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import "DecodeViewController.h"

#import <AVFoundation/AVFoundation.h>
#import "FFMpeg-arm64/include/libavcodec/avcodec.h"
#import "FFMpeg-arm64/include/libavutil/avutil.h"
#import "FFMpeg-arm64/include/libavformat/avformat.h"
#import "FFMpeg-arm64/include/libswscale/swscale.h"

@interface DecodeViewController ()

@end

@implementation DecodeViewController

void yuvCodecToVideoH264(const char *input_file_name)
{
    AVFormatContext *pFormatCtx;
    AVOutputFormat *fmt;
    AVStream *video_st;
    AVCodecContext *pCodecCtx;
    AVCodec *pCodec;
    AVPacket pkt;
    uint8_t *picture_buf;
    AVFrame *pFrame;
    int picture_size;
    int y_size;
    int framecnt = 0;
//    FILE *in_file = fopen("srv01_480x272.yuv", "rb"); // input raw YUV data

    const char *input_file = [[[NSBundle mainBundle] pathForResource:@"FFmpegTest" ofType:@"yuv"] cStringUsingEncoding:NSUTF8StringEncoding];
    FILE *in_file = fopen(input_file, "rb");
    int in_w =480, in_h = 272;
    int framenum = 100;

    const char *out_file = [[NSTemporaryDirectory() stringByAppendingPathComponent:@"dash.h264"] cStringUsingEncoding:NSUTF8StringEncoding];


    av_register_all();
    pFormatCtx = avformat_alloc_context();

    fmt = av_guess_format(NULL, out_file, NULL);
    pFormatCtx->oformat = fmt;

    // open output url
    if (avio_open(&pFormatCtx, out_file, AVIO_FLAG_READ_WRITE)) {
        printf("failed to open output file!\n");
        return;
    }

    video_st = avformat_new_stream(pFormatCtx, 0);
    video_st->time_base.num = 1;
    video_st->time_base.den = 25;

    if (video_st == NULL) {
        printf("failed to get stream info!\n");
        return;
    }

    // param that must set
    pCodecCtx = video_st->codec;
    pCodecCtx->codec_id = fmt->video_codec;
    pCodecCtx->codec_type = AVMEDIA_TYPE_VIDEO;
    pCodecCtx->pix_fmt = AV_PIX_FMT_YUV420P;
    pCodecCtx->width = in_w;
    pCodecCtx->height = in_h;
    pCodecCtx->bit_rate = 400000;
    pCodecCtx->gop_size = 250;

    pCodecCtx->time_base.num = 1;
    pCodecCtx->time_base.den = 25;

    pCodecCtx->qmin = 10;
    pCodecCtx->qmax = 51;

    // optional param
    pCodecCtx->max_b_frames = 3;

    // set option
    AVDictionary *param = NULL;
    // H.264
    if (pCodecCtx->codec_id == AV_CODEC_ID_H264) {
        av_dict_set(&param, "preset", "slow", 0); // 通过
    }

}


#pragma mark life circle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
