//
//  ELCImagePickerController.h
//  ELCImagePickerDemo
//
//  Created by ELC on 9/9/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCAssetSelectionDelegate.h"
//#import "CRNavigationController.h"

@class ELCImagePickerController;

@protocol ELCImagePickerControllerDelegate <UINavigationControllerDelegate>
@optional
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info;
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker;
- (void)cancelImagePicker;
@end

@interface ELCImagePickerController : UINavigationController <ELCAssetSelectionDelegate>

@property (nonatomic, assign) id<ELCImagePickerControllerDelegate> delegate;
@property (nonatomic, assign) BOOL allowEdit;   //Default is NO

- (void)cancelImagePicker;
//- (void)selectedAssets:(NSArray *)assets;
@end

