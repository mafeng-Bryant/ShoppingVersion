//
//  SubmitOrderViewController.m
//  shopping
//
//  Created by yunlai on 13-1-29.
//
//

#import "SubmitOrderViewController.h"
#import "DBOperate.h"
#import "ReservationInfo.h"
#import "MyAddressViewController.h"
#import "PayAndSendViewController.h"
#import "WritingInvoiceViewController.h"
#import "MyDiscountViewController.h"
#import "Common.h"
#import "FileManager.h"
#import "UIImageScale.h"
#import "DataManager.h"
#import "PayOrderViewController.h"
#import "CustomTabBar.h"
#import "tabEntranceViewController.h"
#import "PayOrderByAlipay.h"
#import "ProductDetailViewController.h"
//#import "AlixPayOrder.h"
//#import "AlixPayResult.h"
//#import "AlixPay.h"
//#import "DataSigner.h"

#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"

#import "Product.h"

@interface SubmitOrderViewController ()

@end

@implementation SubmitOrderViewController
@synthesize bookInfoArray;
@synthesize info;
@synthesize shopArray;
@synthesize totalPrice;
@synthesize savePrice;
@synthesize promotionDataArray;
@synthesize totalMoney;
@synthesize isEasyBuy;
@synthesize promotionMoney;
@synthesize fullSendID;
@synthesize delivepArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"订单";
    
    NSArray *ay = [[NSArray alloc] init];
    self.promotionDataArray = ay;
    [ay release];
    
    //保存上一次运费
    preDeliveryFare = 0.00;
    
    NSArray *d_ay = [[NSArray alloc] init];
    self.delivepArray = d_ay;
    [d_ay release];
    
    sectionTitleArray = [[NSArray alloc] initWithObjects:@"  收货人信息",@"  支付及配送",@"  发票信息",@"  优惠券",@"  备注",@"  产品清单", nil];
    buyAndSendArray = [[NSArray alloc] initWithObjects:@"支付方式",@"配送方式",@"送货时间",@"送货前电话",@"付款方式", nil];
    invoiceArray = [[NSArray alloc] initWithObjects:@"发票类型",@"发票抬头",@"发票内容", nil];
    NSNumber *_userid = [[[DBOperate queryData:T_MEMBER_INFO theColumn:nil theColumnValue:nil withAll:YES] objectAtIndex:0] objectAtIndex:member_info_memberId];
    NSLog(@"_userid:%d",[_userid intValue]);
    //查找默认的轻松购信息
    //NSArray *list = [DBOperate queryData:T_EASYBOOK_LIST theColumn:@"is_default" theColumnValue:@"1" withAll:NO];
    NSArray *list = [DBOperate queryData:T_EASYBOOK_LIST theColumn:@"is_default" equalValue:@"1" theColumn:@"memberId" equalValue:_userid];
    NSLog(@"list:%@",list);
    if (list != nil && [list count] > 0) {
        self.bookInfoArray = [list objectAtIndex:0];
    }
    
    ReservationInfo *_info = [[ReservationInfo alloc] init];
    self.info = _info;
    [_info release];
    
    if (bookInfoArray != nil && [bookInfoArray count] > 0) {
        int buyStyle = [[bookInfoArray objectAtIndex:easybook_list_payway] intValue];
        NSString *buyStr;
        NSString *moneyStr;
        if (buyStyle == 0) {
            buyStr = @"在线支付";
            moneyStr = @"";
        }else {
            buyStr = @"货到付款";
            if ([[bookInfoArray objectAtIndex:easybook_list_payment] intValue] == 0) {
                moneyStr = @"现金";
            }else {
                moneyStr = @"刷卡";
            }
        }
        
        NSString *sendStr;
        int sendId = [[bookInfoArray objectAtIndex:easybook_list_post_id] intValue];
        NSArray *ay = [DBOperate queryData:T_SENDSTYLE theColumn:@"id" theColumnValue:[NSString stringWithFormat:@"%d",sendId] withAll:NO];
        if ([ay count] > 0) {
            sendStr = [[ay objectAtIndex:0] objectAtIndex:sendstyle_name];
        }else {
            sendStr = @"";
        }
        
        NSString *timeStr;
        time = [[bookInfoArray objectAtIndex:easybook_list_send_time] intValue];
        if (time == 1) {
            timeStr = @"只工作日送";
        }else if (time == 2) {
            timeStr = @"工作日，双休，假日均可送货";
        }else {
            timeStr = @"只双休日，假日送货";
        }
        
        NSString *isSureStr;
        isSure = [[bookInfoArray objectAtIndex:easybook_list_issure] intValue];
        if (isSure == 0) {
            isSureStr = @"否";
        }else {
            isSureStr = @"是";
        }
        
        NSString *invoiceTypeStr;
        invoiceType = [[bookInfoArray objectAtIndex:easybook_list_invoice_type] intValue];
        if (invoiceType == 1) {
            invoiceTypeStr = @"普通发票";
        }
        
        NSString *invoiceTitleStr;
        invoiceTitle = [[bookInfoArray objectAtIndex:easybook_list_invoice_title_type] intValue];
        if (invoiceTitle == 1) {
            invoiceTitleStr = @"个人";
        }else {
            invoiceTitleStr = @"单位";
        }
        info.easyName = [bookInfoArray objectAtIndex:easybook_list_easyname];
        info.per_name = [bookInfoArray objectAtIndex:easybook_list_consignee];
        info.per_tel = [bookInfoArray objectAtIndex:easybook_list_mobile];
        info.per_post = [bookInfoArray objectAtIndex:easybook_list_zip_code];
        info.per_province = [bookInfoArray objectAtIndex:easybook_list_province];
        info.per_city = [bookInfoArray objectAtIndex:easybook_list_city];
        info.per_area = [bookInfoArray objectAtIndex:easybook_list_area];
        info.per_detailAddress = [bookInfoArray objectAtIndex:easybook_list_address];
        info.buy_buyStyle = buyStr;
        info.buy_sendStyle = sendStr;
        info.buy_time = timeStr;
        info.buy_isSureByTel = isSureStr;
        info.buy_moneyStyle = moneyStr;
        info.invoice_style = invoiceTypeStr;
        info.invoice_title = invoiceTitleStr;
        info.invoice_titleName = [bookInfoArray objectAtIndex:easybook_list_invoice_title_cont];
        
        //请求获取运费
        [self accessDeliveryFare];
    }
    
    //配送和支付字典索引
    dict = [[NSMutableDictionary alloc] init];
    
    orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height- 44 - 44) style:UITableViewStylePlain];
    orderTableView.showsHorizontalScrollIndicator = NO;
    orderTableView.showsVerticalScrollIndicator = YES;
    orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    orderTableView.delegate = self;
    orderTableView.dataSource = self;
    orderTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:orderTableView];
    
    [self addToolBarView];
    
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc]
								  initWithTitle:@"提交"
								  style:UIBarButtonItemStyleBordered
								  target:self
								  action:@selector(onSubmit:)];
	self.navigationItem.rightBarButtonItem = submitButton;
	[submitButton release];
}

- (void) addToolBarView{
    toolBarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT - 20.0f - 44-44, self.view.frame.size.width, 44)];
    UIImage *backImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"订单下bar" ofType:@"png"]];
    toolBarImageView.image = backImage;
    [backImage release];
    [self.view addSubview:toolBarImageView];
    toolBarImageView.userInteractionEnabled = YES;
    
    UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"订单按钮" ofType:@"png"]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.view.frame.size.width-img.size.width,0, img.size.width, img.size.height);
    [button addTarget:self action:@selector(onSubmit:)
     forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor redColor];
    [button setBackgroundImage:img forState:UIControlStateNormal];
    [img release];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button setTitle:@"提交订单" forState:UIControlStateNormal];
    [toolBarImageView addSubview:button];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 20)];
    label1.textColor = [UIColor darkTextColor];
    label1.font = [UIFont systemFontOfSize:12.0f];
    label1.textAlignment = UITextAlignmentLeft;
    label1.backgroundColor = [UIColor clearColor];
    [toolBarImageView addSubview:label1];
    label1.text = @"总金额:";
    [label1 release];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 80, 20)];
    label2.tag = 600;
    label2.textColor = [UIColor redColor];
    label2.font = [UIFont systemFontOfSize:12.0f];
    label2.textAlignment = UITextAlignmentLeft;
    label2.backgroundColor = [UIColor clearColor];
    [toolBarImageView addSubview:label2];
    label2.text = [NSString stringWithFormat:@"￥%.2f",totalMoney];
    [label2 release];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 80, 20)];
    label3.textColor = [UIColor darkTextColor];
    label3.font = [UIFont systemFontOfSize:12.0f];
    label3.textAlignment = UITextAlignmentLeft;
    label3.backgroundColor = [UIColor clearColor];
    [toolBarImageView addSubview:label3];
    label3.text = @"节   省:";
    [label3 release];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, 80, 20)];
    label4.tag = 601;
    label4.textColor = [UIColor darkTextColor];
    label4.font = [UIFont systemFontOfSize:12.0f];
    label4.textAlignment = UITextAlignmentLeft;
    label4.backgroundColor = [UIColor clearColor];
    [toolBarImageView addSubview:label4];
    label4.text = [NSString stringWithFormat:@"￥%.2f",[savePrice doubleValue]+promotionMoney];
    [label4 release];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSArray *arr1 = [NSArray arrayWithObjects:info.buy_buyStyle,info.buy_sendStyle,info.buy_time,info.buy_isSureByTel,info.buy_moneyStyle, nil];
    NSArray *arr2 = [NSArray arrayWithObjects:info.invoice_style,info.invoice_title,info.invoice_titleName, nil];
    [dict removeAllObjects];
    [dict setObject:arr1 forKey:[NSNumber numberWithInt:1]];
    [dict setObject:arr2 forKey:[NSNumber numberWithInt:2]];
    
    [orderTableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [textField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc{
    [super dealloc];
    [sectionTitleArray release],sectionTitleArray = nil;
    [orderTableView release],orderTableView = nil;
    [bookInfoArray release],bookInfoArray = nil;
//    [info release],info = nil;
    [buyAndSendArray release],buyAndSendArray = nil;
    [dict release],dict = nil;
    [invoiceArray release],invoiceArray = nil;
    [shopArray release],shopArray = nil;
    [toolBarImageView release],toolBarImageView = nil;
    [totalPrice release],totalPrice = nil;
    [textField release],textField = nil;
    [deliveryPriceLabel release],deliveryPriceLabel = nil;
    [delivepArray release],delivepArray = nil;
//    [promotionDataArray release],promotionDataArray = nil;
//    [savePrice release],savePrice = nil;
}

- (void) onSubmit:(id)sender{
    BOOL canSubmit = YES;
    if (info.per_name.length == 0 || info.per_tel.length == 0 || info.per_post.length == 0 || info.per_area.length == 0 || info.per_detailAddress.length == 0)
    {
        MBProgressHUD *mprogressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        mprogressHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-信息.png"]] autorelease];
        mprogressHUD.mode = MBProgressHUDModeCustomView;
        mprogressHUD.labelText = @"请填写完整的收货信息";
        [self.view addSubview:mprogressHUD];
        [self.view bringSubviewToFront:mprogressHUD];
        [mprogressHUD show:YES];
        [mprogressHUD hide:YES afterDelay:1.5];
        [mprogressHUD release];
        canSubmit = NO;
    }else if (info.buy_buyStyle.length == 0 || info.buy_sendStyle.length == 0 || info.buy_time.length == 0 || info.buy_isSureByTel.length == 0){
        MBProgressHUD *mprogressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        mprogressHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-信息.png"]] autorelease];
        mprogressHUD.mode = MBProgressHUDModeCustomView;
        mprogressHUD.labelText = @"请填写完整的支付配送信息";
        [self.view addSubview:mprogressHUD];
        [self.view bringSubviewToFront:mprogressHUD];
        [mprogressHUD show:YES];
        [mprogressHUD hide:YES afterDelay:1.5];
        [mprogressHUD release];
        canSubmit = NO;
    }else if (info.invoice_style.length == 0 || info.invoice_title.length == 0 || info.invoice_titleName.length == 0){
        MBProgressHUD *mprogressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        mprogressHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-信息.png"]] autorelease];
        mprogressHUD.mode = MBProgressHUDModeCustomView;
        mprogressHUD.labelText = @"请填写完整的发票信息";
        [self.view addSubview:mprogressHUD];
        [self.view bringSubviewToFront:mprogressHUD];
        [mprogressHUD show:YES];
        [mprogressHUD hide:YES afterDelay:1.5];
        [mprogressHUD release];
        canSubmit = NO;
    }
    //是否提示满就送
    if (canSubmit) {
        [self submitOrder];
    }
}

- (void) submitOrder{
    
    progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    progressHUD.labelText = @"订单提交中... ";
    [self.view addSubview:progressHUD];
    [self.view bringSubviewToFront:progressHUD];
    [progressHUD show:YES];
    
    SBJSON *json = [[SBJSON alloc] init];
    NSMutableArray *productArray = [[NSMutableArray alloc] init];
    
    //订单添加预定产品列表
    for (int i = 0; i < [shopArray count]; i++) {
        NSArray *ay = [shopArray objectAtIndex:i];
        NSNumber *pid = [NSNumber numberWithInt:[[ay objectAtIndex:shopcar_product_id] intValue]];
        NSNumber *pnum = [NSNumber numberWithInt:[[ay objectAtIndex:shopcar_product_count] intValue]];
        NSDictionary *prodict = [[NSDictionary alloc] initWithObjectsAndKeys:pid,@"product_id", pnum,@"product_num",nil];
        [productArray addObject:prodict];
        [prodict release];
    }
    
    int _userId = [[[[DBOperate queryData:T_MEMBER_INFO theColumn:nil theColumnValue:nil withAll:YES] objectAtIndex:0] objectAtIndex:member_info_memberId] intValue];
    
    if ([info.buy_buyStyle isEqualToString:@"在线支付"]) {
        payType = 0;
    }else{
        payType = 1;
    }
    if ([info.buy_moneyStyle isEqualToString:@"现金"]) {
        payMent = 0;
    }else{
        payMent = 1;
    }
    NSDictionary *jsontestDic;
    NSString *mark = @"";
    if([textField.text length] > 0){
        mark = textField.text;
    }
    //普通下单流程
    if (!isEasyBuy) {
        if ([self.promotionDataArray count] > 0) {
            jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                           [Common getSecureString],@"keyvalue",
                           [NSNumber numberWithInt: SITE_ID],@"site_id",
                           [NSNumber numberWithInt: _userId],@"user_id",
                           [NSNumber numberWithInt: 2],@"type",
                           info.per_name,@"name",
                           info.per_tel,@"mobile",
                           info.per_detailAddress,@"address",
                           info.per_province,@"province",
                           info.per_city,@"city",
                           info.per_area,@"area",
                           info.per_post,@"zip_code",
                           [NSNumber numberWithInt:payType],@"payway",
                           [NSNumber numberWithInt:payMent],@"payment",
                           [NSNumber numberWithInt:_sendId],@"post_id",
                           [NSNumber numberWithInt:time],@"send_time",
                           [NSNumber numberWithInt:isSure],@"issure",
                           [NSNumber numberWithInt:invoiceType],@"invoice_type",
                           [NSNumber numberWithInt:invoiceTitle],@"invoice_title_type",
                           info.invoice_titleName,@"invoice_title_cont",
                           mark,@"remark",
                           [NSNumber numberWithInt:fullSendID],@"send_id",
                           [NSNumber numberWithInt:[[self.promotionDataArray objectAtIndex:mydiscountlist_id] intValue]],@"p_id",
                           [json objectWithString:[json stringWithObject:productArray]],@"productinfos",nil];
        }else {
            jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                           [Common getSecureString],@"keyvalue",
                           [NSNumber numberWithInt: SITE_ID],@"site_id",
                           [NSNumber numberWithInt: _userId],@"user_id",
                           [NSNumber numberWithInt: 2],@"type",
                           info.per_name,@"name",
                           info.per_tel,@"mobile",
                           info.per_detailAddress,@"address",
                           info.per_province,@"province",
                           info.per_city,@"city",
                           info.per_area,@"area",
                           info.per_post,@"zip_code",
                           [NSNumber numberWithInt:payType],@"payway",
                           [NSNumber numberWithInt:payMent],@"payment",
                           [NSNumber numberWithInt:_sendId],@"post_id",
                           [NSNumber numberWithInt:time],@"send_time",
                           [NSNumber numberWithInt:isSure],@"issure",
                           [NSNumber numberWithInt:invoiceType],@"invoice_type",
                           [NSNumber numberWithInt:invoiceTitle],@"invoice_title_type",
                           info.invoice_titleName,@"invoice_title_cont",
                           mark,@"remark",
                           [NSNumber numberWithInt:fullSendID],@"send_id",
                           [json objectWithString:[json stringWithObject:productArray]],@"productinfos",nil];
        }
        
    }else{//轻松定下单流程
        jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [Common getSecureString],@"keyvalue",
                                     [NSNumber numberWithInt: SITE_ID],@"site_id",
                                     [NSNumber numberWithInt: _userId],@"user_id",
                                     [NSNumber numberWithInt: 1],@"type",   //type为1，轻松购类型
                                     [[[DBOperate queryData:T_MEMBER_INFO theColumn:nil theColumnValue:nil withAll:YES] objectAtIndex:0] objectAtIndex:member_info_name],@"name",
                                     [json objectWithString:[json stringWithObject:productArray]],@"productinfos",
                                     nil];
    }
        
    [productArray release];
    [json release];
    NSString *reqUrl = @"book/addorder.do?param=%@";
    [[DataManager sharedManager] accessService:jsontestDic
                                       command:SUBMIT_ORDER_COMMAND_ID
                                  accessAdress:reqUrl
                                      delegate:self
                                     withParam:nil];
    
    
}

- (void) didFinishCommand:(NSMutableArray *)resultArray cmd:(int)commandid withVersion:(int)ver{
    switch (commandid) {
        case GET_DELIVERY_FARE:{
            [self performSelectorOnMainThread:@selector(updateDeliveryFare:) withObject:resultArray waitUntilDone:NO];
        }
            break;
        case SUBMIT_ORDER_COMMAND_ID:{
            [self performSelectorOnMainThread:@selector(update:) withObject:resultArray waitUntilDone:NO];
        }
            break;
        default:
            break;
    }
}

- (void) updateDeliveryFare:(NSMutableArray*)array{
    if (progressHUD != nil) {
        if (progressHUD) {
            [progressHUD hide:YES];
            [progressHUD removeFromSuperViewOnHide];
        }
    }
    self.delivepArray = array;
//    NSLog(@"totalMoney == %f",totalMoney);
//    NSLog(@"运费 == %f",[[delivepArray objectAtIndex:0] doubleValue]);
//    NSLog(@"preDeliveryFare == %f",preDeliveryFare);
    totalMoney = totalMoney + [[delivepArray objectAtIndex:0] doubleValue] - preDeliveryFare;
    preDeliveryFare = [[delivepArray objectAtIndex:0] doubleValue];
    
    UILabel *totollabel = (UILabel*)[toolBarImageView viewWithTag:600];
    totollabel.text = [NSString stringWithFormat:@"￥%.2f",totalMoney];
}

- (void) update:(NSMutableArray*)array{
    if (progressHUD != nil) {
        if (progressHUD) {
            [progressHUD hide:YES];
            [progressHUD removeFromSuperViewOnHide];
        }
    }
    
    if ([array count] > 0) {
        //对返回值ret，0为提交订单失败，1为提交订单成功，2产品没库存了。3.产品已下架，4该满就送不存在5.该优惠劵已过期，6.该物流已不存在。7.该支付方式已不存在
        int ret = [[array objectAtIndex:0] intValue];
        if (ret == 0) {
            MBProgressHUD *mprogressHUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:mprogressHUD];
            [self.view bringSubviewToFront:mprogressHUD];
            mprogressHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-信息.png"]] autorelease];
            mprogressHUD.mode = MBProgressHUDModeCustomView;
            [mprogressHUD show:YES];
            mprogressHUD.labelText = @"提交失败";
            [mprogressHUD hide:YES afterDelay:1.5];
            [mprogressHUD release];
        }else if (ret == 1){
            [DBOperate deleteData:T_SHOPCAR tableColumn:@"isSelect" columnValue:@"1"];
            //TODO:订单信息本地缓存
            //如果是在线支付，直接调用支付宝支付
            if (payType == 0) {
                NSString *desc = textField.text;
                NSString *name;
                if ([desc length] > 0) {
                    desc = @"暂无描述";
                }
                if ([shopArray count] > 0) {
                    NSArray *ay = [shopArray objectAtIndex:0];
                    name = [NSString stringWithFormat:@"%@ 等",[ay objectAtIndex:shopcar_product_name]];
                }else{
                    NSArray *ay = [shopArray objectAtIndex:0];
                    name = [ay objectAtIndex:shopcar_product_name];
                }
                orderID = [array objectAtIndex:1];
                //[PayOrderByAlipay payOrder:[[array objectAtIndex:2] floatValue] withOrderID:[array objectAtIndex:1] withOrderName:@"订单名称" withDesc:@"订单描述"];
                [self payOrder:[[array objectAtIndex:2] floatValue] withOrderID:[array objectAtIndex:1] withOrderName:name withDesc:@"订单描述"];
            }else if(payType == 1){
                //前往订单支付页
                PayOrderViewController *pvc = [[PayOrderViewController alloc] init];
                pvc.orderArray = array;
                pvc.info = self.info;
                [self.navigationController pushViewController:pvc animated:YES];
                [pvc release];
            }
        }else if (ret == 2){
            MBProgressHUD *mprogressHUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:mprogressHUD];
            [self.view bringSubviewToFront:mprogressHUD];
            mprogressHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-信息.png"]] autorelease];
            mprogressHUD.mode = MBProgressHUDModeCustomView;
            [mprogressHUD show:YES];
            mprogressHUD.labelText = @"库存不足";
            [mprogressHUD hide:YES afterDelay:1.5];
            [mprogressHUD release];
        }else if (ret == 3){
            MBProgressHUD *mprogressHUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:mprogressHUD];
            [self.view bringSubviewToFront:mprogressHUD];
            mprogressHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-信息.png"]] autorelease];
            mprogressHUD.mode = MBProgressHUDModeCustomView;
            [mprogressHUD show:YES];
            mprogressHUD.labelText = @"产品已下架";
            [mprogressHUD hide:YES afterDelay:1.5];
            [mprogressHUD release];
        }else if (ret == 4){
            
        }else if (ret == 5){
            MBProgressHUD *mprogressHUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:mprogressHUD];
            [self.view bringSubviewToFront:mprogressHUD];
            mprogressHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-信息.png"]] autorelease];
            mprogressHUD.mode = MBProgressHUDModeCustomView;
            [mprogressHUD show:YES];
            mprogressHUD.labelText = @"该优惠券已过期";
            [mprogressHUD hide:YES afterDelay:1.5];
            [mprogressHUD release];
        }else if (ret == 6){
            
        }else if (ret == 7){
            
        }
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        if (![info.buy_buyStyle length] > 0) {
            return 1;
        }else{
            
            if ([info.buy_buyStyle isEqualToString:@"在线支付"]) {
                return 4;
            }else{
                return 5;
            }
        }
    }
    else if(section == 2){
        if (![info.invoice_style length] > 0) {
            return 1;
        }else{
            return 2;
        }
    }else if(section == 5){
        return [shopArray count] + 1;
    }else{
        return 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 16)];
    
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"分割线_虚线.png"]];
    imgV.frame = CGRectMake(0, 7, 320, 1);
    [headView addSubview:imgV];
    [imgV release];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 88, 16)];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"小栏目背景.png"]];
    label.text = [sectionTitleArray objectAtIndex:section];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = 1;
    [headView addSubview:label];
    [label release];
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if ([info.per_name length] > 0) {
                return 70;
            }else{
                return 60;
            }
        }
            break;
        case 1:{
            if ([info.buy_buyStyle length] > 0) {
                return 22;
            }else{
                return 60;
            }
        }
            break;
        case 2:{
            if ([info.invoice_style length] > 0) {
                return 28;
            }else{
                return 60;
            }
        }
            break;
        case 3:{
            return 30;
        }
            break;
        case 5:{
            return 86;
        }
            break;
        default:
            return 60;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && !isEasyBuy) {
        int _userId = [[[[DBOperate queryData:T_MEMBER_INFO theColumn:nil theColumnValue:nil withAll:YES] objectAtIndex:0] objectAtIndex:member_info_memberId] intValue];
        MyAddressViewController *myAddr = [[MyAddressViewController alloc] init];
        myAddr.delegate = self;
        myAddr.fromType = FromTypeReceive;
        myAddr._isHidden = NO;
        myAddr.userId = [NSString stringWithFormat:@"%d",_userId];
        myAddr.info = self.info;
        [self.navigationController pushViewController:myAddr animated:YES];
        [myAddr release];
    }else if (indexPath.section == 1 && !isEasyBuy){
        PayAndSendViewController *paySend = [[PayAndSendViewController alloc] initWithStyle:UITableViewStyleGrouped];
        paySend.myDelegate = self;
        paySend.info = info;
        paySend.info.buy_moneyStyle = @"现金";
        [self.navigationController pushViewController:paySend animated:YES];
        [paySend release];
    }else if(indexPath.section == 2 && !isEasyBuy){
        WritingInvoiceViewController *writingInvoice = [[WritingInvoiceViewController alloc] initWithStyle:UITableViewStyleGrouped];
        writingInvoice.info = info;
        [self.navigationController pushViewController:writingInvoice animated:YES];
        [writingInvoice release];
    }else if(indexPath.section == 3){
        NSArray *dbArr = [DBOperate queryData:T_MEMBER_INFO theColumn:nil theColumnValue:nil withAll:YES];
        if ([dbArr count] > 0) {
            NSString *userIdStr = [NSString stringWithFormat:@"%d",[[[dbArr objectAtIndex:0] objectAtIndex:member_info_memberId] intValue]];
            
            MyDiscountViewController *myDiscount = [[MyDiscountViewController alloc] init];
            myDiscount.myDelegate = self;
            myDiscount.isSelectPromotion = YES;
            myDiscount.userId = userIdStr;
            [self.navigationController pushViewController:myDiscount animated:YES];
            [myDiscount release];
        }
    }else if(indexPath.section == 5){
        if (indexPath.row < [shopArray count]) {
            NSArray *ay = [shopArray objectAtIndex:indexPath.row];
            int productid = [[ay objectAtIndex:product_id] intValue];
            ProductDetailViewController *ProductDetailView = [[ProductDetailViewController alloc] init];
            ProductDetailView.productID = productid;
            [self.navigationController pushViewController:ProductDetailView animated:YES];
            [ProductDetailView release];
        }
    }
}

#pragma mark GetMyAddressDelegate
-(void) getMyAddress{
    if ([info.per_province length] > 0) {
        [self accessDeliveryFare];
    }
}

#pragma mark getPromotionDetailDelegate
-(void)getPromotionArray:(NSArray*)promotionArray{
    NSLog(@"promotionArray === %@",promotionArray);
    self.promotionDataArray = promotionArray;
}

//请求快递运费
- (void) accessDeliveryFare{
    progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    progressHUD.labelText = @"计算运费...";
    [self.view addSubview:progressHUD];
    [self.view bringSubviewToFront:progressHUD];
    [progressHUD show:YES];
    
    SBJSON *json = [[SBJSON alloc] init];
    NSMutableArray *productArray = [[NSMutableArray alloc] init];
    
    //NSArray *shopProductArray = [DBOperate queryData:T_SHOPCAR theColumn:@"isSelect" theColumnValue:@"1" withAll:NO];
    
    //订单添加预定产品列表
    for (int i = 0; i < [shopArray count]; i++) {
        NSArray *ay = [shopArray objectAtIndex:i];
        NSNumber *pid = [NSNumber numberWithInt:[[ay objectAtIndex:shopcar_product_id] intValue]];
        NSNumber *pnum = [NSNumber numberWithInt:[[ay objectAtIndex:shopcar_product_count] intValue]];
        NSDictionary *prodict = [[NSDictionary alloc] initWithObjectsAndKeys:pid,@"product_id", pnum,@"product_num",nil];
        [productArray addObject:prodict];
        [prodict release];
    }
    
    NSArray *dbArr = [DBOperate queryData:T_SENDSTYLE theColumn:@"name" theColumnValue:self.info.buy_sendStyle withAll:NO];
    if ([dbArr count] > 0) {
        _sendId = [[[dbArr objectAtIndex:0] objectAtIndex:sendstyle_id] intValue];
    }
    NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [Common getSecureString],@"keyvalue",
                                 [NSNumber numberWithInt: SITE_ID],@"site_id",
                                 info.per_province,@"province",
                                 info.per_city,@"city",
                                 [NSNumber numberWithInt:_sendId],@"post_id",
                                 [json objectWithString:[json stringWithObject:productArray]],@"productInfos",nil];
    
    [productArray release];
    [json release];
    NSString *reqUrl = @"product/logisticsCost.do?param=%@";
    [[DataManager sharedManager] accessService:jsontestDic
                                       command:GET_DELIVERY_FARE
                                  accessAdress:reqUrl
                                      delegate:self
                                     withParam:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.section == 0) {
            if(![info.per_name length] > 0){
                UIImage *img = [UIImage imageNamed:@"button_白色.png"];
                img = [img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:img.size.height/2];
                
                UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
                imageView.frame = CGRectMake(10, 10, 300, 40);
                [cell.contentView addSubview:imageView];
                [imageView release];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 280, 40)];
                label.textAlignment = 0;
                label.backgroundColor = [UIColor clearColor];
                label.text = @"填写收货人信息";
                label.font = [UIFont systemFontOfSize:16];
                [cell.contentView addSubview:label];
                [label release];
                
                UIImageView *riImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"右箭头.png"]];
                riImgView.frame = CGRectMake(290, 24, 16, 11);
                if (!isEasyBuy) {
                    [cell.contentView addSubview:riImgView];
                }
                [riImgView release];
            }else{
                UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 250, 22)];
                label1.textColor = [UIColor darkGrayColor];
                label1.font = [UIFont systemFontOfSize:14.0f];
                label1.textAlignment = UITextAlignmentLeft;
                label1.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:label1];
                label1.text = [NSString stringWithFormat:@"%@   %@",info.per_name,info.per_tel];
                [label1 release];
                                
                UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 250, 22)];
                label2.textColor = [UIColor darkGrayColor];
                label2.font = [UIFont systemFontOfSize:14.0f];
                label2.textAlignment = UITextAlignmentLeft;
                label2.backgroundColor = [UIColor clearColor];
                [label2 setLineBreakMode:UILineBreakModeWordWrap];
                [label2 setNumberOfLines:0];
                label2.text = [NSString stringWithFormat:@"%@   %@    %@  %@   %@",info.per_province,info.per_city,info.per_area ,info.per_detailAddress,info.per_post];
                //重置label的大小
                CGSize constraint2 = CGSizeMake(250, 20000.0f);
                CGSize size2 = [label2.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint2 lineBreakMode:UILineBreakModeWordWrap];
                float fixHeight = size2.height;
                fixHeight = fixHeight == 0 ? 22.f : fixHeight;
                label2.frame = CGRectMake(10, 25, 250, fixHeight);
                [cell.contentView addSubview:label2];
                [label2 release];
                
                UIImageView *riImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"圆右箭头.png"]];
                riImgView.frame = CGRectMake(290, 26, 17, 17);
                if (!isEasyBuy) {
                    [cell.contentView addSubview:riImgView];
                }
                [riImgView release];
            }
        }else if(indexPath.section == 1){
            if(![info.buy_buyStyle length] > 0){
                UIImage *img = [UIImage imageNamed:@"button_白色.png"];
                img = [img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:img.size.height/2];
                
                UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
                imageView.frame = CGRectMake(10, 10, 300, 40);
                [cell.contentView addSubview:imageView];
                [imageView release];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 280, 40)];
                label.textAlignment = 0;
                label.backgroundColor = [UIColor clearColor];
                if (indexPath.section == 1) {
                    label.text = @"选择支付及配送方式";
                }else if(indexPath.section == 2){
                    label.text = @"发票信息";
                }
                label.font = [UIFont systemFontOfSize:16];
                [cell.contentView addSubview:label];
                [label release];
                
                UIImageView *riImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"右箭头.png"]];
                riImgView.frame = CGRectMake(290, 24, 16, 11);
                if (!isEasyBuy) {
                    [cell.contentView addSubview:riImgView];
                }
                [riImgView release];
            }else{
                UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 20)];
                label1.textColor = [UIColor darkTextColor];
                label1.font = [UIFont systemFontOfSize:14.0f];
                label1.textAlignment = UITextAlignmentLeft;
                label1.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:label1];
                if (indexPath.section == 1) {
                    label1.text = [buyAndSendArray objectAtIndex:indexPath.row];
                }else if(indexPath.section == 2){
                    label1.text = [invoiceArray objectAtIndex:indexPath.row];
                }
                [label1 release];
                
                UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 200, 20)];
                label2.textColor = [UIColor darkGrayColor];
                label2.font = [UIFont systemFontOfSize:12.0f];
                label2.textAlignment = UITextAlignmentLeft;
                label2.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:label2];
                label2.text = [[dict objectForKey:[NSNumber numberWithInt:indexPath.section]] objectAtIndex:indexPath.row];
                [label2 release];
                if (indexPath.row == 2) {
                    UIImageView *riImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"圆右箭头.png"]];
                    riImgView.frame = CGRectMake(290, 2, 17, 17);
                    if (!isEasyBuy) {
                        [cell.contentView addSubview:riImgView];
                    }
                    [riImgView release];
                }
            }
        }else if (indexPath.section == 2){
            if(![info.invoice_style length] > 0){
                UIImage *img = [UIImage imageNamed:@"button_白色.png"];
                img = [img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:img.size.height/2];
                
                UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
                imageView.frame = CGRectMake(10, 10, 300, 40);
                [cell.contentView addSubview:imageView];
                [imageView release];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 280, 40)];
                label.textAlignment = 0;
                label.backgroundColor = [UIColor clearColor];
                label.text = @"发票信息";
                label.font = [UIFont systemFontOfSize:16];
                [cell.contentView addSubview:label];
                [label release];
                UIImageView *riImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"右箭头.png"]];
                riImgView.frame = CGRectMake(290, 24, 16, 11);
                if (!isEasyBuy) {
                    [cell.contentView addSubview:riImgView];
                }
                [riImgView release];
            }else{
                UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 20)];
                label1.textColor = [UIColor darkTextColor];
                label1.font = [UIFont systemFontOfSize:14.0f];
                label1.textAlignment = UITextAlignmentLeft;
                label1.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:label1];
                label1.text = [invoiceArray objectAtIndex:indexPath.row];
                [label1 release];
                
                UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 200, 20)];
                label2.textColor = [UIColor darkGrayColor];
                [label2 setLineBreakMode:UILineBreakModeWordWrap];
                [label2 setNumberOfLines:0];
                label2.font = [UIFont systemFontOfSize:12.0f];
                label2.textAlignment = UITextAlignmentLeft;
                label2.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:label2];
                
                if (indexPath.row == 0) {
                    label2.text = [[dict objectForKey:[NSNumber numberWithInt:indexPath.section]] objectAtIndex:indexPath.row];
                }else if(indexPath.row == 1) {
                    //添加右箭头指示图片
                    UIImageView *riImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"圆右箭头.png"]];
                    riImgView.frame = CGRectMake(290, -10, 17, 17);
                    if (!isEasyBuy) {
                        [cell.contentView addSubview:riImgView];
                    }
                    [riImgView release];
                    
                    NSString *text1= [[dict objectForKey:[NSNumber numberWithInt:indexPath.section]] objectAtIndex:indexPath.row];
                    NSString *text2= [[dict objectForKey:[NSNumber numberWithInt:indexPath.section]] objectAtIndex:indexPath.row + 1];
                    label2.text = [NSString stringWithFormat:@"%@ (%@)",text1,text2];
                    CGSize textSize = [label2.text sizeWithFont:[UIFont systemFontOfSize:12.0]];
                    if (textSize.width > label2.frame.size.width) {
                        CGSize constraint = CGSizeMake(200, 20000.0f);
                        CGSize size = [label2.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
                        float fixHeight = size.height;
                        label2.frame = CGRectMake(label2.frame.origin.x, -4, 200, fixHeight);
                    }
                }
                [label2 release];
            }
        }else if (indexPath.section == 3){
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 20)];
            label1.textColor = [UIColor darkTextColor];
            label1.font = [UIFont systemFontOfSize:14.0f];
            label1.textAlignment = UITextAlignmentLeft;
            label1.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label1];
            label1.text = @"优惠券";
            [label1 release];
            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(90, 4, 200, 20)];
            label2.textColor = [UIColor darkGrayColor];
            label2.font = [UIFont systemFontOfSize:12.0f];
            label2.textAlignment = UITextAlignmentLeft;
            label2.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label2];
            if (promotionDataArray == nil || ![promotionDataArray count] > 0) {
                label2.text = @"选择优惠券";
            }else{
                //label2.text = [NSString stringWithFormat:@"%@ %@",[promotionDataArray objectAtIndex:mydiscountlist_price],[promotionDataArray objectAtIndex:mydiscountlist_name]];//@"10元优惠券";
                label2.text = [promotionDataArray objectAtIndex:mydiscountlist_name];
                UILabel *totollabel = (UILabel*)[toolBarImageView viewWithTag:600];

                double filalMoney = totalMoney - [[promotionDataArray objectAtIndex:mydiscountlist_price] doubleValue];

                if (filalMoney > 0) {
                    totollabel.text = [NSString stringWithFormat:@"￥%.2f",totalMoney-[[promotionDataArray objectAtIndex:mydiscountlist_price] doubleValue]];
                    totalMoney = filalMoney;
                
                }else{
                    totollabel.text = @"￥0.00";
                }
                
                UILabel *savelb = (UILabel*)[toolBarImageView viewWithTag:601];
                savelb.text = [NSString stringWithFormat:@"￥%.2f",[savePrice doubleValue]+[[promotionDataArray objectAtIndex:mydiscountlist_price] doubleValue]];
            }
            [label2 release];
            UIImageView *riImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"圆右箭头.png"]];
            riImgView.frame = CGRectMake(290, 5, 17, 17);
            [cell.contentView addSubview:riImgView];
            [riImgView release];
        }else if (indexPath.section == 4){
            UIImage *img = [UIImage imageNamed:@"button_白色.png"];
            img = [img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:img.size.height/2];
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
            imageView.frame = CGRectMake(10, 10, 300, 40);
            [cell.contentView addSubview:imageView];
            [imageView release];
            if (textField == nil) {
                textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 280, 40)];
            }
            textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textField.returnKeyType = UIReturnKeyDone;
            textField.backgroundColor = [UIColor clearColor];
            textField.placeholder = @"请输入";
            textField.delegate = self;
            textField.font = [UIFont systemFontOfSize:16];
            [cell.contentView addSubview:textField];
        }else if (indexPath.section == 5){
            NSArray *ay;
            if (indexPath.row < [shopArray count]) {
                ay = [shopArray objectAtIndex:indexPath.row];
                UIImageView *cImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8 ,70, 70)];
                cImageView.tag = 10;
                cImageView.backgroundColor = [UIColor redColor];
                [cell.contentView addSubview:cImageView];
                
                NSString *picUrl = [ay objectAtIndex:shopcar_product_pic_url];
                NSString *picName = [Common encodeBase64:(NSMutableData *)[picUrl dataUsingEncoding: NSUTF8StringEncoding]];
                if (picUrl.length > 1)
                {
                    UIImage *pic = [[FileManager getPhoto:picName] fillSize:CGSizeMake(70, 70)];
                    if (pic.size.width > 2)
                    {
                        cImageView.image = pic;
                    }
                    else
                    {
                        UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表默认图片" ofType:@"png"]];
                        UIImageView *vi = (UIImageView *)[cell.contentView viewWithTag:10];
                        vi.image = [defaultPic fillSize:CGSizeMake(70, 70)];
                        
                    }
                }
                else
                {
                    UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表默认图片" ofType:@"png"]];
                    
                    cImageView.image = [defaultPic fillSize:CGSizeMake(70, 70)];
                }
                
                [cImageView release];
                
                UILabel *cName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cImageView.frame) + 10, 8, 180, 30)];
                cName.text = [ay objectAtIndex:shopcar_product_name];
                cName.tag = 11;
                cName.font = [UIFont systemFontOfSize:14.0f];
                cName.textAlignment = UITextAlignmentLeft;
                cName.backgroundColor = [UIColor clearColor];
                [cName setLineBreakMode:UILineBreakModeWordWrap];
                [cName setNumberOfLines:0];
                
                CGSize constraint = CGSizeMake(180, 20000.0f);
                CGSize size = [cName.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
                float fixHeight = size.height;
                fixHeight = fixHeight > 50 ? 50.0f : fixHeight;
                cName.frame = CGRectMake(CGRectGetMaxX(cImageView.frame) + 10, 8, 180, fixHeight);
                
                [cell.contentView addSubview:cName];
                [cName release];
                
                
                if ([[ay objectAtIndex:shopcar_product_promotionprice] intValue] == 0) {
                    UILabel *promoney = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cImageView.frame) + 10, 60, 60, 20)];
                    promoney.text = promoney.text = [NSString stringWithFormat:@"￥%.2f ",[[ay objectAtIndex:shopcar_product_price] doubleValue]];
                    CGSize promonySize = [promoney.text sizeWithFont:[UIFont systemFontOfSize:14.0]];
                    promoney.frame = CGRectMake(promoney.frame.origin.x,promoney.frame.origin.y,promonySize.width,promonySize.height);
                    promoney.textColor = [UIColor redColor];
                    promoney.tag = 22;
                    promoney.font = [UIFont systemFontOfSize:14.0f];
                    promoney.textAlignment = UITextAlignmentLeft;
                    promoney.backgroundColor = [UIColor clearColor];
                    [cell.contentView addSubview:promoney];
                    [promoney release];
                }else {
                    UILabel *promoney = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cImageView.frame) + 10, 60, 60, 20)];
                    promoney.text = [NSString stringWithFormat:@"￥%.2f ",[[ay objectAtIndex:shopcar_product_promotionprice] doubleValue]];
                    CGSize promonySize = [promoney.text sizeWithFont:[UIFont systemFontOfSize:14.0]];
                    promoney.frame = CGRectMake(promoney.frame.origin.x,promoney.frame.origin.y,promonySize.width,promonySize.height);
                    promoney.textColor = [UIColor redColor];
                    promoney.tag = 22;
                    promoney.font = [UIFont systemFontOfSize:14.0f];
                    promoney.textAlignment = UITextAlignmentLeft;
                    promoney.backgroundColor = [UIColor clearColor];
                    [cell.contentView addSubview:promoney];
                    [promoney release];
                    
                    UILabel *money = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(promoney.frame), 60, 80, 20)];
                    money.text = [NSString stringWithFormat:@"/ ￥%.2f",[[ay objectAtIndex:shopcar_product_price] doubleValue]];
                    
                    CGSize constraint = CGSizeMake(80, 20000.0f);
                    CGSize size = [money.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
                    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(6,10, size.width-4, 1)];
                    lineImageView.backgroundColor = [UIColor darkGrayColor];
                    [money addSubview:lineImageView];
                    [lineImageView release];
                    
                    money.textColor = [UIColor darkGrayColor];
                    money.tag = 33;
                    money.font = [UIFont systemFontOfSize:14.0f];
                    money.textAlignment = UITextAlignmentLeft;
                    money.backgroundColor = [UIColor clearColor];
                    [cell.contentView addSubview:money];
                    [money release];
                }
                
                
                UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 50, 13, 40, 20)];
                tLabel.textAlignment = UITextAlignmentRight;
                tLabel.textColor = [UIColor grayColor];
                tLabel.text = [NSString stringWithFormat:@"%d件",[[ay objectAtIndex:shopcar_product_count] intValue]];
                tLabel.backgroundColor = [UIColor clearColor];
                
                tLabel.adjustsFontSizeToFitWidth = YES;
                [cell.contentView addSubview:tLabel];
                [tLabel release];
                
                UILabel *saveLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 90, 60, 80, 20)];
                saveLabel.textAlignment = UITextAlignmentRight;
                saveLabel.textColor = [UIColor grayColor];
                
                double save = 0 ;
                if ([[ay objectAtIndex:shopcar_product_promotionprice] intValue] == 0) {
                    save = 0;
                }else {
                    double pm = [[ay objectAtIndex:shopcar_product_promotionprice] doubleValue];
                    double m = [[ay objectAtIndex:shopcar_product_price] doubleValue];
                    save = [[ay objectAtIndex:shopcar_product_count] doubleValue] * (m-pm);
                }
                
                saveLabel.text = [NSString stringWithFormat:@"已节省:￥%.2f",save];
                saveLabel.backgroundColor = [UIColor clearColor];
                saveLabel.adjustsFontSizeToFitWidth = YES;
                if ([[ay objectAtIndex:shopcar_product_promotionprice] intValue] > 0) {
                    [cell.contentView addSubview:saveLabel];
                }
                [saveLabel release];
                
                UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 85, 320, 1)];
                imageview.image = [UIImage imageNamed:@"商品一级分类分割线"];
                [cell.contentView addSubview:imageview];
                [imageview release];
            }else {
                UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 20)];
                label1.textColor = [UIColor darkTextColor];
                label1.font = [UIFont systemFontOfSize:14.0f];
                label1.textAlignment = UITextAlignmentLeft;
                label1.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:label1];
                label1.text = @"运费";
                [label1 release];
                
                deliveryPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-90, 5, 80, 20)];
                deliveryPriceLabel.textColor = [UIColor darkGrayColor];
                deliveryPriceLabel.font = [UIFont systemFontOfSize:14.0f];
                deliveryPriceLabel.textAlignment = UITextAlignmentRight;
                deliveryPriceLabel.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:deliveryPriceLabel];
                if ([delivepArray count] > 0) {
                    deliveryPriceLabel.text = [NSString stringWithFormat:@"+￥%@",[delivepArray objectAtIndex:0]];
                }else{
                    deliveryPriceLabel.text = @"0.00";
                }
                
                
                UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 80, 20)];
                label3.textColor = [UIColor darkTextColor];
                label3.font = [UIFont systemFontOfSize:14.0f];
                label3.textAlignment = UITextAlignmentLeft;
                label3.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:label3];
                label3.text = @"优惠券";
                [label3 release];
                
                UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-90, 25, 80, 20)];
                label4.textColor = [UIColor darkGrayColor];
                label4.font = [UIFont systemFontOfSize:14.0f];
                label4.textAlignment = UITextAlignmentRight;
                label4.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:label4];
                if (promotionDataArray != nil && [promotionDataArray count] > 0) {
                    label4.text = [NSString stringWithFormat:@"-￥%@",[promotionDataArray objectAtIndex:mydiscountlist_price]];//@"-￥10.00";
                }else{
                   label4.text = @"￥0.00";
                }
                [label4 release];
                
                UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 80, 20)];
                label5.textColor = [UIColor darkTextColor];
                label5.font = [UIFont systemFontOfSize:14.0f];
                label5.textAlignment = UITextAlignmentLeft;
                label5.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:label5];
                label5.text = @"满就送";
                [label5 release];
                
                UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-90, 45, 80, 20)];
                label6.textColor = [UIColor darkGrayColor];
                label6.font = [UIFont systemFontOfSize:14.0f];
                label6.textAlignment = UITextAlignmentRight;
                label6.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:label6];
                label6.text = [NSString stringWithFormat:@"-￥%.2f",promotionMoney];
                [label6 release];
            }
            
        }
    }
    
    return cell;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
	
	float viewup = 0.0f;
    if (IOS_VERSION >= 7.0){
        viewup = -180.0f + 30.0f;
    }else{
        viewup = -180.0f;
    }
	NSTimeInterval animationDuration = 0.30f;
	[UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
	
	[UIView setAnimationDuration:animationDuration];
	[UIView setAnimationDelegate:self];
	float width = self.view.frame.size.width;
	float height = self.view.frame.size.height;
	CGRect rect = CGRectMake(0.0f, viewup,width,height);
	self.view.frame = rect;
	[UIView commitAnimations];
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)tf{
	[tf resignFirstResponder];
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    if (IOS_VERSION >= 7.0){
        rect = CGRectMake(0.0f, 64, self.view.frame.size.width, self.view.frame.size.height);
    }
    self.view.frame = rect;
    [UIView commitAnimations];
    return YES;
}

- (BOOL) payOrder:(float)orderPrice withOrderID:(NSString*)orderID withOrderName:(NSString*)name withDesc:(NSString*)desc{
    NSLog(@"payorder");
    /*
	 *点击获取prodcut实例并初始化订单信息
	 */
	Product *product = [[Product alloc] init];
    product.price = orderPrice;//[[orderArray objectAtIndex:2] floatValue];
    product.orderId = orderID;//[self generateTradeNO];//[orderArray objectAtIndex:1];
    product.subject = name;
    product.body = desc;
    
    /*
     *商户的唯一的parnter和seller。
     *外部商户可以考虑存于服务端或本地其他地方。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    NSString *partner = ALIPAY_PARTNER;
    NSString *seller = ALIPAY_SELLER;
    //partner和seller获取失败,提示
	if ([partner length] == 0 || [seller length] == 0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
														message:@"缺少partner或者seller。"
													   delegate:self
											  cancelButtonTitle:@"确定"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return NO;
	}
    /*
	 *生成订单信息及签名
	 *可以存放在服务端或本地其他地方,确保安全性
	 */
	//将商品信息赋予AlixPayOrder的成员变量
    
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = orderID; //订单ID（由商家自行制定）
    order.productName = product.subject; //商品标题
    order.productDescription = product.body; //商品描述
    order.amount = @"0.01"; //商品价格
    order.notifyURL = @"http://www.yunlai.cn"; //回调URL
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    //NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner([[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA private key"]);
    NSString *signedString = [signer signString:orderSpec];
    
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types,用于安全支付成功后重新唤起商户应用
    NSString *appScheme = @"ShopingTempleate";
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            int resurtInt = [[resultDic objectForKey:@"resultStatus"] intValue];
            if (resurtInt == 9000) {
                NSLog(@"支付成功");
            } else {
                NSLog(@"支付失败");
            }
        }];
    }
    
//    AlixPayOrder *order = [[AlixPayOrder alloc] init];
//	order.partner = partner;
//	order.seller = seller;
//	order.tradeNO = orderID;//订单ID（由商家自行制定）
//	order.productName = product.subject; //商品标题
//	order.productDescription = product.body; //商品描述
//	order.amount = @"0.01";//[NSString stringWithFormat:@"%.2f",product.price]; //商品价格
//	order.notifyURL =  @"http://www.yunlai.cn"; //回调URL
//    
//    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types,用于安全支付成功后重新唤起商户应用
//	NSString *appScheme = @"ShopingTempleate";
//    
//    //将商品信息拼接成字符串
//	NSString *orderSpec = [order description];
//	NSLog(@"orderSpec = %@",orderSpec);
//	
//	//获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//	id<DataSigner> signer = CreateRSADataSigner([[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA private key"]);
//	NSString *signedString = [signer signString:orderSpec];
//    
//    //将签名成功字符串格式化为订单字符串,请严格按照该格式
//	NSString *orderString = nil;
//	if (signedString != nil) {
//		orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                       orderSpec, signedString, @"RSA"];
//        NSLog(@"orderString = %@",orderString);
//        
//        //获取安全支付单例并调用安全支付接口
//        AlixPay * alixpay = [AlixPay shared];
//        int ret = [alixpay pay:orderString applicationScheme:appScheme];
//        
//        if (ret == kSPErrorAlipayClientNotInstalled) {
//            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                 message:@"您还没有安装支付宝快捷支付，请先安装。"
//                                                                delegate:self
//                                                       cancelButtonTitle:@"确定"
//                                                       otherButtonTitles:nil];
//            [alertView setTag:123];
//            [alertView show];
//            [alertView release];
//        }
//        else if (ret == kSPErrorSignError) {
//            NSLog(@"签名错误！");
//        }
//        
//	}
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView.tag == 123) {
		NSString * URLString = @"http://itunes.apple.com/cn/app/id535715926?mt=8";
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
	}
}

@end
