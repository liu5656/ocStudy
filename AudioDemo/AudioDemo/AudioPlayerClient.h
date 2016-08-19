//
//  AudioPlayerClient.h
//  AudioDemo
//
//  Created by 刘健 on 16/8/17.
//  Copyright © 2016年 刘健. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioPlayerClient : NSObject
+ (instancetype)sharedInstance;

- (void)playWithFilePath:(NSString *)path;
- (void)playWithData:(NSData *)data;
- (void)stopPlay;
@end
