//
//  Vc.m
//  LogicItems
//
//  Created by sixiaobo on 15/11/26.
//  Copyright © 2015年 sixiaobo. All rights reserved.
//

#import "Vc.h"
#import "Header.h"
#import "UIView+Vision.h"

@implementation Vc


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    img.image = [UIImage imageNamed:@"gao"];
    [self.view addSubview:img];
    
}



@end
