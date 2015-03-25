//
//  ELCAssetPicker.m
//  ImageAsset
//
//  Created by baidu on 15/1/26.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "ELCAssetPicker.h"
#import "ELCDefines.h"

#define BOTTOM_HEIGHT 45.0f

@interface ELCAssetPicker ()
@property (strong, nonatomic) UICollectionView* collectionView;
@property (strong, nonatomic) NSMutableArray *elcAssets;
@property (strong, nonatomic) NSMutableArray* selectedIndexArray;
@property (strong, nonatomic) UIView* bottomView;
@end

@implementation ELCAssetPicker

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    ELCAssetImageLayout* layout = [[ELCAssetImageLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
    layout.delegate = self;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[ELCAssetCell class] forCellWithReuseIdentifier:CELL_IDENTIFIER];
    [self.view addSubview:_collectionView];
    
    if (!_singleSelection) {
        
        [self initialBottomItems];
    }
    _selectedIndexArray = [[NSMutableArray alloc] init];
    _elcAssets = [[NSMutableArray alloc] init];
    _preCount = 0;
    
    [self performSelectorInBackground:@selector(preparePhotos) withObject:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)preparePhotos
{
    __weak ELCAssetPicker* weakself = self;
    @autoreleasepool {
        NSLog(@"enumerating photos");
        [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if(result == nil) {
                return;
            }
            
            ELCAsset *elcAsset = [[ELCAsset alloc] initWithAsset:result];
            [elcAsset setParent:self];
            [_elcAssets addObject:elcAsset];
        }];
        NSLog(@"done enumerating photos");
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            

            [weakself updateLayout];
            [_collectionView reloadData];
            if ([_elcAssets count] != 0) {
                
                [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:([_elcAssets count] - 1) inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
            }

        });
        
    }
}

- (void)initialBottomItems
{
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - BOTTOM_HEIGHT, SCREEN_WIDTH, BOTTOM_HEIGHT)];
    [_bottomView setBackgroundColor:[UIColor whiteColor]];
    
    UIButton* preViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [preViewButton setFrame:CGRectMake(10, 7, 70, 31)];
    [preViewButton setTag:10];
    [preViewButton setTitle:@"预览" forState:UIControlStateNormal];
    [preViewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [preViewButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [preViewButton.layer setBorderColor:[UIColor grayColor].CGColor];
    [preViewButton.layer setBorderWidth:1.0f];
    [preViewButton.layer setCornerRadius:3.0f];
    [preViewButton.layer setMasksToBounds:YES];
    [preViewButton addTarget:self action:@selector(preViewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [preViewButton setEnabled:NO];
    [_bottomView addSubview:preViewButton];
    
    UIButton* sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setFrame:CGRectMake(SCREEN_WIDTH - 110, 7, 100, 31)];
    [sendButton setTag:11];
    [sendButton setTitle:@"发送" forState:UIControlStateDisabled];
    [sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [sendButton.layer setBorderColor:[UIColor grayColor].CGColor];
    [sendButton.layer setBorderWidth:1.0f];
    [sendButton.layer setCornerRadius:3.0f];
    [sendButton.layer setMasksToBounds:YES];
    [sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setEnabled:NO];
    [_bottomView addSubview:sendButton];
    
    [self.view addSubview:_bottomView];
}

- (void)refreshSendButton:(NSInteger)selectedCount
{
    UIButton *previewButton = (UIButton*)[self.view viewWithTag:10];
    UIButton *sendButton = (UIButton*)[self.view viewWithTag:11];
    if (selectedCount == 0) {
        [previewButton setEnabled:NO];
        [previewButton.layer setBorderColor:[UIColor grayColor].CGColor];
        [sendButton setEnabled:NO];
        [sendButton.layer setBorderColor:[UIColor grayColor].CGColor];
    }else {
        [previewButton setEnabled:YES];
        [previewButton.layer setBorderColor:[UIColor blueColor].CGColor];
        [sendButton setEnabled:YES];
        [sendButton.layer setBorderColor:[UIColor blueColor].CGColor];
        [sendButton setTitle:[NSString stringWithFormat:@"发送(%ld)", (long)selectedCount] forState:UIControlStateNormal];
    }
}

- (NSMutableArray*)prepareSelectedAsset
{
    __block NSMutableArray* array = [NSMutableArray array];
    [self.elcAssets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ELCAsset *asset = obj;
        if (asset.selected) {
            [array addObject:obj];
            [_selectedIndexArray addObject:@(idx)];
        }
    }];
    return array;
}

- (NSMutableArray*)prepareSelectedImages
{
    __block NSMutableArray* array = [NSMutableArray array];
    [self.elcAssets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ELCAsset *asset = obj;
        if (asset.selected) {
            ALAsset *alasset = [asset asset];
            ALAssetRepresentation* representation = [alasset defaultRepresentation];
            UIImage* image = [UIImage imageWithCGImage:[representation fullResolutionImage] scale:[representation scale] orientation:(UIImageOrientation)[representation orientation]];
            [array addObject:image];
            [_selectedIndexArray addObject:@(idx)];
        }
    }];
    return array;
}

- (void)updateLayout
{
    ELCAssetImageLayout *layout =
    (ELCAssetImageLayout *)self.collectionView.collectionViewLayout;
    layout.columnCount = 4;
    layout.itemWidth = self.collectionView.frame.size.width / 4 - 2;

}

#pragma mark - UICollectionView delegate & datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.elcAssets count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ELCAssetCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    cell.showSelectedImage = !_singleSelection;
    cell.asset = self.elcAssets[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewLayout delegate

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(ELCAssetImageLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (SCREEN_HEIGHT >= 736.0) {
        
        return 105;
    }else if (SCREEN_HEIGHT >= 667.0) {
        
        return 95;
    }else {
        
        return 85;
    }
   
}

#pragma mark - button click event

- (void)preViewButtonClicked:(id)sender
{
    NSMutableArray* array = [self prepareSelectedAsset];
    
    __weak ELCAssetPicker* weakself = self;
    ELCPreviewController* controller = [[ELCPreviewController alloc] initWithImageAsset:array imageCallback:_cropBlock update:^(NSArray *asset) {
        
        [_selectedIndexArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSInteger index = [(NSNumber*)obj integerValue];
            ELCAsset* assetPre = weakself.elcAssets[index];
            ELCAsset* assetModify = asset[idx];
            assetPre.selected = assetModify.selected;
        }];
        [_selectedIndexArray removeAllObjects];
        [_collectionView reloadData];
        [self totalSelectedAssets];
    }];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)sendButtonClicked:(id)sender
{
    if (_cropBlock) {
        NSArray* array = [[NSArray alloc] initWithArray:[self prepareSelectedImages]];
        _cropBlock(array);
    }
}

#pragma mark - elcasset delegate

- (void)assetSelected:(ELCAsset *)asset
{
    if (_singleSelection) {
        
        if (_allowEdit) {
            
            ELCAsset* selectedAsset = asset;
            ELCImageEditorController* editor = [[ELCImageEditorController alloc] initWithImageID:selectedAsset allowEdit:YES cropSzie:CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH)];
            if (_cropBlock) {
                editor.cropBlock = _cropBlock;
            }
            self.navigationController.navigationBarHidden = YES;
            [self.navigationController pushViewController:editor animated:YES];
        }else {
            ALAsset *alasset = [asset asset];
            ALAssetRepresentation* representation = [alasset defaultRepresentation];
            UIImage* image = [UIImage imageWithCGImage:[representation fullResolutionImage] scale:[representation scale] orientation:(UIImageOrientation)[representation orientation]];
            NSArray* array = [[NSArray alloc] initWithObjects:image, nil];
            _cropBlock(array);
        }
    }
}

- (void)showAlert
{
    UIAlertView* alView = [[UIAlertView alloc] initWithTitle:@"最多只能选择8张图片" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alView show];
}

- (void)totalSelectedAssets {
    
    if (_singleSelection) {
        
    }else {
        NSInteger count = 0;
        
        for(ELCAsset *asset in self.elcAssets) {
            if([asset selected]) {
                count++;
            }
        }
        _preCount = count;
        [self refreshSendButton:count];
    }
}
@end
