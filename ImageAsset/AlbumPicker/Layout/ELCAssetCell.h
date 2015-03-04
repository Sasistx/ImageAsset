//
//  ELCAssetCell.h
//  ImageAsset
//
//  Created by baidu on 15/1/26.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCAsset.h"

@interface ELCAssetCell : UICollectionViewCell <UIGestureRecognizerDelegate>
@property (assign, nonatomic) BOOL showSelectedImage;
@property (strong, nonatomic) ELCAsset* asset;
@end
