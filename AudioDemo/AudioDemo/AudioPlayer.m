//
//  AudioPlayer.m
//  AudioDemo
//
//  Created by 刘健 on 16/8/17.
//  Copyright © 2016年 刘健. All rights reserved.
//

#import "AudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayer()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *player;

@end


@implementation AudioPlayer

- (instancetype)init
{
    if (self = [super init]) {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError *err = nil;
        [audioSession setCategory :AVAudioSessionCategoryPlayback error:&err];
        
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath = [path stringByAppendingPathComponent:@"recording.mp3"];
        
//        filePath = [[NSBundle mainBundle] pathForResource:@"android" ofType:@"mp3"];
        
        NSURL *url = [NSURL fileURLWithPath:filePath];
        NSError *error = nil;
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        self.player = player;
        player.delegate = self;
        player.volume = 1;
        player.numberOfLoops = 0;
        [player prepareToPlay];
    }
    return self;
}


- (void)play
{
    if (self.player.isPlaying) {
        [self.player stop];
    }
    [self.player play];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"error : %@",error);
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    NSLog(@"audioPlayerBeginInterruption");
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"audioPlayerDidFinishPlaying");
}

@end
