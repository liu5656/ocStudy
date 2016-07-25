//
//  SoundEffectViewController.m
//  AudioDemo
//
//  Created by 刘健 on 16/7/8.
//  Copyright © 2016年 刘健. All rights reserved.
//

#import "SoundEffectViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface SoundEffectViewController ()

@end

@implementation SoundEffectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self playSoundEffect:@"videoRing.caf"];
}

void soundCompleteCallBack(SystemSoundID ssID,void* __nullable    clientData) {

}

- (void)playSoundEffect:(NSString *)name
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *url = [NSURL URLWithString:path];
    
    SystemSoundID soundID = 0;
    
    /**
     * inFileUrl:音频文件url
     * outSystemSoundID:声音id（此函数会将音效文件加入到系统音频服务中并返回一个长整形ID）
     */
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
    //如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallBack, NULL);
//    AudioServicesPlayAlertSound(soundID); // 音效加振动
    AudioServicesPlaySystemSound(soundID); // 音效无振动
}

@end
