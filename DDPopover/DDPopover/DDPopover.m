//
//  DDPopover.m
//  DDPopover
//
//  Created by 刘健 on 16/9/21.
//  Copyright © 2016年 刘健. All rights reserved.
//

#import "DDPopover.h"

@interface DDPopover()

@property (nonatomic, assign) CGPoint *arrowPoint;

@end

@implementation DDPopover

+ (instancetype)popover
{
    return [[DDPopover alloc] init];
}

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{

}

- (void)showAtView:(UIView *)atView withText:(NSString *)abs
{
    [self showAtView:atView withText:abs inView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
}

- (void)showAtView:(UIView *)atView withText:(NSString *)abs inView:(UIView *)container
{
    UILabel *textLabel = [UILabel new];
    textLabel.text = abs;
    [textLabel sizeToFit];
    textLabel.backgroundColor = [UIColor clearColor];
    [self showAtView:atView withContentView:textLabel inView:container];
    
    CGRect atViewFrame = [atView convertRect:atView.frame toView:container];
    
}

- (void)showAtView:(UIView *)atView withContentView:(UIView *)contentView inView:(UIView *)containerView
{
    UIControl *blackOverlay = [[UIControl alloc] init];
    blackOverlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    blackOverlay.frame = containerView.bounds;
    [containerView addSubview:blackOverlay];
}

- (void)show
{
    
}

- (void)dismiss
{

}


@end
