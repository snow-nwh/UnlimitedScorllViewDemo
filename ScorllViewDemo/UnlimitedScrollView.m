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
    
    NSArray *_imageArray;
}

//- (void)setFrame:(CGRect)frame
//{
//    _frame = frame;
//}

- (instancetype)initWithFrame:(CGRect)frame withImageArray:(NSArray *)imageArray andPlaceHolderImage:(UIImage *)placeHolderImage
{
    self = [super init];
    if (self) {
        self.frame = frame;
        _imageArray = imageArray;
        [self configUIWithFrame:frame];
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
    _pageControl.numberOfPages = _imageArray.count;
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
    if (_collectionview.contentOffset.x == self.frame.size.width * (_imageArray.count + 1))
    {
        CGPoint contentOffSet = CGPointZero;
        contentOffSet.x += self.frame.size.width;
        _collectionview.contentOffset = contentOffSet;
    }
    //第一张时，将偏移量调整为 倒数第二张的偏移量
    if (_collectionview.contentOffset.x == 0)
    {
        CGPoint contentOffSet = CGPointZero;
        contentOffSet.x += self.frame.size.width * (_imageArray.count);
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
    _pageControl.numberOfPages = _imageArray.count;
    if (_imageArray.count)
    {
        if (_imageArray.count == 1)
        {
            return 1;
        }
        else if (_imageArray.count > 1)
        {
            //
            collectionView.contentOffset = CGPointMake(collectionView.frame.size.width, 0);
            return _imageArray.count + 2;
        }
    }
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0 || indexPath.item == _imageArray.count ) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.frame];
        cell.backgroundColor = [UIColor cyanColor];
        [cell.contentView addSubview:imageView];
        return cell;
    }
    if (indexPath.item == _imageArray.count + 1|| indexPath.item == 1) {
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

#pragma mark <UICollectionViewDelegateFlowLayout>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"clicked :%@",indexPath);
    NSArray *array = _imageArray[indexPath.item - 1];
//    if ([self.delegate performSelector:@selector(unlimitedScrollViewDidSelectItemAtIndexPath:withItemInformation:)])
    [self.delegate unlimitedScrollView:self
              didSelectItemAtIndexPath:indexPath
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
