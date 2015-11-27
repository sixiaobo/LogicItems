//
//  Factory.m
//  LogicItems
//
//  Created by sixiaobo on 15/11/25.
//  Copyright © 2015年 sixiaobo. All rights reserved.
//

#import "Factory.h"
#import "UIImage+Extention.h"


@implementation Factory

#pragma mark - 依据字体计算宽度
+ (CGSize)getSizeWithString:(NSString *)str andFont:(UIFont *)font andMaxSize:(CGSize)maxSize {
    //    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    //    CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    ////    CGSize size = [str sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
    //    return size;
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

/**
 *  将16进制颜色转换成UIColor
 *
 *  @author zhouyu
 *  @version v5.2.0
 *  @修改历史
 *   修改版本    作者名     修改明细
 */
+ (UIColor *)colorWithHexStr: (NSString *)colorStr {
    NSString *redStr = [colorStr substringWithRange:NSMakeRange(0, 2)];
    NSScanner *redScanner = [NSScanner scannerWithString:redStr];
    unsigned int redIntValue;
    [redScanner scanHexInt:&redIntValue];
    
    NSString *greenStr = [colorStr substringWithRange:NSMakeRange(2, 2)];
    NSScanner *greenScanner = [NSScanner scannerWithString:greenStr];
    unsigned int greenIntValue;
    [greenScanner scanHexInt:&greenIntValue];
    
    NSString *blueStr = [colorStr substringWithRange:NSMakeRange(4, 2)];
    NSScanner *blueScanner = [NSScanner scannerWithString:blueStr];
    unsigned int blueIntValue;
    [blueScanner scanHexInt:&blueIntValue];
    
    return [UIColor colorWithRed:redIntValue / 255.0 green:greenIntValue / 255.0 blue:blueIntValue / 255.0 alpha:1];
}



/**
 *  通过颜色来生成一个纯色图片
 *
 *  @author sixiaobo
 *
 *  @since v1.0
 *
 *  @param color
 *
 *  @return
 */
+ (UIImage *)imageWithColor:(UIColor *)color frame:(CGRect)frame {
    CGRect rect = frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

//图片裁剪
+ (void)tailorImageWithImageView:(UIImageView *)imageView {
    CGRect rect =  CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height);
    CGImageRef cgimg = CGImageCreateWithImageInRect([imageView.image CGImage], rect);
    imageView.image = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
}


//反色
+ (UIColor *)colorWithBackMarkStr:(NSString *)markStr {
    NSArray *strs = [markStr componentsSeparatedByString:@","];
    if (strs.count == 3) {
        CGFloat r = [[strs firstObject] floatValue];
        CGFloat g = [[strs objectAtIndex:1] floatValue];
        CGFloat b = [[strs lastObject] floatValue];
        if ([Factory judgeColorValue:r] && [Factory judgeColorValue:g] && [Factory judgeColorValue:b]) {
            return [UIColor redColor];
        } else {
            return kColor(255.f - r, 255.f - g, 255.f - b, 1);
        }
    }
    return [UIColor redColor];
}

+ (BOOL)judgeColorValue:(CGFloat)value {
    return (value >= (255.f / 2 - 10)) && (value <= (255.f/2 + 10));
}




//北京时间
+ (NSNumber *)beiJingDate
{
    NSDate *date = [NSDate date];
    //    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    //    NSInteger interval = [zone secondsFromGMTForDate: date];
    //    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSTimeInterval a =[date timeIntervalSince1970];
    NSNumber *num = [NSNumber numberWithDouble:a * 1000];
    return num;
}


//时长
+ (NSString *)secondsStrWithTimeOldFlot:(CGFloat)oldFlot newFlot:(CGFloat)newFlot {
    NSInteger time = (newFlot - oldFlot);
    NSInteger mark = 0;
    NSString *str = nil;
    if (time >= 3600 * 24) {
        mark = time / (3600 * 24);
        str = @"天";
    } else if (time >= 3600) {
        mark = time / 3600;
        str = @"小时";
    } else if (time >= 60) {
        mark = time / 60;
        str = @"分钟";
    } else {
        mark = time;
        str = @"秒";
    }
    return [NSString stringWithFormat:@"%lu%@ 答复",mark, str];
}

/**
 *  应用版本
 *
 *  @author sixiaobo
 *
 *  @since v1.0.2
 *
 *  @return
 */
+ (NSString *)appVersion  {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}



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
+ (UIImage *)screenShotWithController:(UIViewController *)controller {
    UIGraphicsBeginImageContext(controller.view.bounds.size);
    [controller.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImage *blur = [image boxblurImageWithBlur:0.6];
    //UIImageWriteToSavedPhotosAlbum(blur, nil, nil, nil);
    return blur;
}

/**
 *  依据点击处坐标计算大图中心点位置,锚点原理
 *
 *  @author sixiaobo
 *
 *  @since v1.0
 */
+ (CGPoint)centerBigWithPoint:(CGPoint)point smallFrame:(CGRect)smallFrame bigFrame:(CGRect)bigFrame {
    CGFloat proW = (point.x - smallFrame.origin.x) / smallFrame.size.width;
    CGFloat proY = (point.y - smallFrame.origin.y) / smallFrame.size.height;
    
    CGPoint pointBig = CGPointMake(bigFrame.size.width * proW + smallFrame.origin.x, bigFrame.size.height * proY + smallFrame.origin.y);
    pointBig = CGPointMake(pointBig.x - (bigFrame.size.width - smallFrame.size.width) / 2, pointBig.y - (bigFrame.size.height - smallFrame.size.height) / 2);   //向中心调整
    CGPoint center = CGPointMake(kScreenWidth / 2 + (point.x - pointBig.x), kScreenHeight / 2 + (point.y - pointBig.y));
    return center;
}






@end
