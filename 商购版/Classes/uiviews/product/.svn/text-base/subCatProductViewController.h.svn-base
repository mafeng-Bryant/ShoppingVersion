//
//  subCatProductViewController.h
//  subCatProduct
//
//  Created by lai yun on 12-12-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myWaterFlowViewController.h"
#import "productTableViewController.h"

@interface subCatProductViewController : UIViewController
{
    myWaterFlowViewController *myWaterFlowView;
    productTableViewController *productTableView;
    int showType;
    UIButton *waterFlowButton;
    UIButton *productTableButton;
    NSString *catId;
}

@property(nonatomic,retain) myWaterFlowViewController *myWaterFlowView;
@property(nonatomic,retain) productTableViewController *productTableView;
@property(nonatomic,assign) int showType;
@property(nonatomic,retain) UIButton *waterFlowButton;
@property(nonatomic,retain) UIButton *productTableButton;
@property(nonatomic,retain) NSString *catId;

//动画切换
-(void)showViewWithAnimated;

//商品瀑布流展示
-(void)showWaterFlow;

//商品普通列表展示
-(void)showProductTable;

//显示瀑布流
-(void)showWaterFlowView;

//显示普通列表
-(void)showProductTableView;


@end
