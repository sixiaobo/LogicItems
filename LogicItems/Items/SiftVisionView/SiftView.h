//
//  SiftView.h
//  AppForMeiDa
//
//  Created by sixiaobo on 15/4/24.
//  Copyright (c) 2015年 mxyc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ScrollBlock)(BOOL);

@interface SiftView : UIView


//可以在代码块里写入需要关闭和开启的操作
- (instancetype)initWithVc:(UIViewController *)vc scrollBlock:(ScrollBlock)scrollBlock;

- (instancetype)initWithRootVc:(UIViewController *)vc;

- (void)show;

- (void)hidden;

- (void)changeVcWithClassName:(NSString *)className;


@end
