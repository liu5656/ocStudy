//
//  DDCustomAlert.h
//  test
//
//  Created by 刘健 on 2017/1/5.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JKCustomAlertDelegate <NSObject>
@optional
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

@interface DDCustomAlert : UIAlertView

@property(readwrite, retain) UIImage *backgroundImage;
@property(readwrite, retain) UIImage *contentImage;
@property(nonatomic, weak) id JKdelegate;
- (id)initWithImage:(UIImage *)image contentImage:(UIImage *)content;
-(void) addButtonWithUIButton:(UIButton *) btn;
@end
