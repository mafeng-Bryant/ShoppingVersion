//
//  ProductDetailViewController.h
//  shopping
//
//  Created by yunlai on 13-1-21.
//
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import "UIColumnView.h"
#import "manageActionSheet.h"
#import "SinaViewController.h"
#import "TencentViewController.h"
#import "MBProgressHUD.h"
#import "LoginViewController.h"
#import "CommandOperation.h"
#import "UIColumnViewCell.h"

@class UpdateAppAlert;


@interface ProductDetailViewController : UIViewController<HPGrowingTextViewDelegate,UIColumnViewDelegate, UIColumnViewDataSource,manageActionSheetDelegate,OauthSinaWeiSuccessDelegate,OauthTencentWeiSuccessDelegate,MBProgressHUDDelegate,LoginViewDelegate,CommandOperationDelegate,UIScrollViewDelegate,ScrollIndexDelegate>{
    HPGrowingTextView *textView;
    UIView *containerView;
    UIColumnView *columnView;
    
    NSDictionary *product;
    NSMutableArray *productList;    //产品详情数据列表
    int productID;  //商品id
    int catID;  //商品所在的分类id，查看下一个产品使用
    
    int selectIndex;    //选择商品的索引
    
    manageActionSheet *shareActionSheet;
    manageActionSheet *wechatActionSheet;
    UpdateAppAlert *weChatAlert;
    
    BOOL isFavorite;
    BOOL isLike;
    NSString *userId;
    MBProgressHUD *progressHUDTmp;
    
    int operateType;
    UIButton *likeBtn;
    UIButton *shoucangBtn;
    
    enum ProductType{
        NormalProduct = 0
    };
    int pType;
    NSString *currentCatId;
    BOOL isLoadingMore;

    NSString *pvType;

    int currentCellIndex;
    int currentCellImageIndex;
    UIColumnViewCell *currentCell;

}

@property (nonatomic,assign) int operateType;
@property (nonatomic,assign) int catID;
@property (nonatomic,assign) int productID;
@property (nonatomic,assign) int selectIndex;
@property (nonatomic,retain) NSMutableArray *productList;
@property (nonatomic,assign) BOOL isFavorite;
@property (nonatomic,assign) BOOL isLike;
@property (nonatomic,assign) int pType;
@property (nonatomic,retain) NSString *userId;
@property (nonatomic,retain) NSString *currentCatId;
@property (nonatomic, retain) NSString *pvType;
@property (nonatomic, retain) NSString *pvType3_Id;

- (void) updateView:(NSArray*)array;
- (void) accessService;
- (void) showCustomToolbar;
- (void) share:(id)sender;
- (void) like:(id)sender;
- (void) shoucang:(id)sender;
- (void) handleToWeChat:(id)sender;
- (void) addButtomBar;
@end
