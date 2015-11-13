//
//  scanHistoryViewController.h
//  scanHistory
//
//  Created by siphp on 13-01-05.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface scanHistoryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *myTableView;
	NSMutableArray *historyItems;
	UIActivityIndicatorView *spinner;
}

@property(nonatomic,retain) UITableView *myTableView;
@property(nonatomic,retain) NSMutableArray *historyItems;
@property(nonatomic,retain) UIActivityIndicatorView *spinner;

//添加数据表视图
-(void)addTableView;

//回归常态
-(void)backNormal;

@end

