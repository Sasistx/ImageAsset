//
//  Asset.m
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAsset.h"
#import "ELCAssetPicker.h"

@implementation ELCAsset

@synthesize asset = _asset;
@synthesize parent = _parent;
@synthesize selected = _selected;

- (id)initWithAsset:(ALAsset*)asset
{
	self = [super init];
	if (self) {
		self.asset = asset;
        _selected = NO;
    }
    
	return self;	
}

- (void)toggleSelection
{
    self.selected = !self.selected;
    //设置标题
}

- (void)setSelected:(BOOL)selected
{
    _selected=selected;

        if (_parent != nil && [_parent respondsToSelector:@selector(assetSelected:)]) {
            [_parent assetSelected:self];
        }
}

- (BOOL)checkImageCount
{
    if (((ELCAssetPicker*)_parent).preCount >= 8) {
            
        return NO;
    }
    return YES;
}

- (void)showTipAlert
{
    if ([_parent respondsToSelector:@selector(showAlert)]) {
        [_parent showAlert];
    }
}

- (void)refreshBottomButton
{
    if ([_parent respondsToSelector:@selector(totalSelectedAssets)]) {
        [_parent totalSelectedAssets];
    }
}

- (void)dealloc
{
    
}

@end

