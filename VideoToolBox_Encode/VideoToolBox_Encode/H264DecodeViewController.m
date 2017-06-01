//
//  ViewController.m
//  LearnVideoToolBox
//
//  Created by 林伟池 on 16/9/1.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "H264DecodeViewController.h"
#import "LYOpenGLView.h"
#import <VideoToolbox/VideoToolbox.h>

#import "H264Decoder.h"

@interface H264DecodeViewController ()
@property (nonatomic , strong) LYOpenGLView *mOpenGLView;
@property (nonatomic , strong) UILabel  *mLabel;
@property (nonatomic , strong) UIButton *mButton;
@property (nonatomic , strong) CADisplayLink *mDispalyLink;
@end


@implementation H264DecodeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.mOpenGLView = (LYOpenGLView *)self.view;
    [self.mOpenGLView setupGL];
    
    self.mLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 200, 100)];
    self.mLabel.textColor = [UIColor redColor];
    [self.view addSubview:self.mLabel];
    self.mLabel.text = @"测试H264硬解码";
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(200, 20, 100, 100)];
    [button setTitle:@"play" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    self.mButton = button;
    
    
    self.mDispalyLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateFrame)];
    self.mDispalyLink.frameInterval = 2; // 默认是30FPS的帧率录制
    [self.mDispalyLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.mDispalyLink setPaused:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClick:(UIButton *)button {
    button.hidden = YES;
    [self startDecode];
}

-(void)startDecode {
    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"abc.h264"];
    [[H264Decoder sharedInstance] onInputStart:file];
    [self.mDispalyLink setPaused:NO];
}

-(void)updateFrame {
    
    CVPixelBufferRef pixelBuffer = [[H264Decoder sharedInstance] updateDecode];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mOpenGLView displayPixelBuffer:pixelBuffer];
        CVPixelBufferRelease(pixelBuffer);
    });
}

@end
