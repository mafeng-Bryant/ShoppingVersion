//
//  SubmitOrderViewController.h
//  shopping
//
//  Created by yunlai on 13-1-29.
//
//

#import <UIKit/UIKit.h>
#import "CommandOperation.h"
#import "MBProgressHUD.h"
#import "MyDiscountViewController.h"
#import "PromotionAlertView.h"
#import "MyAddressViewController.h"

@class ReservationInfo;


@interface SubmitOrderViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,CommandOperationDelegate,MBProgressHUDDelegate,getPromotionDetailDelegate,PromotionAlertViewDelegate,GetMyAddressDelegate>{
    NSArray *sectionTitleArray;
    NSArray *buyAndSendArray;
    NSArray *invoiceArray;
    NSArray *delivepArray;
    UITableView *orderTableView;
    NSMutableDictionary *dict;
    NSArray *bookInfoArray;
    ReservationInfo *info;
    NSArray *shopArray;
    UIImageView *toolBarImageView;
    
    double totalMoney;
    NSString *totalPrice;
    NSString *savePrice;
    UITextField *textField;
    
    MBProgressHUD *progressHUD;
    int payType;
    int payMent;
    double promotionMoney;
    int invoiceType;
    int invoiceTitle;
    
    NSArray *promotionDataArray;   //优惠券金额
    int _sendId;
    int time;
    int isSure;
    UILabel *deliveryPriceLabel;
    BOOL isEasyBuy;
    int fullSendID;
    double preDeliveryFare;//保存上一次运费
}

- (void) update:(NSMutableArray*)array;

@property (nonatomic,retain) NSArray *bookInfoArray;
@property (nonatomic,retain) ReservationInfo *info;
@property (nonatomic,retain) NSArray *shopArray;
@property (nonatomic,retain) NSString *totalPrice;
@property (nonatomic,retain) NSString *savePrice;
@property (nonatomic,retain) NSArray *promotionDataArray;
@property (nonatomic,retain) NSArray *delivepArray;
@property (nonatomic,assign) double totalMoney;
@property (nonatomic,assign) BOOL isEasyBuy;
@property (nonatomic,assign) double promotionMoney;
@property (nonatomic,assign) int fullSendID;
@end
