//
//  Header.h
//  LogicItems
//
//  Created by sixiaobo on 15/11/25.
//  Copyright © 2015年 sixiaobo. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define kScreenWidth          ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight         ([[UIScreen mainScreen] bounds].size.height)


#define kColor(r, g, b, a)    [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:(a)]


#define ViewW(v)        v.frame.size.width
#define ViewH(v)        v.frame.size.height
#define ViewX(v)        v.frame.origin.x
#define ViewY(v)        v.frame.origin.y
#define ViewMaxX(v)     CGRectGetMaxX(v.frame)
#define ViewMaxY(v)     CGRectGetMaxY(v.frame)

#define RectX(rect)     rect.origin.x
#define RectY(rect)     rect.origin.y
#define RectW(rect)     rect.size.width
#define RectH(rect)     rect.size.height


#endif /* Header_h */
