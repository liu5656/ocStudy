//
//  DDAudioFileStream.h
//  AudioDemo
//
//  Created by 刘健 on 2017/5/22.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface DDAudioFileStream : NSObject

+ (instancetype)sharedInstance;
- (void)parseAudioData:(NSData *)audio andFileType:(AudioFileTypeID)fileType andCompletion:(void (^)(NSData *parsedData, NSError *error))completion;

@end
