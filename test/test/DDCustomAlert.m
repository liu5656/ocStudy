
//
//  DDCustomAlert.m
//  test
//
//  Created by 刘健 on 2017/1/5.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import "DDCustomAlert.h"

@interface DDCustomAlert ()
@property(nonatomic, strong) NSMutableArray *buttonArrays;
@end

@implementation DDCustomAlert

- (id)initWithImage:(UIImage *)image contentImage:(UIImage *)content{
    if (self == [super init]) {
        
        self.backgroundImage = image;
        self.contentImage = content;
        self.buttonArrays = [NSMutableArray arrayWithCapacity:4];
    }
    return self;
}

-(void) addButtonWithUIButton:(UIButton *) btn
{
    [_buttonArrays addObject:btn];
}


- (void)drawRect:(CGRect)rect {
    
    CGSize imageSize = self.backgroundImage.size;
    [self.backgroundImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    
}

- (void) layoutSubviews {
    //屏蔽系统的ImageView 和 UIButton
    for (UIView *v in [self subviews]) {
        if ([v class] == [UIImageView class]){
            [v setHidden:YES];
        }
        
        
        if ([v isKindOfClass:[UIButton class]] ||
            [v isKindOfClass:NSClassFromString(@"UIThreePartButton")]) {
            [v setHidden:YES];
        }
    }
    
    for (int i=0;i<[_buttonArrays count]; i++) {
        UIButton *btn = [_buttonArrays objectAtIndex:i];
        btn.tag = i;
        [self addSubview:btn];
        [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (self.contentImage) {
        UIImageView *contentview = [[UIImageView alloc] initWithImage:self.contentImage];
        contentview.frame = CGRectMake(0, 0, self.backgroundImage.size.width, self.backgroundImage.size.height);
        [self addSubview:contentview];
    }
}

-(void) buttonClicked:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    
    if (self.JKdelegate) {
        if ([self.JKdelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
        {
            [self.JKdelegate alertView:self clickedButtonAtIndex:btn.tag];
        }
    }
    
    [self dismissWithClickedButtonIndex:0 animated:YES];
    
}

- (void) show {
    [super show];
    CGSize imageSize = self.backgroundImage.size;
    self.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
    
    
}



@end
