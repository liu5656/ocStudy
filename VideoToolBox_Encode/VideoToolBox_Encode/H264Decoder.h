//
//  H264Decoder.h
//  VideoToolBox_Encode
//
//  Created by lj on 17/2/14.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VideoToolbox/VideoToolbox.h>

@interface H264Decoder : NSObject

+ (instancetype)sharedInstance;

- (void)onInputStart:(NSString *)path;

- (CVPixelBufferRef)updateDecode;

@end
