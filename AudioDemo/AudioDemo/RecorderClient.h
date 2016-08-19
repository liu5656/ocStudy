//
//  Mp3EncodeClient.h
//  AudioDemo
//
//  Created by 刘健 on 16/8/17.
//  Copyright © 2016年 刘健. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recorder.h"
#import "Mp3EncodeOperation.h"

@interface RecorderClient : NSObject
@property (nonatomic, strong) Mp3EncodeOperation *operation;
+ (instancetype)sharedInstance;

- (void)startRecording;
- (void)stopRecording;

@end
