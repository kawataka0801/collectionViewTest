//
//  ViewController.m
//  CollectionViewTest
//
//  Created by Takashi Kawakami on 2016/02/07.
//  Copyright © 2016年 Takashi Kawakami. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"
#import "HeaderReusableView.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "ProfileView.h"
#import "ChannelViewController.h"
#import "MylistViewController.h"

@interface ViewController ()
<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,
CHTCollectionViewDelegateWaterfallLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet ProfileView *profileView;
@property (weak, nonatomic) IBOutlet UIView *headerActionView;

@property (nonatomic)  BOOL isStatusBarHidden;
@property (nonatomic)  BOOL isProccessing;

@property CGFloat preScrollPointY;
@property CGFloat screenHeight;
@property CGFloat headerActionViewOriginalY;
@property int navigationBarHeight;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _screenHeight              = [UIScreen mainScreen].bounds.size.height;
    _navigationBarHeight       = 64;
    _headerActionViewOriginalY = CGRectGetMinY(self.headerActionView.frame);
    
    [self.collectionView registerClass:[HeaderReusableView class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                   withReuseIdentifier:@"HeaderReusableView"];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 10;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    
    //セル側に構造体をまとめて渡してセットするメソッドを用意しますー
    cell.userNameLabel.text = [NSString stringWithFormat:@"%ld番目っす", indexPath.row];
    cell.likeCountLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    
    return cell;
}

#pragma mark ヘッダ

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section
{
    //とりあえずアテ
    return 220;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    /* 
     なぜかこのlibを使うとStoryboardのIdetifierから読み込めないし、Subviewが消える。
     libraryのバグか??後でコードを見てみる
     とりあえずregisterClassで一旦回避
     SegmentControl等のsubViewが消えるから必要とあらばここらで載せる
     */
    
    HeaderReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderReusableView" forIndexPath:indexPath];
    
    //セグメントコントロール
    /*
     UISegmentedControl *segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"最新", @"更新"]];
     segmentControl.frame = CGRectMake(75, 10, 180, 29);
     [segmentControl addTarget:self action:@selector(segmentedControlTapped:) forControlEvents:UIControlEventValueChanged];
     segmentControl.backgroundColor = [UIColor yellowColor];
     
     [header addSubview:segmentControl];
     */
    
    return header;
}

#pragma mark segmentControl

typedef NS_ENUM(NSUInteger, SelectedType) {
    SelectedTypeNewest = 0,
    SelectedTypePopular,
};

- (void)segmentedControlTapped:(UISegmentedControl *)segmentControl {
    
    switch (segmentControl.selectedSegmentIndex) {
        case SelectedTypeNewest:
            break;
            
        case SelectedTypePopular:
            break;
            
        default:
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

{
//    このタイミングではdeuque出来ない模様。CollectionViewDelegateのサイクルタイムを確認
//    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    
    CGSize size = CGSizeMake(145, 310);
    if (indexPath.row % 2 == 0) {
        int add = (int)indexPath.row * 50;
        size.height += add;
    }
    return size;
}

//レイアウトを上書きした時はこっちも書かないとダメな模様
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollViewDidScroll:) object:nil];
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY >= (scrollView.contentSize.height - self.screenHeight) ) {
        return;
    }
    if (self.isProccessing) {
        return;
    }
    
    [self scrollProfileViewWithOffset:offsetY];
    
    [self scrollActionViewForHeaderWithOffset:offsetY];
    
    [self showOrHideNavigationBarWithOffset:offsetY];
}

#pragma mark プロフィール部分

- (void)scrollProfileViewWithOffset:(CGFloat)offsetY
{
    CGRect rect = self.profileView.frame;
    
    self.profileView.frame = CGRectMake(rect.origin.x,
                                        -offsetY,
                                        rect.size.width,
                                        rect.size.height);   
}

#pragma mark ボタンが並んでいる部分

- (void)scrollActionViewForHeaderWithOffset:(CGFloat)offsetY
{
    int actionViewHeight    = 30;
    
    if (self.headerActionView.frame.origin.y - (self.navigationBarHeight + actionViewHeight) <= offsetY) {
        [self scrollHeaderActionView:offsetY + self.navigationBarHeight];
    }else{
        [self scrollHeaderActionView:self.navigationBarHeight];
    }
    
    if (self.headerActionViewOriginalY - (self.navigationBarHeight + actionViewHeight) >= offsetY) {
        [self scrollHeaderActionView:self.headerActionViewOriginalY];
    }
}

- (void)scrollHeaderActionView:(CGFloat)y
{
    [self.headerActionView.layer removeAllAnimations];
    
    CGRect rect = self.headerActionView.frame;
    rect.origin.y = y;
    self.headerActionView.frame = rect;
}

#pragma mark statusbarとnavigationbar

- (void)showOrHideNavigationBarWithOffset:(CGFloat)offsetY
{
     CGFloat scrollGap = offsetY - self.preScrollPointY;
    
    if (offsetY <= 0) {
        return;
    }
    
    if (scrollGap > 0) {
        [self changeStatusAndNavigationHidden:YES];
        _navigationBarHeight = 0;
    }else{
        [self changeStatusAndNavigationHidden:NO];
        _navigationBarHeight = 64;
    }
    
    _preScrollPointY = offsetY;   
}

- (void)changeStatusAndNavigationHidden:(BOOL)boolean
{
    if (self.navigationController.navigationBarHidden == boolean) {
        return;
    }
    
    _isProccessing = YES;
    
    //引っ込めるときはviewをxxにする
    [UIView animateWithDuration:0.25f animations:^{
        self.navigationController.navigationBarHidden = boolean;
        self.isStatusBarHidden = boolean;
        [self setNeedsStatusBarAppearanceUpdate];
        _isProccessing = NO;
        //navigationbarが引っ込んだ44をなんとかする
    }];
}

- (BOOL)prefersStatusBarHidden
{
    return self.isStatusBarHidden;
}


@end


