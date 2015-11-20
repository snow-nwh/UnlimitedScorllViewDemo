//
//  UnlimitedScrollView.m
//  ScorllViewDemo
//
//  Created by snow_nwh on 15/11/9.
//  Copyright © 2015年 DDY. All rights reserved.
//

#import "UnlimitedScrollView.h"

static NSString * const reuseIdentifier = @"Cell";

@implementation UnlimitedScrollView
{
    UICollectionView *_collectionview;
    UIPageControl *_pageControl;
    NSTimer *_timer;
    
    NSArray *_dateArray;
}
#pragma mark - 类方法
+ (instancetype)unlimitedScrolllViewWithFrame:(CGRect)frame andImageArray:(NSArray *)imageArray
{
    UnlimitedScrollView *unlimitedScrollView;
    if (!unlimitedScrollView) {
        unlimitedScrollView = [[UnlimitedScrollView alloc]initWithFrame:frame withImageArray:imageArray];
    }
    return unlimitedScrollView;
}
#pragma mark - set方法
//-(void)setFrame:(CGRect)frame
//{
//    _frame = frame;
//    [self configUIWithFrame:frame];
//}
- (void)setImageArray:(NSArray *)imageArray
{
    _imageArray = imageArray;
    _dateArray = imageArray;
    [self configUIWithFrame:self.frame];
//    [_collectionview reloadData];
}
- (void)setPlaceHolderImage:(UIImage *)placeHolderImage
{
    _placeHolderImage = placeHolderImage;
    //xxx
}
#pragma mark - 减方法初始化
//-(instancetype)init
//{
//    if (self = [super init]) {
//        [self configUIWithFrame:CGRectZero];
//    }
//    return self;
//}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUIWithFrame:frame];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame withImageArray:(NSArray *)imageArray
{
    self = [super initWithFrame:frame];
    if (self) {
        _dateArray = imageArray;
        _imageArray = imageArray;
        [self configUIWithFrame:frame];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame withImageArray:(NSArray *)imageArray andPlaceHolderImage:(UIImage *)placeHolderImage
{
    self = [self initWithFrame:frame withImageArray:imageArray];
    if (self) {
        _placeHolderImage = placeHolderImage;
    }
    return self;
}

- (void)configUIWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionview = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:layout];
    _collectionview.pagingEnabled = YES;
    _collectionview.showsVerticalScrollIndicator = NO;
    _collectionview.showsHorizontalScrollIndicator = NO;
    _collectionview.bounces = NO;
    _collectionview.delegate = self;
    _collectionview.dataSource = self;
    [_collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    _collectionview.backgroundColor = [UIColor whiteColor];
    [self addSubview:_collectionview];
    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(frame.size.width/4, frame.size.height-10, frame.size.width/2, 5)];
    _pageControl.hidesForSinglePage = YES;
    _pageControl.numberOfPages = _dateArray.count;
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [self addSubview:_pageControl];
    
    if (!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(scrollTheCollectionView) userInfo:nil repeats:YES];
        [_timer setFireDate:[NSDate distantPast]];
    }

}

//定时器实现自动滚动
- (void)scrollTheCollectionView
{
    CGPoint contentOffSet = _collectionview.contentOffset;
    contentOffSet.x += self.frame.size.width;
    [_collectionview setContentOffset:contentOffSet animated:YES];
}

#pragma mark <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //滚动到最后一张时，将偏移量调整为 第二张的偏移量
    if (_collectionview.contentOffset.x == self.frame.size.width * (_dateArray.count + 1))
    {
        CGPoint contentOffSet = CGPointZero;
        contentOffSet.x += self.frame.size.width;
        _collectionview.contentOffset = contentOffSet;
    }
    //第一张时，将偏移量调整为 倒数第二张的偏移量
    if (_collectionview.contentOffset.x == 0)
    {
        CGPoint contentOffSet = CGPointZero;
        contentOffSet.x += self.frame.size.width * (_dateArray.count);
        _collectionview.contentOffset = contentOffSet;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentPage = scrollView.contentOffset.x/scrollView.frame.size.width;
    _pageControl.currentPage = currentPage - 1;
}
/**
 called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
 只响应 (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;这个方法
 **/
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSInteger currentPage = scrollView.contentOffset.x/scrollView.frame.size.width;
    _pageControl.currentPage = currentPage - 1;
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    _pageControl.numberOfPages = _dateArray.count;
    if (_dateArray.count)
    {
        if (_dateArray.count == 1)
        {
            if (_timer) {
                [_timer invalidate];
            }
            return 1;
        }
        else if (_dateArray.count > 1)
        {
            //
            collectionView.contentOffset = CGPointMake(collectionView.frame.size.width, 0);
            return _dateArray.count + 2;
        }
    }
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0 || indexPath.item == _dateArray.count ) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.frame];
        cell.backgroundColor = [UIColor cyanColor];
        [cell.contentView addSubview:imageView];
        return cell;
    }
    if (indexPath.item == _dateArray.count + 1|| indexPath.item == 1) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.frame];
        cell.backgroundColor = [UIColor yellowColor];
        [cell.contentView addSubview:imageView];
        return cell;
    }
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.frame];
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%10*0.1f green:arc4random()%10*0.1f blue:arc4random()%10*0.1f alpha:1];
    [cell.contentView addSubview:imageView];
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = nil;
    NSIndexPath *newIndexPath;
    if (_dateArray.count == 1)
    {
        array = _dateArray[0];
        newIndexPath = [NSIndexPath indexPathForItem:indexPath.item  inSection:0];
    }
    else
    {
        array = _dateArray[indexPath.item - 1];
        newIndexPath = [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:0];
    }
    
    if ([self.delegate respondsToSelector:@selector(unlimitedScrollView:didSelectItemAtIndexPath:withItemInformation:)])
    [self.delegate unlimitedScrollView:self
              didSelectItemAtIndexPath:newIndexPath
                   withItemInformation:array
     ];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frame.size;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
