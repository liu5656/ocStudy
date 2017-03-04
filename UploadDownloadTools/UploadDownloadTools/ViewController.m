//
//  ViewController.m
//  UploadDownloadTools
//
//  Created by 刘健 on 2017/3/3.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import "ViewController.h"
#import "Uploader.h"
#import "VideoInfo.h"
#import "WebServiceApi.h"
#import <AdSupport/AdSupport.h>
#import "resourcePath.h"

#import "VideoUploader.h"

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *uploading;

@property (nonatomic, strong) VideoUploader *uploader;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)uploader:(UIButton *)sender {
    NSInteger tag = sender.tag;
    switch (tag) {
        case 1:
        {
            /*
             1、userid 为 user10018；
             2、videoinfo 为 {filesize:54636,range: "50000-54635",fileid:"gxv20z61ljgs1t5j1ahcju2qsbfq1i5l",pointstart:{longitude:23.3,latitude:45.4,mark:"花果山"},pointend:{longitude:123.3,latitude:145.4,mark:"水帘洞"},timestart:32323233,timeend:323423432}
             这个字符串有点长，看起来有点吃力，下面格式化一下，然后注释参数的含义：
             {
             filesize: 54636, //文件的总的大小
             range: "50000-54635 ", //本次上传第多少字节到多少字节的内容
             fileid: "gxv20z61ljgs1t5j1ahcju2qsbfq1i5l", //第一次为空，从服务器获取后，每次都需要赋值，见说明2
             pointstart:{ //视频录制起点的位置
             longitude: 23.3, //经度
             latitude: 45.4, //纬度
             mark: "花果山" //名称
             },
             pointend: { //视频录制起点的位置
             longitude: 123.3,
             latitude: 145.4,
             mark: "水帘洞"
             },
             timestart: 3232323321, //视频录制开始的日期，毫秒数
             timeend: 32342343254 //视频录制结束的日期，毫秒数
             }
             */
//            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"17_03_03_09_06_04" ofType:@"mp4"];
//            
//            CoordinatePoint *pointstart = [CoordinatePoint new];
//            pointstart.longitude = 23.3;
//            pointstart.latitude = 45.4;
//            pointstart.mark = @"gfhjkahsd";
//            
//            CoordinatePoint *pointend = [CoordinatePoint new];
//            pointend.longitude = 123.3;
//            pointend.latitude = 145.4;
//            pointend.mark = @"fajksdn";
//            
//            VideoInfo *info = [VideoInfo new];
//            info.filesize = [self fileSizeAtPath:filePath];
//            info.range = @"0-19999";
//            info.fileid = @"";
//            info.pointstart = pointstart;
//            info.pointend = pointend;
//            info.timestart = 3232323321;
//            info.timeend = 32342343254;
//            
//            
//            
//            
//            NSMutableDictionary *header = [NSMutableDictionary dictionary];
//            [header setObject:@"user10000" forKey:@"userid"];
//            [header setObject:info.toJSONString forKey:@"videoinfo"];
//            
//            Uploader *uploader1 = [[Uploader alloc] init];
//            [uploader1 upload:@"rest/collect/video" destinationPath:filePath begin:0 end:0 headers:header failure:^(NSError *error) {
//                
//            } successBlock:^(NSString *downLoadFilePath) {
//                
//            } progress:^(long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//                
//            }];
            
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"17_03_03_09_06_04" ofType:@"mp4"];
            
            CoordinatePoint *pointstart = [CoordinatePoint new];
            pointstart.longitude = 23.3;
            pointstart.latitude = 45.4;
            pointstart.mark = @"gfhjkahsd";
            
            CoordinatePoint *pointend = [CoordinatePoint new];
            pointend.longitude = 123.3;
            pointend.latitude = 145.4;
            pointend.mark = @"fajksdn";
            
            VideoInfo *info = [VideoInfo new];
            info.filesize = [self fileSizeAtPath:filePath];
            info.range = @"0-19999";
            info.fileid = @"";
            info.pointstart = pointstart;
            info.pointend = pointend;
            info.timestart = 3232323321;
            info.timeend = 32342343254;
            info.path = filePath;
            
            _uploader = [[VideoUploader alloc] init];
            [_uploader upload:@"rest/collect/video" destinationVideo:info failure:^(NSError *error, VideoInfo *video) {
                
            } successBlock:^(NSString *downLoadFilePath, VideoInfo *video) {
                
            } progress:^(long long totalBytesWritten, long long totalBytesExpectedToWrite, VideoInfo *video) {
                
            }];

            
        }
            break;
            
        case 2:

            //            NSString *identifer = nil;
//            if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
//                identifer = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
//            }
//            
//            if (identifer) {
//                NSMutableDictionary *params = [NSMutableDictionary dictionary];
//                [params setObject:identifer forKey:@"phoneid"];
//                [[WebServiceApi sharedInstance] getRequestWithPath:RPLoginByIDFA params:params headers:nil failure:^(CZLErrMsg *error) {
//                    
//     
//                    
//                } successBlock:^(id obj) {
//                    
//                }];
//            }
            [_uploader resume];
            break;
        case 3:
        {
            [_uploader suspend];
        }
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark utils
- (long long)fileSizeAtPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:path];
    if (isExist) {
        return [[fileManager attributesOfItemAtPath:path error:nil] fileSize];
    }else{
        return 0;
    }
}

#pragma mark get
- (NSMutableArray *)uploading {
    if (!_uploading) {
        _uploading  = [NSMutableArray array];
    }
    return _uploading;
}


@end
