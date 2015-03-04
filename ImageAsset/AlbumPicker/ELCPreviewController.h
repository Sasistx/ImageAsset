//
//  ELCPreviewController.h
//  BaiduTong
//
//  Created by baidu on 14-5-20.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCBaseViewController.h"
#import "ELCAsset.h"
#import "ELCBaseZoomScrollViewController.h"
#import "ELCImagePickerController.h"
#import "ELCDefines.h"

typedef void(^UpdateImageAsset)(NSArray* asset);

@interface ELCPreviewController : ELCBaseViewController <UIScrollViewDelegate>
//- (instancetype)initWithImageAsset:(NSMutableArray*)assets;
- (instancetype)initWithImageAsset:(NSMutableArray*)assets imageCallback:(ELCCropImage)cropImage update:(UpdateImageAsset)asset;
@end
