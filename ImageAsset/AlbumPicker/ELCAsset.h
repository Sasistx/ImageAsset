//
//  Asset.h
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void(^ELCCropImage)(NSArray* cropImages);

@class ELCAsset;

@protocol ELCAssetDelegate <NSObject>

@optional
- (void)assetSelected:(ELCAsset *)asset;
- (void)showAlert;
- (void)totalSelectedAssets;
@end

@interface ELCAsset : NSObject

@property (nonatomic, strong) ALAsset *asset;
@property (nonatomic, assign) id<ELCAssetDelegate> parent;
@property (nonatomic, assign) BOOL selected;

- (id)initWithAsset:(ALAsset *)asset;
- (BOOL)checkImageCount;
- (void)showTipAlert;
- (void)refreshBottomButton;
@end