//
//  ButtonHandler.m
//  sfasd
//
//  Created by 刘健 on 2017/6/27.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import "ButtonHandler.h"
#import "CustomAlertWindow.h"

@interface ButtonHandler()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) void (^handler)(NSInteger index);
@property (nonatomic, strong) UIView *torusBottmeLdftBG;
@property (nonatomic, strong) UIView *torusBottmeRightBG;

@end

@implementation ButtonHandler

+ (instancetype)buttonHandlerWithTitle:(NSString *)title andIndex:(NSInteger)index andClickBlock:(void (^)(NSInteger index))block {
    ButtonHandler *handler = [self buttonWithType:UIButtonTypeCustom];
    handler.title = title;
    handler.index = index;
    handler.handler = block;
    
    handler.backgroundColor = [UIColor clearColor];
    handler.titleLabel.textAlignment = NSTextAlignmentCenter;
    [handler setTitle:handler.title forState:UIControlStateNormal];
    [handler setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [handler addTarget:handler action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    return handler;
}

- (void)buttonClick{
    [[CustomAlertWindow sharedInstance] revertKeyWindowAndHidden];
    [CustomAlertWindow sharedInstance].rootViewController = nil;
    _handler(self.index);
}

- (void)addLayerBorder:(UIRectCorner )corner {
    switch (corner) {
        case UIRectCornerBottomLeft:
            self.torusBottmeLdftBG.hidden = NO;
            break;
        case UIRectCornerBottomRight:
            self.torusBottmeRightBG.hidden = NO;
            break;
        default:
            break;
    }
}

- (void)removeBorder {
    self.torusBottmeLdftBG.hidden = YES;
    self.torusBottmeRightBG.hidden = YES;
}

#pragma mark get
- (UIView *)torusBottmeLdftBG {
    if (!_torusBottmeLdftBG) {
        CGFloat borderWidth = 2.0f;
        CGFloat radius = 10.0f;
        _torusBottmeLdftBG = [[UIView alloc] initWithFrame:self.bounds];
        _torusBottmeLdftBG.backgroundColor = [UIColor greenColor];
        
        UIBezierPath *path1 = [UIBezierPath bezierPathWithRoundedRect:_torusBottmeLdftBG.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *mask1 = [[CAShapeLayer alloc] init];
        mask1.path = path1.CGPath;
        _torusBottmeLdftBG.layer.mask = mask1;
        
        UIBezierPath *path2 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(borderWidth, borderWidth, _torusBottmeLdftBG.bounds.size.width - 2 * borderWidth, _torusBottmeLdftBG.bounds.size.height - 2 * borderWidth) byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(radius, radius)];
        CALayer *layer2 = [CALayer layer];
        layer2.backgroundColor = [[UIColor whiteColor] CGColor];
        layer2.frame = _torusBottmeLdftBG.bounds;
        
        CAShapeLayer *mask2 = [[CAShapeLayer alloc] initWithLayer:layer2];
        mask2.path = path2.CGPath;
        
        layer2.mask = mask2;
        [_torusBottmeLdftBG.layer addSublayer:layer2];
        [self insertSubview:_torusBottmeLdftBG atIndex:0];
    }
    return _torusBottmeLdftBG;
}

- (UIView *)torusBottmeRightBG {
    if (!_torusBottmeRightBG) {
        CGFloat borderWidth = 2.0f;
        CGFloat radius = 10.0f;
        _torusBottmeRightBG = [[UIView alloc] initWithFrame:self.bounds];
        _torusBottmeRightBG.backgroundColor = [UIColor greenColor];
        
        UIBezierPath *path1 = [UIBezierPath bezierPathWithRoundedRect:_torusBottmeRightBG.bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *mask1 = [[CAShapeLayer alloc] init];
        mask1.path = path1.CGPath;
        _torusBottmeRightBG.layer.mask = mask1;
        
        UIBezierPath *path2 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(borderWidth, borderWidth, _torusBottmeRightBG.bounds.size.width - 2 * borderWidth, _torusBottmeRightBG.bounds.size.height - 2 * borderWidth) byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(radius, radius)];
        CALayer *layer2 = [CALayer layer];
        layer2.backgroundColor = [[UIColor whiteColor] CGColor];
        layer2.frame = _torusBottmeRightBG.bounds;
        
        CAShapeLayer *mask2 = [[CAShapeLayer alloc] initWithLayer:layer2];
        mask2.path = path2.CGPath;
        
        layer2.mask = mask2;
        [_torusBottmeRightBG.layer addSublayer:layer2];
        [self insertSubview:_torusBottmeRightBG atIndex:0];
    }
    return _torusBottmeRightBG;
}


@end
