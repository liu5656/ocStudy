//
//  ViewController.m
//  VideoToolBox_Encode
//
//  Created by 刘健 on 2017/1/16.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import "ViewController.h"
#import <VideoToolbox/VideoToolbox.h>
#import <AVFoundation/AVFoundation.h>

#import "H264Encoder.h"

@interface ViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) UILabel *mLabel;
@property (nonatomic, strong) AVCaptureSession *mCaptureSession;
@property (nonatomic, strong) AVCaptureDeviceInput *mCaptureDeviceInput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *mCaptureDeviceOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *mPreviewLayer;


@end

@implementation ViewController
{
    dispatch_queue_t mCaptureQueue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    // Do any additional setup after loading the view, typically from a nib.
    self.mLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 200, 100)];
    self.mLabel.textColor = [UIColor redColor];
    [self.view addSubview:self.mLabel];
    self.mLabel.text = @"测试H264硬编码";
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(200, 20, 100, 100)];
    [button setTitle:@"play" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onClick:(UIButton *)sender {
    if (!self.mCaptureSession || !self.mCaptureSession.running) {
        [sender setTitle:@"stop" forState:UIControlStateNormal];
        [self startCapture];
    }else{
        [sender setTitle:@"play" forState:UIControlStateNormal];
        [self stopCapture];
    }
}

- (void)startCapture {
    self.mCaptureSession = [[AVCaptureSession alloc] init];
    self.mCaptureSession.sessionPreset = AVCaptureSessionPreset1280x720;
    
    mCaptureQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    AVCaptureDevice *inputCamera = nil;
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == AVCaptureDevicePositionBack) {
            inputCamera = device;
        }
    }
    
    self.mCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:inputCamera error:nil];
    
    if ([self.mCaptureSession canAddInput:self.mCaptureDeviceInput]) {
        [self.mCaptureSession addInput:self.mCaptureDeviceInput];
    }
    
    self.mCaptureDeviceOutput = [[AVCaptureVideoDataOutput alloc] init];
    [self.mCaptureDeviceOutput setAlwaysDiscardsLateVideoFrames:NO];
    
    [self.mCaptureDeviceOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    [self.mCaptureDeviceOutput setSampleBufferDelegate:self queue:mCaptureQueue];
    if ([self.mCaptureSession canAddOutput:self.mCaptureDeviceOutput]) {
        [self.mCaptureSession addOutput:self.mCaptureDeviceOutput];
    }
    AVCaptureConnection *connection = [self.mCaptureDeviceOutput connectionWithMediaType:AVMediaTypeVideo];
    [connection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
    
    self.mPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.mCaptureSession];
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        _mPreviewLayer.transform = CATransform3DMakeRotation(M_PI_2, 0, 0, -1);
    }
    
    [self.mPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.mPreviewLayer setFrame:self.view.bounds];
    [self.view.layer addSublayer:self.mPreviewLayer];
    
    [self.mCaptureSession startRunning];
    
}

- (void)stopCapture {
    [self.mCaptureSession stopRunning];
    [self.mPreviewLayer removeFromSuperlayer];
    [[H264Encoder sharedInstance] endViedoToolBox];

}



#pragma mark AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
        [[H264Encoder sharedInstance] encode:sampleBuffer];

}


@end
