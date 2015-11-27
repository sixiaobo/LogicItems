//
//  UIView+BackgroundColor.h
//  AppForMeiDa
//
//  Created by sixiaobo on 15/5/22.
//  Copyright (c) 2015年 mxyc. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kWhiteColorKey  @"white"



/**
 颜色模式
 */
typedef enum visionMode {
    kDaytime = 0,
    kNight
}VisionMode;



//用来给所有的，无论系统或自定义的视图控件，添加一个颜色检索关键字
@interface UIView (Vision)
@property (nonatomic, copy) NSString *colorKey;
@property (nonatomic, copy) NSString *btn_image_mode_key;   //处理需要换图标的按钮
@property (nonatomic, copy) NSString *btn_background_color_key;   //检索按钮背景色的key


/**
 *  @author sixiaobo, 15-11-26 16:11:27
 *
 *  切换主题模式
 *
 *  @param mode  可扩展的主题模式
 *
 *  @since v6.3.5
 */
+ (void)changeVisionMode:(VisionMode)mode;


+ (VisionMode)currentMode;


@end



