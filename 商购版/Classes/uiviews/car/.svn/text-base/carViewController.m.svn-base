//
//  carViewController.m
//  shopping
//
//  Created by lai yun on 12-12-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "carViewController.h"
#import "DBOperate.h"
#import "Common.h"
#import "downloadParam.h"
#import "imageDownLoadInWaitingObject.h"
#import "FileManager.h"
#import "UIImageScale.h"
#import "CustomTabBar.h"
#import "tabEntranceViewController.h"
#import "SubmitOrderViewController.h"
#import "PayOrderViewController.h"
#import "LoginViewController.h"
#import "ProductDetailViewController.h"
#import "UIColumnViewController.h"

@interface carViewController ()

@end

@implementation carViewController
@synthesize carTableView = _carTableView;
@synthesize listArray = __listArray;
@synthesize totalMoneyLabel;
@synthesize saveMoneyLabel;
@synthesize userId;
@synthesize imageDownloadsInProgressDic;
@synthesize imageDownloadsInWaitingArray;

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
    self.view.backgroundColor = [UIColor clearColor];
    
    NSMutableDictionary *idip = [[NSMutableDictionary alloc]init];
	self.imageDownloadsInProgressDic = idip;
	[idip release];
	NSMutableArray *wait = [[NSMutableArray alloc]init];
	self.imageDownloadsInWaitingArray = wait;
	[wait release];
    
    //添加导航条返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0f, 0.0f, 60.0f, 30.0f);
    [backButton setTitle:@"去结算" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [backButton addTarget:self action:@selector(checkOnSubmit) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"button_黄色" ofType:@"png"]] forState:UIControlStateNormal];
    
    rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = rightBarButton;
    
//    rightBarButton = [[UIBarButtonItem alloc]
//                                  initWithTitle:@"去结算"
//                                  style:UIBarButtonItemStyleBordered
//                                  target:self
//                                  action:@selector(finishAction)];
    
    //无产品
    noProView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    noProView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:noProView];
    
    UIImage *img = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"购物_空购物车" ofType:@"png"]];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((320 - img.size.width) * 0.5, (self.view.frame.size.height - img.size.height) * 0.5 - 100, img.size.width, img.size.height)];
    imgView.image = img;
    [noProView addSubview:imgView];
    [imgView release];
    [img release];
    
    UILabel *strLabel = [[UILabel alloc] initWithFrame:CGRectMake(imgView.frame.origin.x, CGRectGetMaxY(imgView.frame), imgView.frame.size.width, 20)];
    strLabel.backgroundColor = [UIColor clearColor];
    strLabel.text = @"购物车是空的";
    strLabel.shadowOffset = CGSizeMake(0.0, -1.0);
    strLabel.font = [UIFont systemFontOfSize:22];
    strLabel.textAlignment = UITextAlignmentCenter;
    strLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    [noProView addSubview:strLabel];
    [strLabel release];
    
    UIImage *btnImage = [UIImage imageNamed:@"button_黄色.png"];
    UIButton *goButton = [UIButton buttonWithType:UIButtonTypeCustom];
    goButton.frame = CGRectMake(10, CGRectGetMaxY(strLabel.frame) + 20, 300, 40);
    [goButton addTarget:self action:@selector(shoppingAction) forControlEvents:UIControlEventTouchUpInside];
    [goButton setBackgroundImage:[btnImage stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
    [noProView addSubview:goButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, goButton.frame.size.width, goButton.frame.size.height)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"去逛逛";
    titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
    titleLabel.shadowColor = [UIColor grayColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [goButton addSubview:titleLabel];
    [titleLabel release];
    
    //有产品
    haveProView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    haveProView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:haveProView];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    topView.backgroundColor = [UIColor clearColor];
    [haveProView addSubview:topView];
    
    UIImage *btnImg1 = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"input_未选中" ofType:@"png"]];
    
    topSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    topSelectButton.frame = CGRectMake(10, (40 - btnImg1.size.height) * 0.5, btnImg1.size.width, btnImg1.size.height);
    [topSelectButton addTarget:self action:@selector(select) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:topSelectButton];
    [topSelectButton setImage:btnImg1 forState:UIControlStateNormal];
    
    UILabel *strLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(topSelectButton.frame), topSelectButton.frame.origin.y, 40, 16)];
    strLabel1.backgroundColor = [UIColor clearColor];
    strLabel1.text = @"全选";
    strLabel1.font = [UIFont systemFontOfSize:14];
    strLabel1.textAlignment = UITextAlignmentCenter;
    strLabel1.textColor = [UIColor darkTextColor];
    [topView addSubview:strLabel1];
    [strLabel1 release];
    
    countLabel = [[UILabel alloc] initWithFrame:CGRectMake(320 - 170, 0, 150, 40)];
    countLabel.backgroundColor = [UIColor clearColor];
    countLabel.font = [UIFont systemFontOfSize:14];
    countLabel.textAlignment = UITextAlignmentRight;
    countLabel.textColor = [UIColor darkTextColor];
    [topView addSubview:countLabel];
    [topView release];
    
    _carTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 320, self.view.frame.size.height - 120) style:UITableViewStylePlain];
    _carTableView.delegate = self;
    _carTableView.dataSource = self;
    _carTableView.scrollEnabled = YES;
    _carTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [haveProView addSubview:_carTableView];
    self.carTableView.backgroundColor = [UIColor clearColor];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 80)];
    self.carTableView.tableFooterView = footView;
    
    strLabelTotal = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 240, 20)];
    strLabelTotal.backgroundColor = [UIColor clearColor];
    strLabelTotal.text = @"总金额：";
    strLabelTotal.font = [UIFont systemFontOfSize:14.0f];
    strLabelTotal.textAlignment = UITextAlignmentRight;
    strLabelTotal.textColor = [UIColor darkTextColor];
    [footView addSubview:strLabelTotal];
    
    totalMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(strLabelTotal.frame) + 5, 10, 100, 20)];
    totalMoneyLabel.backgroundColor = [UIColor clearColor];
    totalMoneyLabel.text = @"¥ 396.00";
    totalMoneyLabel.font = [UIFont boldSystemFontOfSize:16];
    totalMoneyLabel.textAlignment = UITextAlignmentLeft;
    totalMoneyLabel.textColor = [UIColor redColor];
    [footView addSubview:totalMoneyLabel];
    
    saveMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(strLabelTotal.frame), 300, 20)];
    saveMoneyLabel.backgroundColor = [UIColor clearColor];
    saveMoneyLabel.text = @"节省 ¥100.00";
    saveMoneyLabel.font = [UIFont systemFontOfSize:14];
    saveMoneyLabel.textAlignment = UITextAlignmentRight;
    saveMoneyLabel.textColor = [UIColor darkGrayColor];
    [footView addSubview:saveMoneyLabel];
    
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    [self.listArray removeAllObjects];
    NSMutableArray *arr = (NSMutableArray *)[DBOperate queryData:T_SHOPCAR theColumn:nil theColumnValue:nil withAll:YES];
    for (int i = [arr count] - 1; i < [arr count]; i --) {
        [self.listArray addObject:[arr objectAtIndex:i]];
    }
    
    if ([self.listArray count] > 0) {
        haveProView.hidden = NO;
        noProView.hidden = YES;
        
        self.navigationItem.rightBarButtonItem = rightBarButton;
        self.tabBarController.navigationItem.rightBarButtonItem = rightBarButton;
        
        NSArray *items = [DBOperate queryData:T_SHOPCAR theColumn:@"isSelect" theColumnValue:@"1" withAll:NO];
        int totalValue = 0;
        for (int i = 0; i < [items count]; i ++) {
            int count = [[[items objectAtIndex:i] objectAtIndex:shopcar_product_count] intValue];
            totalValue += count;
        }
        
        countLabel.text = [NSString stringWithFormat:@"商品件数: %d",totalValue];
        
        double saveMoney = 0;
        totalMoney = 0;
        for (int i = 0; i < [items count]; i ++) {
            double money = 0;
            double save = 0;
            
            int count = [[[items objectAtIndex:i] objectAtIndex:shopcar_product_count] intValue];
            
            if ([[[items objectAtIndex:i] objectAtIndex:shopcar_product_promotionprice] intValue] == 0) {
                money = [[[items objectAtIndex:i] objectAtIndex:shopcar_product_price] doubleValue];
                
                save = 0;
            }else {
                money = [[[items objectAtIndex:i] objectAtIndex:shopcar_product_promotionprice] doubleValue];
                
                save = ([[[items objectAtIndex:i] objectAtIndex:shopcar_product_price] doubleValue] - money) * count;
            }
            
            double value = money *count;
            totalMoney += value;
            
            saveMoney += save;
        }
        totalMoneyLabel.text = [NSString stringWithFormat:@"¥ %.2f",totalMoney];
        CGSize constraint = CGSizeMake(20000.0f, 20.0f);
        CGSize size = [totalMoneyLabel.text sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        totalMoneyLabel.frame = CGRectMake(310 - size.width, 10, size.width, 20);
        strLabelTotal.frame = CGRectMake(10, 10, 300 - size.width, 20);
        
        saveMoneyLabel.text = [NSString stringWithFormat:@"节省 ¥%.2f",saveMoney];
        
        [self.carTableView reloadData];
        
        if ([self.listArray count] == [items count]) {
            UIImage *btnImg2 = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"input_选中" ofType:@"png"]];
            [topSelectButton setImage:btnImg2 forState:UIControlStateNormal];
            _isSelectAll = YES;
        }
    }else {
        noProView.hidden = NO;
        haveProView.hidden = YES;
        
        self.tabBarController.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)dealloc
{
    [_carTableView release];
    [noProView release];
//    [haveProView release];
    [__listArray release];
    [totalMoneyLabel release];
    [strLabelTotal release];
    [saveMoneyLabel release];
    [countLabel release];
    [userId release];
    [imageDownloadsInProgressDic release];
    [imageDownloadsInWaitingArray release];
    [topSelectButton release];
    [super dealloc];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.listArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 86;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	
	//NSInteger row = [indexPath row];
	
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImage *bgImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表背景" ofType:@"png"]];
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0 , bgImage.size.width, bgImage.size.height)];
    bgImageView.userInteractionEnabled = YES;
    [cell.contentView addSubview:bgImageView];
    bgImageView.image = bgImage;
    [bgImage release];
    
    UIImage *btnImg1 = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"input_未选中" ofType:@"png"]];
    
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectButton.frame = CGRectMake(10, (86 - btnImg1.size.height) * 0.5, btnImg1.size.width, btnImg1.size.height);
    [selectButton addTarget:self action:@selector(leftSelectBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    selectButton.tag = indexPath.row + 10000;
    [bgImageView addSubview:selectButton];
    [selectButton setImage:btnImg1 forState:UIControlStateNormal];
    
    UIImageView *cImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(selectButton.frame) + 5, 8 ,70, 70)];
    cImageView.tag = 10;
    [bgImageView addSubview:cImageView];
    [cImageView release];
    
    UIButton *didCellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    didCellBtn.frame = cImageView.frame;
    [didCellBtn addTarget:self action:@selector(didCell:) forControlEvents:UIControlEventTouchUpInside];
    didCellBtn.tag = indexPath.row + 100;
    [bgImageView addSubview:didCellBtn];
    
    UILabel *cName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cImageView.frame) + 10, 10, 110, 40)];
    cName.text = @"";
    cName.tag = 11;
    cName.font = [UIFont systemFontOfSize:16.0f];
    cName.textAlignment = UITextAlignmentLeft;
    cName.backgroundColor = [UIColor clearColor];
    [bgImageView addSubview:cName];
    [cName release];
    
    UILabel *promoney = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cImageView.frame) + 10, CGRectGetMaxY(cName.frame), 80, 20)];
    promoney.text = @"";
    promoney.textColor = [UIColor redColor];
    promoney.tag = 22;
    promoney.font = [UIFont systemFontOfSize:14.0f];
    promoney.textAlignment = UITextAlignmentLeft;
    promoney.backgroundColor = [UIColor clearColor];
    [bgImageView addSubview:promoney];
    [promoney release];
    
    UILabel *money = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(promoney.frame) + 10, CGRectGetMaxY(cName.frame), 80, 20)];
    money.text = @"";
    money.textColor = [UIColor darkGrayColor];
    money.tag = 33;
    money.font = [UIFont systemFontOfSize:14.0f];
    money.textAlignment = UITextAlignmentLeft;
    money.backgroundColor = [UIColor clearColor];
    [bgImageView addSubview:money];
    [money release];
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(5, (money.frame.size.height- 1) * 0.5,money.frame.size.width - 5, 1)];
    imageview.tag = 222;
    imageview.backgroundColor = [UIColor darkGrayColor];
    [money addSubview:imageview];
    [imageview release];
    imageview.hidden = YES;
    
    UIView *btnBGView = [[UIView alloc] initWithFrame:CGRectMake(320 - 95, (86 - 40) * 0.5, 90, 40)];
    btnBGView.backgroundColor = [UIColor clearColor];
    btnBGView.userInteractionEnabled = YES;
    btnBGView.tag = 1000;
    [bgImageView addSubview:btnBGView];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(CGRectGetMaxX(cImageView.frame) + 5, 0, cName.frame.size.width, bgImageView.frame.size.height);
    [selectBtn addTarget:self action:@selector(leftSelectBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    selectBtn.tag = indexPath.row + 10000;
    [bgImageView addSubview:selectBtn];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"购物车_减.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.tag = 'l';
    leftButton.frame = CGRectMake(0, 0, 30, 40);
    [btnBGView addSubview:leftButton];
    
    UIImage *numImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"购物车数量背景" ofType:@"png"]];
    UIImageView *numImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftButton.frame), 0, numImage.size.width, numImage.size.height)];
    numImageView.image = numImage;
    [btnBGView addSubview:numImageView];
    
    UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftButton.frame), 0, numImageView.frame.size.width, numImageView.frame.size.height)];
    tLabel.textAlignment = UITextAlignmentCenter;
    tLabel.textColor = [UIColor blackColor];
    tLabel.backgroundColor = [UIColor clearColor];
    tLabel.tag = 't';
    tLabel.adjustsFontSizeToFitWidth = YES;
    [btnBGView addSubview:tLabel];
    [tLabel release];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"购物车_加.png"] forState:UIControlStateNormal];
    [rightButton setTitle:[NSString stringWithFormat:@"%d",indexPath.row] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.tag = 'r';
    rightButton.frame = CGRectMake(CGRectGetMaxX(numImageView.frame), 0, 30, 40);
    [btnBGView addSubview:rightButton];
    
    
    
    UIButton *leftButton1 = (UIButton *)[cell.contentView viewWithTag:'l'];
    [leftButton1 setTitle:[NSString stringWithFormat:@"%d",indexPath.row] forState:UIControlStateNormal];
    
    UIButton *rightButton2 = (UIButton *)[cell.contentView viewWithTag:'r'];
    [rightButton2 setTitle:[NSString stringWithFormat:@"%d",indexPath.row] forState:UIControlStateNormal];
    
    if ([self.listArray count] > 0) {
        NSArray *cellArray = [self.listArray objectAtIndex:indexPath.row];
        
        UIButton *btn = (UIButton *)[cell.contentView viewWithTag:indexPath.row + 10000];
        UIImage *btnImg1 = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"input_未选中" ofType:@"png"]];
        UIImage *btnImg2 = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"input_选中" ofType:@"png"]];
        int value = [[cellArray objectAtIndex:shopcar_product_isSelect] intValue];
        if (value == 0) {
            [btn setImage:btnImg1 forState:UIControlStateNormal];    
        }else {
            [btn setImage:btnImg2 forState:UIControlStateNormal];
        }
        
        UILabel *label1 = (UILabel *)[cell.contentView viewWithTag:11];
        label1.text = [cellArray objectAtIndex:shopcar_product_name];
        
        UILabel *label2 = (UILabel *)[cell.contentView viewWithTag:22];
        
        UILabel *label3 = (UILabel *)[cell.contentView viewWithTag:33];
        
        if ([[cellArray objectAtIndex:shopcar_product_promotionprice] intValue] == 0) {
            label2.text = [NSString stringWithFormat:@"¥ %.2f",[[cellArray objectAtIndex:shopcar_product_price] doubleValue]];
            CGSize constraint = CGSizeMake(80, 20000.0f);
            CGSize size = [label2.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            label2.frame = CGRectMake(110, CGRectGetMaxY(label1.frame), size.width, 20);
            label3.text = @"";
            UIImageView *vi = (UIImageView *)[cell.contentView viewWithTag:222];
            vi.hidden = YES;
        }else {
            label2.text = [NSString stringWithFormat:@"¥ %.2f",[[cellArray objectAtIndex:shopcar_product_promotionprice] doubleValue]];
            label3.text = [NSString stringWithFormat:@"/ ¥ %.2f",[[cellArray objectAtIndex:shopcar_product_price] doubleValue]];
            
            CGSize constraint = CGSizeMake(80, 20000.0f);
            CGSize size = [label2.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            label2.frame = CGRectMake(110, CGRectGetMaxY(label1.frame), size.width, 20);
            
            CGSize size1 = [label3.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            
            label3.frame = CGRectMake(CGRectGetMaxX(label2.frame) + 2, CGRectGetMaxY(label1.frame), size1.width, 20);
            
            UIImageView *vi = (UIImageView *)[cell.contentView viewWithTag:222];
            vi.frame = CGRectMake(5, 10, size1.width - 5, 1);
            vi.hidden = NO;
        }
        
        UILabel *tlabel = (UILabel *)[cell.contentView viewWithTag:'t'];
        tlabel.text = [NSString stringWithFormat:@"%d",[[[self.listArray objectAtIndex:indexPath.row] objectAtIndex:shopcar_product_count] intValue]];
        
        UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:10];
        NSString *picUrl = [cellArray objectAtIndex:shopcar_product_pic_url];
        
        NSString *picName = [Common encodeBase64:(NSMutableData *)[picUrl dataUsingEncoding: NSUTF8StringEncoding]];
    
		if (picUrl.length > 1) 
        {
            UIImage *pic = [[FileManager getPhoto:picName] fillSize:CGSizeMake(70, 70)];
            if (pic.size.width > 2)
            {
                imageView.image = pic;
            }
            else
            {
                UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表默认图片" ofType:@"png"]];
                UIImageView *vi = (UIImageView *)[cell.contentView viewWithTag:10];
                vi.image = [defaultPic fillSize:CGSizeMake(70, 70)];
                
				if (tableView.dragging == NO && tableView.decelerating == NO)
				{
                    [self startIconDownload:picUrl forIndex:indexPath];
				}
            }
        }
        else
        {
            UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表默认图片" ofType:@"png"]];
            
            imageView.image = [defaultPic fillSize:CGSizeMake(70, 70)];
        }
    }
    
	return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    int _productId = [[[self.listArray objectAtIndex:indexPath.row] objectAtIndex:shopcar_product_id] intValue];
    
    [DBOperate deleteData:T_SHOPCAR tableColumn:@"product_id" columnValue:[NSNumber numberWithInt:_productId]];
    [self.listArray removeObjectAtIndex:indexPath.row];
    
    [self.listArray removeAllObjects];
    NSMutableArray *arr = (NSMutableArray *)[DBOperate queryData:T_SHOPCAR theColumn:nil theColumnValue:nil withAll:YES];
    for (int i = [arr count] - 1; i < [arr count]; i --) {
        [self.listArray addObject:[arr objectAtIndex:i]];
    }
    [self.carTableView reloadData];
    
    //重置优惠金额等
    promotionMoney = 0;
    
    int totalValue = 0;
    NSArray *items = [DBOperate queryData:T_SHOPCAR theColumn:@"isSelect" theColumnValue:@"1" withAll:NO];
    for (int i = 0; i < [items count]; i ++) {
        int count = [[[items objectAtIndex:i] objectAtIndex:shopcar_product_count] intValue];
        totalValue += count;
    }
    countLabel.text = [NSString stringWithFormat:@"商品件数: %d",totalValue];
    
    double saveMoney = 0;
    totalMoney = 0;
    for (int i = 0; i < [items count]; i ++) {
        double money = 0;
        double save = 0;
        
        int count = [[[items objectAtIndex:i] objectAtIndex:shopcar_product_count] intValue];
        
        if ([[[items objectAtIndex:i] objectAtIndex:shopcar_product_promotionprice] intValue] == 0) {
            money = [[[items objectAtIndex:i] objectAtIndex:shopcar_product_price] doubleValue];
            
            save = 0;
        }else {
            money = [[[items objectAtIndex:i] objectAtIndex:shopcar_product_promotionprice] doubleValue];
            
            save = ([[[items objectAtIndex:i] objectAtIndex:shopcar_product_price] intValue] - money) * count;
        }
        
        int value = money *count;
        totalMoney += value;
        
        saveMoney += save;
    }
    totalMoneyLabel.text = [NSString stringWithFormat:@"¥ %.2f",totalMoney];
    CGSize constraint = CGSizeMake(20000.0f, 20.0f);
    CGSize size = [totalMoneyLabel.text sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    totalMoneyLabel.frame = CGRectMake(310 - size.width, 10, size.width, 20);
    strLabelTotal.frame = CGRectMake(10, 10, 300 - size.width, 20);
    
    saveMoneyLabel.text = [NSString stringWithFormat:@"节省 ¥%.2f",saveMoney];
    
    if ([self.listArray count] == 0) {
        haveProView.hidden = YES;
        noProView.hidden = NO;
        self.tabBarController.navigationItem.rightBarButtonItem = nil;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
    UITableViewCell *cell = (UITableViewCell *)[self.carTableView cellForRowAtIndexPath:indexPath];
    UIView *vi = [cell.contentView viewWithTag:1000];
    vi.hidden = YES;
    return UITableViewCellEditingStyleDelete; 
} 

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[self.carTableView cellForRowAtIndexPath:indexPath];
    UIView *vi = [cell.contentView viewWithTag:1000];
    vi.hidden = NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark ---- loadImage Method
- (void)startIconDownload:(NSString*)imageURL forIndex:(NSIndexPath*)index
{
	IconDownLoader *iconDownloader = [imageDownloadsInProgressDic objectForKey:index];
    if (iconDownloader == nil && imageURL != nil && imageURL.length > 1) 
    {
		if (imageURL != nil && imageURL.length > 1) 
		{
			if ([imageDownloadsInProgressDic count] >= 3) {
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
	UITableViewCell *cell = (UITableViewCell *)[self.carTableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
	
    if (iconDownloader != nil)
    {
		if(iconDownloader.cardIcon.size.width > 2.0){ 			
			UIImage *photo = iconDownloader.cardIcon;
            NSArray *p_ay = [self.listArray objectAtIndex:iconDownloader.indexPathInTableView.row];
			NSString *picurl = [p_ay objectAtIndex:shopcar_product_pic_url];
			NSString *picName = [Common encodeBase64:(NSMutableData *)[picurl dataUsingEncoding: NSUTF8StringEncoding]];
            
            if ([FileManager savePhoto:picName withImage:photo]) {
                UIImageView *view = (UIImageView *)[cell.contentView viewWithTag:10];
                view.image = [photo fillSize:CGSizeMake(70, 70)];
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

#pragma mark ----private method
- (void)didCell:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSArray *productArray = [self.listArray objectAtIndex: btn.tag - 100];
    ProductDetailViewController *ProductDetailView = [[ProductDetailViewController alloc] init];
    ProductDetailView.productID = [[productArray objectAtIndex:shopcar_product_id] intValue];
    [self.navigationController pushViewController:ProductDetailView animated:YES];
    [ProductDetailView release];
}

- (void)select
{
    UIImage *btnImg1 = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"input_未选中" ofType:@"png"]];
    UIImage *btnImg2 = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"input_选中" ofType:@"png"]];
    
    if (_isSelectAll == NO) {
        [DBOperate updateData:T_SHOPCAR tableColumn:@"isSelect" columnValue:@"0" conditionColumn:@"1" conditionColumnValue:[NSNumber numberWithInt:1]];
        
        [DBOperate updateData:T_SHOPCAR tableColumn:@"isSelect" columnValue:@"1" conditionColumn:@"0" conditionColumnValue:[NSNumber numberWithInt:0]];
        
        [topSelectButton setImage:btnImg2 forState:UIControlStateNormal];
        _isSelectAll = YES;
    }else {
        [DBOperate updateData:T_SHOPCAR tableColumn:@"isSelect" columnValue:@"1" conditionColumn:@"0" conditionColumnValue:[NSNumber numberWithInt:0]];
        
        [DBOperate updateData:T_SHOPCAR tableColumn:@"isSelect" columnValue:@"0" conditionColumn:@"1" conditionColumnValue:[NSNumber numberWithInt:1]];
        
        [topSelectButton setImage:btnImg1 forState:UIControlStateNormal];
        _isSelectAll = NO;
    }
    
    [self.listArray removeAllObjects];
    NSMutableArray *arr = (NSMutableArray *)[DBOperate queryData:T_SHOPCAR theColumn:nil theColumnValue:nil withAll:YES];
    for (int i = [arr count] - 1; i < [arr count]; i --) {
        [self.listArray addObject:[arr objectAtIndex:i]];
    }
    [self.carTableView reloadData];
    
    int totalValue = 0;
    NSArray *items = [DBOperate queryData:T_SHOPCAR theColumn:@"isSelect" theColumnValue:@"1" withAll:NO];
    for (int i = 0; i < [items count]; i ++) {
        int count = [[[items objectAtIndex:i] objectAtIndex:shopcar_product_count] intValue];
        totalValue += count;
    }
    countLabel.text = [NSString stringWithFormat:@"商品件数: %d",totalValue];
    
    double saveMoney = 0;
    totalMoney = 0;
    for (int i = 0; i < [items count]; i ++) {
        double money = [[[items objectAtIndex:i] objectAtIndex:shopcar_product_promotionprice] doubleValue];
        int count = [[[items objectAtIndex:i] objectAtIndex:shopcar_product_count] intValue];
        
        double value = money *count;
        totalMoney += value;
        
        double save = 0;
        if ([[[items objectAtIndex:i] objectAtIndex:shopcar_product_price] intValue] == 0) {
            save = 0;
        }else {
            save = ([[[items objectAtIndex:i] objectAtIndex:shopcar_product_price] doubleValue] - money) * count;
        }
        saveMoney += save;
    }
    totalMoneyLabel.text = [NSString stringWithFormat:@"¥ %.2f",totalMoney];
    CGSize constraint = CGSizeMake(20000.0f, 20.0f);
    CGSize size = [totalMoneyLabel.text sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    totalMoneyLabel.frame = CGRectMake(310 - size.width, 10, size.width, 20);
    strLabelTotal.frame = CGRectMake(10, 10, 300 - size.width, 20);
    
    saveMoneyLabel.text = [NSString stringWithFormat:@"节省 ¥%.2f",saveMoney];
}

- (void)leftSelectBtnPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSArray *dbArr = [self.listArray objectAtIndex:btn.tag - 10000];
    NSString *infoId = [NSString stringWithFormat:@"%d",[[dbArr objectAtIndex:shopcar_product_id] intValue]];
    int _select = [[dbArr objectAtIndex:shopcar_product_isSelect] intValue];
    if (_select == 0) {
        [DBOperate updateData:T_SHOPCAR tableColumn:@"isSelect" columnValue:@"1" conditionColumn:@"product_id" conditionColumnValue:infoId];
    }else {
        [DBOperate updateData:T_SHOPCAR tableColumn:@"isSelect" columnValue:@"0" conditionColumn:@"product_id" conditionColumnValue:infoId];
    }
    
    if (_isSelectAll == YES) {
        UIImage *btnImg1 = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"input_未选中" ofType:@"png"]];
        [topSelectButton setImage:btnImg1 forState:UIControlStateNormal];
        
        _isSelectAll = NO;
    }else {
        if ([[DBOperate queryData:T_SHOPCAR theColumn:@"isSelect" theColumnValue:@"0" withAll:NO] count] == 0) {
            UIImage *btnImg2 = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"input_选中" ofType:@"png"]];
            [topSelectButton setImage:btnImg2 forState:UIControlStateNormal];
            
            _isSelectAll = YES;
        }
    }
    
    [self.listArray removeAllObjects];
    NSMutableArray *arr = (NSMutableArray *)[DBOperate queryData:T_SHOPCAR theColumn:nil theColumnValue:nil withAll:YES];
    for (int i = [arr count] - 1; i < [arr count]; i --) {
        [self.listArray addObject:[arr objectAtIndex:i]];
    }
    [self.carTableView reloadData];
    
    int totalValue = 0;
    NSArray *items = [DBOperate queryData:T_SHOPCAR theColumn:@"isSelect" theColumnValue:@"1" withAll:NO];
    for (int i = 0; i < [items count]; i ++) {
        int count = [[[items objectAtIndex:i] objectAtIndex:shopcar_product_count] intValue];
        totalValue += count;
    }
    countLabel.text = [NSString stringWithFormat:@"商品件数: %d",totalValue];
    
    double saveMoney = 0;
    totalMoney = 0;
    for (int i = 0; i < [items count]; i ++) {
        double money = 0;
        double save = 0;
        
        int count = [[[items objectAtIndex:i] objectAtIndex:shopcar_product_count] intValue];
        
        if ([[[items objectAtIndex:i] objectAtIndex:shopcar_product_promotionprice] intValue] == 0) {
            money = [[[items objectAtIndex:i] objectAtIndex:shopcar_product_price] doubleValue];
            
            save = 0;
        }else {
            money = [[[items objectAtIndex:i] objectAtIndex:shopcar_product_promotionprice] doubleValue];
            
            save = ([[[items objectAtIndex:i] objectAtIndex:shopcar_product_price] doubleValue] - money) * count;
        }
        
        double value = money *count;
        totalMoney += value;
        
        saveMoney += save;
    }
    totalMoneyLabel.text = [NSString stringWithFormat:@"¥ %.2f",totalMoney];
    CGSize constraint = CGSizeMake(20000.0f, 20.0f);
    CGSize size = [totalMoneyLabel.text sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    totalMoneyLabel.frame = CGRectMake(310 - size.width, 10, size.width, 20);
    strLabelTotal.frame = CGRectMake(10, 10, 300 - size.width, 20);
    
    saveMoneyLabel.text = [NSString stringWithFormat:@"节省 ¥%.2f",saveMoney];
}

- (void)leftButtonPressed:(id)sender
{
    promotionMoney = 0;
    UIButton *button = (UIButton *)sender;
    int index = [button.titleLabel.text intValue];
    //NSLog(@"leftButtonPressed--%d",index);
    
    NSString *productId = [NSString stringWithFormat:@"%d",[[[self.listArray objectAtIndex:index] objectAtIndex:shopcar_product_id] intValue]];
    int countValue = [[[self.listArray objectAtIndex:index] objectAtIndex:shopcar_product_count] intValue];
    if (countValue > 1) {
        int count_ = countValue - 1;
        [DBOperate updateData:T_SHOPCAR tableColumn:@"product_count" columnValue:[NSString stringWithFormat:@"%d",count_] conditionColumn:@"product_id" conditionColumnValue:productId];
        
//        self.listArray = (NSMutableArray *)[DBOperate queryData:T_SHOPCAR theColumn:nil theColumnValue:nil withAll:YES];
        [self.listArray removeAllObjects];
        NSMutableArray *arr = (NSMutableArray *)[DBOperate queryData:T_SHOPCAR theColumn:nil theColumnValue:nil withAll:YES];
        for (int i = [arr count] - 1; i < [arr count]; i --) {
            [self.listArray addObject:[arr objectAtIndex:i]];
        }
        [self.carTableView reloadData];
    }

    int _isSelect = [[[self.listArray objectAtIndex:index] objectAtIndex:shopcar_product_isSelect] intValue];
    NSArray *items = [DBOperate queryData:T_SHOPCAR theColumn:@"isSelect" theColumnValue:@"1" withAll:NO];
    if (_isSelect == 1) {
        int totalValue = 0;
        for (int i = 0; i < [items count]; i ++) {
            int count = [[[items objectAtIndex:i] objectAtIndex:shopcar_product_count] intValue];
            totalValue += count;
        }
        countLabel.text = [NSString stringWithFormat:@"商品件数: %d",totalValue];
        
        double saveMoney = 0;
        totalMoney = 0;
        for (int i = 0; i < [items count]; i ++) {
            double money = 0;
            double save = 0;
            
            int count = [[[items objectAtIndex:i] objectAtIndex:shopcar_product_count] intValue];
            
            if ([[[items objectAtIndex:i] objectAtIndex:shopcar_product_promotionprice] intValue] == 0) {
                money = [[[items objectAtIndex:i] objectAtIndex:shopcar_product_price] doubleValue];
                
                save = 0;
            }else {
                money = [[[items objectAtIndex:i] objectAtIndex:shopcar_product_promotionprice] doubleValue];
                
                save = ([[[items objectAtIndex:i] objectAtIndex:shopcar_product_price] doubleValue] - money) * count;
            }
            
            double value = money *count;
            totalMoney += value;
            
            saveMoney += save;
        }
        totalMoneyLabel.text = [NSString stringWithFormat:@"¥ %.2f",totalMoney];
        CGSize constraint = CGSizeMake(20000.0f, 20.0f);
        CGSize size = [totalMoneyLabel.text sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        totalMoneyLabel.frame = CGRectMake(310 - size.width, 10, size.width, 20);
        strLabelTotal.frame = CGRectMake(10, 10, 300 - size.width, 20);
        
        saveMoneyLabel.text = [NSString stringWithFormat:@"节省 ¥%.2f",saveMoney];
    }
}

- (void)rightButtonPressed:(id)sender
{
    promotionMoney = 0;
    UIButton *button = (UIButton *)sender;
    int index = [button.titleLabel.text intValue];
    //NSLog(@"rightButtonPressed--%d",index);
    
    NSString *productId = [NSString stringWithFormat:@"%d",[[[self.listArray objectAtIndex:index] objectAtIndex:shopcar_product_id] intValue]];
    int countValue = [[[self.listArray objectAtIndex:index] objectAtIndex:shopcar_product_count] intValue];
    int count_ = countValue + 1;
    if (count_  <= [[[self.listArray objectAtIndex:index] objectAtIndex:shopcar_product_sum] intValue]) {
        [DBOperate updateData:T_SHOPCAR tableColumn:@"product_count" columnValue:[NSString stringWithFormat:@"%d",count_] conditionColumn:@"product_id" conditionColumnValue:productId];
        
        [self.listArray removeAllObjects];
        NSMutableArray *arr = (NSMutableArray *)[DBOperate queryData:T_SHOPCAR theColumn:nil theColumnValue:nil withAll:YES];
        for (int i = [arr count] - 1; i < [arr count]; i --) {
            [self.listArray addObject:[arr objectAtIndex:i]];
        }
        [self.carTableView reloadData];
        
        int _isSelect = [[[self.listArray objectAtIndex:index] objectAtIndex:shopcar_product_isSelect] intValue];
        NSArray *items = [DBOperate queryData:T_SHOPCAR theColumn:@"isSelect" theColumnValue:@"1" withAll:NO];
        if (_isSelect == 1) {
            int totalValue = 0;
            for (int i = 0; i < [items count]; i ++) {
                int count = [[[items objectAtIndex:i] objectAtIndex:shopcar_product_count] intValue];
                totalValue += count;
            }
            countLabel.text = [NSString stringWithFormat:@"商品件数: %d",totalValue];
            
            double saveMoney = 0;
            totalMoney = 0;
            for (int i = 0; i < [items count]; i ++) {
                double money = 0;
                double save = 0;
                
                int count = [[[items objectAtIndex:i] objectAtIndex:shopcar_product_count] intValue];
                
                if ([[[items objectAtIndex:i] objectAtIndex:shopcar_product_promotionprice] intValue] == 0) {
                    money = [[[items objectAtIndex:i] objectAtIndex:shopcar_product_price] doubleValue];
                    
                    save = 0;
                }else {
                    money = [[[items objectAtIndex:i] objectAtIndex:shopcar_product_promotionprice] doubleValue];
                    
                    save = ([[[items objectAtIndex:i] objectAtIndex:shopcar_product_price] doubleValue] - money) * count;
                }
                
                double value = money *count;
                totalMoney += value;
                
                saveMoney += save;
            }
            totalMoneyLabel.text = [NSString stringWithFormat:@"¥ %.2f",totalMoney];
            CGSize constraint = CGSizeMake(20000.0f, 20.0f);
            CGSize size = [totalMoneyLabel.text sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            totalMoneyLabel.frame = CGRectMake(310 - size.width, 10, size.width, 20);
            strLabelTotal.frame = CGRectMake(10, 10, 300 - size.width, 20);
            
            saveMoneyLabel.text = [NSString stringWithFormat:@"节省 ¥%.2f",saveMoney];
        }
    }else {
        MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithView:self.view];
        progressHUDTmp.delegate = self;
        progressHUDTmp.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-信息.png"]] autorelease];
        progressHUDTmp.mode = MBProgressHUDModeCustomView;
        progressHUDTmp.labelText = @"库存不足";
        [self.view addSubview:progressHUDTmp];
        [progressHUDTmp show:YES];
        [progressHUDTmp hide:YES afterDelay:1.5];
        [progressHUDTmp release];
    }
}

- (void)shoppingAction
{
//    UIColumnViewController *uic = [[UIColumnViewController alloc] init];
//    [self.navigationController pushViewController:uic animated:YES];
//    [uic release];
    NSArray *arrayViewControllers = self.navigationController.viewControllers;
    if ([[arrayViewControllers objectAtIndex:0] isKindOfClass:[CustomTabBar class]])
    {
        CustomTabBar *tabViewController = [arrayViewControllers objectAtIndex:0];
        tabViewController.selectedIndex = 1;
        
        UIButton *btn = (UIButton *)[tabViewController.view viewWithTag:90001];
        
        [tabViewController selectedTab:btn];
    }
    else
    {
        tabEntranceViewController *tabViewController = [arrayViewControllers objectAtIndex:0];
        tabViewController.selectedIndex = 1;
        
        [tabViewController tabBarController:tabViewController didSelectViewController:tabViewController.selectedViewController];
    }
}

- (void)finishAction
{
    NSArray *items = [DBOperate queryData:T_SHOPCAR theColumn:@"isSelect" theColumnValue:@"1" withAll:NO];
    if ([items count] == 0) {
        MBProgressHUD *mbprogressHUD = [[MBProgressHUD alloc] initWithView:self.view];
		mbprogressHUD.delegate = self;
		mbprogressHUD.customView= [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-信息.png"]] autorelease];
		mbprogressHUD.mode = MBProgressHUDModeCustomView;
		mbprogressHUD.labelText = @"请选择商品";
		[self.view addSubview:mbprogressHUD];
		[self.view bringSubviewToFront:mbprogressHUD];
		[mbprogressHUD show:YES];
		[mbprogressHUD hide:YES afterDelay:1];
		[mbprogressHUD release];
    }else {
        if (_isLogin) {
            SubmitOrderViewController *sovc = [[SubmitOrderViewController alloc] init];
            sovc.totalMoney = totalMoney;
            sovc.totalPrice = [[totalMoneyLabel.text componentsSeparatedByString:@" "] objectAtIndex:1];
            sovc.savePrice = [[saveMoneyLabel.text componentsSeparatedByString:@" ¥"] objectAtIndex:1];
            sovc.shopArray = items;
            sovc.fullSendID = fullSendID;
            NSLog(@"promotionMoney:%.2f",promotionMoney);
            sovc.promotionMoney = promotionMoney;
            [self.navigationController pushViewController:sovc animated:YES];
            [sovc release];
        }else{
            LoginViewController *login = [[LoginViewController alloc] init];
            login.delegate = self;
            [self.navigationController pushViewController:login animated:YES];
            [login release];
        }
    }
}

#pragma mark 登录接口回调
- (void)loginWithResult:(BOOL)isLoginSuccess{
    
	if (isLoginSuccess)
    {
//        SubmitOrderViewController *sovc = [[SubmitOrderViewController alloc] init];
//        sovc.totalPrice = totalMoneyLabel.text;
//        sovc.savePrice = saveMoneyLabel.text;
//        [self.navigationController pushViewController:sovc animated:YES];
//        [sovc release];
//        [self performSelector:@selector(finishAction) withObject:nil afterDelay:0.5];
	}
}


//提交订单前check订单是都满足满送活动
- (void) checkOnSubmit{
    //所有促销的列表
    NSArray *ayArray = [DBOperate queryData:T_FULL_PROMOTION theColumn:nil theColumnValue:nil orderBy:@"total" orderType:@"desc" withAll:YES];
    //isDisCount为TRUE时为打折，为NO是立减
    BOOL isDisCount = NO;
    //记录多余1条，肯定是立减活动
    if ([ayArray count] > 1) {
        isDisCount = NO;
    }else if([ayArray count] == 1){
        int type = [[[ayArray objectAtIndex:0] objectAtIndex:fullpromotion_type] intValue];
        //type为1时,优惠活动是打折
        if (type == 1) {
            isDisCount = YES;
        }else{
            isDisCount = NO;
        }
    }
    if ([ayArray count] > 0) {
        NSArray *ay = nil;
        //是否直接减掉促销价格或打折
        BOOL flag = NO; 
        for (int i = 0; i < [ayArray count]; i++) {
            ay = [ayArray objectAtIndex:i];
            if (totalMoney >= [[ay objectAtIndex:fullpromotion_total] doubleValue]) {
                //总价钱落在那个区间，直接减掉促销的金额
                flag = YES;
                break;
            }else{
                ay = nil;
            }
        }
        if (ay == nil) {
            ay = [ayArray lastObject];
            //需要再判断订单金额是否达到促销的百分点，弹出加单提示框
            flag = NO;
        }
        
        int startTime = [[ay objectAtIndex:fullpromotion_startTime] intValue];
        int endTime = [[ay objectAtIndex:fullpromotion_endTime] intValue];
        
        NSDate* nowDate = [NSDate date];
        NSDateFormatter *outputFormat = [[NSDateFormatter alloc] init];
        [outputFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString = [outputFormat stringFromDate:nowDate];
        NSDate *currentDate = [outputFormat dateFromString:dateString];
        [outputFormat release];
        NSTimeInterval t = [currentDate timeIntervalSince1970];   //转化为时间戳
        long long int ttime = (long long int)t;
        NSNumber *num = [NSNumber numberWithLongLong:ttime];
        int currentInt = [num intValue];
        
        if (currentInt >= startTime && currentInt <= endTime) {
            if (flag) {
                if (isDisCount) {//打折优惠活动
                    double preTotal = totalMoney;
                    totalMoney = preTotal * [[ay objectAtIndex:fullpromotion_price] doubleValue] / 10;
                    promotionMoney = preTotal - totalMoney;
                }else{//后台设置是立减优惠活动
                    promotionMoney = [[ay objectAtIndex:fullpromotion_price] doubleValue];
                    totalMoney -= promotionMoney;
                }
                fullSendID = [[ay objectAtIndex:fullpromotion_fid] intValue];
                [self finishAction];
            }else{
                double priceInt = [[ay objectAtIndex:fullpromotion_total] doubleValue];
                
                double value = totalMoney;
                
                if (value >= priceInt * promotionPercent && value < priceInt) {
                    NSString *valueStr = [NSString stringWithFormat:@"%.2f",priceInt - value];
                    
                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    if (!window)
                    {
                        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
                    }
                    
                    PromotionAlertView *shareAlertView = [[[PromotionAlertView alloc] initWithFrame:window.bounds withTotal:[NSString stringWithFormat:@"%.0f",value] withPrice:valueStr withName:[[ayArray objectAtIndex:0] objectAtIndex:fullpromotion_name]] autorelease];
                    shareAlertView._delegate = self;
                    [window addSubview:shareAlertView];
                    [shareAlertView showFromPoint:[window center]];
                }else if (value > priceInt){
                    [self finishAction];
                }else {
                    [self finishAction];
                }
            }
            
        }else {
            [DBOperate deleteData:T_FULL_PROMOTION];
            [self finishAction];
        }
    }else{
        [self finishAction];
    }
}

#pragma mark -----PromotionAlertViewDelegate method
- (void)leftGoOnAction
{
    NSArray *arrayViewControllers = self.navigationController.viewControllers;
    if ([[arrayViewControllers objectAtIndex:0] isKindOfClass:[CustomTabBar class]])
    {
        CustomTabBar *tabViewController = [arrayViewControllers objectAtIndex:0];
        tabViewController.selectedIndex = 1;
        
        UIButton *btn = (UIButton *)[tabViewController.view viewWithTag:90001];
        [tabViewController selectedTab:btn];
    }
    else
    {
        tabEntranceViewController *tabViewController = [arrayViewControllers objectAtIndex:0];
        tabViewController.selectedIndex = 0;
        
        [tabViewController tabBarController:tabViewController didSelectViewController:tabViewController.selectedViewController];
    }
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)rightFinishAction
{
    [self finishAction];
}

@end
