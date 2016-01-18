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
#import "HotView.h"

@interface ViewController () {
    SiftView *_sift;
    BOOL _open;
    UILabel *_info;
}
@property (nonatomic, strong) HotView *hot;

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
    
    
    
    __weak UILabel *wlabel = _info;
    __weak ViewController *wself = self;
    _hot = [[HotView alloc] initWithFrame:CGRectMake(0, 68, kScreenWidth, 20) clickBlock:^(NSString *str) {
        wlabel.text = str;
        [wself.hot loadWithItems:[wself items]];   //这里面的hot已为空，被arc释放了
    }];
    [self.view addSubview:_hot];
    [_hot loadWithItems:[self items]];
    
}


- (NSArray *)items {
    NSString *str = arc4random() % 2 ? @"幸福的眼泪" : @"快乐的人不要去天堂起来";
    return @[@"你是很牛逼", str, @"走吧", @"去实现更大的报复", @"流行的孩子", @"和一只马的感情越来越好", @"二环内夜晚是最文艺的"];
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
