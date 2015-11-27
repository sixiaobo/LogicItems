//
//  SiftView.m
//  AppForMeiDa
//
//  Created by sixiaobo on 15/4/24.
//  Copyright (c) 2015年 mxyc. All rights reserved.
//

#import "SiftView.h"
#import "BaseViewController.h"


#define kLeftWidth (kScreenWidth * 0.618)


@implementation SiftView {
    __weak UIViewController *_vc;
    UIImageView *_blur;
    UIPanGestureRecognizer *_pan;
    UITapGestureRecognizer *_tap;
    NSMutableDictionary *_controllersDic;
    __weak ScrollBlock _scrollBlock;
    __weak UIViewController *_markVc;     //标记需要移出的视图控制器
}



- (instancetype)initWithVc:(UIViewController *)vc scrollBlock:(ScrollBlock)scrollBlock {
    if (self = [super initWithFrame:CGRectMake(- kLeftWidth, 0, kLeftWidth, kScreenHeight)]) {
        _scrollBlock = scrollBlock;
        [self commonInitActionWithVc:vc];
    }
    return self;
}


- (instancetype)initWithRootVc:(UIViewController *)vc {
    if (self = [super initWithFrame:CGRectMake(- kLeftWidth, 0, kLeftWidth, kScreenHeight)]) {
        [self commonInitActionWithVc:vc];
    }
    return self;
}


- (void)commonInitActionWithVc:(UIViewController *)vc {
    _vc = vc;
    _blur = [[UIImageView alloc] initWithFrame:CGRectMake(00, 0, kScreenWidth, kScreenHeight)];
    _blur.alpha = 0;
    self.backgroundColor = kColor(0, 0, 0, 0.6);
    _controllersDic = [[NSMutableDictionary alloc] init];
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [_vc.view addGestureRecognizer:_pan];
    [_vc.view addSubview:_blur];
    [_vc.view addSubview:self];
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [_blur addGestureRecognizer:_tap];
    _blur.userInteractionEnabled = YES;
}



- (void)panAction:(UIPanGestureRecognizer *)pan {
    CGPoint p = [pan translationInView:_vc.view];
    if ([self judgeActionWithPoint:p]) {
        return;
    }
    if (pan.state == UIGestureRecognizerStateBegan) {
        if (ViewX(self) == - kLeftWidth) {
            [self changeBlurImage];
        }
    }
    self.center = CGPointMake(self.center.x + p.x, self.center.y);
    CGFloat pro = ViewMaxX(self) / kLeftWidth;
    _blur.alpha = pro;
    [pan setTranslation:CGPointZero inView:_vc.view];
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (ViewMaxX(self) > kLeftWidth * 1 / 2) {
            [self commonActionWithShow:YES anim:YES];
        } else {
            [self commonActionWithShow:NO anim:YES];
        }
    }
    
    
}




//判断是否到达边界
- (BOOL)judgeActionWithPoint:(CGPoint)p {
    if (ViewMaxX(self) + p.x > kLeftWidth) {
        [self commonActionWithShow:YES anim:NO];
        return YES;
    }
    return NO;
}


- (void)changeBlurImage {
    [self handleVcStage:NO];
    _blur.image = [UIParts screenShotWithController:_vc];
}



//改变视图状态（开关）
- (void)handleVcStage:(BOOL)open {
    _tap.enabled = !open;
    if (_scrollBlock) {
        _scrollBlock(open);
    }
}



- (void)tapClick:(UITapGestureRecognizer *)tap {
    [self hidden];
}



- (void)show {
    [self changeBlurImage];
    [self commonActionWithShow:YES anim:YES];
}

- (void)hidden {
    [self commonActionWithShow:NO anim:YES];
}


//可以选择有无动画的视图归位
- (void)commonActionWithShow:(BOOL)show anim:(BOOL)anim {
    CGRect frame = self.frame;
    CGFloat alpha = 0.f;
    if (show) {
        frame.origin.x = 0.f;
        alpha = 1.f;
    } else {
        frame.origin.x = - kLeftWidth;
        alpha = 0.f;
    }
    if (anim) {
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = frame;
            _blur.alpha = alpha;
        } completion:^(BOOL finished) {
            if (!show) {
                [self handleVcStage:YES];
            }
        }];
    } else {
        self.frame = frame;
        _blur.alpha = alpha;
    }
}




//变换视图控制器
- (void)changeVcWithClassName:(NSString *)className {
    BaseViewController *cvc = [_controllersDic objectForKey:className];
    if (!cvc) {
        cvc = [[NSClassFromString(className) alloc] init];
        [_controllersDic setObject:cvc forKey:className];
        __block SiftView *wself = self;
        cvc.backLeft = ^(){
            [wself show];
        };
        _scrollBlock = cvc.scrollBlock;
    }
    [_vc.view insertSubview:cvc.view belowSubview:_blur];
    [_vc addChildViewController:cvc];
    if (_markVc != cvc) {
        [_markVc.view removeFromSuperview];
        [_markVc removeFromParentViewController];
        _markVc = cvc;
    }
    [self hidden];
}




- (void)dealloc {
    [_vc.view removeGestureRecognizer:_pan];
    [_blur removeFromSuperview];
}


@end
