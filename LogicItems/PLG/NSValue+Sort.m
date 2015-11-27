//
//  NSValue+Sort.m
//  PLGCollectionView
//
//  Created by sixiaobo on 14/12/12.
//  Copyright (c) 2014年 sixiaobo. All rights reserved.
//

#import "NSValue+Sort.h"
#import <UIKit/UIKit.h>

@implementation NSValue (Sort)

- (BOOL)isHeighterThanAnother:(NSValue *)another {
    CGRect frame;
    [self getValue:&frame];
    CGRect anotherFrame;
    [another getValue:&anotherFrame];
    return (frame.origin.y + frame.size.height > anotherFrame.origin.y + anotherFrame.size.height) ? YES : NO;
}





@end
