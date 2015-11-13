//
//  historyViewController.h
//  history
//
//  Created by siphp on 13-01-05.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconDownLoader.h"
#import "CustomSegment.h"
typedef enum
{
    ViewTypeProduct,
    ViewTypeNew
}ViewType;

@interface historyViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,IconDownloaderDelegate,CustomSegmentDelegate>
{
    UITableView *myTableView;
	NSMutableArray *productItems;
    NSMutableDictionary *imageDownloadsInProgress;
	NSMutableArray *imageDownloadsInWaiting;
    CGFloat picWidth;
    CGFloat picHeight;
    
    CGFloat imgWidth;
    CGFloat imgHeight;
    CustomSegment *segmentView;
    ViewType __viewType;
}

@property(nonatomic,retain) UITableView *myTableView;
@property(nonatomic,retain) NSMutableArray *productItems;
@property(nonatomic,retain) NSMutableArray *imageDownloadsInWaiting;
@property(nonatomic,retain) NSMutableDictionary *imageDownloadsInProgress;

//添加数据表视图
-(void)addTableView;

//滚动loading图片
- (void)loadImagesForOnscreenRows;

//保存缓存图片
-(bool)savePhoto:(UIImage*)photo atIndexPath:(NSIndexPath*)indexPath;

//获取网络图片
- (void)startIconDownload:(NSString*)photoURL forIndexPath:(NSIndexPath*)indexPath;

//回调 获到网络图片后的回调函数
- (void)appImageDidLoad:(NSIndexPath *)indexPath withImageType:(int)Type;


@end

