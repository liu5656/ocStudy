//
//  DDPopover.h
//  DDPopover
//
//  Created by 刘健 on 16/9/21.
//  Copyright © 2016年 刘健. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDPopover : UIView


+ (instancetype)popover;

- (void)showAtView:(UIView *)atView withText:(NSString *)abs;



- (void)showAtView:(UIView *)atView withText:(NSString *)abs inView:(UIView *)container;

- (void)showAtView:(UIView *)atView withContentView:(UIView *)contentView inView:(UIView *)containerView;
@end
