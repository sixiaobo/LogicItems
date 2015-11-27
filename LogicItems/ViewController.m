//
//  ViewController.m
//  LogicItems
//
//  Created by sixiaobo on 15/11/25.
//  Copyright © 2015年 sixiaobo. All rights reserved.
//

#import "ViewController.h"
#import "SiftView.h"
#import "UIView+Vision.h"


@interface ViewController () {
    SiftView *_sift;
    BOOL _open;
    UILabel *_info;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    img.image = [UIImage imageNamed:@"gaojunxi"];
    [self.view addSubview:img];
    self.view.colorKey = kWhiteColorKey;
    _sift = [[SiftView alloc] initWithVc:self scrollBlock:^(BOOL open) {
       
    }];
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(30, 60, 80, 40)];
    btn.backgroundColor = [UIColor yellowColor];
    [_sift addSubview:btn];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
    
    
    _info = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    _info.textAlignment = NSTextAlignmentCenter;
    _info.font = [UIFont boldSystemFontOfSize:17];
    _info.textColor = [UIColor blackColor];
    _info.text = @"白天模式";
    
    [self.view addSubview:_info];
}


- (void)tap {
    if ([UIView currentMode] == kDaytime) {
        [UIView changeVisionMode:kNight];
        _info.textColor = [UIColor whiteColor];
        _info.text = @"夜间模式";
    } else {
        [UIView changeVisionMode:kDaytime];
        _info.textColor = [UIColor blackColor];
        _info.text = @"白天模式";
    }
    
}



- (void)btnClick {
    NSString *className = _open ? @"ViewController" : @"Vc";
    [_sift changeVcWithClassName:className];
    _open = !_open;
    
    NSLog(@"ok");
}











@end
