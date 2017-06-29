//
//  ButtonHandler.h
//  sfasd
//
//  Created by 刘健 on 2017/6/27.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ButtonHeight 40

@interface ButtonHandler : UIButton

+ (instancetype)buttonHandlerWithTitle:(NSString *)title andIndex:(NSInteger)index andClickBlock:(void (^)(NSInteger index))block;
- (void)buttonClick;

- (void)addLayerBorder:(UIRectCorner )corner;
- (void)removeBorder;

@end
