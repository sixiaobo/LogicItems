//
//  Factory.h
//  LogicItems
//
//  Created by sixiaobo on 15/11/25.
//  Copyright © 2015年 sixiaobo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@interface Factory : NSObject


/**
 *  截屏且取得一张模糊图
 *
 *  @author sixiaobo
 *
 *  @since v1.0.2
 *
 *  @param controller
 *
 *  @return
 */
+ (UIImage *)screenShotWithController:(UIViewController *)controller;


@end
