//
//  NSString+Extention.m
//  LogicItems
//
//  Created by sixiaobo on 15/11/30.
//  Copyright © 2015年 sixiaobo. All rights reserved.
//

#import "NSString+Extention.h"

@implementation NSString (Extention)




- (CGSize)getSizeWithFont:(UIFont *)font andMaxSize:(CGSize)maxSize {
    //    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    //    CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    ////    CGSize size = [str sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
    //    return size;
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}





@end
