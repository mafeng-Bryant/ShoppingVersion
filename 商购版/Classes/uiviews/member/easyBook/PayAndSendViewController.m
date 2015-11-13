//
//  PayAndSendViewController.m
//  shopping
//
//  Created by 来 云 on 13-1-10.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PayAndSendViewController.h"
#import "shoppingAppDelegate.h"
#import "CustomPicker.h"
@interface PayAndSendViewController ()

@end

@implementation PayAndSendViewController
@synthesize payTextField = _payTextField;
@synthesize sendTextField = _sendTextField;
@synthesize timeTextField = _timeTextField;
@synthesize isTelTextField = _isTelTextField;
@synthesize moneyTextField = _moneyTextField;
@synthesize _delegate;
@synthesize info;
@synthesize myDelegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        rowCount = 5;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"支付及配送方式";

    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundView = nil;
    if (IOS_VERSION >= 7.0) {
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 10.0f)];
    }
    
    UIBarButtonItem *mrightbto = [[UIBarButtonItem alloc]
                                  initWithTitle:@"确定"
                                  style:UIBarButtonItemStyleBordered
                                  target:self
                                  action:@selector(sureAction)];
    self.navigationItem.rightBarButtonItem = mrightbto;
    [mrightbto release];
    
    [self initallStaticUI];
}

- (void)initallStaticUI
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake( 10, 10, 80, 30)];
    
    CGFloat xValue = IOS_VERSION < 7.0 ? 0.0f : 20.0f;
    
    _payTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + xValue, 10, 200, 30)];
    _payTextField.font = [UIFont systemFontOfSize:14.0f];
    _payTextField.delegate = self;
    _payTextField.textAlignment = UITextAlignmentRight;
    _payTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _payTextField.returnKeyType = UIReturnKeyNext;
    _payTextField.borderStyle = UITextBorderStyleNone;
    _payTextField.backgroundColor = [UIColor clearColor];
    [_payTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    _sendTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + xValue, 10, 200, 30)];
    _sendTextField.font = [UIFont systemFontOfSize:14.0f];
    _sendTextField.textAlignment = UITextAlignmentRight;
    _sendTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _sendTextField.returnKeyType = UIReturnKeyNext;
    _sendTextField.borderStyle = UITextBorderStyleNone;
    _sendTextField.backgroundColor = [UIColor clearColor];
    [_sendTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    _sendTextField.placeholder = @"请选择";
    
    _timeTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + xValue, 10, 200, 30)];
    _timeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _timeTextField.returnKeyType = UIReturnKeyNext;
    _timeTextField.font = [UIFont systemFontOfSize:14.0f];
    _timeTextField.textAlignment = UITextAlignmentRight;
    _timeTextField.borderStyle = UITextBorderStyleNone;
    _timeTextField.backgroundColor = [UIColor clearColor];
    [_timeTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    _isTelTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + xValue, 10, 200, 30)];
    _isTelTextField.delegate = self;
    _isTelTextField.font = [UIFont systemFontOfSize:14.0f];
    _isTelTextField.textAlignment = UITextAlignmentRight;
    _isTelTextField.borderStyle = UITextBorderStyleNone;
    _isTelTextField.backgroundColor = [UIColor clearColor];
    [_isTelTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    _moneyTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + xValue, 10, 200, 30)];
    _moneyTextField.font = [UIFont systemFontOfSize:14.0f];
    _moneyTextField.delegate = self;
    _moneyTextField.textAlignment = UITextAlignmentRight;
    _moneyTextField.borderStyle = UITextBorderStyleNone;
    _moneyTextField.backgroundColor = [UIColor clearColor];
    [_moneyTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    _moneyTextField.text = @"现金";
    _moneyTextField.enabled = NO;
    
    [label release];
    
    
    if (info.buy_buyStyle == nil) {
        self.payTextField.text = @"货到付款";
        rowCount = 5;
    }else {
        self.payTextField.text = info.buy_buyStyle;
        if ([info.buy_buyStyle isEqualToString:@"货到付款"]) {
            rowCount = 5;
        }else {
            rowCount = 4;
        }
    }
    
    if (info.buy_sendStyle == nil) {
        NSArray *ay = [DBOperate queryData:T_SENDSTYLE theColumn:nil theColumnValue:nil withAll:YES];
        if ([ay count] > 0) {
            self.sendTextField.text = [[ay objectAtIndex:0] objectAtIndex:sendstyle_name];
        }
    }else {
        self.sendTextField.text = info.buy_sendStyle;
    }
    
    if (info.buy_time == nil) {
        self.timeTextField.text = @"只工作日送";
    }else {
        self.timeTextField.text = info.buy_time;
    }
    
    if (info.buy_isSureByTel == nil) {
        self.isTelTextField.text = @"是";
    }else {
        self.isTelTextField.text = info.buy_isSureByTel;
    }
    
    self.moneyTextField.text = info.buy_moneyStyle;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    //ios7新特性,解决分割线短一点
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    switch (indexPath.row) {
        case 0:
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake( 10, 10, 80, 30)];
            label.text = @"支付方式：";
            label.font = [UIFont systemFontOfSize:16.0f];
            label.textAlignment = UITextAlignmentLeft;
            label.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label];
            [label release];
            
            [cell.contentView addSubview:_payTextField];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = indexPath.row + 1;
            [btn addTarget:self action:@selector(selectRow:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(_payTextField.frame.origin.x, 10, 200, 30);
            [cell.contentView addSubview:btn];
            
        }
            break;
        case 1:
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake( 10, 10, 80, 30)];
            label.text = @"配送方式：";
            label.font = [UIFont systemFontOfSize:16.0f];
            label.textAlignment = UITextAlignmentLeft;
            label.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label];
            [label release];
            
            [cell.contentView addSubview:_sendTextField];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = indexPath.row + 1;
            [btn addTarget:self action:@selector(selectRow:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(_sendTextField.frame.origin.x, 10, 200, 30);
            [cell.contentView addSubview:btn];
        }
            break;
        case 2:
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake( 10, 10, 80, 30)];
            label.text = @"送货时间：";
            label.font = [UIFont systemFontOfSize:16.0f];
            label.textAlignment = UITextAlignmentLeft;
            label.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label];
            [label release];
            
            [cell.contentView addSubview:_timeTextField];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = indexPath.row + 1;
            [btn addTarget:self action:@selector(selectRow:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(_timeTextField.frame.origin.x, 10, 200, 30);
            [cell.contentView addSubview:btn];
        }
            break;
        case 3:
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake( 10, 10, 80, 30)];
            label.text = @"电话确认：";
            label.font = [UIFont systemFontOfSize:16.0f];
            label.textAlignment = UITextAlignmentLeft;
            label.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label];
            [label release];
            
            [cell.contentView addSubview:_isTelTextField];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = indexPath.row + 1;
            [btn addTarget:self action:@selector(selectRow:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(_isTelTextField.frame.origin.x, 10, 200, 30);
            [cell.contentView addSubview:btn];
        }
            break;
        case 4:
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake( 10, 10, 80, 30)];
            label.text = @"付款方式：";
            label.font = [UIFont systemFontOfSize:16.0f];
            label.textAlignment = UITextAlignmentLeft;
            label.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label];
            [label release];
            
            [cell.contentView addSubview:_moneyTextField];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = indexPath.row + 1;
            [btn addTarget:self action:@selector(selectRow:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(_moneyTextField.frame.origin.x, 10, 200, 30);
            [cell.contentView addSubview:btn];
            
        }
            break;
            
        default:
            break;
    }

    return cell;
}

#pragma mark ----UIActionSheetDelegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    CustomPicker *picer = (CustomPicker *)actionSheet;
    if (buttonIndex == 1){
        switch (picer.tag) {
            case 11:
            {
                if ([self.payTextField.text isEqualToString:@"在线支付"]) {
                    if (rowCount != 4) {
                        rowCount = 4;
                        
                        NSMutableArray *deleteIndexPaths = [[NSMutableArray alloc] init];
                        NSIndexPath *newPath = [NSIndexPath indexPathForRow:4 inSection:0];
                        [deleteIndexPaths addObject:newPath];
                        
                        [self.tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                        [deleteIndexPaths release];
                    }
                }else{
                    if (rowCount != 5) {
                        rowCount = 5;
                        
                        NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
                        NSIndexPath *newPath = [NSIndexPath indexPathForRow:4 inSection:0];
                        [insertIndexPaths addObject:newPath];
                        
                        [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                        [insertIndexPaths release];
                    }
                }
            }
                break;
            case 12:
            {
                
            }
                break;
            case 13:
            {
                
            }
                break;
            case 14:
            {
                
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark -----private methods
- (void)selectRow:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    shoppingAppDelegate *delegate =  (shoppingAppDelegate *)[UIApplication sharedApplication].delegate;
    
    CustomPicker *picker = nil;
    
    switch (btn.tag) {
        case 1:
        {
            NSMutableArray *payArray = [[NSMutableArray alloc] init];
            
            NSArray *isdeliverypayArray = [DBOperate queryData:T_SYSTEM_CONFIG theColumn:@"tag" 
                                                theColumnValue:@"isDeliverypay" withAll:NO];
            if ([isdeliverypayArray count] > 0) {
                int isDeliverypayValue = [[[isdeliverypayArray objectAtIndex:0] objectAtIndex:1] intValue];
                if (isDeliverypayValue == 1) {
                    [payArray addObject:@"货到付款"];
                }
            }
            
            NSArray *isalipayArray = [DBOperate queryData:T_SYSTEM_CONFIG theColumn:@"tag" 
                                                  theColumnValue:@"isAlipay" withAll:NO];
            if ([isalipayArray count] > 0) {
                int isAlipayValue = [[[isalipayArray objectAtIndex:0] objectAtIndex:1] intValue];
                if (isAlipayValue == 1) {
                    [payArray addObject:@"在线支付"];
                }
            }
            if ([payArray count] > 0) {
                picker = [[CustomPicker alloc] initWithTitle:nil withFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 130) delegate:self PickerArray:payArray Obj:self.payTextField];
                picker.tag = 11;
            }
        }
            break;
        case 2:
        {
            NSArray *ay = [DBOperate queryData:T_SENDSTYLE theColumn:nil theColumnValue:nil withAll:YES];
            NSMutableArray *nameArr = [[NSMutableArray alloc] init];
            NSLog(@"ay = %@",ay);
            if ([ay count] > 0) {
                for (int i = 0; i < [ay count]; i ++) {
                    NSArray *dbArr = [ay objectAtIndex:i];
                    NSString *name = [dbArr objectAtIndex:sendstyle_name];
                    [nameArr addObject:name];
                }
                picker = [[CustomPicker alloc] initWithTitle:nil withFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 130) delegate:self PickerArray:nameArr Obj:self.sendTextField];
                
                picker.tag = 12;
            }
        }
            break;
        case 3:
        {
            picker = [[CustomPicker alloc] initWithTitle:nil withFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 130) delegate:self PickerArray:[NSMutableArray arrayWithObjects:@"只工作日送",@"工作日，双休，假日均可送货",@"只双休日，假日送货", nil] Obj:self.timeTextField];
            picker.tag = 13;
        }
            break;
        case 4:
        {
            picker = [[CustomPicker alloc] initWithTitle:nil withFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 130) delegate:self PickerArray:[NSMutableArray arrayWithObjects:@"是",@"否", nil] Obj:self.isTelTextField];
            picker.tag = 14;
        }
            break;
        case 5:
        {
            picker = [[CustomPicker alloc] initWithTitle:nil withFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 130) delegate:self PickerArray:[NSMutableArray arrayWithObjects:@"现金",@"刷卡", nil] Obj:self.moneyTextField];
            picker.tag = 15;
        }
            break;
            
        default:
            break;
    }
    
    picker.delegate  = self;
    [picker showInDelegateView:delegate.window];
    [picker release];
}

- (void)sureAction
{
    if (self.payTextField.text.length == 0 || self.sendTextField.text.length == 0 || self.timeTextField.text.length == 0 || self.isTelTextField.text.length == 0) {
        MBProgressHUD *mprogressHUD = [[MBProgressHUD alloc] initWithView:self.tableView];
        mprogressHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-信息.png"]] autorelease];
        mprogressHUD.mode = MBProgressHUDModeCustomView;
        mprogressHUD.labelText = @"请填写完整的信息";
        [self.view addSubview:mprogressHUD];
        [self.view bringSubviewToFront:mprogressHUD];
        [mprogressHUD show:YES];
        [mprogressHUD hide:YES afterDelay:1.5];
        [mprogressHUD release];
    }else {
        info.buy_buyStyle = self.payTextField.text;
        info.buy_sendStyle = self.sendTextField.text;
        info.buy_time = self.timeTextField.text;
        info.buy_isSureByTel = self.isTelTextField.text;
        if ([info.buy_buyStyle isEqualToString:@"在线支付"]) {
            info.buy_moneyStyle = @"";
        }else {
            info.buy_moneyStyle = self.moneyTextField.text;
        }
        
        if (myDelegate != nil && [myDelegate respondsToSelector:@selector(getMyAddress)]) {
            [myDelegate getMyAddress];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
