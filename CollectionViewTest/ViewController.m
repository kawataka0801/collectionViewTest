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
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView2;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView3;


@property (weak, nonatomic) IBOutlet ProfileView *profileView;
@property (weak, nonatomic) IBOutlet UIView *headerActionView;

@property (nonatomic)  BOOL isStatusBarHidden;
@property (nonatomic)  BOOL isProccessing;

@property CGFloat preScrollPointY;
@property CGFloat screenHeight;
@property CGFloat headerActionViewOriginalY;
@property int navigationBarHeight;

@property int currentIndex;
@property (weak, nonatomic) IBOutlet UIButton *standUserButton;

@end

@implementation ViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _screenHeight        = [UIScreen mainScreen].bounds.size.height;
        _navigationBarHeight = 64;
        _currentIndex        = 0;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _headerActionViewOriginalY = CGRectGetMinY(self.headerActionView.frame);
    
    [self registerHeaderView];
    
    [self addLeftSwipeGesture];
    [self addRightSwipeGesture];
}

- (void)registerHeaderView
{
    NSString *identifier = @"HeaderReusableView";
    Class headerClass = [HeaderReusableView class];
    
    [self.collectionView registerClass:headerClass
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                   withReuseIdentifier:identifier];
    
    [self.collectionView2 registerClass:headerClass
             forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                    withReuseIdentifier:identifier];
    
    [self.collectionView3 registerClass:headerClass
             forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                    withReuseIdentifier:identifier];
}

#pragma mark swipe

- (void)addLeftSwipeGesture {
   
    //左スワイプ
    UISwipeGestureRecognizer *swipeLeftGesture = [[UISwipeGestureRecognizer alloc]
                                                  initWithTarget:self
                                                  action:@selector(swipeLeft:)];
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.collectionView addGestureRecognizer:swipeLeftGesture];
    [self.collectionView.panGestureRecognizer requireGestureRecognizerToFail:swipeLeftGesture];
    
     UISwipeGestureRecognizer *swipeLeftGesture2 = [[UISwipeGestureRecognizer alloc]
                                                  initWithTarget:self
                                                  action:@selector(swipeLeft:)];
    swipeLeftGesture2.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.collectionView2 addGestureRecognizer:swipeLeftGesture2];
    [self.collectionView2.panGestureRecognizer requireGestureRecognizerToFail:swipeLeftGesture2];
    
    
    UISwipeGestureRecognizer *swipeLeftGesture3 = [[UISwipeGestureRecognizer alloc]
                                                   initWithTarget:self
                                                   action:@selector(swipeLeft:)];
    swipeLeftGesture3.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.collectionView3 addGestureRecognizer:swipeLeftGesture3];
    [self.collectionView3.panGestureRecognizer requireGestureRecognizerToFail:swipeLeftGesture3];

}

- (void)addRightSwipeGesture {
    
    //右スワイプ
    UISwipeGestureRecognizer *swipeRightGesture = [[UISwipeGestureRecognizer alloc]
                                                   initWithTarget:self
                                                   action:@selector(swipeRight:)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.collectionView addGestureRecognizer:swipeRightGesture];
    [self.collectionView.panGestureRecognizer requireGestureRecognizerToFail:swipeRightGesture];
    
    
    UISwipeGestureRecognizer *swipeRightGesture2 = [[UISwipeGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(swipeRight:)];
    swipeRightGesture2.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.collectionView2 addGestureRecognizer:swipeRightGesture2];
    [self.collectionView2.panGestureRecognizer requireGestureRecognizerToFail:swipeRightGesture2];
    
    
    UISwipeGestureRecognizer *swipeRightGesture3 = [[UISwipeGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(swipeRight:)];
    swipeRightGesture3.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.collectionView3 addGestureRecognizer:swipeRightGesture3];
    [self.collectionView3.panGestureRecognizer requireGestureRecognizerToFail:swipeRightGesture3];   
}

typedef NS_ENUM(NSUInteger, CollectionViewType) {
    CollectionViewTypeStand = 0,
    CollectionViewTypeKamehameha ,
    CollectionViewTypePiccoro,
};

- (void)swipeLeft:(UISwipeGestureRecognizer *)sender
{
    [self changeViewWithIndex:-1];
}

- (void)swipeRight:(UISwipeGestureRecognizer *)sender
{
    [self changeViewWithIndex:1];
}

- (void)changeViewWithIndex:(int)index
{
    self.currentIndex += index;
    
    switch (self.currentIndex) {
        case CollectionViewTypeStand:
            [self tapStandUser:nil];
            break;
            
        case CollectionViewTypeKamehameha:
            [self tapKamehameha:nil];
            break;
            
        case CollectionViewTypePiccoro:
            [self tapPiccoro:nil];
            break;
            
        default:
            self.currentIndex -= index;
            NSLog(@"インデックス %d, ここで振動のアニメーション入れます", self.currentIndex);
            break;
    }
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 10;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionViewCell *cell;
   
    if([collectionView isEqual:self.collectionView]){
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
        cell.userNameLabel.text = [NSString stringWithFormat:@"%ld番目っす", indexPath.row];
        cell.likeCountLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
 
    }else if ([collectionView isEqual:self.collectionView2]){
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell2" forIndexPath:indexPath];
        cell.userNameLabel.text = [NSString stringWithFormat:@"%ldゴルァ", indexPath.row];
        
    }else{
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell3" forIndexPath:indexPath];
        cell.userNameLabel.text = [NSString stringWithFormat:@"%ldブルぁ", indexPath.row];
        
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

{
//    このタイミングではdeuque出来ない模様。CollectionViewDelegateのサイクルタイムを確認
//    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    
    //FlowLayoutで横のアイテム数が決まっている。
    //ちゃんとやるときはTableViewのように横には1セルしか出ないFlowlayoutクラスを用意して対応する
    
    CGSize size;
    
    if([collectionView isEqual:self.collectionView]){
        size = CGSizeMake(145, 310);
        if (indexPath.row % 2 == 0) {
            int add = (int)indexPath.row * 50;
            size.height += add;
        }
    }else if ([collectionView isEqual:self.collectionView2]){
        size = CGSizeMake(300, 44);
    }else{
        size = CGSizeMake(300, 100);
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
#pragma mark ヘッダ

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section
{
    //とりあえずアテ
    return 230;
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
    
//    NSLog(@"ヘッダー %@", header);
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

#pragma mark ボタン

- (IBAction)tapStandUser:(id)sender {
    
    self.currentIndex = CollectionViewTypeStand;
    
    [self.view addSubview:self.collectionView2];
    [self.view addSubview:self.profileView];
    
    //profileの位置、collectionViewの位置、navigationを戻す
    [self showStatusBarAndNavigationBar];
    
    [self scrollProfileViewWithOffset:-64];
    
    [self setupOffSet:self.collectionView2];
    
    [self.collectionView2.collectionViewLayout invalidateLayout];
    [self.collectionView2 reloadData];

}

- (IBAction)tapKamehameha:(id)sender {
    
    self.currentIndex = CollectionViewTypeKamehameha;
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.profileView];
    
    [self showStatusBarAndNavigationBar];
    [self scrollProfileViewWithOffset:-64];
    [self setupOffSet:self.collectionView];
    
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView reloadData];
}

- (IBAction)tapPiccoro:(id)sender {
    
    self.currentIndex = CollectionViewTypePiccoro;
    
    [self.view addSubview:self.collectionView3];
    [self.view addSubview:self.profileView];
    
    [self showStatusBarAndNavigationBar];
    [self scrollProfileViewWithOffset:-64];
    [self setupOffSet:self.collectionView3];
    
    [self.collectionView3.collectionViewLayout invalidateLayout];
    [self.collectionView3 reloadData];
}

- (void)showStatusBarAndNavigationBar
{
    self.isStatusBarHidden = NO;
    [self setNeedsStatusBarAppearanceUpdate];
    self.navigationController.navigationBarHidden = NO;
}

- (void)setupOffSet:(UICollectionView *)collectionView
{
    int topOffset = 64;
    collectionView.contentInset = UIEdgeInsetsMake(topOffset, 0, 0, 0);
    collectionView.contentOffset = CGPointMake(0, -topOffset);
}

@end
