//
//  MP4Encoder.m
//  FFMpegTest
//
//  Created by 刘健 on 2017/4/24.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import "MP4Encoder.h"
#import "FFMpeg-arm64/include/libavformat/avformat.h"
#import "FFMpeg-arm64/include/libavutil/mathematics.h"

@implementation MP4Encoder

- (void)createMp4File {
    
    AVOutputFormat *ofmt = NULL;
    AVFormatContext *ifmt_ctx_v = NULL, *ofmt_ctx = NULL;
    int videoindex_v=-1,videoindex_out=-1;
    int frame_index=0;
    int64_t cur_pts_v=0,cur_pts_a=0;
    
    const char *in_filename_v = "in_filename_v.h264";
    const char *out_filename = "out_filename.mp4";
    
    av_register_all();
    // Input
    int ret = avformat_open_input(&ifmt_ctx_v, in_filename_v, 0, 0);
    if (ret < 0) {
        printf("could not open input file");
        return;
    }
    ret = avformat_find_stream_info(ifmt_ctx_v, 0);
    if (ret < 0) {
        printf("failed to retrieve input stream information");
        return;
    }
    printf("===========Input Information==========\n");
    av_dump_format(ifmt_ctx_v, 0, in_filename_v, 0);
    printf("======================================\n");
    
    // Output
    avformat_alloc_output_context2(&ofmt_ctx, NULL, NULL, out_filename);
    if (!ofmt_ctx) {
        printf("could not create outpue context\n");
        return;
    }
    ofmt = ofmt_ctx->oformat;
    for (int i = 0; i < ifmt_ctx_v->nb_streams; i++) {
        if (ifmt_ctx_v->streams[i]->codec->codec_type == AVMEDIA_TYPE_VIDEO) {
            AVStream *in_stream = ifmt_ctx_v->streams[i];
            AVStream *out_stream = avformat_new_stream(ofmt_ctx, in_stream->codec->codec_type);
            videoindex_v = i;
            if (!out_stream) {
                printf("failed allocating outpue stream\n");
                return;
            }
            
            videoindex_out = out_stream->index;
            if (avcodec_copy_context(out_stream->codec, in_stream->codec)) {
                printf("failed to copy context from input to output stream codec context\n");
                return;
            }
            out_stream->codec->codec_tag = 0;
            if (ofmt_ctx->oformat->flags & AVIO_FLAG_WRITE) {
                out_stream->codec->flags |= CODEC_FLAG_GLOBAL_HEADER;
            }
            break;
        }
    }
    printf("==========Output Information==========\n");
    av_dump_format(ofmt_ctx, 0, out_filename, 1);
    printf("======================================\n");
    
    // Open output file
    if (!ofmt->flags & AVFMT_NOFILE) {
        if (avio_open(&ofmt_ctx->pb, out_filename, AVIO_FLAG_WRITE) < 0) {
            printf("could not open output file '%s'", out_filename);
            return;
        }
    }
    
    // Write file header
    if (avformat_write_header(ofmt_ctx, NULL) < 0) {
        printf("error occurred when opening output file\n");
        return;
    }
    
    AVBitStreamFilterContext *h264bsfc = av_bitstream_filter_init("h264_mp4toannexb");
    AVBitStreamFilterContext *aacbsfc = av_bitstream_filter_init("aac_adtstoasc");
    
    AVPacket pkt;
    while (1) {
        AVFormatContext *ifmt_ctx;
        int stream_index = 0;
        AVStream *in_stream, *out_stream;
        
        ifmt_ctx = ifmt_ctx_v;
        stream_index = videoindex_out;
        if (av_read_frame(ifmt_ctx, &pkt) >= 0) {
            do {
                in_stream = ifmt_ctx->streams[pkt.stream_index];
                out_stream = ofmt_ctx->streams[stream_index];
                if (pkt.stream_index == videoindex_v) {
                    if (pkt.pts == AV_NOPTS_VALUE) {
                        // writes PTS
                        AVRational time_base1 = in_stream->time_base;
                        // duration between 2 frames (us)
                        int64_t calc_duration = (double)AV_TIME_BASE/av_q2d(in_stream->r_frame_rate);
                        // Parameters
                        pkt.pts=(double)(frame_index * calc_duration) / (double)(av_q2d(time_base1) * AV_TIME_BASE);
                        pkt.dts=pkt.pts;
                        pkt.duration = (double)calc_duration / (double)(av_q2d(time_base1) * AV_TIME_BASE);
                        frame_index++;
                    }
                    cur_pts_v = pkt.pts;
                    break;
                }
                
                
            } while (av_read_frame(ifmt_ctx, &pkt) >= 0);
        }else{
            break;
        }
        
    
        av_bitstream_filter_filter(h264bsfc, in_stream->codec, NULL, &pkt.data, &pkt.size, pkt.data, pkt.size, 0);
        av_bitstream_filter_filter(aacbsfc, out_stream->codec, NULL, &pkt.data, &pkt.size, pkt.data, pkt.size, 0);
        
        pkt.pts = av_rescale_q_rnd(pkt.pts, in_stream->time_base, out_stream->time_base, (AVRounding)(AV_ROUND_NEAR_INF | AV_ROUND_PASS_MINMAX);
                                   
        
    }
    
    
}































































@end
