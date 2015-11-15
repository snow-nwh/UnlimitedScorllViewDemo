//
//  ViewController.m
//  ScorllViewDemo
//
//  Created by snow_nwh on 15/11/9.
//  Copyright © 2015年 DDY. All rights reserved.
//

#import "ViewController.h"
#import "UnlimitedScrollView.h"

@interface ViewController () <UnlimitedScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self configUI];
}
- (void)configUI
{
    CGFloat viewHeight = self.view.frame.size.height;
    CGFloat viewWidth = self.view.frame.size.width;
    
    NSArray *array = @[@"1",@"2",@"3"];
    
    UnlimitedScrollView *scrollView = [[UnlimitedScrollView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight/3) withImageArray:array andPlaceHolderImage:nil];
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
}
#pragma mark <UnlimitedScrollViewDelegate>
- (void)unlimitedScrollView:(UnlimitedScrollView *)unlimitedScrollView didSelectItemAtIndexPath:(NSIndexPath *)indexPath withItemInformation:(NSArray *)inforArray
{
    NSLog(@"response1");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
