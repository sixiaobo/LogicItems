//
//  HotView.m
//  xmxcy_iphone
//
//  Created by sixiaobo on 15/11/23.
//  Copyright © 2015年 xuchuan. All rights reserved.
//

#import "HotView.h"
#import "Header.h"


#define kOff 15.f
#define kButtonTitleFont [UIFont systemFontOfSize:12.f]
#define kButtonHeight 24.f



#define kBtnTag_0  10


@implementation HotView {
    StrBlock _strBlock;
}


/**
 *  @author sixiaobo, 15-11-23 17:11:19
 *
 *  初始化
 *
 *  @param frame
 *  @param strBlock 点击回调的block
 *
 *  @return
 *
 *  @since 6.3.5
 */
- (id)initWithFrame:(CGRect)frame clickBlock:(StrBlock)strBlock {
    if (self = [super initWithFrame:frame]) {
        _strBlock = strBlock;
        self.clipsToBounds = YES;
    }
    return self;
}


/**
 *  @author sixiaobo, 15-11-23 17:11:54
 *
 *  刷新热词视图
 *
 *  @param items
 *
 *  @since 6.3.5
 */
- (void)loadWithItems:(NSArray *)items {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    CGFloat maxY = kOriginHeight;
    for (NSInteger i = 0; i < items.count; i ++) {
        NSString *title = [items objectAtIndex:i];
        if (i == 0) {
            maxY = [self creatButtonWithFrontButton:nil title:title i:i];
        } else {
            UIButton *frontBtn = (UIButton *)[self viewWithTag:kBtnTag_0 + i - 1];
            maxY = [self creatButtonWithFrontButton:frontBtn title:title i:i];
        }
    }
    if (items.count == 0) {
        maxY = 0;
    }
    
    CGRect frame = self.frame;
    frame.size.height = maxY;
    self.frame = frame;
}



/**
 *  @author sixiaobo, 15-11-23 17:11:48
 *
 *  动态计算布局按钮
 *
 *  @param button
 *  @param title
 *  @param i
 *
 *  @since 6.3.5
 */
- (CGFloat)creatButtonWithFrontButton:(UIButton *)button title:(NSString *)title i:(NSInteger)i {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGSize size = [title getSizeWithFont:[UIFont systemFontOfSize:16] andMaxSize:CGSizeMake(kScreenWidth, 18)];
    size.width += 30.f;
    if (!button) {
        btn.frame = CGRectMake(kOff, kOriginHeight, size.width, kButtonHeight);
    } else {
        CGFloat x = ViewMaxX(button) + 8.f;
        CGFloat y = ViewY(button);
        if (x > kScreenWidth - kOff - size.width) {
            x = kOff;
            y = ViewMaxY(button) + 8.f;
        }
        btn.frame = CGRectMake(x, y, size.width, kButtonHeight);
    }
    btn.layer.borderColor = [UIColor orangeColor].CGColor;
    btn.layer.borderWidth = 1;
    btn.tag = i + kBtnTag_0;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = kButtonTitleFont;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return ViewMaxY(btn);
}


- (void)btnClick:(UIButton *)btn {
    if (_strBlock) {
        _strBlock(btn.titleLabel.text);
    }
}

@end
