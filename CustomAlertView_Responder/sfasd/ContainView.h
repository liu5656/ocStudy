//
//  ContainView.h
//  sfasd
//
//  Created by 刘健 on 2017/6/27.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ContainerDefaultWidth 280
#define ContainerDefaultHeight 80
#define ContainerDefaultBorder 10

#define TitleDefaultHeight 20

@interface ContainView : UIView

+ (instancetype)containViewWithTitle:(NSString *)title andMessage:(NSString *)message;

@end
