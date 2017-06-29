//
//  CustomAlertWindow.m
//  sfasd
//
//  Created by 刘健 on 2017/6/27.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import "CustomAlertWindow.h"


@interface CustomAlertWindow()

@property (nonatomic, strong, readwrite) UIWindow *previousKeyWindow;
@property (nonatomic, assign) UIViewTintAdjustmentMode oldTintAdjustmentMode;

@end

@implementation CustomAlertWindow

+ (instancetype)sharedInstance {
    static CustomAlertWindow *alertWindow = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alertWindow = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return alertWindow;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.windowLevel = UIWindowLevelNormal;
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
    }
    return self;
}

- (void)makeKeyWindow {
    if (!self.isKeyWindow) {
        _previousKeyWindow = [[UIApplication sharedApplication] keyWindow];
        if ([_previousKeyWindow respondsToSelector:@selector(setTintAdjustmentMode:)]) { // for iOS 7
            _oldTintAdjustmentMode = _previousKeyWindow.tintAdjustmentMode;
            _previousKeyWindow.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        }
        
    }
    [super makeKeyWindow];
}


- (void)revertKeyWindowAndHidden {
    self.hidden = YES;
    
    if ([_previousKeyWindow respondsToSelector:@selector(setTintAdjustmentMode:)]) {
        _previousKeyWindow.tintAdjustmentMode = self.oldTintAdjustmentMode;
    }
    if (self.isKeyWindow) {
        [_previousKeyWindow makeKeyWindow];
    }
    _previousKeyWindow = nil;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
