//
//  ELCAssetPicker.h
//  ImageAsset
//
//  Created by baidu on 15/1/26.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ELCAssetImageLayout.h"
#import "ELCAssetCell.h"
#import "ELCAsset.h"
#import "ELCPreviewController.h"
#import "ELCImageEditorController.h"

@interface ELCAssetPicker : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, ELCAssetImageLayoutDelegate, ELCAssetDelegate>
@property (assign, nonatomic) BOOL singleSelection;
@property (assign, nonatomic) BOOL allowEdit;
@property (assign, nonatomic, readonly) NSInteger preCount;
@property (strong, nonatomic) ALAssetsGroup* assetGroup;
@property (nonatomic, copy) ELCCropImage cropBlock;
@end
