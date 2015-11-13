//
//  newsCommentViewController.h
//  newsCommentView
//
//  Created by siphp on 13-01-05.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "IconDownLoader.h"
#import "DataManager.h"
#import "HPGrowingTextView.h"
#import "MBProgressHUD.h"
#import "LoginViewController.h"

enum news_comment {
	news_comment_user_name,
	news_comment_content,
	news_comment_created,
    news_comment_head_img
};

@interface newsCommentViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate,CommandOperationDelegate,IconDownloaderDelegate,HPGrowingTextViewDelegate,MBProgressHUDDelegate,LoginViewDelegate>
{
    UITableView *myTableView;
    int newsId;
    NSString *infoTitle;
	NSMutableArray *commentItems;
	UIActivityIndicatorView *spinner;
    UILabel *moreLabel;
    EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
    BOOL _loadingMore;
    BOOL _isAllowLoadingMore;
    NSMutableDictionary *imageDownloadsInProgress;
	NSMutableArray *imageDownloadsInWaiting;
    CGFloat picWidth;
    CGFloat picHeight;
    UIView *containerView;
    HPGrowingTextView *textView;
    MBProgressHUD *progressHUD;
    NSString *tempTextContent;
    NSString *userId;
}

@property(nonatomic,retain) UITableView *myTableView;
@property (nonatomic, assign) int newsId;
@property(nonatomic,retain) NSString *infoTitle;
@property(nonatomic,retain) NSMutableArray *commentItems;
@property(nonatomic,retain) UIActivityIndicatorView *spinner;
@property(nonatomic,retain) UILabel *moreLabel;
@property (nonatomic, assign) BOOL _reloading;
@property (nonatomic, assign) BOOL _loadingMore;
@property(nonatomic,retain) NSMutableArray *imageDownloadsInWaiting;
@property(nonatomic,retain) NSMutableDictionary *imageDownloadsInProgress;
@property(nonatomic,retain) UIView *containerView;
@property(nonatomic,retain) HPGrowingTextView *textView;
@property(nonatomic,retain) MBProgressHUD *progressHUD;
@property(nonatomic,retain) NSString *tempTextContent;
@property(nonatomic,retain) NSString *userId;

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

//更新记录
-(void)update;

//更多的操作
-(void)appendTableWith:(NSMutableArray *)data;

//网络获取数据
-(void)accessItemService;

//网络获取更多数据
-(void)accessMoreService;

//回归常态
-(void)backNormal;

//更多回归常态
-(void)moreBackNormal;

//网络请求回调函数
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver;

@end

