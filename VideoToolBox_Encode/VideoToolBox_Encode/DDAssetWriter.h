//
//  DDAssetWriter.h
//  VideoToolBox_Encode
//
//  Created by 刘健 on 2017/6/2.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface DDAssetWriter : NSObject

+ (instancetype)sharedInstance;

- (void)processSampleBuffer:(CMSampleBufferRef)sampleBuffer;

@end
