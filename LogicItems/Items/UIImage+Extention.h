//
//  UIImage+handle.h
//  LogicItems
//
//  Created by sixiaobo on 15/11/25.
//  Copyright © 2015年 sixiaobo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extention)

//高斯模糊
- (UIImage *)boxblurImageWithBlur:(CGFloat)blur;

/**
 *  改变图标颜色
 *
 *  @param color
 *
 *  @return
 */
- (UIImage *)imageWithColor:(UIColor *)color;


@end
