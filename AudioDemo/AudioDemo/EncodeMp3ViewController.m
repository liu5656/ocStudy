//
//  EncodeMp3ViewController.m
//  AudioDemo
//
//  Created by 刘健 on 16/8/5.
//  Copyright © 2016年 刘健. All rights reserved.
//

#import "EncodeMp3ViewController.h"
#import "Recorder.h"
#import "Mp3EncodeOperation.h"
#import "AudioPlayer.h"

@interface EncodeMp3ViewController ()

@property (nonatomic, strong) Recorder *recorder;
@property (nonatomic, strong) Mp3EncodeOperation *operation;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) AudioPlayer *player;

@end

@implementation EncodeMp3ViewController
- (IBAction)start:(id)sender {
    
    NSMutableArray *recordQueue = [NSMutableArray array];
    self.operation = [[Mp3EncodeOperation alloc] init];
    self.operation.recordQueue = recordQueue;
    
    self.operationQueue = [[NSOperationQueue alloc] init];
    [self.operationQueue addOperation:self.operation];
    
    self.recorder = [[Recorder alloc] init];
    self.recorder.recordQueue = recordQueue;
    [self.recorder startRecording];
    
}

- (IBAction)stop:(id)sender {
    self.operation.setToStopped = YES;
    [self.recorder stopRecording];
    
}
- (IBAction)play:(id)sender {
    AudioPlayer *player = [[AudioPlayer alloc] init];
    _player = player;
    [player play];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.recorder stopRecording];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
