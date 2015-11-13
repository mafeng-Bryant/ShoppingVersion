//
//  productViewController.h
//  shopping
//
//  Created by lai yun on 12-12-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LightMenuBarDelegate.h"
#import "DataManager.h"
#import "myWaterFlowViewController.h"
#import "productTableViewController.h"

@protocol productViewDelegate
@optional
- (void)productBtnAction:(BOOL)animated;
@end

@interface productViewController : UIViewController<LightMenuBarDelegate,CommandOperationDelegate>
{
    NSObject<productViewDelegate> *delegate;
    LightMenuBar *myMenuBar;
	NSMutableArray *productCatItems;
	UIActivityIndicatorView *spinner;
    myWaterFlowViewController *myWaterFlowView;
    productTableViewController *productTableView;
    int showType;
    UIButton *waterFlowButton;
    UIButton *productTableButton;
    UILabel *titleLabel;
}

@property(nonatomic,retain) NSObject<productViewDelegate> *delegate;
@property(nonatomic,retain) LightMenuBar *myMenuBar;
@property(nonatomic,retain) NSMutableArray *productCatItems;
@property(nonatomic,retain) UIActivityIndicatorView *spinner;
@property(nonatomic,retain) myWaterFlowViewController *myWaterFlowView;
@property(nonatomic,retain) productTableViewController *productTableView;
@property(nonatomic,assign) int showType;
@property(nonatomic,retain) UIButton *waterFlowButton;
@property(nonatomic,retain) UIButton *productTableButton;
@property(nonatomic,retain) UILabel *titleLabel;

//添加滚动分类导航
-(void)addCatNat;

//动画切换
-(void)showViewWithAnimated;

//商品分类按钮
-(void)productCat;

//商品瀑布流展示
-(void)showWaterFlow;

//商品普通列表展示
-(void)showProductTable;

//显示瀑布流
-(void)showWaterFlowView;

//显示普通列表
-(void)showProductTableView;

//向左滚动
-(void)goLeft;

//向右滚动
-(void)goRight;

//网络获取分类数据
-(void)accessCatService;

//更新商品分类的操作
-(void)updateProductCat;

//回归常态
-(void)backNormal;

//网络请求回调函数
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver;


@end
