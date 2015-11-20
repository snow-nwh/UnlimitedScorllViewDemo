//
//  UnlimitedScrollView.h
//  ScorllViewDemo
//
//  Created by snow_nwh on 15/11/9.
//  Copyright © 2015年 DDY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UnlimitedScrollView;
@protocol UnlimitedScrollViewDelegate <NSObject>

- (void)unlimitedScrollView:(UnlimitedScrollView *)unlimitedScrollView
   didSelectItemAtIndexPath:(NSIndexPath *)indexPath
        withItemInformation:(NSArray *)inforArray;

@end

@interface UnlimitedScrollView : UIView <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

//delegate
@property (nonatomic,weak) id<UnlimitedScrollViewDelegate> delegate;
//default image
#warning message - 没有必要重写frame
@property (nonatomic,strong) UIImage *placeHolderImage;
@property (nonatomic,strong) NSArray *imageArray;

- (instancetype)initWithFrame:(CGRect)frame withImageArray:(NSArray *)imageArray;
- (instancetype)initWithFrame:(CGRect)frame withImageArray:(NSArray *)imageArray andPlaceHolderImage:(UIImage *)placeHolderImage;

+ (instancetype)unlimitedScrolllViewWithFrame:(CGRect)frame andImageArray:(NSArray *)imageArray;

@end
