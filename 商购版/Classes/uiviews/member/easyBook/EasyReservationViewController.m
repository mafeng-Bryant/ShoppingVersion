//
//  EasyReservationViewController.m
//  shopping
//
//  Created by 来 云 on 13-1-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "EasyReservationViewController.h"
#import "Common.h"
#import "DBOperate.h"
#import "DataManager.h"
#import "AddOrEditReservationViewController.h"
@interface EasyReservationViewController ()

@end

@implementation EasyReservationViewController
@synthesize myTableView = _myTableView;
@synthesize listArray = __listArray;
@synthesize commandOper;
@synthesize userId;
@synthesize bookId;
@synthesize infoId;
@synthesize rowValue;
@synthesize spinner;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        __listArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"轻松购";
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 5, 320, self.view.frame.size.height- 60) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView];
    self.myTableView.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *mrightbto = [[UIBarButtonItem alloc]
                                  initWithTitle:@"新增"
                                  style:UIBarButtonItemStyleBordered
                                  target:self
                                  action:@selector(addAction)];
    self.navigationItem.rightBarButtonItem = mrightbto;
    [mrightbto release];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (noLabel != nil) {
        [noLabel removeFromSuperview];
    }
    
    [self accessService];
}

- (void)dealloc
{
    [_myTableView release];
    [__listArray release];
    [progressHUD release];
    self.commandOper.delegate = nil;
	self.commandOper = nil;
    [noLabel release];
    [super dealloc];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.commandOper.delegate = nil;
	self.commandOper = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0) {
		return [self.listArray count];
	}else {
		return 0;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section ==0) {
		return 86.0f;
	}else {
		return 0;
	}	
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if (section == 1) {
		UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
		UILabel *moreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 320, 30)];
		moreLabel.text = @"显示更多";
		moreLabel.tag = 200;
		moreLabel.textColor = [UIColor blackColor];
		moreLabel.textAlignment = UITextAlignmentCenter;
		moreLabel.backgroundColor = [UIColor clearColor];
		[vv addSubview:moreLabel];
		[moreLabel release];
		
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		btn.backgroundColor = [UIColor clearColor];
		btn.frame = CGRectMake(0, 0, 320, 50);
		[btn addTarget:self action:@selector(getMoreAction) forControlEvents:UIControlEventTouchUpInside];
		[vv addSubview:btn];
		
		//添加loading图标
		indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
		[indicatorView setCenter:CGPointMake(320 / 3, 50 / 2.0)];
		indicatorView.hidesWhenStopped = YES;
		[vv addSubview:indicatorView];
		
		UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 49, 320, 1)];
		lab.backgroundColor = [UIColor grayColor];
		
		[vv addSubview:lab];
		[lab release];
		return vv;
	}else {
		return nil;		
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if (section == 1 && self.listArray.count >= 20) {
		return 50;
	}else {
		return 0;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	
	//NSInteger row = [indexPath row];
	
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImage *bgImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表背景" ofType:@"png"]];
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0 , bgImage.size.width, bgImage.size.height)];
        bgImageView.userInteractionEnabled = YES;
        [cell.contentView addSubview:bgImageView];
        bgImageView.image = bgImage;
        [bgImage release];
        
        UIImage *btnImg1 = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"input_未选中" ofType:@"png"]];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(15, (86 - btnImg1.size.height) * 0.5, btnImg1.size.width, btnImg1.size.height);
        [button addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = indexPath.row + 10000;
        [bgImageView addSubview:button];
        [button setImage:btnImg1 forState:UIControlStateNormal];
        
        UILabel *cName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button.frame) + 10, 10, 200, 25)];
		cName.text = @"";
        cName.textColor = [UIColor darkTextColor];
        cName.tag = 'n';
		cName.font = [UIFont systemFontOfSize:16.0f];
		cName.textAlignment = UITextAlignmentLeft;
		cName.backgroundColor = [UIColor clearColor];
		[bgImageView addSubview:cName];
        [cName release];
        
        UILabel *cAddr = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button.frame) + 10, CGRectGetMaxY(cName.frame), 200, 40)];
		cAddr.text = @"深圳市南山区科技园留学生创业大厦906 云来网络 111111";
        cAddr.textColor = [UIColor darkGrayColor];
        cAddr.numberOfLines = 0;
        cAddr.lineBreakMode = UILineBreakModeWordWrap;
        cAddr.tag = 'a';
		cAddr.font = [UIFont systemFontOfSize:14.0f];
		cAddr.textAlignment = UITextAlignmentLeft;
		cAddr.backgroundColor = [UIColor clearColor];
		[bgImageView addSubview:cAddr];
        [cAddr release];
        
        UIView *btnBGView = [[UIView alloc] initWithFrame:CGRectMake(305 - 50,  30, 50, 30)];
        btnBGView.backgroundColor = [UIColor clearColor];
        btnBGView.userInteractionEnabled = YES;
        btnBGView.tag = 'v';
        [bgImageView addSubview:btnBGView];
        
        UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        changeBtn.tag = indexPath.row + 1;
        changeBtn.frame = CGRectMake(0, 0, 50, 30);
        [changeBtn addTarget:self action:@selector(changeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [changeBtn setBackgroundImage:[UIImage imageNamed:@"button_白色.png"] forState:UIControlStateNormal];
        [btnBGView addSubview:changeBtn];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
		label.text = @"修改";
        label.textColor = [UIColor darkGrayColor];
		label.font = [UIFont systemFontOfSize:16.0f];
		label.textAlignment = UITextAlignmentCenter;
		label.backgroundColor = [UIColor clearColor];
		[changeBtn addSubview:label];
        [label release];
        
        [btnBGView release];
        
        [bgImageView release];
    }
    if ([self.listArray count] > 0 && indexPath.row < [self.listArray count]) {
        NSArray *ayArr = [self.listArray objectAtIndex:indexPath.row];
        
        UIImage *btnImg1 = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"input_未选中" ofType:@"png"]];
        UIImage *btnImg2 = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"input_选中" ofType:@"png"]];
        
        UIButton *btn = (UIButton *)[cell.contentView viewWithTag:indexPath.row + 10000];
        
        int value = [[ayArr objectAtIndex:easybook_list_is_default] intValue];
        if (value == 0) {
            [btn setImage:btnImg1 forState:UIControlStateNormal];    
        }else {
            [btn setImage:btnImg2 forState:UIControlStateNormal];
        }
        
        UILabel *label1 = (UILabel *)[cell.contentView viewWithTag:'n'];
        label1.text = [ayArr objectAtIndex:easybook_list_easyname];
        
        UILabel *label3 = (UILabel *)[cell.contentView viewWithTag:'a'];
        label3.text = [NSString stringWithFormat:@"%@ %@ %@ %d",[ayArr objectAtIndex:easybook_list_city],[ayArr objectAtIndex:easybook_list_area],[ayArr objectAtIndex:easybook_list_address],[[ayArr objectAtIndex:easybook_list_zip_code] intValue]];
    }
    
	return cell;	
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    rowValue = indexPath.row;
    self.infoId = [NSString stringWithFormat:@"%d",[[[self.listArray objectAtIndex:indexPath.row] objectAtIndex:easybook_list_id] intValue]];
    
    NSMutableDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [Common getSecureString],@"keyvalue",
                                        [NSNumber numberWithInt:[self.infoId intValue]],@"id",
                                        [NSNumber numberWithInt: SITE_ID],@"site_id",
                                        [NSNumber numberWithInt:[self.userId intValue]],@"user_id",nil];
    
    [[DataManager sharedManager] accessService:jsontestDic command:EASYLIST_DELETE_COMMAND_ID accessAdress:@"book/deleasy.do?param=%@" delegate:self withParam:jsontestDic];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int value = [[[self.listArray objectAtIndex:indexPath.row] objectAtIndex:easybook_list_is_default] intValue];
    if (value == 1) {
        return nil;
    }else {
        UITableViewCell *cell = (UITableViewCell *)[self.myTableView cellForRowAtIndexPath:indexPath];
        UIView *vi = [cell.contentView viewWithTag:'v'];
        vi.hidden = YES;
        return UITableViewCellEditingStyleDelete;
    }
} 

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[self.myTableView cellForRowAtIndexPath:indexPath];
    UIView *vi = [cell.contentView viewWithTag:'v'];
    vi.hidden = NO;
}

#pragma mark -------private methods
- (void)leftButtonPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    //NSLog(@"btn.tag - 1====%d", btn.tag - 10000);
    
    self.bookId = [NSString stringWithFormat:@"%d",[[[self.listArray objectAtIndex:btn.tag - 10000] objectAtIndex:easybook_list_id] intValue]];
    
    int defaultInt = [[[self.listArray objectAtIndex:btn.tag - 10000] objectAtIndex:easybook_list_is_default] intValue];
    if (defaultInt != 1) {
        progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        progressHUD.labelText = @"正在请求中... ";
        [self.view addSubview:progressHUD];
        [self.view bringSubviewToFront:progressHUD];
        [progressHUD show:YES];
        
        [self accessChangeService];
    }else{
        return;
    }
}

- (void)changeBtnAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    //NSLog(@"=====%d",btn.tag - 1);
    NSArray *ayArr = [self.listArray objectAtIndex:btn.tag - 1];
    
    int buyStyle = [[ayArr objectAtIndex:easybook_list_payway] intValue];
    NSString *buyStr;
    NSString *moneyStr;
    if (buyStyle == 0) {
        buyStr = @"在线支付";
        moneyStr = @"";
    }else {
        buyStr = @"货到付款";
        if ([[ayArr objectAtIndex:easybook_list_payment] intValue] == 0) {
            moneyStr = @"现金";
        }else {
            moneyStr = @"刷卡";
        }
    }
    
    NSString *sendStr;
    int sendId = [[ayArr objectAtIndex:easybook_list_post_id] intValue];
    NSArray *ay = [DBOperate queryData:T_SENDSTYLE theColumn:@"id" theColumnValue:[NSString stringWithFormat:@"%d",sendId] withAll:NO];
    if ([ay count] > 0) {
        sendStr = [[ay objectAtIndex:0] objectAtIndex:sendstyle_name];
    }else {
        sendStr = @"";
    }
    
    NSString *timeStr;
    int time = [[ayArr objectAtIndex:easybook_list_send_time] intValue];
    if (time == 1) {
        timeStr = @"只工作日送";
    }else if (time == 2) {
        timeStr = @"工作日，双休，假日均可送货";
    }else {
        timeStr = @"只双休日，假日送货";
    }
    
    NSString *isSureStr;
    int isSure = [[ayArr objectAtIndex:easybook_list_issure] intValue];
    if (isSure == 0) {
        isSureStr = @"否";
    }else {
        isSureStr = @"是";
    }
    
    NSString *invoiceTypeStr;
    int invoiceType = [[ayArr objectAtIndex:easybook_list_invoice_type] intValue];
    if (invoiceType == 1) {
        invoiceTypeStr = @"普通发票";
    }
    
    NSString *invoiceTitleStr;
    int invoiceTitle = [[ayArr objectAtIndex:easybook_list_invoice_title_type] intValue];
    if (invoiceTitle == 1) {
        invoiceTitleStr = @"个人";
    }else {
        invoiceTitleStr = @"单位";
    }
    
    ReservationInfo *_info = [[ReservationInfo alloc] init];
    _info.easyName = [ayArr objectAtIndex:easybook_list_easyname];
    _info.per_name = [ayArr objectAtIndex:easybook_list_consignee];
    _info.per_tel = [ayArr objectAtIndex:easybook_list_mobile];
    _info.per_post = [ayArr objectAtIndex:easybook_list_zip_code];
    _info.per_province = [ayArr objectAtIndex:easybook_list_province];
    _info.per_city = [ayArr objectAtIndex:easybook_list_city];
    _info.per_area = [ayArr objectAtIndex:easybook_list_area];
    _info.per_detailAddress = [ayArr objectAtIndex:easybook_list_address];
    _info.buy_buyStyle = buyStr;
    _info.buy_sendStyle = sendStr;
    _info.buy_time = timeStr;
    _info.buy_isSureByTel = isSureStr;
    _info.buy_moneyStyle = moneyStr;
    _info.invoice_style = invoiceTypeStr;
    _info.invoice_title = invoiceTitleStr;
    _info.invoice_titleName = [ayArr objectAtIndex:easybook_list_invoice_title_cont];
    
    AddOrEditReservationViewController *editReservation = [[AddOrEditReservationViewController alloc] init];
    editReservation.info = _info;
    editReservation.easyId = [NSString stringWithFormat:@"%d",[[ayArr objectAtIndex:easybook_list_id] intValue]];
    [self.navigationController pushViewController:editReservation animated:YES];
    [editReservation release];
    [_info release];
}

- (void)addAction
{ 
    AddOrEditReservationViewController *addReservation = [[AddOrEditReservationViewController alloc] init];
    [self.navigationController pushViewController:addReservation animated:YES];
    [addReservation release];
}

- (void)getMoreAction
{
	UILabel *label = (UILabel*)[self.myTableView viewWithTag:200];
	label.text = @"正在加载...";	
	
	[indicatorView startAnimating];
	
	[self accessMoreService];
	
}

- (void)accessChangeService
{
    NSMutableDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [Common getSecureString],@"keyvalue",
                                        [NSNumber numberWithInt:[self.bookId intValue]],@"id",
                                        [NSNumber numberWithInt: SITE_ID],@"site_id",
                                        [NSNumber numberWithInt:[self.userId intValue]],@"user_id",nil];
    
    [[DataManager sharedManager] accessService:jsontestDic command:SETDEFAULT_COMMAND_ID accessAdress:@"book/seteasy.do?param=%@" delegate:self withParam:jsontestDic];
}

- (void)accessMoreService
{
    int lastId = [[[self.listArray objectAtIndex:self.listArray.count - 1] objectAtIndex:easybook_list_updatetime] intValue];
    //NSLog(@"lastId====%d",lastId);

    NSMutableDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [Common getSecureString],@"keyvalue",
                                        [NSNumber numberWithInt:-1],@"ver",
                                        [NSNumber numberWithInt: SITE_ID],@"site_id",
                                        [NSNumber numberWithInt:[self.userId intValue]],@"user_id",
                                        [NSNumber numberWithInt:lastId],@"updatetime",nil];
    
    [[DataManager sharedManager] accessService:jsontestDic command:EASYLISTMORE_COMMAND_ID accessAdress:@"book/easylist.do?param=%@" delegate:self withParam:jsontestDic];
}

- (void)accessService
{
    //添加loading图标
    UIActivityIndicatorView *tempSpinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
    [tempSpinner setCenter:CGPointMake(self.view.frame.size.width / 3, self.view.frame.size.height / 2.0)];
    self.spinner = tempSpinner;
    
    UILabel *loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 100, 20)];
    loadingLabel.font = [UIFont systemFontOfSize:14];
    loadingLabel.textColor = [UIColor colorWithRed:0.5 green: 0.5 blue: 0.5 alpha:1.0];
    loadingLabel.text = LOADING_TIPS;		
    loadingLabel.textAlignment = UITextAlignmentCenter;
    loadingLabel.backgroundColor = [UIColor clearColor];
    [self.spinner addSubview:loadingLabel];
    [self.view addSubview:self.spinner];
    [self.spinner startAnimating];
    [tempSpinner release];

    NSMutableDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [Common getSecureString],@"keyvalue",
                                        [Common getMemberVersion:[self.userId intValue] commandID:EASYLIST_COMMAND_ID],@"ver",
                                        [NSNumber numberWithInt: SITE_ID],@"site_id",
                                        [NSNumber numberWithInt:[self.userId intValue]],@"user_id",nil];
    	
    [[DataManager sharedManager] accessService:jsontestDic command:EASYLIST_COMMAND_ID accessAdress:@"book/easylist.do?param=%@" delegate:self withParam:jsontestDic];
}

- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
	NSLog(@"information finish");
	NSLog(@"=====%@",resultArray);
    switch (commandid) {
        case EASYLIST_COMMAND_ID:
        {
            if (ver == NEED_UPDATE ) {
                [self performSelectorOnMainThread:@selector(update:) withObject:resultArray waitUntilDone:NO];
            }
        }
            break;
        case EASYLISTMORE_COMMAND_ID:
        {
            [self performSelectorOnMainThread:@selector(getMoreResult:) withObject:resultArray waitUntilDone:NO];
        }
            break;
        case SETDEFAULT_COMMAND_ID:
        {
            [self performSelectorOnMainThread:@selector(setDefaultResult:) withObject:resultArray waitUntilDone:NO];
        }
            break;
        case EASYLIST_DELETE_COMMAND_ID:
        {
            [self performSelectorOnMainThread:@selector(deleteResult:) withObject:resultArray waitUntilDone:NO];
        }
            break;
            
        default:
            break;
    }
}

- (void)update:(NSMutableArray *)resultArray
{
    //NSLog(@"resultArray===%@",resultArray);
    
    //移出loading
    [self.spinner removeFromSuperview];
    
    self.listArray = (NSMutableArray *)[DBOperate queryData:T_EASYBOOK_LIST theColumn:@"memberId" theColumnValue:self.userId orderBy:@"updatetime" orderType:@"DESC" withAll:NO];
    //NSLog(@"self.listArray====%@",self.listArray);
    
    if (noLabel != nil) {
        [noLabel removeFromSuperview];
    }
    
    if ([self.listArray count] == 0) {
        noLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        noLabel.text = @"您还未设置轻松购信息";
        noLabel.backgroundColor = [UIColor clearColor];
        noLabel.textColor = [UIColor grayColor];
        noLabel.textAlignment = UITextAlignmentCenter;
        noLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.view addSubview:noLabel];
    }
    
    [self.myTableView reloadData];
}

- (void)getMoreResult:(NSMutableArray *)resultArray
{
	UILabel *label = (UILabel*)[self.myTableView viewWithTag:200];
	label.text = @"显示更多";	
	[indicatorView stopAnimating];
	
	for (int i = 0; i < [resultArray count];i++ ) 
	{
		NSMutableArray *item = [resultArray objectAtIndex:i];
		[self.listArray addObject:item];
	}
	//NSLog(@"self.listArray========%@",self.listArray);
	//NSLog(@"[self.listArray count]=====%d",[self.listArray count]);
	NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:[resultArray count]];
    for (int ind = 0; ind < [resultArray count]; ind ++) 
    {
        NSIndexPath *newPath = [NSIndexPath indexPathForRow:
                                [self.listArray indexOfObject:[resultArray objectAtIndex:ind]] inSection:0];
        [insertIndexPaths addObject:newPath];
    }
    [self.myTableView insertRowsAtIndexPaths:insertIndexPaths 
                            withRowAnimation:UITableViewRowAnimationFade];
}

- (void)setDefaultResult:(NSMutableArray *)resultArray
{
    if (progressHUD != nil) {
		if (progressHUD) {
			[progressHUD removeFromSuperview];
		}
	}
    
    if ([resultArray count] > 0) {
        int ret = [[resultArray objectAtIndex:0] intValue];
        if (ret == 1) {
            //NSLog(@"self.infoId====%@",self.infoId);
            [DBOperate updateData:T_EASYBOOK_LIST tableColumn:@"is_default" columnValue:@"0" conditionColumn1:@"memberId" conditionColumnValue1:self.userId conditionColumn2:@"1" conditionColumnValue2:[NSNumber numberWithInt:1]];
            
            [DBOperate updateData:T_EASYBOOK_LIST tableColumn:@"is_default" columnValue:@"1" conditionColumn1:@"memberId" conditionColumnValue1:self.userId conditionColumn2:@"id" conditionColumnValue2:self.bookId];
            
            self.listArray = (NSMutableArray *)[DBOperate queryData:T_EASYBOOK_LIST theColumn:@"memberId" theColumnValue:self.userId orderBy:@"updatetime" orderType:@"DESC" withAll:NO];
            
            [self.myTableView reloadData];
        }
    }
}

- (void)deleteResult:(NSMutableArray *)resultArray
{
	if ([resultArray count] > 0) {
        int retInt = [[resultArray objectAtIndex:0] intValue];
        if (retInt == 1) {
            //int value = [[[[DBOperate queryData:T_EASYBOOK_LIST theColumn:@"id" equalValue:self.infoId theColumn:@"memberId" equalValue:self.userId] objectAtIndex:0] objectAtIndex:easybook_list_is_default] intValue];
            
            [DBOperate deleteDataWithTwoConditions:T_EASYBOOK_LIST columnOne:@"id" valueOne:self.infoId columnTwo:@"memberId" valueTwo:self.userId];
            
            [self.listArray removeObjectAtIndex:rowValue];
            
//            if (value == 1 && [self.listArray count] > 0) {
//                int _id = [[[[DBOperate queryData:T_EASYBOOK_LIST theColumn:@"memberId" theColumnValue:self.userId orderBy:@"updatetime" orderType:@"DESC" withAll:NO] objectAtIndex:0] objectAtIndex:easybook_list_id] intValue];
//                
//                [DBOperate updateData:T_EASYBOOK_LIST tableColumn:@"is_default" columnValue:@"1" conditionColumn1:@"memberId" conditionColumnValue1:self.userId conditionColumn2:@"id" conditionColumnValue2:[NSString stringWithFormat:@"%d",_id]];
//            }

            self.listArray = (NSMutableArray *)[DBOperate queryData:T_EASYBOOK_LIST theColumn:@"memberId" theColumnValue:self.userId orderBy:@"updatetime" orderType:@"DESC" withAll:NO];
            
            [self.myTableView reloadData];
            
            if ([self.listArray count] == 0) {
                self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                if (noLabel != nil) {
                    [noLabel removeFromSuperview];
                }
                noLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
                noLabel.text = @"您还未设置轻松购信息";
                noLabel.backgroundColor = [UIColor clearColor];
                noLabel.textColor = [UIColor grayColor];
                noLabel.textAlignment = UITextAlignmentCenter;
                noLabel.font = [UIFont systemFontOfSize:16.0f];
                [self.view addSubview:noLabel];
            }
            
        }else {
            UITableViewCell *cell = (UITableViewCell *)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowValue inSection:0]];
            UIView *vi = [cell.contentView viewWithTag:'v'];
            vi.hidden = NO;
            
            MBProgressHUD *mbprogressHUD = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 320, 380)];
            mbprogressHUD.delegate = self;
            mbprogressHUD.customView= [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-信息.png"]] autorelease];
            mbprogressHUD.mode = MBProgressHUDModeCustomView; 
            mbprogressHUD.labelText = @"删除失败";
            [self.view addSubview:mbprogressHUD];
            [self.view bringSubviewToFront:mbprogressHUD];
            [mbprogressHUD show:YES];
            [mbprogressHUD hide:YES afterDelay:1];
            [mbprogressHUD release];
        }
    }	
}

@end
