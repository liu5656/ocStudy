//
//  ViewController.m
//  AudioDemo
//
//  Created by 刘健 on 16/7/8.
//  Copyright © 2016年 刘健. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>

#import "DDAudioSession.h"
#import "DDAudioFileStream.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testAVFoundation];
    [self testAudioFileStream];
}

- (void)testAVFoundation {
     [DDAudioSession sharedInstance];
}

- (void)testAudioFileStream {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MP3Sample" ofType:@"mp3"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    [[DDAudioFileStream sharedInstance] parseAudioData:data andFileType:kAudioFileMP3Type andCompletion:nil];
}



@end
