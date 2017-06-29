//
//  CustomAlertWindow.h
//  sfasd
//
//  Created by 刘健 on 2017/6/27.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAlertWindow : UIWindow
+ (instancetype)sharedInstance;
- (void)revertKeyWindowAndHidden;
@end
