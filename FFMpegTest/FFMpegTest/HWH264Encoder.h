//
//  HWH264Encoder.h
//  FFMpegTest
//
//  Created by 刘健 on 2017/4/7.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void (^completionBlock)(NSData *h264Data, NSError *error);

@interface HWH264Encoder : NSObject

+ (instancetype)sharedInstance;

- (void)convertSampleBufferToH264:(CMSampleBufferRef)sampleBuffer andCompletionBlock:(completionBlock)block;

@end
