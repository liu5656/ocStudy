//
//  DDAudioSession.m
//  AudioDemo
//
//  Created by 刘健 on 2017/5/19.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import "DDAudioSession.h"
#import <AVFoundation/AVFoundation.h>

@implementation DDAudioSession

+ (instancetype)sharedInstance {
    static DDAudioSession *session;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        session = [[DDAudioSession alloc] init];
    });
    return session;
}

- (instancetype)init {
    if (self = [super init]) {
        NSError *err = nil;
        [[AVAudioSession sharedInstance] setActive:YES error:&err];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterruptionListener:) name:AVAudioSessionInterruptionNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRouteChangeListener:) name:AVAudioSessionRouteChangeNotification object:nil];
    }
    return self;
}

- (void)handleInterruptionListener:(NSNotification *)noti {
    NSLog(@"s收到中断通知:%@", noti.userInfo);
}

- (void)handleRouteChangeListener:(NSNotification *)noti {
    NSLog(@"收到路径改变通知:%@", noti.userInfo);
}

@end
