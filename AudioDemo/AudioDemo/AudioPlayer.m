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
        
        
    }
    return self;
}

- (void)play
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"recording.mp3"];
    
//    filePath = [[NSBundle mainBundle] pathForResource:@"Nickelback - If Everyone Cared" ofType:@"mp3"];
    
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSError *error = nil;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.player = player;
    player.delegate = self;
    player.volume = 1;
    player.numberOfLoops = 4;
    [player prepareToPlay];
    [player play];
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
