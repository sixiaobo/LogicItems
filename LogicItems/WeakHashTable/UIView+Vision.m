//
//  UIView+BackgroundColor.m
//  AppForMeiDa
//
//  Created by sixiaobo on 15/5/22.
//  Copyright (c) 2015年 mxyc. All rights reserved.
//

#import "UIView+Vision.h"
#import <objc/runtime.h>


/**
 *  @author sixiaobo, 15-11-26 16:11:37
 *
 *  VisionTool  类
 *
 *  @since v6.3.5
 */

@interface VisionTool : NSObject
@property (nonatomic, assign) VisionMode mode; //显示模式

+ (VisionTool *)share;

//添加需要变化颜色的视图,对应的颜色键值
- (void)addWeakView:(UIView *)view;


@end


@implementation VisionTool {
    NSHashTable *_hashTable;    //弱引用键值对集合
    NSMutableArray *_modeColorDicsArray;
}


- (instancetype)init {
    if (self = [super init]) {
        _hashTable = [NSHashTable weakObjectsHashTable];
        _modeColorDicsArray = [[NSMutableArray alloc] init];
        [self initColors];
    }
    return self;
}


//颜色字典初始化
- (void)initColors {
    [_modeColorDicsArray addObject:@{kWhiteColorKey : [UIColor whiteColor]}];
    [_modeColorDicsArray addObject:@{kWhiteColorKey : [UIColor blackColor]}];
    _mode = kDaytime;
}




+ (VisionTool *)share {
    static VisionTool *ob = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ob = [[VisionTool alloc] init];
    });
    return ob;
}


//添加需要变化颜色的视图,对应的颜色键值
- (void)addWeakView:(UIView *)view {
    [self giveColor:[self colorWithKey:view.colorKey] toView:view];
    [_hashTable addObject:view];
}


//筛选出颜色
- (UIColor *)colorWithKey:(NSString *)colorKey {
    NSDictionary *dic = _modeColorDicsArray[_mode];
    return dic[colorKey];
}

/**
 *  筛选出图标
 *
 *  @param btnImageKey
 *
 *  @return
 */
- (UIImage *)imageWithKey:(NSString *)btnImageKey {
    NSDictionary *dic = _modeColorDicsArray[_mode];
    return dic[btnImageKey];
}




//激活动作
- (void)fireNotific {
    for (UIView *view in _hashTable) {
        [self giveColor:[self colorWithKey:view.colorKey] toView:view];
    }
}



//给视图赋颜色
- (void)giveColor:(UIColor *)color toView:(UIView *)view {
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)view;
        label.textColor = color;
    } else if ([view isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)view;
        if (btn.btn_image_mode_key) {
            [btn setImage:[self imageWithKey:btn.btn_image_mode_key] forState:UIControlStateNormal];
        } else {
            if (btn.colorKey) {
                [btn setTitleColor:color forState:UIControlStateNormal];
            }
            if (btn.btn_background_color_key) {
                btn.backgroundColor = [self colorWithKey:btn.btn_background_color_key];
            }
        }
    } else {
        view.backgroundColor = color;
    }
}



//设置显示模式
- (void)setMode:(VisionMode)mode {
    _mode = mode;
    [self fireNotific];
    
    NSLog(@"fuck");
}

@end







/**
 *  @author sixiaobo, 15-11-26 16:11:41
 *
 *  类别执行
 *
 *  @since v6.3.5
 */

@implementation UIView (Vision)

static char str = 'a';
static char another = 'b';
static char btnBackColor = 'c';

//返回属性
- (NSString *)colorKey {
    return objc_getAssociatedObject(self, &str);
}


//设置颜色属性
- (void)setColorKey:(NSString *)colorKey {
    objc_setAssociatedObject(self, &str, colorKey, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [[VisionTool share] addWeakView:self];
}


/**
 *  按钮图标检索的key
 *
 *  @return
 */
- (NSString *)btn_image_mode_key {
    return objc_getAssociatedObject(self, &another);
}


- (void)setBtn_image_mode_key:(NSString *)btn_image_mode_key {
    objc_setAssociatedObject(self, &another, btn_image_mode_key, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [[VisionTool share] addWeakView:self];
}




- (NSString *)btn_background_color_key {
    return objc_getAssociatedObject(self, &btnBackColor);
}


- (void)setBtn_background_color_key:(NSString *)btn_background_color_key {
    objc_setAssociatedObject(self, &btnBackColor, btn_background_color_key, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [[VisionTool share] addWeakView:self];
}


+ (void)changeVisionMode:(VisionMode)mode {
    [VisionTool share].mode = mode;
}


+ (VisionMode)currentMode {
    return [VisionTool share].mode;
}

@end
















