//
//  UIColumnViewCell.h
//  shopping
//
//  Created by yunlai on 13-1-22.
//
//

#import <UIKit/UIKit.h>
#import "myImageView.h"
#import "IconDownLoader.h"
#import "CommandOperation.h"
#import "TableFooterView.h"
#import "AddOrEditReservationViewController.h"
#import "LoginViewController.h"
#import "PromotionAlertView.h"

@class MBProgressHUD;

@protocol ScrollIndexDelegate <NSObject>

- (void) getScrollIndex:(NSUInteger)index;

@end

@interface UIColumnViewCell : UITableViewCell<UIScrollViewDelegate,myImageViewDelegate,UITableViewDelegate,UITableViewDataSource,IconDownloaderDelegate,CommandOperationDelegate,AddOrEditReservationDelegate,LoginViewDelegate,PromotionAlertViewDelegate> {
    NSArray *productDetailData;
    NSArray *productPicArray;
    NSMutableArray *commentArray;
    UIView *headerView;
    UIScrollView *imageScrollView;
    UIImage *docImage;
    UITableView *commentTableView;
    UIPageControl *pageControl;
    
    NSMutableDictionary *imageDownloadsInProgress;
    NSMutableArray *imageDownloadsInWaiting;
    UINavigationController *myNavigationController;
    
    BOOL isLoadingMore;
    BOOL canLoadMore;
    
    TableFooterView *footerView;
    
    MBProgressHUD *progressHUD;
    id<ScrollIndexDelegate> delegate;
    int ccindex;
    double totalMoney;
    double promotionMoney;
    int fullSendID;
    
    UIButton *easyBuy;
    UIButton *buyButton;
}

@property (nonatomic,retain) NSArray *productDetailData;
@property (nonatomic,retain) NSArray *productPicArray;
@property (nonatomic,retain) NSMutableArray *commentArray;
@property (nonatomic,retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic,retain) NSMutableArray *imageDownloadsInWaiting;
@property (nonatomic,retain) UINavigationController *myNavigationController;
@property (nonatomic,retain) UIPageControl *pageControl;
@property (nonatomic,retain) UITableView *commentTableView;

@property (nonatomic,assign) BOOL isLoadingMore;
@property (nonatomic,assign) BOOL canLoadMore;
@property (nonatomic,assign) id<ScrollIndexDelegate> delegate;

- (void) addComponent;
- (void) accessService;
- (void) addCommentTableview;
@end
