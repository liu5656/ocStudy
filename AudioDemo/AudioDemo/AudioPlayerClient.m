//
//  AudioPlayerClient.m
//  AudioDemo
//
//  Created by 刘健 on 16/8/17.
//  Copyright © 2016年 刘健. All rights reserved.
//

#import "AudioPlayerClient.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayerClient()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSMutableArray *playQueue;

@end

@implementation AudioPlayerClient


+ (instancetype)sharedInstance
{
    static AudioPlayerClient *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AudioPlayerClient alloc] init];
    });
    return sharedInstance;
}

- (void)playWithFilePath:(NSString *)path
{
//    if (self.player.isPlaying) {
//        if (<#condition#>) {
//            <#statements#>
//        }
//    }
}
- (void)playWithData:(NSData *)data
{
    if (self.player.isPlaying) {
        [self.player stop];
        self.player = nil;
    }
    
    NSError *error = nil;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:data error:&error];
    if (error) {
        NSLog(@"%s 播放音频时候出错:%@", __func__, error);
        return;
    }
    self.player = player;
    player.delegate = self;
    player.volume = 1;
    player.numberOfLoops = 1;
    [player prepareToPlay];
    [player play];
}

- (void)stopPlay
{

}


#pragma mark AVAudioPlayerDelegate
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    NSLog(@"audioPlayerBeginInterruption");
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.player stop];
    self.player = nil;
    NSLog(@"audioPlayerDidFinishPlaying");
}

@end
