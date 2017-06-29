//
//  ContainView.m
//  sfasd
//
//  Created by 刘健 on 2017/6/27.
//  Copyright © 2017年 刘健. All rights reserved.
//

#import "ContainView.h"



@implementation ContainView

+ (instancetype)containViewWithTitle:(NSString *)title andMessage:(NSString *)message {
    ContainView *view = [[ContainView alloc] init];
    
    CGFloat defaultWidth = ContainerDefaultWidth;
    CGFloat defaultHheight = ContainerDefaultHeight - 2 * ContainerDefaultBorder;
    CGFloat height = 0;
    if (title.length) {
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, defaultWidth, TitleDefaultHeight)];
        titleL.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.backgroundColor = [UIColor clearColor];
        titleL.textColor = [UIColor blackColor];
        titleL.lineBreakMode = NSLineBreakByTruncatingTail;
        titleL.text = title;
        [view addSubview:titleL];
        height = CGRectGetMaxY(titleL.frame);
    }
    
    if (message.length) {
        CGSize size = [message boundingRectWithSize:CGSizeMake(ContainerDefaultWidth - ContainerDefaultBorder * 2, 999) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        UILabel *messageL = [[UILabel alloc] initWithFrame:CGRectMake(ContainerDefaultBorder, height + ContainerDefaultBorder, defaultWidth - ContainerDefaultBorder * 2, size.height)];
        messageL.textAlignment = NSTextAlignmentCenter;
        messageL.lineBreakMode = NSLineBreakByTruncatingTail;
        messageL.font = [UIFont systemFontOfSize:14];
        messageL.numberOfLines = 0;
        messageL.backgroundColor = [UIColor clearColor];
        messageL.textColor = [UIColor blackColor];
        messageL.text = message;
        [view addSubview:messageL];
        height = CGRectGetMaxY(messageL.frame);
    }
    
    view.frame = CGRectMake(0, 0, defaultWidth, MAX(defaultHheight, height));
    view.backgroundColor = [UIColor clearColor];
    return view;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
