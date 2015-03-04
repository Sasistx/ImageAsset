//
//  ELCAssetCell.m
//  ImageAsset
//
//  Created by baidu on 15/1/26.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "ELCAssetCell.h"

@interface ELCAssetCell ()
@property (strong, nonatomic) UIImageView* selectedImage;
@property (nonatomic, strong) UIImageView* cellImageView;
@end

@implementation ELCAssetCell

- (void)setAsset:(ELCAsset *)asset
{
    if (_asset != asset) {
        
        _asset = nil;
        _asset = asset;
        _cellImageView.image = [UIImage imageWithCGImage:_asset.asset.thumbnail];
        if (_showSelectedImage){
            _selectedImage.hidden = !_asset.selected;
        }else {
            _selectedImage.hidden = YES;
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self layoutCellImage];
    }
    return self;
}

- (void)layoutCellImage
{
    _cellImageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    _cellImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _cellImageView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_cellImageView];
    
    _selectedImage = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    _selectedImage.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [_selectedImage setImage:[UIImage imageNamed:@"test_overlay.png"]];
    [self.contentView addSubview:_selectedImage];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [tapRecognizer setDelegate:self];
    [self.contentView addGestureRecognizer:tapRecognizer];
}

- (void)cellTapped:(UITapGestureRecognizer *)tapRecognizer
{
    if (_showSelectedImage) {
     
        _asset.selected = !_asset.selected;
        _selectedImage.hidden = !_asset.selected;
        
        if ([_asset checkImageCount]) {
            if (_asset.selected) {
                CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
                CATransform3D transform = _selectedImage.layer.transform;
                animation.duration = 0.4f;
                animation.values = @[[NSValue valueWithCATransform3D:CATransform3DScale(transform, 0.01f, 0.01f, 1.0f)], [NSValue valueWithCATransform3D:CATransform3DScale(transform, 1.1f, 1.1f, 1.0f)], [NSValue valueWithCATransform3D:CATransform3DScale(transform, 1.0f, 1.0f, 1.0f)]];
                [_selectedImage.layer addAnimation:animation forKey:nil];
            }else {
                
                
            }
            
            [_asset refreshBottomButton];
        }else {
            [_asset showTipAlert];
        }
    }else {
    
        _asset.selected = !_asset.selected;
    }
    
    /*
    CGPoint point = [tapRecognizer locationInView:self.contentView];
    CGFloat startX = START_WIDTH;
    CGFloat imageWidth = (self.frame.size.width - individ * 3) / 4.0;
    
    CGRect frame = CGRectMake(startX, 2, imageWidth, imageWidth);
    
    if (_showSelected) {
        for (int i = 0; i < [_rowAssets count]; ++i) {
            if (CGRectContainsPoint(frame, point)) {
                ELCAsset *asset = [_rowAssets objectAtIndex:i];
                if ((![asset checkImageCount]) && (!asset.selected)) {
                    [asset showTipAlert];
                    break;
                }else {
                    asset.selected = !asset.selected;
                    UIImageView *overlayView = [_overlayViewArray objectAtIndex:i];
                    overlayView.hidden = !asset.selected;
                    
                    if (asset.selected) {
                        
                        CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
                        CATransform3D transform = overlayView.layer.transform;
                        animation.duration = 0.4f;
                        animation.values = @[[NSValue valueWithCATransform3D:CATransform3DScale(transform, 0.01f, 0.01f, 1.0f)], [NSValue valueWithCATransform3D:CATransform3DScale(transform, 1.1f, 1.1f, 1.0f)], [NSValue valueWithCATransform3D:CATransform3DScale(transform, 1.0f, 1.0f, 1.0f)]];
                        [overlayView.layer addAnimation:animation forKey:nil];
                    }
                    
                    [asset refreshBottomButton];
                    break;
                }
            }
            frame.origin.x = frame.origin.x + frame.size.width + 4;
        }
    }else {
        for (int i = 0; i < [_rowAssets count]; ++i){
            if (CGRectContainsPoint(frame, point)){
                ELCAsset *asset = [_rowAssets objectAtIndex:i];
                asset.selected = !asset.selected;
            }
            frame.origin.x = frame.origin.x + frame.size.width + 4;
        }
    }
     */
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    return YES;
//}

@end
