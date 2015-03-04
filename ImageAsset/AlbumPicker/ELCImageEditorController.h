//
//  ECLImageEditorController.h
//  BaiduTong
//
//  Created by baidu on 14/11/14.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCBaseZoomScrollViewController.h"
#import "UIImage+CropImage.h"
#import "ELCAsset.h"

@interface ELCImageEditorController : ELCBaseZoomScrollViewController
@property (copy, nonatomic) ELCCropImage cropBlock;
@end

@interface ELCEditorMask : UIView
@property (assign, nonatomic) CGSize cropSize;
@property (strong, nonatomic) UIColor* cropBorderColor;
@property (strong, nonatomic) UIColor* cropBackgroundColor;
@end