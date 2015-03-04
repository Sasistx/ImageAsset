//
//  ELCAssetImageLayout.h
//  ImageAsset
//
//  Created by baidu on 15/1/26.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ELCAssetImageLayout;
@protocol ELCAssetImageLayoutDelegate <NSObject>
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(ELCAssetImageLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface ELCAssetImageLayout : UICollectionViewLayout
@property (assign, nonatomic) UIEdgeInsets sectionInset;
@property (assign, nonatomic) CGFloat itemWidth;
@property (assign, nonatomic) NSUInteger columnCount;
@property (weak, nonatomic) id <ELCAssetImageLayoutDelegate> delegate;
@end
