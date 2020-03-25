//
//  ViewController.m
//  SelectPhoto
//
//  Created by 方存 on 2020/3/25.
//  Copyright © 2020 JKB. All rights reserved.
//

#import "ViewController.h"
#import <TZImagePickerController.h>
#import "CollectionViewCell.h"

#define k_width [UIScreen mainScreen].bounds.size.width
#define k_height [UIScreen mainScreen].bounds.size.height
static CGFloat item_wh = 0.f;
static CGFloat spacing = 4.f;
@interface ViewController ()<TZImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, assign) BOOL isSelectOriginalPhoto;
@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) NSMutableArray *photosArr;
@property (nonatomic ,strong) NSMutableArray *assestArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - 私有方法
- (void)setupUI
{
    self.title = @"选择图片";
    self.view.backgroundColor = [UIColor whiteColor];
    [self collectionView];
}

#pragma mark - 事件响应
/** 点击加号,添加照片 */
- (void)addPhoto
{
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:6 delegate:self];
    [imagePicker setSortAscendingByModificationDate:NO];
    imagePicker.isSelectOriginalPhoto = self.isSelectOriginalPhoto;
    imagePicker.selectedAssets = self.assestArr;
    imagePicker.allowPickingVideo = NO;
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

/** 删除照片 */
- (void)removePhotos:(UIButton *)but
{
    __weak typeof(self) weakSelf = self;
    [self.photosArr removeObjectAtIndex:but.tag - 10];
    [self.assestArr removeObjectAtIndex:but.tag - 10];
    [self.collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:but.tag-10 inSection:0];
        [weakSelf.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [weakSelf.collectionView reloadData];
    }];
}

#pragma mark - ImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    self.photosArr = [NSMutableArray arrayWithArray:photos];
    self.assestArr = [NSMutableArray arrayWithArray:assets];
    self.isSelectOriginalPhoto = isSelectOriginalPhoto;
    [self.collectionView reloadData];
}

#pragma mark - CollectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row == self.photosArr.count) {
        cell.imgView.image = [UIImage imageNamed:@"add"];
        cell.deleteBut.hidden = YES;
    }else{
        cell.imgView.image = self.photosArr[indexPath.row];
        cell.deleteBut.hidden = NO;
    }
    cell.deleteBut.tag = 10 + indexPath.row;
    [cell.deleteBut addTarget:self action:@selector(removePhotos:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.photosArr.count) {
        // 点击加号
        [self addPhoto];
        
    }else{
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_assestArr selectedPhotos:_photosArr index:indexPath.row];
        imagePickerVc.isSelectOriginalPhoto = self.isSelectOriginalPhoto;
        __weak typeof(self) weakSelf = self;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            weakSelf.photosArr = [NSMutableArray arrayWithArray:photos];
            weakSelf.assestArr = [NSMutableArray arrayWithArray:assets];
            weakSelf.isSelectOriginalPhoto = isSelectOriginalPhoto;
            [weakSelf.collectionView reloadData];
            weakSelf.collectionView.contentSize = CGSizeMake(0, ((weakSelf.photosArr.count + 2) / 3 ) * (spacing + item_wh));
        }];
        imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photosArr.count + 1;
}

#pragma mark - lazy
- (NSMutableArray *)photosArr{
    if (!_photosArr) {
        self.photosArr = [NSMutableArray array];
    }
    return _photosArr;
}

- (NSMutableArray *)assestArr{
    if (!_assestArr) {
        self.assestArr = [NSMutableArray array];
    }
    return _assestArr;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        item_wh = (k_width - 2*spacing - 4) / 3 - spacing;
        UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
        flowLayOut.itemSize = CGSizeMake((k_width - 50)/ 4, (k_width - 50)/ 4);
        flowLayOut.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 150, k_width, 400) collectionViewLayout:flowLayOut];
        [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.collectionView];
    }
    return _collectionView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
