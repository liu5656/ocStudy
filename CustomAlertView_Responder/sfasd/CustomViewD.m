//
//  CustomViewD.m
//  sfasd
//
//  Created by 刘健 on 2017/6/23.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import "CustomViewD.h"

@implementation CustomViewD

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
    // 是否是可以点击的
    if (!self.userInteractionEnabled || self.alpha < 0.01) return nil;
    // 判断触摸点是否在自己范围内
    if(![self pointInside:point withEvent:event]) return nil;
    // 判断是否还有更合适的视图
    NSInteger count = self.subviews.count;
    for (NSInteger i = (count - 1); i >= 0; i--) {
        UIView *childView = self.subviews[i];
        CGPoint chindPoint = [self convertPoint:point toView:childView];
        UIView *fileView = [childView hitTest:chindPoint withEvent:event];
        if (fileView) {
            return fileView;
        }
    }
    return self;
    
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    BOOL result = CGRectContainsPoint(self.bounds, point);
    NSLog(@"%d-%s",  result, __func__);
    return result;
}

@end
