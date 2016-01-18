//
//  HotView.h
//  xmxcy_iphone
//
//  Created by sixiaobo on 15/11/23.
//  Copyright © 2015年 xuchuan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kOriginHeight 0.f

typedef void  (^StrBlock)(NSString *str);



@interface HotView : UIView

- (id)initWithFrame:(CGRect)frame clickBlock:(StrBlock)strBlock;
/**
 *  @author sixiaobo, 15-11-23 17:11:54
 *
 *  刷新热词视图
 *
 *  @param items
 *
 *  @since 6.3.5
 */
- (void)loadWithItems:(NSArray *)items;

@end
