//
//  ELCBaseZoomScrollViewController.m
//  BaiduTong
//
//  Created by baidu on 14-5-20.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "ELCBaseZoomScrollViewController.h"

@interface ELCBaseZoomScrollViewController ()
@property (nonatomic, strong) ELCAsset* asset;
@end

@implementation ELCBaseZoomScrollViewController

- (instancetype)initWithImageID:(ELCAsset *)asset allowEdit:(BOOL)edit cropSzie:(CGSize)cropSize
{
    self = [super init];
    if (self) {
        _asset = asset;
        _allowEdit = edit;
        _cropSize = cropSize;
    }
    return self;
}

- (instancetype)initWithImageID:(ELCAsset *)asset withIndex:(NSUInteger)index
{
    self = [super init];
    if (self) {
        _asset = asset;
        _allowEdit = NO;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    __block float viewWidth = CGRectGetWidth(self.view.frame);
    __block float viewHeight = CGRectGetHeight(self.view.frame);
    
    __weak ELCBaseZoomScrollViewController* weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ALAsset* asset = [_asset asset];
        ALAssetRepresentation* representation = [asset defaultRepresentation];
        UIImage* image = [UIImage imageWithCGImage:[representation fullScreenImage]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _zoomScrollView = [[UIScrollView alloc] initWithFrame:weakself.view.bounds];
            _zoomScrollView.delegate = weakself;
            _zoomScrollView.maximumZoomScale = 3.0f;
            _zoomScrollView.showsVerticalScrollIndicator = NO;
            _zoomScrollView.showsHorizontalScrollIndicator = NO;
            [_zoomScrollView setBackgroundColor:[UIColor whiteColor]];
            
            [weakself.view addSubview:_zoomScrollView];
            
            if (_allowEdit) {
                [_zoomScrollView setBackgroundColor:[UIColor blackColor]];
                _zoomScrollView.contentSize = CGSizeMake(viewWidth - 1, viewHeight - 1);
                _zoomScrollView.scrollEnabled = YES;
                [weakself zoomScrollDoneWithImage:image];
                
            }else {
                _zoomScrollView.contentSize = CGSizeMake(viewWidth, viewHeight);
                _zoomImageView = [[UIImageView alloc] initWithImage:image];
                _zoomImageView.contentMode = UIViewContentModeScaleAspectFit;
                _zoomImageView.tag = _controllerIndex;
                
                CGSize zoomImageSize = CGSizeMake(image.size.width / [UIScreen mainScreen].scale, image.size.height / [UIScreen mainScreen].scale);
                
                float afterImageViewWidth = 0;
                float afterImageViewHeight = 0;
                float imageViewWidth = zoomImageSize.width;
                float imageViewHeight = zoomImageSize.height;
                
                if (imageViewWidth > viewWidth || imageViewHeight > viewHeight) {
                    if ((imageViewWidth / imageViewHeight) > (viewWidth / viewHeight)) {
                        afterImageViewWidth =  viewWidth;
                        afterImageViewHeight = imageViewHeight * viewWidth / imageViewWidth;
                    } else if((imageViewWidth / imageViewHeight) < (viewWidth / viewHeight)) {
                        afterImageViewWidth =  imageViewWidth * viewHeight / imageViewHeight;
                        afterImageViewHeight = viewHeight;
                    } else {
                        afterImageViewWidth =  viewWidth;
                        afterImageViewHeight = viewHeight;
                    }
                } else {
                    afterImageViewWidth = imageViewWidth;
                    afterImageViewHeight = imageViewHeight;
                }
                
                _zoomImageView.frame = CGRectMake(0, 0, afterImageViewWidth, afterImageViewHeight);
                [weakself refreshImageViewCenter];
                [_zoomScrollView addSubview:_zoomImageView];
                
                UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:weakself action:@selector(doDoubleTapImage)];
                doubleTap.numberOfTapsRequired = 2;
                doubleTap.numberOfTouchesRequired = 1;
                _zoomImageView.userInteractionEnabled = YES;
                [_zoomImageView addGestureRecognizer:doubleTap];
                
                [weakself zoomScrollDone];
            }
        });
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)zoomScrollDoneWithImage:(UIImage*)image
{
    
}

- (void)zoomScrollDone
{
    
}

- (void)refreshImageViewCenter
{
    float frameWidth = CGRectGetWidth(_zoomScrollView.frame);
    float contentWidth = _zoomScrollView.contentSize.width;
    float frameHeight = CGRectGetHeight(_zoomScrollView.frame);
    float contentHeight = _zoomScrollView.contentSize.height;
    CGFloat offsetX = (frameWidth > contentWidth) ? (frameWidth - contentWidth) * 0.5f : 0;
    CGFloat offsetY = (frameHeight > contentHeight)? (frameHeight - contentHeight) * 0.5f : 0;
    _zoomImageView.center = CGPointMake(contentWidth * 0.5f + offsetX, contentHeight * 0.5f + offsetY);
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self refreshImageViewCenter];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _zoomImageView;
}

#pragma mark - 双击图片放大缩小
- (void)doDoubleTapImage
{
    if (_zoomScrollView.zoomScale >= 2.0f) {
        [_zoomScrollView setZoomScale:1.0f animated:YES];
    } else {
        [_zoomScrollView setZoomScale:2.0f animated:YES];
    }
}

@end
