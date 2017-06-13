//
//  DDAssetWriter.m
//  VideoToolBox_Encode
//
//  Created by 刘健 on 2017/6/2.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import "DDAssetWriter.h"
#import <UIKit/UIKit.h>

@interface DDAssetWriter()

@property (nonatomic, strong) AVAssetWriter *writer;
@property (nonatomic, strong) AVAssetWriterInput *videoInput;
@property (nonatomic,strong) AVAssetWriterInputPixelBufferAdaptor* adaptor;

@property (nonatomic, assign) NSInteger frame;

@end

@implementation DDAssetWriter

+ (instancetype)sharedInstance {
    static DDAssetWriter *writer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        writer = [[DDAssetWriter alloc] init];
    });
    return writer;
}

- (instancetype)init {
    if (self = [super init]) {
        NSString *betaCompressionDirectory = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents/Movie.mp4"];
        NSError *error = nil;
        unlink([betaCompressionDirectory UTF8String]);
        self.writer = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:betaCompressionDirectory] fileType:AVFileTypeQuickTimeMovie error:&error];
        if(error)
            NSLog(@"error = %@", [error localizedDescription]);
        
         CGSize size = [UIScreen mainScreen].bounds.size;
        NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                       AVVideoCodecH264, AVVideoCodecKey,
                                       [NSNumber numberWithInt:size.width], AVVideoWidthKey,
                                       [NSNumber numberWithInt:size.height],AVVideoHeightKey,
                                       nil];
        _videoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
        _videoInput.expectsMediaDataInRealTime = YES;
        NSDictionary *sourcePixelBufferAttributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA], kCVPixelBufferPixelFormatTypeKey, nil];
        self.adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:_videoInput sourcePixelBufferAttributes:sourcePixelBufferAttributesDictionary];
        [_writer addInput:_videoInput];
        _frame = 200;
    }
    return self;
}

- (void)processSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    if( _writer.status > AVAssetWriterStatusWriting )
    {
        if( _writer.status == AVAssetWriterStatusFailed )
            return;
    }
    if ([_videoInput isReadyForMoreMediaData])
    {
        if( [_videoInput appendSampleBuffer:sampleBuffer] )
        {
            _frame--;
            if (_frame == 0) {
                [_videoInput markAsFinished];
                
                [_writer finishWritingWithCompletionHandler:^{
                    NSLog(@"--------------------------------------------");
                }];
            }
        }
    }

}







@end
