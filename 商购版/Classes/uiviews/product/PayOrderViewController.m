//
//  PayOrderViewController.m
//  shopping
//
//  Created by yunlai on 13-1-30.
//
//

#import "PayOrderViewController.h"
//#import "AlixPayOrder.h"
//#import "AlixPayResult.h"
//#import "AlixPay.h"
//#import "DataSigner.h"
#import "ReservationInfo.h"
#import "CustomTabBar.h"
#import "tabEntranceViewController.h"
#import "MyOrdersViewController.h"
#import "DBOperate.h"
#import "Common.h"

@interface PayOrderViewController ()

@end

@implementation PayOrderViewController
@synthesize orderArray;
@synthesize info;

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

    [self.navigationController.navigationBar setTranslucent:YES];
    
    //上bar
    UIImage *topBarImage = Nil;
    
    int yValue = 0;
    if (IOS_VERSION >= 7.0) {
        topBarImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:IOS7_NAV_BG_PIC ofType:nil]];
        yValue = 20;
    }else{
        topBarImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"上bar1" ofType:@"png"]];
    }
    
    UIImageView *topBarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f , 0.0f , self.view.frame.size.width , topBarImage.size.height)];
	topBarImageView.image = topBarImage;
	[topBarImage release];
    
    //添加title
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-80)/2, yValue, 180 , 44)];
    titleLabel.text = @"订单提交成功";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [UIColor whiteColor];
    [topBarImageView addSubview:titleLabel];
	[titleLabel release];
    
    [self.view addSubview:topBarImageView];
    
    [self.view addSubview:topBarImageView];
	[topBarImageView release];
    
    //添加导航条返回按钮
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    backButton.frame = CGRectMake(0.0f, 0.0f, 40.0f, 40.0f);
//    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setBackgroundImage:[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"返回按钮" ofType:@"png"]] forState:UIControlStateNormal];
//    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    [backItem release];
//    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    
    UITableView *orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(topBarImageView.frame), self.view.frame.size.width-12*2, 7*40) style:UITableViewStyleGrouped];
    orderTableView.delegate = self;
    orderTableView.dataSource = self;
    orderTableView.backgroundView = nil;
    orderTableView.scrollEnabled = NO;
    orderTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:orderTableView];
    [orderTableView release];
    
    if (IOS_VERSION >= 7.0) {
        orderTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, orderTableView.bounds.size.width, 10.f)];
    }
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController.navigationBar setTranslucent:YES];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void) goBack{
    [self shoppingAction];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) dealloc{
    [super dealloc];
    [orderArray release],orderArray = nil;
    [info release],info = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 25;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }else{
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 36)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 300, 16)];
        label.text = @"您的订单正在处理中，如有必要您可以联系我们";
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = 1;
        label.textAlignment = UITextAlignmentLeft;
        [headView addSubview:label];
        [label release];
        
        return headView;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }else{
        return 2;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"cell";
	UITableViewCell *cell;
	
    //ios7新特性,解决分割线短一点
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
	cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 0) {
            UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 130, 30)];
            leftLabel.backgroundColor = [UIColor clearColor];
            if (indexPath.row == 0) {
                leftLabel.text = @"订单号:";
            }else if(indexPath.row == 1){
                leftLabel.text = @"订单金额:";
            }else if(indexPath.row == 2){
                leftLabel.text = @"支付方式:";
            }
            leftLabel.textAlignment = UITextAlignmentLeft;
            leftLabel.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:leftLabel];
            
            UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftLabel.frame), 5, 130, 30)];
            rightLabel.backgroundColor = [UIColor clearColor];
            if (indexPath.row == 0) {
                rightLabel.text = [orderArray objectAtIndex:1];
            }else if(indexPath.row == 1){
                rightLabel.text = [NSString stringWithFormat:@"%@%@",@"￥",[orderArray objectAtIndex:2]];
                rightLabel.textColor = [UIColor redColor];
            }else if(indexPath.row == 2){
                //rightLabel.text = info.buy_moneyStyle;
                rightLabel.text = @"货到付款";
            }
            rightLabel.textAlignment = UITextAlignmentRight;
            rightLabel.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:rightLabel];
            [rightLabel release];
            [leftLabel release];
        }else{
            UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 130, 30)];
            leftLabel.backgroundColor = [UIColor clearColor];
            if (indexPath.row == 0) {
                leftLabel.text = @"查看订单状态";
            }else if(indexPath.row == 1){
                leftLabel.text = @"继续购物";
            }
            leftLabel.textAlignment = UITextAlignmentLeft;
            leftLabel.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:leftLabel];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"右箭头.png"]];
            imageView.frame = CGRectMake(265, 15, 16, 11);
            [cell addSubview:imageView];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            int _userId = [[[[DBOperate queryData:T_MEMBER_INFO theColumn:nil theColumnValue:nil withAll:YES] objectAtIndex:0] objectAtIndex:member_info_memberId] intValue];
            MyOrdersViewController *orders = [[MyOrdersViewController alloc] init];
            orders.userId = [NSString stringWithFormat:@"%d",_userId];
			[self.navigationController pushViewController:orders animated:YES];
			[orders release];
        }else if(indexPath.row == 1){
            [self shoppingAction];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

- (void)shoppingAction
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
        tabViewController.selectedIndex = 1;
        
        [tabViewController tabBarController:tabViewController didSelectViewController:tabViewController.selectedViewController];
    }
}
@end
