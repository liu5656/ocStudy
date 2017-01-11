//
//  ViewController.m
//  test
//
//  Created by 刘健 on 2016/12/5.
//  Copyright © 2016年 刘健. All rights reserved.
//

#import "ViewController.h"
#import "DDCustomAlertController.h"
#import "DDCustomAlert.h"
#import "Downloader.h"

@interface ViewController ()<JKCustomAlertDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self animationGroup]; // 通过核心动画组添加动画
//    [self downloadeAction];
}
- (IBAction)alertControllerAction:(id)sender {
     DDCustomAlertController *vc = [DDCustomAlertController alertControllerWithTitle:@"提示" message:@"this is message" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击按钮:%@",action.title);
    }];
    
    [vc addAction:cancle];
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)alertViewAction:(id)sender {
    DDCustomAlert *alet = [[DDCustomAlert alloc] initWithImage:[UIImage imageNamed:@""] contentImage:[UIImage imageNamed:@""]];
//    alet addButtonWithUIButton:<#(UIButton *)#>
    alet.JKdelegate = self;
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"取消" forState:UIControlStateNormal];
    
    
}

#pragma mark JKCustomAlertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
}

- (void)downloadeAction
{
    Downloader *xx = [[Downloader alloc] init];
    [xx download:@"http://192.168.13.170:8080/WebAPI/rest/file/?fileid=idwcncnlphbyztyjzf5ongk1reik551y" begin:100 length:1024*100 failure:^(CZLErrMsg *error) {
        
    } successBlock:^(NSString *downLoadFilePath) {
        
    } progress:^(long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    }];
}

- (void)animationGroup
{
    
    UIView *rView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 60, 60)];
    rView.layer.cornerRadius = 30;
    rView.layer.masksToBounds = YES;
    rView.backgroundColor = [UIColor redColor];
    [self.view addSubview:rView];
    
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(105, 105, 50, 50)];
    bView.backgroundColor = [UIColor blackColor];
    bView.layer.cornerRadius = 25;
    bView.layer.masksToBounds = YES;
    [self.view addSubview:bView];
    
    /*
     - keyPath可以使用的key
     
     - #define angle2Radian(angle) ((angle)/180.0*M_PI)
     
     - transform.rotation.x 围绕x轴翻转 参数：角度 angle2Radian(4)
     
     transform.rotation.y 围绕y轴翻转 参数：同上
     
     transform.rotation.z 围绕z轴翻转 参数：同上
     
     transform.rotation 默认围绕z轴
     
     transform.scale.x x方向缩放 参数：缩放比例 1.5
     
     transform.scale.y y方向缩放 参数：同上
     
     transform.scale.z z方向缩放 参数：同上
     
     transform.scale 所有方向缩放 参数：同上
     
     transform.translation.x x方向移动 参数：x轴上的坐标 100
     
     transform.translation.y x方向移动 参数：y轴上的坐标
     
     transform.translation.z x方向移动 参数：z轴上的坐标
     
     transform.translation 移动 参数：移动到的点 （100，100）
     
     opacity 透明度 参数：透明度 0.5
     
     backgroundColor 背景颜色 参数：颜色 (id)[[UIColor redColor] CGColor]
     
     cornerRadius 圆角 参数：圆角半径 5
     
     borderWidth 边框宽度 参数：边框宽度 5
     
     bounds 大小 参数：CGRect
     
     contents 内容 参数：CGImage
     
     contentsRect 可视内容 参数：CGRect 值是0～1之间的小数
     
     hidden 是否隐藏
     
     position
     
     shadowColor
     
     shadowOffset
     
     shadowOpacity
     
     shadowRadius
     
     文／呉囲仌犮yzx（简书作者）
     原文链接：http://www.jianshu.com/p/daa58c99ee1e
     著作权归作者所有，转载请联系作者获得授权，并标注“简书作者”。
     */
    
    CABasicAnimation *opacityAni = [CABasicAnimation animation];
    opacityAni.keyPath = @"opacity";
    opacityAni.toValue = @(0);
    
    CABasicAnimation *shapeAni = [CABasicAnimation animation];
    shapeAni.keyPath = @"transform.scale";
    shapeAni.toValue = @(3);
    
    NSArray *groupA = @[opacityAni,shapeAni];
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 1;
    group.repeatCount = 1000;
    group.animations = groupA;
    [rView.layer addAnimation:group forKey:@"group"];
}


@end
