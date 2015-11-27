//
//  PLGLayout.h
//  PLGCollectionView
//
//  Created by sixiaobo on 14/12/12.
//  Copyright (c) 2014年 sixiaobo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRowNumReload   @"RowNum"
#define kChangeVertical  @"ChangeV"



@protocol PLGLayoutDelegate <NSObject>
@required
//瀑布流列数
- (NSInteger)numberOfColumnsInCollectionView:(UICollectionView *)collectionView;
//对应元素的高度
- (CGFloat)collectionView:(UICollectionView *)collectionView itemHeightAtIndex:(NSInteger)index;

//元素宽高比
- (CGFloat)collectionView:(UICollectionView *)collectionView itemProWithIndex:(NSInteger)index;

@optional


- (NSInteger)numberOfColumnsInCollectionView:(UICollectionView *)collectionView section:(NSInteger)section;

//元素综合间距
- (CGFloat)spaceOfItemsInCollectionView:(UICollectionView *)collectionView;

//左右边框
- (CGFloat)sideSpaceOfCollectionView:(UICollectionView *)collectionView;

//上下间距
- (CGFloat)upSpaceOfCollectionView:(UICollectionView *)collectionView;

/**
 *  元素底部空间
 *
 *  @return 底部空间高度
 */
- (CGFloat)itemBotomHeightCollectionView:(UICollectionView *)collectionview;


@end


@interface PLGLayout : UICollectionViewLayout
@property (weak, nonatomic) id<PLGLayoutDelegate> plgDelegate;
@property (assign, nonatomic)  BOOL isSearchDetail;
@property (assign, nonatomic) BOOL vertical; //竖向瀑布流
@property (assign, nonatomic)  CGFloat topSpace;
@property (assign, nonatomic)  NSInteger markIndex;

@end
