//
//  NSValue+Sort.h
//  PLGCollectionView
//
//  Created by sixiaobo on 14/12/12.
//  Copyright (c) 2014年 sixiaobo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSValue (Sort)

//给value的frame按照在视图中的高度排序
- (BOOL)isHeighterThanAnother:(NSValue *)another;


@end
