//
//  ECLImageEditorController.m
//  BaiduTong
//
//  Created by baidu on 14/11/14.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "ELCImageEditorController.h"

@interface ELCImageEditorController ()
@property (assign, nonatomic) UIEdgeInsets imageInset;
@property (assign, nonatomic) CGSize imageSize;
@property (assign, nonatomic) CGFloat diffHeight;
@property (strong, nonatomic) UIImage* image;
@end

@implementation ELCImageEditorController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doDoubleTapImage
{

}

#pragma mark -
#pragma mark - create UI

- (void)zoomScrollDoneWithImage:(UIImage*)image
{
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    
    _image = image;
    
    self.zoomImageView = [[UIImageView alloc] init];

    height = (SCREEN_WIDTH / width) * height;
    width = SCREEN_WIDTH;
    
    _imageSize = CGSizeMake(width, height);
    
    [self.zoomImageView setFrame:CGRectMake(0, 0, width, height)];
    [self.zoomImageView setImage:image];
    
    [self refreshImageViewCenter];

    self.zoomImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.zoomScrollView addSubview:self.zoomImageView];
    
    if (height > self.cropSize.height) {
        
        CGFloat offsetH = (self.zoomScrollView.contentSize.height - self.zoomScrollView.frame.size.height) / 2;
        [self.zoomScrollView setContentOffset:CGPointMake(0, offsetH)];
    }
    
    ELCEditorMask* maskView = [[ELCEditorMask alloc] initWithFrame:self.view.bounds];
    [maskView setCropSize:self.cropSize];
    [maskView setUserInteractionEnabled:NO];
    [maskView setBackgroundColor:[UIColor clearColor]];
    [maskView setCropBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
    [self.view addSubview:maskView];
    [self.view bringSubviewToFront:maskView];
    
    [self createBottomItem];
}

- (void)createBottomItem
{
    UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setFrame:CGRectMake(0, 0, 100, 40)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (IsIPhone5) {
        [cancelButton setCenter:CGPointMake(SCREEN_WIDTH/4, SCREEN_HEIGHT - 80)];
    }else {
        [cancelButton setCenter:CGPointMake(SCREEN_WIDTH/4, SCREEN_HEIGHT - 40)];
    }
    
    [cancelButton addTarget:self action:@selector(cancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    [self.view bringSubviewToFront:cancelButton];
    
    UIButton* selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectButton setFrame:CGRectMake(0, 0, 100, 40)];
    [selectButton setTitle:@"选择" forState:UIControlStateNormal];
    [selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (IsIPhone5) {
        [selectButton setCenter:CGPointMake((SCREEN_WIDTH*3)/4, SCREEN_HEIGHT - 80)];
    }else {
        [selectButton setCenter:CGPointMake((SCREEN_WIDTH*3)/4, SCREEN_HEIGHT - 40)];
    }
    
    [selectButton addTarget:self action:@selector(selectClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectButton];
    [self.view bringSubviewToFront:selectButton];
}

#pragma mark -
#pragma mark - refresh method

- (void)refreshImageViewCenter
{
    [self refreshContenSize:_imageSize];
    float frameWidth = CGRectGetWidth(self.zoomScrollView.frame);
    float contentWidth = self.zoomScrollView.contentSize.width;
    float frameHeight = CGRectGetHeight(self.zoomScrollView.frame);
    float contentHeight = self.zoomScrollView.contentSize.height;
    CGFloat offsetX = (frameWidth > contentWidth) ? (frameWidth - contentWidth) * 0.5f : 0;
    CGFloat offsetY = (frameHeight > contentHeight)? (frameHeight - contentHeight) * 0.5f : 0;
    if (IsIOS7) {
        self.zoomImageView.center = CGPointMake(contentWidth * 0.5f + offsetX, contentHeight * 0.5f + offsetY);
    }else {
        self.zoomImageView.center = CGPointMake(contentWidth * 0.5f + offsetX, contentHeight * 0.5f + offsetY);
    }
}

- (void)refreshContenSize:(CGSize)size
{
    CGFloat currentImageWidth = size.width * self.zoomScrollView.zoomScale;
    CGFloat currentImageHeight = size.height * self.zoomScrollView.zoomScale;
    CGFloat diffValue = currentImageHeight - self.cropSize.height > 0 ? currentImageHeight - self.cropSize.height : 0;
    CGFloat scrollHeight = self.zoomScrollView.frame.size.height;
    
    self.zoomScrollView.contentSize = CGSizeMake(currentImageWidth + 2, scrollHeight + diffValue);
}

#pragma mark -
#pragma mark - button event

- (void)cancelClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectClicked:(id)sender
{
    UIImage* cropImage = [self cropImage];
    NSArray* array = [[NSArray alloc] initWithObjects:cropImage, nil];
    if (_cropBlock) {
        
        _cropBlock(array);
    }
}

#pragma mark -
#pragma mark - crop image method

- (UIImage*)cropImage
{
    CGFloat zoomScale = self.zoomScrollView.zoomScale;
    CGFloat offsetX = self.zoomScrollView.contentOffset.x;
    CGFloat offsetY = self.zoomScrollView.contentOffset.y;
    
    CGFloat imageScale = _image.size.width / self.cropSize.width;
    
    CGFloat tA = offsetX > 0 ? (offsetX / zoomScale * imageScale) : 0;
    CGFloat tB = offsetY > 0 ? (offsetY / zoomScale * imageScale) : 0;
    
    CGFloat tWidth = self.cropSize.width / zoomScale * imageScale;
    CGFloat tHeight;
    
    if (self.cropSize.height * imageScale > _image.size.height) {
        
        tHeight = self.cropSize.height / zoomScale * imageScale;
    }else {
    
        tHeight = _image.size.height;
    }
    
    UIImage* image = [_image cropImageWithX:tA y:tB width:tWidth height:tHeight];
    
    return image;
}

@end

@interface ELCEditorMask ()
@property (assign, nonatomic) CGRect cropRect;
@end

@implementation ELCEditorMask

- (void)setCropBorderColor:(UIColor *)cropBorderColor
{
    if (_cropBorderColor) {
        
        _cropBorderColor = nil;
    }
    _cropBorderColor = cropBorderColor;
    [self setNeedsDisplay];
}

- (void)setCropBackgroundColor:(UIColor *)cropBackgroundColor
{
    if (_cropBackgroundColor) {
        
        _cropBackgroundColor = nil;
    }
    _cropBackgroundColor = cropBackgroundColor;
    [self setNeedsDisplay];
}

- (void)setCropSize:(CGSize)cropSize
{
    CGFloat x = (CGRectGetWidth(self.bounds) - cropSize.width) / 2;
    CGFloat y = (CGRectGetHeight(self.bounds) - cropSize.height) / 2;
    _cropRect = CGRectMake(x, y, cropSize.width, cropSize.height);
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    if (_cropBackgroundColor) {
        
        CGContextSetFillColorWithColor(ctx, _cropBackgroundColor.CGColor);
    }else {
        
        CGContextSetRGBFillColor(ctx, 1, 1, 1, .6);
    }
    
    
    CGContextFillRect(ctx, self.bounds);
    
    if (_cropBorderColor) {
        CGContextSetStrokeColorWithColor(ctx, _cropBorderColor.CGColor);
    }else {
        CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    }
    
    CGContextStrokeRectWithWidth(ctx, _cropRect, 2);
    
    CGContextClearRect(ctx, _cropRect);
}

@end
