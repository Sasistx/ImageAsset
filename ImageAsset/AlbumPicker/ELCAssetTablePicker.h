//
//  AssetTablePicker.h
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ELCAsset.h"
#import "ELCAssetSelectionDelegate.h"
#import "ELCPreviewController.h"
#import "ELCBaseViewController.h"
#import "ELCImageEditorController.h"

@interface ELCAssetTablePicker : ELCBaseViewController <ELCAssetDelegate, UITableViewDataSource, UITableViewDelegate>
{
    ALAssetsGroup *_assetGroup;
}

@property (nonatomic, assign) id <ELCAssetSelectionDelegate> parent;
@property (nonatomic, retain) ALAssetsGroup *assetGroup;
@property (nonatomic, retain) NSMutableArray *elcAssets;
@property (nonatomic, strong) NSMutableArray* selectedAssects;
@property (nonatomic, assign) BOOL singleSelection;
@property (nonatomic, assign) BOOL immediateReturn;
@property (nonatomic, assign) BOOL allowEdit;
@property (nonatomic, retain) UITableView* assetTableview;
@property (nonatomic, strong) UILabel* navigationBarTitle;
@property (nonatomic, copy) NSString* navigationTitle;
@property (nonatomic, assign, readonly) NSInteger preCount;
@property (nonatomic, copy) ELCCropImage cropBlock;
- (void)preparePhotos;

- (void)doneAction:(id)sender;

- (void)assetSelected:(ELCAsset *)asset;

@end