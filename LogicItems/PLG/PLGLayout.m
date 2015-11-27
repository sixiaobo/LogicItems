//
//  PLGLayout.m
//  PLGCollectionView
//
//  Created by sixiaobo on 14/12/12.
//  Copyright (c) 2014年 sixiaobo. All rights reserved.
//

#import "PLGLayout.h"
#import "NSValue+Sort.h"
#import "Header.h"

@implementation PLGLayout {
    NSMutableArray *_framValues;
    CGFloat _itemWidth;
    NSMutableArray *_attributes;
    BOOL _contentZero;  //容器归零
    CGFloat _offy;
    NSInteger _cacheSection;
}


- (id)init {
    if (self = [super init]) {
       // _vertical = YES;
        _cacheSection = 0;        
        _framValues = [[NSMutableArray alloc] init];
        _attributes = [[NSMutableArray alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectionReload) name:kRowNumReload object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeVertical:) name:kChangeVertical object:nil];
    }
    return self;
}


/**
 *  列数变化时刷新
 *
 *  @author sixiaobo
 *
 *  @since v1.0.0
 */
- (void)collectionReload {
    self.collectionView.contentOffset = CGPointMake(0, 0);
    [self.collectionView reloadData];
}




/**
 *  变换竖向瀑布流
 *
 *  @param notific
 */
- (void)changeVertical:(NSNotification *)notific {
    NSNumber *nub = notific.object;
    _vertical = nub.boolValue;
    [self.collectionView reloadData];
}



- (CGSize)collectionViewContentSize {
    CGRect frame;
    [_framValues sortUsingSelector:@selector(isHeighterThanAnother:)];
    NSValue *value = [_framValues lastObject];
    [value getValue:&frame];
    CGFloat contentHeight = 0.f;
    if (_vertical) {
        contentHeight = frame.size.height + frame.origin.y +[_plgDelegate spaceOfItemsInCollectionView:self.collectionView];
        if (contentHeight < self.collectionView.frame.size.height) {
            contentHeight = self.collectionView.frame.size.height + 2;
        }
        if (_contentZero) {
            contentHeight = 0;
            _contentZero = NO;
        }
    } else {
        contentHeight = _offy;
    }
    return CGSizeMake(self.collectionView.frame.size.width, contentHeight);
}




/**
 *  布局元素frame
 */
- (void)configAttributes {
    if (_attributes.count) {
        [_attributes removeAllObjects];
        [_framValues removeAllObjects];
        _offy = 0.f;
    }
    NSInteger columns = [_plgDelegate numberOfColumnsInCollectionView:self.collectionView];
    CGFloat space = 0.f;
    CGFloat side = 0.f;
    CGFloat upsp = 0.f;
    
    if ([_plgDelegate respondsToSelector:@selector(spaceOfItemsInCollectionView:)]) {
        space = [_plgDelegate spaceOfItemsInCollectionView:self.collectionView];
    }
    
    if ([_plgDelegate respondsToSelector:@selector(sideSpaceOfCollectionView:)]) {
        side = [_plgDelegate sideSpaceOfCollectionView:self.collectionView];
    }
    
    if ([_plgDelegate respondsToSelector:@selector(upSpaceOfCollectionView:)]) {
        upsp = [_plgDelegate upSpaceOfCollectionView:self.collectionView];
    }
    if (_vertical) {
        [self handleVerticalWithColumns:columns space:space side:side upsp:upsp];
    } else {
        [self handleWithColumns:columns space:space side:side upsp:upsp];
    }
}





/**
 *  重写的系统方法
 */
- (void)prepareLayout {
    [self configAttributes];
}





- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    return _attributes;
}



/**
 *  竖向瀑布流布局
 *
 *  @param columns 列数
 *  @param space   间距
 *  @param side    边框
 *  @param upsp    中间框
 */
- (void)handleVerticalWithColumns:(NSInteger)columns space:(CGFloat)space side:(CGFloat)side upsp:(CGFloat)upsp {
    CGFloat cellWidth = (self.collectionView.frame.size.width - 2 * side - (columns + 1) * space) / columns;
    
    
    for (NSInteger i=0 ; i < [[self collectionView] numberOfItemsInSection:0]; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        CGRect frame;
        CGFloat sp = space;
        CGFloat height = [_plgDelegate collectionView:self.collectionView itemHeightAtIndex:i];
        if (height == 0.f) {   //过滤高度为零的无效数据
            sp = 0.f;
        } else {
            sp = space;
        }
        if (i < columns) {    //列数之前计算
            CGFloat offx;
            if (i == 0) {
                offx = space;
            } else {
                offx = 2 * space + cellWidth + (cellWidth + space) * (i - 1);
            }
            frame = CGRectMake(offx + side, sp + _topSpace + upsp, cellWidth, height);
        } else {
            [_framValues sortUsingSelector:@selector(isHeighterThanAnother:)];
            NSValue *upValue = [_framValues objectAtIndex:0];
            CGRect upFrame;
            [upValue getValue:&upFrame];
            frame = CGRectMake(upFrame.origin.x, upFrame.origin.y + upFrame.size.height + sp + upsp, cellWidth, height);
        }
        attribute.frame = frame;
        NSValue *value = [NSValue valueWithBytes:&frame objCType:@encode(CGRect)];
        [_framValues addObject:value];
        if (i >= columns) {
            [_framValues removeObjectAtIndex:0];  //移除掉之前排序过的
        }
        [_attributes addObject:attribute];
        
    }
}



/**
 *  横向瀑布流布局
 *
 *  @param columns 列数
 *  @param space   间距
 *  @param side    边框
 *  @param upsp    中间框
 */
- (void)handleWithColumns:(NSInteger)columns space:(CGFloat)space side:(CGFloat)side upsp:(CGFloat)upsp {
    _offy = upsp + space + _topSpace;
    NSInteger itemNumber = [[self collectionView] numberOfItemsInSection:0];
    for (NSInteger i=0 ; i < itemNumber; i++) {
        if ([_plgDelegate respondsToSelector:@selector(numberOfColumnsInCollectionView:section:)]) {
            columns = [_plgDelegate numberOfColumnsInCollectionView:self.collectionView section:_cacheSection];
        }
        if (i % columns == 0) {
            _cacheSection = i / columns;
            //缓存宽高比之和
            CGFloat cachePro = 0.f;
            //防止越界            
            NSInteger bound = (i + columns >= itemNumber) ? itemNumber : (i + columns);
            for (NSInteger j = i; j < bound; j++) {
                //获取对应图片的宽高比
                CGFloat pro = [_plgDelegate collectionView:self.collectionView itemProWithIndex:j];
                cachePro += pro;
            }
            if (cachePro <= 0.f) {   //防止除数为零的情况发生
                continue;
            }
            
            CGFloat h = (CGFloat)(ViewW(self.collectionView) - 2 * side - (bound - i + 1) * space) / cachePro;
            CGFloat offx = side;
            CGFloat botom = 0.f;
            if ([_plgDelegate respondsToSelector:@selector(itemBotomHeightCollectionView:)]) {
                botom = [_plgDelegate itemBotomHeightCollectionView:self.collectionView]; //给元素底部累加的空间，用来放置信息等
            }
            for (NSInteger j = i, k = 0; j < bound; j++, k++) {
                CGFloat pro = [_plgDelegate collectionView:self.collectionView itemProWithIndex:j];
                offx += space;  //添加间隙
                NSIndexPath* indexPath = [NSIndexPath indexPathForItem:j inSection:0];
                UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                CGRect frame = CGRectMake(offx, _offy, h * pro, h + botom);
                offx += h * pro;      //偏移量累加上宽度
                attribute.frame = frame;
                [_attributes addObject:attribute];
            }
            _offy += h + botom + space;
        }
    }
}




- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
