//
//  ELCPreviewController.m
//  BaiduTong
//
//  Created by baidu on 14-5-20.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "ELCPreviewController.h"

static const NSInteger baseTag = 10;

@interface ELCPreviewController ()
@property (nonatomic, strong) UIScrollView *imageScrollView;
@property (nonatomic, strong) NSMutableArray* assetArray;
@property (nonatomic, copy) UpdateImageAsset assetBlock;
@property (nonatomic, copy) ELCCropImage cropImage;
@property (nonatomic, strong) UIButton* rightItemButton;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation ELCPreviewController

- (instancetype)initWithImageAsset:(NSMutableArray*)assets imageCallback:(ELCCropImage)cropImage update:(UpdateImageAsset)asset
{
    self = [super init];
    if (self) {
        _assetArray = [NSMutableArray arrayWithArray:assets];
        _currentIndex = 0;
        _assetBlock = asset;
        _cropImage = cropImage;
    }
    return self;
}

//- (instancetype)initWithImageAsset:(NSMutableArray*)assets
//{
//    self = [super init];
//    if (self) {
//        _assetArray = [NSMutableArray arrayWithArray:assets];
//        _currentIndex = 0;
//    }
//    return self;
//}

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
    
    [self initialNavigationItem];
    if ([_assetArray count] == 1) {
        self.title = @"预览";
    }else {
        self.title = [NSString stringWithFormat:@"1/%lu", (unsigned long)[_assetArray count]];
    }
    
    float viewFrameWidth = CGRectGetWidth(self.view.frame);
    __block float viewFrameHeight = CGRectGetHeight(self.view.frame);
    __weak ELCPreviewController* weakself = self;
    _imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewFrameWidth, viewFrameHeight)];
    _imageScrollView.delegate = self;
    _imageScrollView.backgroundColor = [UIColor whiteColor];
    _imageScrollView.pagingEnabled = YES;
    _imageScrollView.showsVerticalScrollIndicator = NO;
    _imageScrollView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:_imageScrollView];
    if (IsIOS7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _imageScrollView.contentSize = CGSizeMake(viewFrameWidth * [_assetArray count], viewFrameHeight);

    [_assetArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ELCAsset* eclAsset = obj;
        ELCBaseZoomScrollViewController* zoomViewController = [[ELCBaseZoomScrollViewController alloc] initWithImageID:eclAsset withIndex:idx + baseTag];
        [_imageScrollView addSubview:zoomViewController.view];
        zoomViewController.view.frame = CGRectMake(weakself.view.frame.size.width * idx, 0, viewFrameWidth, viewFrameHeight);
        [weakself addChildViewController:zoomViewController];
        [zoomViewController didMoveToParentViewController:weakself];
    }];
    
    [self initailBottomItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initialNavigationItem
{
    [super initialNavigationItem];
    
    _rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightItemButton setFrame:CGRectMake(0, 0, 27, 27)];
//    [_rightItemButton setBackgroundImage:[ResourceHelper loadImageByTheme:@"buddy_check"] forState:UIControlStateNormal];
    [_rightItemButton addTarget:self action:@selector(chooseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:_rightItemButton];
    [self.navigationItem setRightBarButtonItem:item];
}

- (void)initailBottomItem
{
    float viewWidth = CGRectGetWidth(self.view.frame);
    float viewHeight = CGRectGetHeight(self.view.frame);
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight - 45, viewWidth, 45)];
    [bottomView setBackgroundColor:[UIColor whiteColor]];
    
    UIButton* sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [sendButton setFrame:CGRectMake(viewWidth - 90, 7, 80, 31)];
    [sendButton setTitle:[NSString stringWithFormat:@"发送(%lu)", (unsigned long)[_assetArray count]] forState:UIControlStateNormal];
    [sendButton setTitle:@"发送" forState:UIControlStateDisabled];
    [sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [sendButton.layer setBorderColor:[UIColor blueColor].CGColor];
    [sendButton.layer setCornerRadius:2.0f];
    [sendButton.layer setMasksToBounds:YES];
    [sendButton.layer setBorderWidth:1.0f];
    [sendButton setTag:10];
    [sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:sendButton];
    
    [self.view addSubview:bottomView];
}

#pragma mark - refresh UI

- (void)updateRightItem;
{
    ELCAsset* asset = _assetArray[_currentIndex];
    if (asset.selected) {
//        [_rightItemButton setBackgroundImage:[ResourceHelper loadImageByTheme:@"buddy_check"] forState:UIControlStateNormal];
    }else {
        [_rightItemButton setBackgroundImage:nil forState:UIControlStateNormal];
    }
}

- (void)updateTitleItem
{
    [self.navigationBarTitle setText:[NSString stringWithFormat:@"%d/%lu", _currentIndex + 1, (unsigned long)[_assetArray count]]];
}

- (void)updateBottomItem
{
    UIButton* button = (UIButton*)[self.view viewWithTag:10];
    __block NSInteger count = 0;
    [_assetArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ELCAsset* asset = obj;
        if (asset.selected) {
            count++;
        }
    }];
    if (count == 0) {
        [button setEnabled:NO];
        [button.layer setBorderColor:[UIColor grayColor].CGColor];
    }else {
        [button setEnabled:YES];
        [button.layer setBorderColor:[UIColor grayColor].CGColor];
        [button setTitle:[NSString stringWithFormat: @"发送(%ld)", (long)count] forState:UIControlStateNormal];
    }
}

#pragma mark - scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentSizeW = scrollView.contentSize.width;
    CGFloat scrollViewWidth = scrollView.frame.size.width;
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX > contentSizeW - scrollViewWidth) {
        return;
    }
    if (offsetX < 0) {
        return;
    }
    
    CGFloat scrollIndex = offsetX / scrollViewWidth;
    if ((scrollIndex - 0.5 < _currentIndex) && (scrollIndex - 0.5 >= _currentIndex)) {
        return;
    }else {
        _currentIndex = (NSInteger)(scrollIndex + 0.5);
        [self updateRightItem];
        [self updateTitleItem];
    }
}

#pragma mark - button click event

- (void)sendButtonClicked:(id)sender
{
    NSMutableArray* array = [NSMutableArray array];
    [_assetArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        ELCAsset* elcAsset = obj;
        if (elcAsset.selected) {
            
            [array addObject:elcAsset];
        }
        
    }];
    if (_cropImage) {
        _cropImage (array);
    }
}

- (void)chooseButtonClicked:(id)sender
{
    ELCAsset* asset = _assetArray[_currentIndex];
    asset.selected = !asset.selected;
    [self updateRightItem];
    [self updateBottomItem];
}

- (void)btnBackClick:(id)sender
{
    if (_assetBlock) {
        _assetBlock(_assetArray);
    }
    [super btnBackClick:sender];
}

@end
