//
//  AlbumPickerController.h
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ELCAssetSelectionDelegate.h"
#import "ELCAsset.h"
#import "ELCDefines.h"
#import "ELCAssetPicker.h"

@interface ELCAlbumPickerController : UIViewController <ELCAssetSelectionDelegate, UITableViewDataSource, UITableViewDelegate>
- (instancetype)initWithCropImage:(ELCCropImage)cropImageBlock;
- (instancetype)initWithSingleImage:(BOOL)isSingle canEdit:(BOOL)edit cropImage:(ELCCropImage)cropImageBlock;
@property (nonatomic, assign) id<ELCAssetSelectionDelegate> parent;
@property (nonatomic, retain) NSMutableArray *assetGroups;
@property (nonatomic, assign) BOOL allowEdit;
@property (nonatomic, assign) BOOL singleImage;
@end

