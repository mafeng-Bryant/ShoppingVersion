//
//  MyProductsViewController.h
//  shopping
//
//  Created by 来 云 on 13-1-9.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CommandOperation.h"
#import "IconDownLoader.h"
@class MyCollectionViewController;

enum favorite_products {
    favorite_products_status,
    favorite_products_created,
	favorite_products_product_id,
	favorite_products_catid,
	favorite_products_title,
	favorite_products_content,
	favorite_products_promotion_price,
	favorite_products_price,
	favorite_products_likes,
	favorite_products_favorites,
	favorite_products_unit,
	favorite_products_salenum,
	favorite_products_comment_num,
	favorite_products_sort_order,
	favorite_products_is_big_pic,
	favorite_products_pic,
    favorite_products_pics
};


@interface MyProductsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,CommandOperationDelegate,MBProgressHUDDelegate,IconDownloaderDelegate>
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
    
    UILabel *noLabel;
}
@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) NSMutableArray *listArray;
@property(nonatomic,retain) CommandOperation *commandOper;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgressDic;
@property (nonatomic, retain) NSMutableArray *imageDownloadsInWaitingArray;
@property(nonatomic,retain) UIActivityIndicatorView *spinner;
@property (nonatomic, retain) MyCollectionViewController *collectView;

- (void)addView;
- (void)startIconDownload:(NSString*)imageURL forIndex:(NSIndexPath*)index;
@end
