//
//  MyFavoriteViewController.h
//  shopping
//
//  Created by 来 云 on 13-1-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CommandOperation.h"
#import "IconDownLoader.h"

enum my_likes {
    my_likes_status,
    my_likes_created,
	my_likes_product_id,
	my_likes_catid,
	my_likes_title,
	my_likes_content,
	my_likes_promotion_price,
	my_likes_price,
	my_likes_likes,
	my_likes_favorites,
	my_likes_unit,
	my_likes_salenum,
	my_likes_comment_num,
	my_likes_sort_order,
	my_likes_is_big_pic,
	my_likes_pic,
    my_likes_pics
};

@interface MyFavoriteViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,CommandOperationDelegate,IconDownloaderDelegate,MBProgressHUDDelegate>
{
    UITableView *_myTableView;
    NSMutableArray *__listArray;
    UIActivityIndicatorView *indicatorView;
    UIActivityIndicatorView *spinner;
    MBProgressHUD *progressHUD;
    
    NSMutableDictionary *imageDownloadsInProgressDic;
	NSMutableArray *imageDownloadsInWaitingArray;
    CGFloat picWidth;
    CGFloat picHeight;
    
    NSNumber *_infoId;
    int rowValue;
    
    BOOL _isAllowLoadingMore;
    BOOL _loadingMore;
}
@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) NSMutableArray *listArray;
@property(nonatomic,retain) CommandOperation *commandOper;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgressDic;
@property (nonatomic, retain) NSMutableArray *imageDownloadsInWaitingArray;
@property(nonatomic,retain) UIActivityIndicatorView *spinner;
@property (nonatomic, retain) NSString *userId;
@end
