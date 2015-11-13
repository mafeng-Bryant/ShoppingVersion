//
//  MyOrderDetailViewController.m
//  shopping
//
//  Created by 来 云 on 13-1-21.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MyOrderDetailViewController.h"
#import "Common.h"
#import "DataManager.h"
#import "DBOperate.h"
#import "UIImageScale.h"
#import "FileManager.h"
#import "downloadParam.h"
#import "imageDownLoadInWaitingObject.h"
#import "IconDownLoader.h"
#import "callSystemApp.h"
#import "WriteCommentViewController.h"
#import "ProductDetailViewController.h"
#import "alertView.h"
#import "PayOrderByAlipay.h"
//#import "AlixPayOrder.h"
//#import "AlixPayResult.h"
//#import "AlixPay.h"
//#import "DataSigner.h"

#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"

#import "Product.h"

@interface MyOrderDetailViewController ()

@end

@implementation MyOrderDetailViewController
@synthesize myTableView;
@synthesize orderIdStr;
@synthesize userId;
@synthesize listArray = __listArray;
@synthesize productsArray = __productsArray;
@synthesize imageDownloadsInProgressDic;
@synthesize imageDownloadsInWaitingArray;
@synthesize commandOper;
@synthesize progressHUD;
@synthesize __orderType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        __listArray = [[NSMutableArray alloc] init];
        __productsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

static NSString *sectionTitles1[] = {@"  订单信息",@"  物流信息",@"  收货信息",@"  商品信息"};
static NSString *sectionTitles2[] = {@"  订单信息",@"  收货信息",@"  商品信息"};

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"订单详情";
    self.view.backgroundColor = [UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1.0];
    
    NSMutableDictionary *idip = [[NSMutableDictionary alloc]init];
	self.imageDownloadsInProgressDic = idip;
	[idip release];
	
	NSMutableArray *wait = [[NSMutableArray alloc]init];
	self.imageDownloadsInWaitingArray = wait;
	[wait release];
    
    picWidth = 70.0f;
    picHeight = 70.0f;
    
    
    NSDate* nowDate = [NSDate date];
    NSDateFormatter *outputFormat1 = [[NSDateFormatter alloc] init];
    [outputFormat1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString1 = [outputFormat1 stringFromDate:nowDate];
    NSDate *currentDate1 = [outputFormat1 dateFromString:dateString1];
    [outputFormat1 release];
    NSTimeInterval t1 = [currentDate1 timeIntervalSince1970];   //转化为时间戳
    long long int time1 = (long long int)t1;
    NSNumber *num = [NSNumber numberWithLongLong:time1];
    int currentInt = [num intValue];
    int intValue = [[self.listArray objectAtIndex:myorders_list_closetime] intValue] * 24 * 60 * 60;
    
    int type = [[self.listArray objectAtIndex:myorders_list_payresult] intValue];
    if (type == 3) {
        __orderType = OrderTypeSuccess;
    }else if (type == 0) {
        if ([[self.listArray objectAtIndex:myorders_list_createtime] intValue] + intValue < currentInt) {
            __orderType = OrderTypeCancel;
        }else {
            __orderType = OrderTypeNotPay;
        }
    }else if (type == 1) {
        __orderType = OrderTypeNotSend;
    }else if (type == 2) {
        __orderType = OrderTypeWaitReceive;
    }else {
        __orderType = OrderTypeCancel;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //NSLog(@"self.listArray===%@",self.listArray);
    UIBarButtonItem *mrightbto = nil;
    if (__orderType == OrderTypeNotPay) {
        mrightbto = [[UIBarButtonItem alloc]
                     initWithTitle:@"支付"
                     style:UIBarButtonItemStyleBordered
                     target:self
                     action:@selector(barBtnAction:)];
        mrightbto.tag = 1;
    }else if (__orderType == OrderTypeNotSend) {
        mrightbto = [[UIBarButtonItem alloc]
                     initWithTitle:@"联系卖家"
                     style:UIBarButtonItemStyleBordered
                     target:self
                     action:@selector(barBtnAction:)];
        mrightbto.tag = 2;
    }else if (__orderType == OrderTypeWaitReceive){
        mrightbto = [[UIBarButtonItem alloc]
                     initWithTitle:@"确认收货"
                     style:UIBarButtonItemStyleBordered
                     target:self
                     action:@selector(barBtnAction:)];    
        mrightbto.tag = 3;
    }
    self.navigationItem.rightBarButtonItem = mrightbto;
    [mrightbto release];
    
    if (__orderType == OrderTypeNotPay) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 44) style:UITableViewStyleGrouped];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIImage *backgroundImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"表的背景" ofType:@"png"]];
        _myTableView.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
        _myTableView.backgroundView = nil;
        [self.view addSubview:_myTableView];
        [backgroundImage release];
        
        UIImage *barImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"订单下bar" ofType:@"png"]];
        UIImageView *barImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, 320, 44)];
        barImageView.image = barImage;
        barImageView.userInteractionEnabled = YES;
        [self.view addSubview:barImageView];
        [barImage release];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 60, 20)];
        label.text = @"总金额：";
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textAlignment = UITextAlignmentLeft;
        label.backgroundColor = [UIColor clearColor];
        [barImageView addSubview:label];
        [label release];
        
        UILabel *price = [[UILabel alloc] init];
        price.text = [NSString stringWithFormat:@"¥ %.2f",[[self.listArray objectAtIndex:myorders_list_price] doubleValue]];
        price.textColor = [UIColor redColor];
        price.font = [UIFont systemFontOfSize:14.0f];
        price.textAlignment = UITextAlignmentLeft;
        price.backgroundColor = [UIColor clearColor];
        [barImageView addSubview:price];
        
        CGSize constraint = CGSizeMake(80, 20000.0f);
        CGSize size = [price.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        price.frame = CGRectMake(CGRectGetMaxX(label.frame) , 12, size.width, 20);
        [price release];
        
        UIImage *barBtnImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"订单_按钮" ofType:@"png"]];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(320 - barBtnImage.size.width, 0, barBtnImage.size.width , barBtnImage.size.height);
        [button addTarget:self action:@selector(gotoPayAction) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:barBtnImage forState:UIControlStateNormal];
        [button setTitle:@"前往支付宝" forState:UIControlStateNormal];
        [barImageView addSubview:button];
        
        [barImageView release];
        
    }else {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStyleGrouped];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UIImage *backgroundImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"表的背景" ofType:@"png"]];
        _myTableView.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
        _myTableView.backgroundView = nil;
        [self.view addSubview:_myTableView];
    }
    
    [self.myTableView reloadData];
}

- (void)dealloc
{
    [_myTableView release];
    [orderIdStr release];
    [userId release];
    [__listArray release];
    [__productsArray release];
    [imageDownloadsInProgressDic release];
	imageDownloadsInProgressDic = nil;
	[imageDownloadsInWaitingArray release];
	imageDownloadsInWaitingArray = nil;
	for (IconDownLoader *one in [imageDownloadsInProgressDic allValues]){
		one.delegate = nil;
	}
    self.commandOper.delegate = nil;
	self.commandOper = nil;
    progressHUD.delegate = nil;
    [progressHUD release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.commandOper.delegate = nil;
	self.commandOper = nil;
    progressHUD.delegate = nil;
    progressHUD = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (__orderType == OrderTypeSuccess || __orderType == OrderTypeWaitReceive) {
        return 6;
    }else {
        return 5;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else {
        if (__orderType == OrderTypeSuccess || __orderType == OrderTypeWaitReceive) {
            switch (section) {
                case 1:
                    return 3;
                    break;
                case 2:
                    return 2;
                    break;
                case 3:
                    return 4;
                    break;
                case 4:
                    return [self.productsArray count];
                    break;
                case 5:
                    return 1;
                    break;
                default:
                    return 0;
                    break;
            }
        }else {
            switch (section) {
                case 1:
                {
                    if (__orderType == OrderTypeNotPay) {
                        return 3;
                    }else if (__orderType == OrderTypeNotSend) {
                        return 3;
                    }else {
                        return 2;
                    }
                }
                    break;
                case 2:
                    return 4;
                    break;
                case 3:
                    return [self.productsArray count];
                    break;
                case 4:
                    return 1;
                    break;
                    
                default:
                    return 0;
                    break;
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (__orderType == OrderTypeSuccess || __orderType == OrderTypeWaitReceive) {
        if (section == 0 || section == 5) {
            return 0;
        }else {
            return 20;
        }
    }else {
        if (section == 0 || section == 4) {
            return 0;
        }else {
            return 20;
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 5) {
        return nil;
    }else if (section == 4) {
        if (__orderType == OrderTypeSuccess || __orderType == OrderTypeWaitReceive) {
            UIImage *backgroundImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"表的背景" ofType:@"png"]];
            UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
            headView.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
            
            UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"分割线_虚线.png"]];
            imgV.frame = CGRectMake(0, 10, 320, 1);
            [headView addSubview:imgV];
            [imgV release];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 88, 16)];
            label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"小栏目背景.png"]];
            
            if (__orderType == OrderTypeSuccess || __orderType == OrderTypeWaitReceive) {
                label.text = sectionTitles1[section - 1];
            }else {
                label.text = sectionTitles2[section - 1];
            }
            
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = 1;
            [headView addSubview:label];
            [label release];
            
            return headView;
        }else {
            return nil;
        }
    }else {
        UIImage *backgroundImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"表的背景" ofType:@"png"]];
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        headView.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
        
        UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"分割线_虚线.png"]];
        imgV.frame = CGRectMake(0, 10, 320, 1);
        [headView addSubview:imgV];
        [imgV release];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 88, 16)];
        label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"小栏目背景.png"]];
        
        if (__orderType == OrderTypeSuccess || __orderType == OrderTypeWaitReceive) {
            label.text = sectionTitles1[section - 1];
        }else {
            label.text = sectionTitles2[section - 1];
        }
        
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = 1;
        [headView addSubview:label];
        [label release];
        
        return headView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ((__orderType == OrderTypeSuccess && section == 5) || (__orderType == OrderTypeWaitReceive && section == 5) || (__orderType == OrderTypeNotPay && section == 4) || (__orderType == OrderTypeNotSend && section == 4) || (__orderType == OrderTypeCancel && section == 4)) {
        return 60;
    }else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ((__orderType == OrderTypeSuccess && section == 5) || (__orderType == OrderTypeWaitReceive && section == 5) || (__orderType == OrderTypeNotPay && section == 4) || (__orderType == OrderTypeNotSend && section == 4) || (__orderType == OrderTypeCancel && section == 4)) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 55)];
        footerView.backgroundColor = [UIColor clearColor];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 320, 500)];
        view.backgroundColor = [UIColor colorWithRed:0.200 green:0.200 blue:0.200 alpha:1.0];
        [footerView addSubview:view];
        
        UIImage *bottomImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"订单花边" ofType:@"png"]];
        UIImageView *bottomView = [[UIImageView alloc] initWithImage:bottomImage];
        bottomView.frame = CGRectMake(0, 50, 320, bottomImage.size.height);
        [footerView addSubview:bottomView];

        if (__orderType == OrderTypeNotPay) {
            UIImage *img = [UIImage imageNamed:@"button_白色.png"];
            img = [img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:0];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(100,  15, 120, 30);
            [button addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundImage:img forState:UIControlStateNormal];
            [footerView addSubview:button];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
            label.text = @"取消订单";
            label.textColor = [UIColor darkGrayColor];
            label.font = [UIFont systemFontOfSize:14.0f];
            label.textAlignment = UITextAlignmentCenter;
            label.backgroundColor = [UIColor clearColor];
            [button addSubview:label];
            [label release];
        }else {
            UILabel *price = [[UILabel alloc] init];
            price.text = [NSString stringWithFormat:@"¥ %.2f",[[self.listArray objectAtIndex:myorders_list_price] doubleValue]];
            price.textColor = [UIColor redColor];
            price.font = [UIFont systemFontOfSize:14.0f];
            price.textAlignment = UITextAlignmentLeft;
            price.backgroundColor = [UIColor clearColor];
            [footerView addSubview:price];
            
            CGSize constraint = CGSizeMake(80, 20000.0f);
            CGSize size = [price.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            price.frame = CGRectMake(300 - size.width , 15, size.width, 20);
            [price release];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(300 - size.width - 60, 15, 60, 20)];
            label.text = @"总金额：";
            label.textColor = [UIColor darkGrayColor];
            label.font = [UIFont systemFontOfSize:12.0f];
            label.textAlignment = UITextAlignmentLeft;
            label.backgroundColor = [UIColor clearColor];
            [footerView addSubview:label];
            [label release];
        }
        return footerView;
    }else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (__orderType == OrderTypeSuccess || __orderType == OrderTypeWaitReceive) {
        if (indexPath.section == 3 && indexPath.row ==3) {
            CGSize constraint = CGSizeMake(200, 20000.0f);
            CGSize size = [[self.listArray objectAtIndex:myorders_list_contact_address] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            return size.height;
        }else if (indexPath.section == 4) {
            return 86;
        }else if (indexPath.section == 5) {
            return 70;
        }else {
            return 25;
        }
    }else {
        if (indexPath.section == 2 && indexPath.row ==3) {
            CGSize constraint = CGSizeMake(200, 20000.0f);
            CGSize size = [[self.listArray objectAtIndex:myorders_list_contact_address] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            return size.height;
        }else if (indexPath.section == 3) {
            return 86;
        }else if (indexPath.section == 4) {
            return 70;
        }else {
            return 25;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImage *backgroundImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"表的背景" ofType:@"png"]];
    UIView *cellBgView = [[UIView alloc] init];
    cellBgView.tag = 'c';
    cellBgView.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    cellBgView.userInteractionEnabled = YES;
    [cell addSubview:cellBgView];
    
    if (__orderType == OrderTypeSuccess || __orderType == OrderTypeWaitReceive) {
        if (indexPath.section == 3 && indexPath.row ==3) {
            CGSize constraint = CGSizeMake(200, 20000.0f);
            CGSize size = [[self.listArray objectAtIndex:myorders_list_contact_address] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            cellBgView.frame = CGRectMake(0, 0, 320, size.height);
        }else if (indexPath.section == 4) {
            cellBgView.frame = CGRectMake(0, 0, 320, 87);
        }else if (indexPath.section == 5) {
            cellBgView.frame = CGRectMake(0, 0, 320, 71);
        }else {
            cellBgView.frame = CGRectMake(0, 0, 320, 26);
        }
    }else {
        if (indexPath.section == 2 && indexPath.row ==3) {
            CGSize constraint = CGSizeMake(200, 20000.0f);
            CGSize size = [[self.listArray objectAtIndex:myorders_list_contact_address] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            cellBgView.frame = CGRectMake(0, 0, 320, size.height);
        }else if (indexPath.section == 3) {
            cellBgView.frame = CGRectMake(0, 0, 320, 87);
        }else if (indexPath.section == 4) {
            cellBgView.frame = CGRectMake(0, 0, 320, 71);
        }else {
            cellBgView.frame = CGRectMake(0, 0, 320, 26);
        }
    }
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 100, 20)];
                    label.text = @"订单状态：";
                    label.textColor = [UIColor darkTextColor];
                    label.font = [UIFont systemFontOfSize:14.0f];
                    label.textAlignment = UITextAlignmentLeft;
                    label.backgroundColor = [UIColor clearColor];
                    [cellBgView addSubview:label];
                    
                    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 8, 80, 20)];
                    label2.text = @"";
                    label2.textColor = [UIColor darkTextColor];
                    label2.font = [UIFont systemFontOfSize:14.0f];
                    label2.textAlignment = UITextAlignmentLeft;
                    label2.backgroundColor = [UIColor clearColor];
                    [cellBgView addSubview:label2];
                    
                    if (__orderType == OrderTypeSuccess) {
                        label2.text = @"交易成功";
                    }else if (__orderType == OrderTypeNotPay) {
                        label2.text = @"未支付";
                    }else if (__orderType == OrderTypeNotSend) {
                        label2.text = @"未发货";
                    }else if (__orderType == OrderTypeWaitReceive) {
                        label2.text = @"等待收货";
                    }else {
                        label2.text = @"已关闭";
                    }
                    [label release];
                    [label2 release];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            if (__orderType == OrderTypeSuccess) {
                switch (indexPath.row) {
                    case 0:
                    {
                        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 100, 20)];
                        label1.text = @"订单编号：";
                        label1.textColor = [UIColor darkTextColor];
                        label1.font = [UIFont systemFontOfSize:14.0f];
                        label1.textAlignment = UITextAlignmentLeft;
                        label1.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:label1];
                        [label1 release];
                        
                        UILabel *labelStr1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame), 3, 150, 20)];
                        labelStr1.text = @"";
                        labelStr1.text = [NSString stringWithFormat:@"%@",[self.listArray objectAtIndex:myorders_list_billno]];
                        labelStr1.textColor = [UIColor darkTextColor];
                        labelStr1.font = [UIFont systemFontOfSize:14.0f];
                        labelStr1.textAlignment = UITextAlignmentLeft;
                        labelStr1.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:labelStr1];
                        [labelStr1 release];
                    }
                        break;
                    case 1:
                    {
                        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 100, 20)];
                        label3.text = @"成交时间：";
                        label3.textColor = [UIColor darkTextColor];
                        label3.font = [UIFont systemFontOfSize:14.0f];
                        label3.textAlignment = UITextAlignmentLeft;
                        label3.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:label3];
                        [label3 release];
                        
                        int createTime = [[self.listArray objectAtIndex:myorders_list_confirmtime] intValue];
                                            
                        NSDate* date = [NSDate dateWithTimeIntervalSince1970:createTime];
                        NSDateFormatter *outputFormat = [[NSDateFormatter alloc] init];
                        [outputFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        NSString *dateString = [outputFormat stringFromDate:date];
                        [outputFormat release];
                        
                        UILabel *labelStr3 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label3.frame), 3, 150, 20)];
                        if (createTime == 0) {
                            labelStr3.text = @"————————————";
                        }else {
                            labelStr3.text = dateString;
                        }
                        labelStr3.textColor = [UIColor darkTextColor];
                        labelStr3.font = [UIFont systemFontOfSize:14.0f];
                        labelStr3.textAlignment = UITextAlignmentLeft;
                        labelStr3.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:labelStr3];
                        [labelStr3 release];
                    }
                        break;
                    case 2:
                    {
                        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 100, 20)];
                        label4.text = @"订单备注：";
                        label4.textColor = [UIColor darkTextColor];
                        label4.font = [UIFont systemFontOfSize:14.0f];
                        label4.textAlignment = UITextAlignmentLeft;
                        label4.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:label4];
                        [label4 release];
                        
                        UILabel *labelStr4 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label4.frame), 3, 150, 20)];
                        labelStr4.text = [self.listArray objectAtIndex:myorders_list_contact_remark];
                        labelStr4.textColor = [UIColor darkTextColor];
                        labelStr4.font = [UIFont systemFontOfSize:14.0f];
                        labelStr4.textAlignment = UITextAlignmentLeft;
                        labelStr4.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:labelStr4];
                        [labelStr4 release];
                    }
                        break;
                    default:
                        break;
                }
            }else if (__orderType == OrderTypeCancel){
                switch (indexPath.row) {
                    case 0:
                    {
                        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 100, 20)];
                        label1.text = @"订单编号：";
                        label1.textColor = [UIColor darkTextColor];
                        label1.font = [UIFont systemFontOfSize:14.0f];
                        label1.textAlignment = UITextAlignmentLeft;
                        label1.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:label1];
                        [label1 release];
                        
                        UILabel *labelStr1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame), 3, 150, 20)];
                        labelStr1.text = [NSString stringWithFormat:@"%@",[self.listArray objectAtIndex:myorders_list_billno]];
                        labelStr1.textColor = [UIColor darkTextColor];
                        labelStr1.font = [UIFont systemFontOfSize:14.0f];
                        labelStr1.textAlignment = UITextAlignmentLeft;
                        labelStr1.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:labelStr1];
                        [labelStr1 release];
                    }
                        break;
                    case 1:
                    {
                        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 100, 20)];
                        label4.text = @"订单备注：";
                        label4.textColor = [UIColor darkTextColor];
                        label4.font = [UIFont systemFontOfSize:14.0f];
                        label4.textAlignment = UITextAlignmentLeft;
                        label4.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:label4];
                        [label4 release];
                        
                        UILabel *labelStr4 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label4.frame), 3, 150, 20)];
                        labelStr4.text = [self.listArray objectAtIndex:myorders_list_contact_remark];
                        labelStr4.textColor = [UIColor darkTextColor];
                        labelStr4.font = [UIFont systemFontOfSize:14.0f];
                        labelStr4.textAlignment = UITextAlignmentLeft;
                        labelStr4.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:labelStr4];
                        [labelStr4 release];
                    }
                        break;    
                    default:
                        break;
                }
            }else {
                switch (indexPath.row) {
                    case 0:
                    {
                        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 100, 20)];
                        label1.text = @"订单编号：";
                        label1.textColor = [UIColor darkTextColor];
                        label1.font = [UIFont systemFontOfSize:14.0f];
                        label1.textAlignment = UITextAlignmentLeft;
                        label1.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:label1];
                        [label1 release];
                        
                        UILabel *labelStr1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame), 3, 150, 20)];
                        labelStr1.text = [NSString stringWithFormat:@"%@",[self.listArray objectAtIndex:myorders_list_billno]];
                        labelStr1.textColor = [UIColor darkTextColor];
                        labelStr1.font = [UIFont systemFontOfSize:14.0f];
                        labelStr1.textAlignment = UITextAlignmentLeft;
                        labelStr1.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:labelStr1];
                        [labelStr1 release];
                    }
                        break;
                    case 1:
                    {
                        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 100, 20)];
                        label3.text = @"下单时间：";
                        label3.textColor = [UIColor darkTextColor];
                        label3.font = [UIFont systemFontOfSize:14.0f];
                        label3.textAlignment = UITextAlignmentLeft;
                        label3.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:label3];
                        [label3 release];
                        
                        int createTime = [[self.listArray objectAtIndex:myorders_list_createtime] intValue];
                        NSDate* date = [NSDate dateWithTimeIntervalSince1970:createTime];
                        NSDateFormatter *outputFormat = [[NSDateFormatter alloc] init];
                        [outputFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        NSString *dateString = [outputFormat stringFromDate:date];
                        [outputFormat release];
                        
                        UILabel *labelStr3 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label3.frame), 3, 150, 20)];
                        labelStr3.text = dateString;
                        labelStr3.textColor = [UIColor darkTextColor];
                        labelStr3.font = [UIFont systemFontOfSize:14.0f];
                        labelStr3.textAlignment = UITextAlignmentLeft;
                        labelStr3.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:labelStr3];
                        [labelStr3 release];
                    }
                        break; 
                    case 2:
                    {
                        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 100, 20)];
                        label4.text = @"订单备注：";
                        label4.textColor = [UIColor darkTextColor];
                        label4.font = [UIFont systemFontOfSize:14.0f];
                        label4.textAlignment = UITextAlignmentLeft;
                        label4.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:label4];
                        [label4 release];
                        
                        UILabel *labelStr4 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label4.frame), 3, 150, 20)];
                        labelStr4.text = [self.listArray objectAtIndex:myorders_list_contact_remark];
                        labelStr4.textColor = [UIColor darkTextColor];
                        labelStr4.font = [UIFont systemFontOfSize:14.0f];
                        labelStr4.textAlignment = UITextAlignmentLeft;
                        labelStr4.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:labelStr4];
                        [labelStr4 release];
                    }
                        break; 
                    default:
                        break;
                }
            }
        }
            break;
        case 2:
        {
            if (__orderType == OrderTypeCancel || __orderType == OrderTypeNotPay || __orderType == OrderTypeNotSend) {
                switch (indexPath.row) {
                    case 0:
                    {
                        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 100, 20)];
                        label1.text = @"收货人：";
                        label1.textColor = [UIColor darkTextColor];
                        label1.font = [UIFont systemFontOfSize:14.0f];
                        label1.textAlignment = UITextAlignmentLeft;
                        label1.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:label1];
                        [label1 release];
                        
                        UILabel *labelStr1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame), 3, 150, 20)];
                        labelStr1.text = [self.listArray objectAtIndex:myorders_list_contact_name];
                        labelStr1.textColor = [UIColor darkTextColor];
                        labelStr1.font = [UIFont systemFontOfSize:14.0f];
                        labelStr1.textAlignment = UITextAlignmentLeft;
                        labelStr1.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:labelStr1];
                        [labelStr1 release];
                    }
                        break;
                    case 1:
                    {
                        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 100, 20)];
                        label1.text = @"手机：";
                        label1.textColor = [UIColor darkTextColor];
                        label1.font = [UIFont systemFontOfSize:14.0f];
                        label1.textAlignment = UITextAlignmentLeft;
                        label1.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:label1];
                        [label1 release];
                        
                        UILabel *labelStr1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame), 3, 150, 20)];
                        labelStr1.text = [self.listArray objectAtIndex:myorders_list_contact_mobile];
                        labelStr1.textColor = [UIColor darkTextColor];
                        labelStr1.font = [UIFont systemFontOfSize:14.0f];
                        labelStr1.textAlignment = UITextAlignmentLeft;
                        labelStr1.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:labelStr1];
                        [labelStr1 release];
                    }
                        break;
                    case 2:
                    {
                        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 100, 20)];
                        label1.text = @"邮政编码：";
                        label1.textColor = [UIColor darkTextColor];
                        label1.font = [UIFont systemFontOfSize:14.0f];
                        label1.textAlignment = UITextAlignmentLeft;
                        label1.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:label1];
                        [label1 release];
                        
                        UILabel *labelStr1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame), 3, 150, 20)];
                        labelStr1.text = [self.listArray objectAtIndex:myorders_list_contact_code];
                        labelStr1.textColor = [UIColor darkTextColor];
                        labelStr1.font = [UIFont systemFontOfSize:14.0f];
                        labelStr1.textAlignment = UITextAlignmentLeft;
                        labelStr1.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:labelStr1];
                        [labelStr1 release];
                    }
                        break;
                    case 3:
                    {
                        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 100, 20)];
                        label1.text = @"收货地址：";
                        label1.textColor = [UIColor darkTextColor];
                        label1.font = [UIFont systemFontOfSize:14.0f];
                        label1.textAlignment = UITextAlignmentLeft;
                        label1.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:label1];
                        [label1 release];
                        
                        UILabel *labelStr1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame), 2, 200, 20)];
                        labelStr1.text = [self.listArray objectAtIndex:myorders_list_contact_address];
                        labelStr1.numberOfLines = 0;
                        labelStr1.lineBreakMode = UILineBreakModeWordWrap;
                        labelStr1.textColor = [UIColor darkTextColor];
                        labelStr1.font = [UIFont systemFontOfSize:14.0f];
                        labelStr1.textAlignment = UITextAlignmentLeft;
                        labelStr1.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:labelStr1];
                        [labelStr1 release];
                        
                        CGSize constraint = CGSizeMake(200, 20000.0f);
                        CGSize size = [labelStr1.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
                        label1.frame = CGRectMake(10, 2, 100, size.height);
                        labelStr1.frame = CGRectMake(CGRectGetMaxX(label1.frame), 2, 200, size.height);
                    }
                        break;
                        
                    default:
                        break;
                }
            }else {
                switch (indexPath.row) {
                    case 0:
                    {
                        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 100, 20)];
                        label1.text = @"物流公司：";
                        label1.textColor = [UIColor darkTextColor];
                        label1.font = [UIFont systemFontOfSize:14.0f];
                        label1.textAlignment = UITextAlignmentLeft;
                        label1.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:label1];
                        [label1 release];
                        
                        UILabel *labelStr1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame), 3, 150, 20)];
                        labelStr1.text = [self.listArray objectAtIndex:myorders_list_logistics];
                        labelStr1.textColor = [UIColor darkTextColor];
                        labelStr1.font = [UIFont systemFontOfSize:14.0f];
                        labelStr1.textAlignment = UITextAlignmentLeft;
                        labelStr1.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:labelStr1];
                        [labelStr1 release];
                    }
                        break;
                    case 1:
                    {
                        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 100, 20)];
                        label1.text = @"物流编号：";
                        label1.textColor = [UIColor darkTextColor];
                        label1.font = [UIFont systemFontOfSize:14.0f];
                        label1.textAlignment = UITextAlignmentLeft;
                        label1.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:label1];
                        [label1 release];
                        
                        UILabel *labelStr1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame), 3, 150, 20)];
                        labelStr1.text = [self.listArray objectAtIndex:myorders_list_logistics_num];
                        labelStr1.textColor = [UIColor darkTextColor];
                        labelStr1.font = [UIFont systemFontOfSize:14.0f];
                        labelStr1.textAlignment = UITextAlignmentLeft;
                        labelStr1.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:labelStr1];
                        [labelStr1 release];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
        }
            break;
        case 3:
        {
            if (__orderType == OrderTypeCancel || __orderType == OrderTypeNotPay || __orderType == OrderTypeNotSend) {
                UIImage *bgImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表背景" ofType:@"png"]];
                UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0 , bgImage.size.width, bgImage.size.height)];
                bgImageView.userInteractionEnabled = YES;
                [cellBgView addSubview:bgImageView];
                bgImageView.image = bgImage;
                [bgImage release];
                
                UIImageView *cImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 , (86 - 70) * 0.5 , 70, 70)];
                cImageView.tag = 10;
                [bgImageView addSubview:cImageView];
                
                NSString *picUrl = [[self.productsArray objectAtIndex:indexPath.row] objectAtIndex:order_products_list_pic];
                //NSString *picUrl = @"http://192.168.1.48:8080/SG_APPInterfaceServer/t_1.png";
                NSString *picName = [Common encodeBase64:(NSMutableData *)[picUrl dataUsingEncoding: NSUTF8StringEncoding]];
                
                if (picUrl.length > 1) 
                {
                    UIImage *pic = [[FileManager getPhoto:picName] fillSize:CGSizeMake(picWidth, picHeight)];
                    if (pic.size.width > 2)
                    {
                        UIImageView *vi = (UIImageView *)[cellBgView viewWithTag:10];
                        vi.image = pic;
                    }
                    else
                    {
                        UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表默认图片" ofType:@"png"]];
                        UIImageView *vi = (UIImageView *)[cellBgView viewWithTag:10];
                        vi.image = [defaultPic fillSize:CGSizeMake(picWidth, picHeight)];
                        
                        if (tableView.dragging == NO && tableView.decelerating == NO)
                        {
                            [self startIconDownload:picUrl forIndex:indexPath];
                        }
                    }
                }
                else
                {
                    UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表默认图片" ofType:@"png"]];
                    UIImageView *vi = (UIImageView *)[cellBgView viewWithTag:10];
                    vi.image = [defaultPic fillSize:CGSizeMake(picWidth, picHeight)];
                }

                UILabel *cName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cImageView.frame) + 10, 15, 200, 30)];
                //cName.text = @"[芒果缤纷]";
                cName.text = [[self.productsArray objectAtIndex:indexPath.row] objectAtIndex:order_products_list_title];
                cName.textColor = [UIColor darkTextColor];
                cName.tag = 11;
                cName.font = [UIFont systemFontOfSize:14.0f];
                cName.textAlignment = UITextAlignmentLeft;
                cName.backgroundColor = [UIColor clearColor];
                [bgImageView addSubview:cName];
                [cName release];
                
                UILabel *money = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cImageView.frame) + 10, CGRectGetMaxY(cName.frame) + 10, 100, 20)];
                //money.text = @"¥ 90.00";
                if ([[[self.productsArray objectAtIndex:indexPath.row] objectAtIndex:order_products_list_promotion_price] intValue] == 0) {
                    money.text = [NSString stringWithFormat:@"¥ %.2f",[[[self.productsArray objectAtIndex:indexPath.row] objectAtIndex:order_products_list_price] doubleValue]];
                }else {
                    money.text = [NSString stringWithFormat:@"¥ %.2f",[[[self.productsArray objectAtIndex:indexPath.row] objectAtIndex:order_products_list_promotion_price] doubleValue]];
                }
                money.textColor = [UIColor redColor];
                money.tag = 12;
                money.font = [UIFont systemFontOfSize:16.0f];
                money.textAlignment = UITextAlignmentLeft;
                money.backgroundColor = [UIColor clearColor];
                [bgImageView addSubview:money];
                [money release];
                
                UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(money.frame) + 10, CGRectGetMaxY(cName.frame)  + 10, 40, 20)];
                label2.text = @"数量:";
                label2.textColor = [UIColor darkTextColor];
                label2.font = [UIFont systemFontOfSize:14.0f];
                label2.textAlignment = UITextAlignmentLeft;
                label2.backgroundColor = [UIColor clearColor];
                [bgImageView addSubview:label2];
                [label2 release];
                
                UILabel *sum = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label2.frame), CGRectGetMaxY(cName.frame) + 10 , 100, 20)];
                //sum.text = @"2";
                sum.text = [NSString stringWithFormat:@"%d",[[[self.productsArray objectAtIndex:indexPath.row] objectAtIndex:order_products_list_product_num] intValue]];
                sum.textColor = [UIColor darkTextColor];
                sum.tag = 13;
                sum.font = [UIFont systemFontOfSize:14.0f];
                sum.textAlignment = UITextAlignmentLeft;
                sum.backgroundColor = [UIColor clearColor];
                [bgImageView addSubview:sum];
                [sum release];
                
                UIImage *rimg = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"右箭头" ofType:@"png"]];
                UIImageView *rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(297, (86 - rimg.size.height) * 0.5, 16, 11)];
                rightImage.image = rimg;
                [rimg release];
                [bgImageView addSubview:rightImage];
                [rightImage release];
                
                if (__orderType == OrderTypeSuccess) {
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    button.tag = indexPath.row + 10000;
                    button.frame = CGRectMake(320 - 67,55, 67, 22);
                    button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
                    [bgImageView addSubview:button];
                    
                    if ([[[self.productsArray objectAtIndex:indexPath.row] objectAtIndex:order_products_list_is_comment] intValue] == 1) {
                        [button setBackgroundImage:[UIImage imageNamed:@"评价_灰色.png"] forState:UIControlStateNormal];
                        [button setTitle:@"已评价" forState:UIControlStateNormal];
                    }else {
                        [button setBackgroundImage:[UIImage imageNamed:@"评价_橙色.png"] forState:UIControlStateNormal];
                        [button setTitle:@"写评价" forState:UIControlStateNormal];
                        [button addTarget:self action:@selector(writeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                    }
                }
                
                [bgImageView release];
            }else {
                switch (indexPath.row) {
                    case 0:
                    {
                        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 100, 20)];
                        label1.text = @"收货人：";
                        label1.textColor = [UIColor darkTextColor];
                        label1.font = [UIFont systemFontOfSize:14.0f];
                        label1.textAlignment = UITextAlignmentLeft;
                        label1.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:label1];
                        [label1 release];
                        
                        UILabel *labelStr1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame), 3, 150, 20)];
                        labelStr1.text = [self.listArray objectAtIndex:myorders_list_contact_name];
                        labelStr1.textColor = [UIColor darkTextColor];
                        labelStr1.font = [UIFont systemFontOfSize:14.0f];
                        labelStr1.textAlignment = UITextAlignmentLeft;
                        labelStr1.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:labelStr1];
                        [labelStr1 release];
                    }
                        break;
                    case 1:
                    {
                        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 100, 20)];
                        label1.text = @"手机：";
                        label1.textColor = [UIColor darkTextColor];
                        label1.font = [UIFont systemFontOfSize:14.0f];
                        label1.textAlignment = UITextAlignmentLeft;
                        label1.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:label1];
                        [label1 release];
                        
                        UILabel *labelStr1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame), 3, 150, 20)];
                        labelStr1.text = [self.listArray objectAtIndex:myorders_list_contact_mobile];
                        labelStr1.textColor = [UIColor darkTextColor];
                        labelStr1.font = [UIFont systemFontOfSize:14.0f];
                        labelStr1.textAlignment = UITextAlignmentLeft;
                        labelStr1.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:labelStr1];
                        [labelStr1 release];
                    }
                        break;
                    case 2:
                    {
                        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 100, 20)];
                        label1.text = @"邮政编码：";
                        label1.textColor = [UIColor darkTextColor];
                        label1.font = [UIFont systemFontOfSize:14.0f];
                        label1.textAlignment = UITextAlignmentLeft;
                        label1.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:label1];
                        [label1 release];
                        
                        UILabel *labelStr1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame), 3, 150, 20)];
                        labelStr1.text = [self.listArray objectAtIndex:myorders_list_contact_code];                        labelStr1.textColor = [UIColor darkTextColor];
                        labelStr1.font = [UIFont systemFontOfSize:14.0f];
                        labelStr1.textAlignment = UITextAlignmentLeft;
                        labelStr1.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:labelStr1];
                        [labelStr1 release];
                    }
                        break;
                    case 3:
                    {
                        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 100, 20)];
                        label1.text = @"收货地址：";
                        label1.textColor = [UIColor darkTextColor];
                        label1.font = [UIFont systemFontOfSize:14.0f];
                        label1.textAlignment = UITextAlignmentLeft;
                        label1.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:label1];
                        [label1 release];
                        
                        UILabel *labelStr1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame), 2, 200, 20)];
                        labelStr1.text = [self.listArray objectAtIndex:myorders_list_contact_address];
                        labelStr1.numberOfLines = 0;
                        labelStr1.lineBreakMode = UILineBreakModeWordWrap;
                        labelStr1.textColor = [UIColor darkTextColor];
                        labelStr1.font = [UIFont systemFontOfSize:14.0f];
                        labelStr1.textAlignment = UITextAlignmentLeft;
                        labelStr1.backgroundColor = [UIColor clearColor];
                        [cellBgView addSubview:labelStr1];
                        [labelStr1 release];
                        
                        CGSize constraint = CGSizeMake(200, 20000.0f);
                        CGSize size = [labelStr1.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
                        label1.frame = CGRectMake(10, 2, 100, size.height);
                        labelStr1.frame = CGRectMake(CGRectGetMaxX(label1.frame), 2, 200, size.height);
                    }
                        break;
                        
                    default:
                        break;
                }
            }
        }
            break;
        case 4:
        {
            if (__orderType == OrderTypeSuccess || __orderType == OrderTypeWaitReceive) {
                UIImage *bgImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表背景" ofType:@"png"]];
                UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0 , bgImage.size.width, bgImage.size.height)];
                bgImageView.userInteractionEnabled = YES;
                [cellBgView addSubview:bgImageView];
                bgImageView.image = bgImage;
                [bgImage release];
                
                UIImageView *cImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 , (86 - 70) * 0.5 , 70, 70)];
                cImageView.tag = 10;
                [bgImageView addSubview:cImageView];
                
                NSString *picUrl = [[self.productsArray objectAtIndex:indexPath.row] objectAtIndex:order_products_list_pic];
                NSString *picName = [Common encodeBase64:(NSMutableData *)[picUrl dataUsingEncoding: NSUTF8StringEncoding]];
                
                if (picUrl.length > 1)
                {
                    UIImage *pic = [[FileManager getPhoto:picName] fillSize:CGSizeMake(picWidth, picHeight)];
                    if (pic.size.width > 2)
                    {
                        UIImageView *vi = (UIImageView *)[cellBgView viewWithTag:10];
                        vi.image = pic;
                    }
                    else
                    {
                        UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表默认图片" ofType:@"png"]];
                        UIImageView *vi = (UIImageView *)[cellBgView viewWithTag:10];
                        vi.image = [defaultPic fillSize:CGSizeMake(picWidth, picHeight)];
                        
                        if (tableView.dragging == NO && tableView.decelerating == NO)
                        {
                            [self startIconDownload:picUrl forIndex:indexPath];
                        }
                    }
                }
                else
                {
                    UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表默认图片" ofType:@"png"]];
                    UIImageView *vi = (UIImageView *)[cellBgView viewWithTag:10];
                    vi.image = [defaultPic fillSize:CGSizeMake(picWidth, picHeight)];
                }
                
                UILabel *cName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cImageView.frame) + 10, 15, 200, 30)];
                cName.text = [[self.productsArray objectAtIndex:indexPath.row] objectAtIndex:order_products_list_title];
                cName.textColor = [UIColor darkTextColor];
                cName.tag = 11;
                cName.font = [UIFont systemFontOfSize:14.0f];
                cName.textAlignment = UITextAlignmentLeft;
                cName.backgroundColor = [UIColor clearColor];
                [bgImageView addSubview:cName];
                [cName release];
                
                UILabel *money = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cImageView.frame) + 10, CGRectGetMaxY(cName.frame) + 10, 100, 20)];
                if ([[[self.productsArray objectAtIndex:indexPath.row] objectAtIndex:order_products_list_promotion_price] intValue] == 0) {
                    money.text = [NSString stringWithFormat:@"¥ %.2f",[[[self.productsArray objectAtIndex:indexPath.row] objectAtIndex:order_products_list_price] doubleValue]];
                }else {
                    money.text = [NSString stringWithFormat:@"¥ %.2f",[[[self.productsArray objectAtIndex:indexPath.row] objectAtIndex:order_products_list_promotion_price] doubleValue]];
                }
                money.textColor = [UIColor redColor];
                money.tag = 12;
                money.font = [UIFont systemFontOfSize:16.0f];
                money.textAlignment = UITextAlignmentLeft;
                money.backgroundColor = [UIColor clearColor];
                [bgImageView addSubview:money];
                [money release];
                
                UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(money.frame) + 10, CGRectGetMaxY(cName.frame)  + 10, 40, 20)];
                label2.text = @"数量:";
                label2.textColor = [UIColor darkTextColor];
                label2.font = [UIFont systemFontOfSize:14.0f];
                label2.textAlignment = UITextAlignmentLeft;
                label2.backgroundColor = [UIColor clearColor];
                [bgImageView addSubview:label2];
                [label2 release];
                
                UILabel *sum = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label2.frame), CGRectGetMaxY(cName.frame) + 10 , 100, 20)];
                sum.text = [NSString stringWithFormat:@"%d",[[[self.productsArray objectAtIndex:indexPath.row] objectAtIndex:order_products_list_product_num] intValue]];
                sum.textColor = [UIColor darkTextColor];
                sum.tag = 13;
                sum.font = [UIFont systemFontOfSize:14.0f];
                sum.textAlignment = UITextAlignmentLeft;
                sum.backgroundColor = [UIColor clearColor];
                [bgImageView addSubview:sum];
                [sum release];
                
                UIImage *rimg = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"右箭头" ofType:@"png"]];
                UIImageView *rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(297, (86 - rimg.size.height) * 0.5, 16, 11)];
                rightImage.image = rimg;
                [rimg release];
                [bgImageView addSubview:rightImage];
                [rightImage release];
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.tag = indexPath.row + 10000;
                button.frame = CGRectMake(320 - 67,55, 67, 22);
                button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
                [bgImageView addSubview:button];
                
                if (__orderType == OrderTypeSuccess) {
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    button.tag = indexPath.row + 10000;
                    button.frame = CGRectMake(320 - 67,55, 67, 22);
                    button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
                    [bgImageView addSubview:button];
                    
                    if ([[[self.productsArray objectAtIndex:indexPath.row] objectAtIndex:order_products_list_is_comment] intValue] == 1) {
                        [button setBackgroundImage:[UIImage imageNamed:@"评价_灰色.png"] forState:UIControlStateNormal];
                        [button setTitle:@"已评价" forState:UIControlStateNormal];
                    }else {
                        [button setBackgroundImage:[UIImage imageNamed:@"评价_橙色.png"] forState:UIControlStateNormal];
                        [button setTitle:@"写评价" forState:UIControlStateNormal];
                        [button addTarget:self action:@selector(writeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                    }
                }
                
                [bgImageView release];
            }else {
                if (indexPath.row == 0) {
                    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"分割线_虚线.png"]];
                    imgV.frame = CGRectMake(0, 0, 320, 1);
                    [cellBgView addSubview:imgV];
                    [imgV release];
                    
                    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
                    label1.text = @"运费";
                    label1.textColor = [UIColor darkTextColor];
                    label1.font = [UIFont systemFontOfSize:14.0f];
                    label1.textAlignment = UITextAlignmentLeft;
                    label1.backgroundColor = [UIColor clearColor];
                    [cellBgView addSubview:label1];
                    [label1 release];
                    
                    UILabel *labelStr1 = [[UILabel alloc] initWithFrame:CGRectMake(160, 5, 150, 20)];
                    labelStr1.text = [NSString stringWithFormat:@"¥ %@",[self.listArray objectAtIndex:myorders_list_logistics_price]];
                    labelStr1.textColor = [UIColor darkTextColor];
                    labelStr1.font = [UIFont systemFontOfSize:14.0f];
                    labelStr1.textAlignment = UITextAlignmentRight;
                    labelStr1.backgroundColor = [UIColor clearColor];
                    [cellBgView addSubview:labelStr1];
                    [labelStr1 release];
                    
                    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(label1.frame), 100, 20)];
                    label2.text = @"优惠卷";
                    label2.textColor = [UIColor darkTextColor];
                    label2.font = [UIFont systemFontOfSize:14.0f];
                    label2.textAlignment = UITextAlignmentLeft;
                    label2.backgroundColor = [UIColor clearColor];
                    [cellBgView addSubview:label2];
                    [label2 release];
                    
                    UILabel *labelStr2 = [[UILabel alloc] initWithFrame:CGRectMake(160, label2.frame.origin.y, 150, 20)];
                    labelStr2.text = [NSString stringWithFormat:@"- ¥ %@",[self.listArray objectAtIndex:myorders_list_pri_price]];
                    labelStr2.textColor = [UIColor darkTextColor];
                    labelStr2.font = [UIFont systemFontOfSize:14.0f];
                    labelStr2.textAlignment = UITextAlignmentRight;
                    labelStr2.backgroundColor = [UIColor clearColor];
                    [cellBgView addSubview:labelStr2];
                    [labelStr2 release];
                    
                    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(label2.frame), 100, 20)];
                    label3.text = @"满就送";
                    label3.textColor = [UIColor darkTextColor];
                    label3.font = [UIFont systemFontOfSize:14.0f];
                    label3.textAlignment = UITextAlignmentLeft;
                    label3.backgroundColor = [UIColor clearColor];
                    [cellBgView addSubview:label3];
                    [label3 release];
                    
                    UILabel *labelStr3 = [[UILabel alloc] initWithFrame:CGRectMake(160, label3.frame.origin.y, 150, 20)];
                    labelStr3.text = [NSString stringWithFormat:@"- ¥ %@",[self.listArray objectAtIndex:myorders_list_full_price]];
                    labelStr3.textColor = [UIColor darkTextColor];
                    labelStr3.font = [UIFont systemFontOfSize:14.0f];
                    labelStr3.textAlignment = UITextAlignmentRight;
                    labelStr3.backgroundColor = [UIColor clearColor];
                    [cellBgView addSubview:labelStr3];
                    [labelStr3 release];
                }
            }
        }
            break;
        case 5:{
            if (indexPath.row == 0) {
                UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"分割线_虚线.png"]];
                imgV.frame = CGRectMake(0, 0, 320, 1);
                [cellBgView addSubview:imgV];
                [imgV release];
                
                UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
                label1.text = @"运费";
                label1.textColor = [UIColor darkTextColor];
                label1.font = [UIFont systemFontOfSize:14.0f];
                label1.textAlignment = UITextAlignmentLeft;
                label1.backgroundColor = [UIColor clearColor];
                [cellBgView addSubview:label1];
                [label1 release];
                
                UILabel *labelStr1 = [[UILabel alloc] initWithFrame:CGRectMake(160, 5, 150, 20)];
                labelStr1.text = [NSString stringWithFormat:@"¥ %@",[self.listArray objectAtIndex:myorders_list_logistics_price]];
                labelStr1.textColor = [UIColor darkTextColor];
                labelStr1.font = [UIFont systemFontOfSize:14.0f];
                labelStr1.textAlignment = UITextAlignmentRight;
                labelStr1.backgroundColor = [UIColor clearColor];
                [cellBgView addSubview:labelStr1];
                [labelStr1 release];
                
                UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(label1.frame), 100, 20)];
                label2.text = @"优惠卷";
                label2.textColor = [UIColor darkTextColor];
                label2.font = [UIFont systemFontOfSize:14.0f];
                label2.textAlignment = UITextAlignmentLeft;
                label2.backgroundColor = [UIColor clearColor];
                [cellBgView addSubview:label2];
                [label2 release];
                
                UILabel *labelStr2 = [[UILabel alloc] initWithFrame:CGRectMake(160, label2.frame.origin.y, 150, 20)];
                labelStr2.text = [NSString stringWithFormat:@"- ¥ %@",[self.listArray objectAtIndex:myorders_list_pri_price]];
                labelStr2.textColor = [UIColor darkTextColor];
                labelStr2.font = [UIFont systemFontOfSize:14.0f];
                labelStr2.textAlignment = UITextAlignmentRight;
                labelStr2.backgroundColor = [UIColor clearColor];
                [cellBgView addSubview:labelStr2];
                [labelStr2 release];
                
                UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(label2.frame), 100, 20)];
                label3.text = @"满就送";
                label3.textColor = [UIColor darkTextColor];
                label3.font = [UIFont systemFontOfSize:14.0f];
                label3.textAlignment = UITextAlignmentLeft;
                label3.backgroundColor = [UIColor clearColor];
                [cellBgView addSubview:label3];
                [label3 release];
                
                UILabel *labelStr3 = [[UILabel alloc] initWithFrame:CGRectMake(160, label3.frame.origin.y, 150, 25)];
                labelStr3.text = [NSString stringWithFormat:@"- ¥ %@",[self.listArray objectAtIndex:myorders_list_full_price]];
                labelStr3.textColor = [UIColor darkTextColor];
                labelStr3.font = [UIFont systemFontOfSize:14.0f];
                labelStr3.textAlignment = UITextAlignmentRight;
                labelStr3.backgroundColor = [UIColor clearColor];
                [cellBgView addSubview:labelStr3];
                [labelStr3 release];
            }
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3 && (__orderType == OrderTypeCancel || __orderType == OrderTypeNotPay || __orderType == OrderTypeNotSend)) {
        NSArray *productArray = [self.productsArray objectAtIndex:[indexPath row]];
        
        if ([[productArray objectAtIndex:order_products_list_status] intValue] == 1) {
            ProductDetailViewController *ProductDetailView = [[ProductDetailViewController alloc] init];
            ProductDetailView.productID = [[productArray objectAtIndex:order_products_list_product_id] intValue];
            [self.navigationController pushViewController:ProductDetailView animated:YES];
            [ProductDetailView release];
        }else {
            [alertView showAlert:@"商品已下架"];
        }
    }else if (indexPath.section == 4 && (__orderType == OrderTypeSuccess || __orderType == OrderTypeWaitReceive)) {
        NSArray *productArray = [self.productsArray objectAtIndex:[indexPath row]];
        
        if ([[productArray objectAtIndex:order_products_list_status] intValue] == 1) {
            ProductDetailViewController *ProductDetailView = [[ProductDetailViewController alloc] init];
            ProductDetailView.productID = [[productArray objectAtIndex:order_products_list_product_id] intValue];
            [self.navigationController pushViewController:ProductDetailView animated:YES];
            [ProductDetailView release];
        }else {
            [alertView showAlert:@"商品已下架"];
        }
    }
}

#pragma mark ---- loadImage Method
- (void)startIconDownload:(NSString*)imageURL forIndex:(NSIndexPath*)index
{
	IconDownLoader *iconDownloader = [imageDownloadsInProgressDic objectForKey:index];
    if (iconDownloader == nil && imageURL != nil && imageURL.length > 1)
    {
		if (imageURL != nil && imageURL.length > 1) 
		{
			if ([imageDownloadsInProgressDic count] >= DOWNLOAD_IMAGE_MAX_COUNT) {
				imageDownLoadInWaitingObject *one = [[imageDownLoadInWaitingObject alloc]init:imageURL withIndexPath:index withImageType:CUSTOMER_PHOTO];
				[imageDownloadsInWaitingArray addObject:one];
				[one release];
				return;
			}
			
			IconDownLoader *iconDownloader = [[IconDownLoader alloc] init];
			iconDownloader.downloadURL = imageURL;
			iconDownloader.indexPathInTableView = index;
			iconDownloader.imageType = CUSTOMER_PHOTO;
			iconDownloader.delegate = self;
			[imageDownloadsInProgressDic setObject:iconDownloader forKey:index];
			[iconDownloader startDownload];
			[iconDownloader release];   
		}
	}    
}
- (void)appImageDidLoad:(NSIndexPath *)indexPath withImageType:(int)Type
{
    IconDownLoader *iconDownloader = [imageDownloadsInProgressDic objectForKey:indexPath];
	UITableViewCell *cell = (UITableViewCell *)[self.myTableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
	
    if (iconDownloader != nil)
    {
		if(iconDownloader.cardIcon.size.width > 2.0){ 			
			UIImage *photo = iconDownloader.cardIcon;
            NSString *imageurl = [[self.productsArray objectAtIndex:iconDownloader.indexPathInTableView.row] objectAtIndex:order_products_list_pic];
            NSString *photoname = [Common encodeBase64:(NSMutableData *)[imageurl dataUsingEncoding: NSUTF8StringEncoding]];
            
			if ([FileManager savePhoto:photoname withImage:photo]) {
                UIView *vi = (UIView *)[cell.contentView viewWithTag:'c'];
				UIImageView *imgView = (UIImageView *)[vi viewWithTag:10];
                imgView.image = photo;
			}
		}
		[imageDownloadsInProgressDic removeObjectForKey:indexPath];
		if ([imageDownloadsInWaitingArray count] > 0) {
			imageDownLoadInWaitingObject *one = [imageDownloadsInWaitingArray objectAtIndex:0];
			[self startIconDownload:one.imageURL forIndex:one.indexPath];
			[imageDownloadsInWaitingArray removeObjectAtIndex:0];
		}		
    }
}

#pragma mark -----MBProgressHUDDelegate method
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ----private method
- (void)barBtnAction:(id)sender
{
    UIBarButtonItem *btn = (UIBarButtonItem *)sender;
    switch (btn.tag) {
        case 1:
        {
            [self payOrder:[[self.listArray objectAtIndex:myorders_list_price] floatValue]withOrderID:[NSString stringWithFormat:@"%d",[[self.listArray objectAtIndex:myorders_list_id] intValue]] withOrderName:@"订单名称" withDesc:@"订单描述"];
        }
            break;
        case 2:
        {
            NSString *tel = [self.listArray objectAtIndex:myorders_list_telephone];
            [callSystemApp makeCall:tel];
        }
            break;
        case 3:
        {
            progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
            progressHUD.labelText = @"正在提交中... ";
            [self.view addSubview:progressHUD];
            [self.view bringSubviewToFront:progressHUD];
            [progressHUD show:YES];
            
            [self accessSureReceiveService];
        }
            break;
        default:
            break;
    }
}

- (void)cancleAction
{
    progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    progressHUD.labelText = @"正在提交中... ";
    [self.view addSubview:progressHUD];
    [self.view bringSubviewToFront:progressHUD];
    [progressHUD show:YES];
    
    [self accessService];
}

- (void)gotoPayAction
{
    orderID = [self.listArray objectAtIndex:myorders_list_billno];
    [self payOrder:[[self.listArray objectAtIndex:myorders_list_price] floatValue]withOrderID:[NSString stringWithFormat:@"%@",[self.listArray objectAtIndex:myorders_list_billno]] withOrderName:@"订单名称" withDesc:@"订单描述"];
}

- (void)accessService
{
    NSMutableDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [Common getSecureString],@"keyvalue",
                                        [NSNumber numberWithInt: SITE_ID],@"site_id",
                                        [NSNumber numberWithInt:[self.userId intValue]],@"user_id",
                                        [NSNumber numberWithInt:[self.orderIdStr intValue]],@"order_id",nil];
    
    [[DataManager sharedManager] accessService:jsontestDic command:CANCELORDER_COMMAND_ID accessAdress:@"book/cancelOrder.do?param=%@" delegate:self withParam:jsontestDic];
}

- (void)accessSureReceiveService
{
    NSMutableDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [Common getSecureString],@"keyvalue",
                                        [NSNumber numberWithInt: SITE_ID],@"site_id",
                                        [NSNumber numberWithInt:[self.userId intValue]],@"user_id",
                                        [NSNumber numberWithInt:[self.orderIdStr intValue]],@"order_id",nil];
    
    [[DataManager sharedManager] accessService:jsontestDic command:SURERECEIVEORDER_COMMAND_ID accessAdress:@"book/makesureorder.do?param=%@" delegate:self withParam:jsontestDic];
}

- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
	NSLog(@"information finish");
	//NSLog(@"=====%@",resultArray);
    switch (commandid) {
        case CANCELORDER_COMMAND_ID:
        {
            [self performSelectorOnMainThread:@selector(cancelResult:) withObject:resultArray waitUntilDone:NO];
        }
            break;
        case SURERECEIVEORDER_COMMAND_ID:
        {
            [self performSelectorOnMainThread:@selector(sureResult:) withObject:resultArray waitUntilDone:NO];
        }
            break;
        default:
            break;
    }
}

- (void)cancelResult:(NSMutableArray *)resultArray
{
    if (progressHUD != nil) {
        if (progressHUD) {
            [progressHUD hide:YES];
            [progressHUD removeFromSuperViewOnHide];
        }
    }
    //NSLog(@"resultArray====%@",resultArray);
    if ([resultArray count] > 0) {
        int ret = [[resultArray objectAtIndex:0] intValue];
        if (ret == 1) {
            MBProgressHUD *mprogressHUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:mprogressHUD];
            [self.view bringSubviewToFront:mprogressHUD];
            mprogressHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-ok.png"]] autorelease];
            mprogressHUD.mode = MBProgressHUDModeCustomView;
            mprogressHUD.labelText = @"取消成功";
            mprogressHUD.delegate = self;
            [mprogressHUD show:YES];
            [mprogressHUD hide:YES afterDelay:1.5];
            self.progressHUD = mprogressHUD;
            [mprogressHUD release];
        }else {
            MBProgressHUD *mprogressHUD = [[MBProgressHUD alloc] initWithView:self.view];
            mprogressHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-信息.png"]] autorelease];
            mprogressHUD.mode = MBProgressHUDModeCustomView;
            mprogressHUD.labelText = @"取消失败";
            [self.view addSubview:mprogressHUD];
            [self.view bringSubviewToFront:mprogressHUD];
            [mprogressHUD show:YES];
            [mprogressHUD hide:YES afterDelay:1.5];
            [mprogressHUD release];
        }
    }
}

- (void)sureResult:(NSMutableArray *)resultArray
{
    if (progressHUD != nil) {
        if (progressHUD) {
            [progressHUD hide:YES];
            [progressHUD removeFromSuperViewOnHide];
        }
    }
    //NSLog(@"resultArray====%@",resultArray);
    if ([resultArray count] > 0) {
        int ret = [[resultArray objectAtIndex:0] intValue];
        if (ret == 1) {
            MBProgressHUD *mprogressHUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:mprogressHUD];
            [self.view bringSubviewToFront:mprogressHUD];
            mprogressHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-ok.png"]] autorelease];
            mprogressHUD.mode = MBProgressHUDModeCustomView;
            mprogressHUD.labelText = @"确认成功";
            mprogressHUD.delegate = self;
            [mprogressHUD show:YES];
            [mprogressHUD hide:YES afterDelay:1.5];
            self.progressHUD = mprogressHUD;
            [mprogressHUD release];
        }else {
            MBProgressHUD *mprogressHUD = [[MBProgressHUD alloc] initWithView:self.view];
            mprogressHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-信息.png"]] autorelease];
            mprogressHUD.mode = MBProgressHUDModeCustomView;
            mprogressHUD.labelText = @"确认失败";
            [self.view addSubview:mprogressHUD];
            [self.view bringSubviewToFront:mprogressHUD];
            [mprogressHUD show:YES];
            [mprogressHUD hide:YES afterDelay:1.5];
            [mprogressHUD release];
        }
    }
}

- (void)writeBtnAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    int _info = [[[self.productsArray objectAtIndex:btn.tag - 10000] objectAtIndex:order_products_list_product_id] intValue];
    //NSLog(@"%d",_info);
    
    int _orderId = [[[self.productsArray objectAtIndex:btn.tag - 10000] objectAtIndex:order_products_list_order_id] intValue];

    WriteCommentViewController *write = [[WriteCommentViewController alloc] init];
    write.commentType = CommentTypeOrderDetail;
    write.infoIdStr = [NSString stringWithFormat:@"%d",_info];
    write.orderIdStr = [NSString stringWithFormat:@"%d",_orderId];
    [self.navigationController pushViewController:write animated:YES];
    [write release];
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

    
   /*
    AlixPayOrder *order = [[AlixPayOrder alloc] init];
	order.partner = partner;
	order.seller = seller;
	order.tradeNO = orderID;//订单ID（由商家自行制定）
	order.productName = product.subject; //商品标题
	order.productDescription = product.body; //商品描述
	order.amount = @"0.01";//[NSString stringWithFormat:@"%.2f",product.price]; //商品价格
	order.notifyURL =  @"http://www.yunlai.cn"; //回调URL
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types,用于安全支付成功后重新唤起商户应用
	NSString *appScheme = @"ShopingTempleate";
    
    //将商品信息拼接成字符串
	NSString *orderSpec = [order description];
	//NSLog(@"orderSpec = %@",orderSpec);
	
	//获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
	id<DataSigner> signer = CreateRSADataSigner([[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA private key"]);
	NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
	NSString *orderString = nil;
	if (signedString != nil) {
		orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        //NSLog(@"orderString = %@",orderString);
        
        //获取安全支付单例并调用安全支付接口
        AlixPay * alixpay = [AlixPay shared];
        int ret = [alixpay pay:orderString applicationScheme:appScheme];
        
        if (ret == kSPErrorAlipayClientNotInstalled) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"您还没有安装支付宝快捷支付，请先安装。"
                                                                delegate:self
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            [alertView setTag:123];
            [alertView show];
            [alertView release];
        }
        else if (ret == kSPErrorSignError) {
            NSLog(@"签名错误！");
        }
        
	}
    */
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView.tag == 123) {
		NSString * URLString = @"http://itunes.apple.com/cn/app/id535715926?mt=8";
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
	}
}
@end
