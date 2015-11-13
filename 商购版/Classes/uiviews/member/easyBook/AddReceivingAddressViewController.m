//
//  AddReceivingAddressViewController.m
//  shopping
//
//  Created by 来 云 on 13-1-10.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "AddReceivingAddressViewController.h"
#import "TSLocateView.h"
#import "shoppingAppDelegate.h"
#import "DataManager.h"
#import "Common.h"
@interface AddReceivingAddressViewController ()

@end

@implementation AddReceivingAddressViewController
@synthesize nameTextField = _nameTextField;
@synthesize telTextField = _telTextField;
@synthesize postTextField = _postTextField;
@synthesize areaTextField = _areaTextField;
@synthesize addressTextField = _addressTextField;
@synthesize _delegate;
@synthesize info;
@synthesize addrId;
@synthesize myAddress;
@synthesize _fromPrize;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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
    
    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + xValue, 6, 200, 30)];
    _nameTextField.font = [UIFont systemFontOfSize:14.0f];
    _nameTextField.delegate = self;
    _nameTextField.textAlignment = UITextAlignmentRight;
    _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nameTextField.returnKeyType = UIReturnKeyNext;
    _nameTextField.borderStyle = UITextBorderStyleNone;
    _nameTextField.backgroundColor = [UIColor clearColor];
    [_nameTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    _nameTextField.placeholder = @"姓名";
    
    _telTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + xValue, 10, 200, 30)];
    _telTextField.font = [UIFont systemFontOfSize:14.0f];
    _telTextField.textAlignment = UITextAlignmentRight;
    _telTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _telTextField.returnKeyType = UIReturnKeyNext;
    _telTextField.keyboardType = UIKeyboardTypeNumberPad;
    _telTextField.borderStyle = UITextBorderStyleNone;
    _telTextField.backgroundColor = [UIColor clearColor];
    [_telTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    _telTextField.placeholder = @"手机号码";
    
    _postTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + xValue, 10, 200, 30)];
    _postTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _postTextField.returnKeyType = UIReturnKeyNext;
    _postTextField.keyboardType = UIKeyboardTypeNumberPad;
    _postTextField.font = [UIFont systemFontOfSize:14.0f];
    _postTextField.textAlignment = UITextAlignmentRight;
    _postTextField.borderStyle = UITextBorderStyleNone;
    _postTextField.backgroundColor = [UIColor clearColor];
    [_postTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    _postTextField.placeholder = @"邮政编码";
    
    _areaTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + xValue, 10, 200, 30)];
    _areaTextField.delegate = self;
    _areaTextField.font = [UIFont systemFontOfSize:14.0f];
    _areaTextField.textAlignment = UITextAlignmentRight;
    _areaTextField.borderStyle = UITextBorderStyleNone;
    _areaTextField.backgroundColor = [UIColor clearColor];
    [_areaTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    _areaTextField.placeholder = @"广东 深圳市 南山区";
    
    _addressTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + xValue, 10, 200, 30)];
    _addressTextField.font = [UIFont systemFontOfSize:14.0f];
    _addressTextField.delegate = self;
    _addressTextField.textAlignment = UITextAlignmentRight;
    _addressTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _addressTextField.returnKeyType = UIReturnKeyDone;
    _addressTextField.borderStyle = UITextBorderStyleNone;
    _addressTextField.backgroundColor = [UIColor clearColor];
    [_addressTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    _addressTextField.placeholder = @"详细地址";
    
    [label release];
    
    self.nameTextField.text = info.per_name;
    self.telTextField.text = info.per_tel;
    self.postTextField.text = info.per_post;
    if (info.per_province.length == 0 && info.per_city.length == 0 && info.per_area.length == 0) {
        self.areaTextField.text = nil;
        _isEdit = NO;
        self.title = @"新增收货地址";
    }else {
        self.areaTextField.text = [NSString stringWithFormat:@"%@ %@ %@",info.per_province,info.per_city,info.per_area];
        _isEdit = YES;
        self.title = @"修改收货地址";
    }
    self.addressTextField.text = info.per_detailAddress;
}

- (void)dealloc
{
    [_nameTextField release];
    [_telTextField release];
    [_postTextField release];
    [_areaTextField release];
    [_addressTextField release];
    [info release];
    [addrId release];
        
    [super dealloc];
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
    return 5;
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
            label.text = @"收货人：";
            label.font = [UIFont systemFontOfSize:16.0f];
            label.textAlignment = UITextAlignmentLeft;
            label.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label];
            [label release];
            
            [cell.contentView addSubview:_nameTextField];
        }
            break;
        case 1:
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake( 10, 10, 80, 30)];
            label.text = @"手机号码：";
            label.font = [UIFont systemFontOfSize:16.0f];
            label.textAlignment = UITextAlignmentLeft;
            label.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label];
            [label release];
            
            [cell.contentView addSubview:_telTextField];
        }
            break;
        case 2:
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake( 10, 10, 80, 30)];
            label.text = @"邮政编码：";
            label.font = [UIFont systemFontOfSize:16.0f];
            label.textAlignment = UITextAlignmentLeft;
            label.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label];
            [label release];
            
            [cell.contentView addSubview:_postTextField];
        }
            break;
        case 3:
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake( 10, 10, 80, 30)];
            label.text = @"所在地区：";
            label.font = [UIFont systemFontOfSize:16.0f];
            label.textAlignment = UITextAlignmentLeft;
            label.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label];
            [label release];
            
            [cell.contentView addSubview:_areaTextField];
            
            CGFloat xValue = IOS_VERSION < 7.0 ? 0.0f : 20.0f;
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn addTarget:self action:@selector(selectArea) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(CGRectGetMaxX(label.frame) + xValue, 10, 200, 30);
            [cell.contentView addSubview:btn];
        }
            break;
        case 4:
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake( 10, 10, 80, 30)];
            label.text = @"详细地址：";
            label.font = [UIFont systemFontOfSize:16.0f];
            label.textAlignment = UITextAlignmentLeft;
            label.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label];
            [label release];
            
            [cell.contentView addSubview:_addressTextField];
        }
            break;
            
        default:
            break;
    }

    return cell;
}

#pragma mark ----UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameTextField) {
        [self.nameTextField resignFirstResponder];
        [self.telTextField becomeFirstResponder];
    }else if (textField == self.areaTextField) {
        [self.areaTextField resignFirstResponder];
        [self.addressTextField becomeFirstResponder];
    }else if (textField == self.addressTextField) {
        [self.addressTextField resignFirstResponder];
    }
    
    return YES;
}

#pragma mark ----UIActionSheetDelegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1){
        TSLocateView *tt = (TSLocateView *)actionSheet;
        
        self.areaTextField.text = [NSString stringWithFormat:@"%@ %@ %@",tt.locate.country,tt.locate.city,tt.locate.state];
    }
}

#pragma mark -----private methods
- (void)hideKeyboard
{
    [_nameTextField resignFirstResponder];
    [_telTextField resignFirstResponder];
    [_postTextField resignFirstResponder];
    [_areaTextField resignFirstResponder];
    [_addressTextField resignFirstResponder];
}

- (void)selectArea
{
    [self hideKeyboard];
    TSLocateView *locateView = [[TSLocateView alloc] initWithTitle:nil withFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 200) delegate:self];
    
    locateView.tag = 120;
    
    NSArray *arr = [self.areaTextField.text componentsSeparatedByString:@" "];
    locateView.strArray = arr;
    
    shoppingAppDelegate *delegate =  (shoppingAppDelegate *)[UIApplication sharedApplication].delegate;
    [locateView showInView:delegate.window];
}

- (void)sureAction
{
    [self hideKeyboard];
    if (self.nameTextField.text.length == 0 || self.telTextField.text.length == 0 || self.postTextField.text.length == 0 || self.areaTextField.text.length == 0 || self.addressTextField.text.length == 0)
    {
        MBProgressHUD *mprogressHUD = [[MBProgressHUD alloc] initWithView:self.tableView];
        mprogressHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-信息.png"]] autorelease];
        mprogressHUD.mode = MBProgressHUDModeCustomView;
        mprogressHUD.labelText = @"请填写完整的信息";
        [self.view addSubview:mprogressHUD];
        [self.view bringSubviewToFront:mprogressHUD];
        [mprogressHUD show:YES];
        [mprogressHUD hide:YES afterDelay:1.5];
        [mprogressHUD release];
    }else if (self.telTextField.text.length != 11) {
        MBProgressHUD *mprogressHUD = [[MBProgressHUD alloc] initWithView:self.tableView];
        mprogressHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-信息.png"]] autorelease];
        mprogressHUD.mode = MBProgressHUDModeCustomView;
        mprogressHUD.labelText = @"请填写正确的手机号码";
        [self.view addSubview:mprogressHUD];
        [self.view bringSubviewToFront:mprogressHUD];
        [mprogressHUD show:YES];
        [mprogressHUD hide:YES afterDelay:1.5];
        [mprogressHUD release];
    }else if ([self.nameTextField.text isEqualToString:info.per_name] && [self.telTextField.text isEqualToString:info.per_tel] && [self.postTextField.text isEqualToString:info.per_post] && [self.areaTextField.text isEqualToString:[NSString stringWithFormat:@"%@ %@ %@",info.per_province,info.per_city,info.per_area]] && [self.addressTextField.text isEqualToString:info.per_detailAddress])
    {
//        MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithView:self.view];
//        progressHUDTmp.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-信息.png"]] autorelease];
//        progressHUDTmp.mode = MBProgressHUDModeCustomView;
//        progressHUDTmp.labelText = @"请编辑信息";
//        [self.view addSubview:progressHUDTmp];
//        [progressHUDTmp show:YES];
//        [progressHUDTmp hide:YES afterDelay:1];
//        [progressHUDTmp release];
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self accessService];
    }
}

- (void)accessService
{
    int _userId = [[[[DBOperate queryData:T_MEMBER_INFO theColumn:nil theColumnValue:nil withAll:YES] objectAtIndex:0] objectAtIndex:member_info_memberId] intValue];
    
    NSMutableDictionary *jsontestDic = nil;
    if (_isEdit == NO) {
        jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                       [Common getSecureString],@"keyvalue",
                       [NSNumber numberWithInt: SITE_ID],@"site_id",
                       [NSNumber numberWithInt:_userId],@"user_id",
                       [NSNumber numberWithInt:0],@"type",
                       self.nameTextField.text,@"name",
                       self.telTextField.text,@"mobile",
                       [[self.areaTextField.text componentsSeparatedByString:@" "] objectAtIndex:0],@"province",
                       [[self.areaTextField.text componentsSeparatedByString:@" "] objectAtIndex:1],@"city",
                       [[self.areaTextField.text componentsSeparatedByString:@" "] objectAtIndex:2],@"area",
                       self.addressTextField.text,@"adress",
                       self.postTextField.text,@"zip_code",nil];

    }else {
        jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                       [Common getSecureString],@"keyvalue",
                       [NSNumber numberWithInt: SITE_ID],@"site_id",
                       [NSNumber numberWithInt:_userId],@"user_id",
                       [NSNumber numberWithInt:1],@"type",
                       self.nameTextField.text,@"name",
                       self.telTextField.text,@"mobile",
                       [[self.areaTextField.text componentsSeparatedByString:@" "] objectAtIndex:0],@"province",
                       [[self.areaTextField.text componentsSeparatedByString:@" "] objectAtIndex:1],@"city",
                       [[self.areaTextField.text componentsSeparatedByString:@" "] objectAtIndex:2],@"area",
                       self.addressTextField.text,@"adress",
                       self.postTextField.text,@"zip_code",
                       [NSNumber numberWithInt:[self.addrId intValue]],@"id",nil];
    }
    
    [[DataManager sharedManager] accessService:jsontestDic command:ADDOREDIT_ADDRESS_COMMAND_ID accessAdress:@"member/addorUpdateaddress.do?param=%@" delegate:self withParam:jsontestDic];
}

- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver{
	NSLog(@"information finish");
	NSLog(@"=====%@",resultArray);
    switch (commandid) {
        case ADDOREDIT_ADDRESS_COMMAND_ID:
        {
            [self performSelectorOnMainThread:@selector(update:) withObject:resultArray waitUntilDone:NO];
        }
            break;
            
        default:
            break;
    }
}

- (void)update:(NSMutableArray *)resultArray
{
    int _userId = [[[[DBOperate queryData:T_MEMBER_INFO theColumn:nil theColumnValue:nil withAll:YES] objectAtIndex:0] objectAtIndex:member_info_memberId] intValue];
   
    if ([resultArray count] > 0) {
        if ([[resultArray objectAtIndex:0] intValue] == 1) {
            self.info.per_name = self.nameTextField.text;
            self.info.per_tel = self.telTextField.text;
            self.info.per_post = self.postTextField.text;
            self.info.per_province = [[self.areaTextField.text componentsSeparatedByString:@" "] objectAtIndex:0];
            self.info.per_city = [[self.areaTextField.text componentsSeparatedByString:@" "] objectAtIndex:1];
            self.info.per_area = [[self.areaTextField.text componentsSeparatedByString:@" "] objectAtIndex:2];
            self.info.per_detailAddress = self.addressTextField.text;
       
            if (_isEdit == NO) {
                NSArray *ay = [[NSArray alloc] init];
                if (_fromPrize == YES) {
                    [DBOperate updateWithTwoConditions:T_ADDRESS_LIST theColumn:@"isPrizeDefault" theColumnValue:@"0" ColumnOne:@"memberId" valueOne:[NSString stringWithFormat:@"%d",_userId] columnTwo:@"1" valueTwo:[NSNumber numberWithInt:1]];
                    
                    ay = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:[[resultArray objectAtIndex:1] intValue]],[NSNumber numberWithInt:_userId],self.nameTextField.text,self.telTextField.text,[[self.areaTextField.text componentsSeparatedByString:@" "] objectAtIndex:0],[[self.areaTextField.text componentsSeparatedByString:@" "] objectAtIndex:1],[[self.areaTextField.text componentsSeparatedByString:@" "] objectAtIndex:2],self.addressTextField.text,self.postTextField.text,[NSNumber numberWithInt:[[resultArray objectAtIndex:2] intValue]],[NSNumber numberWithInt:1],[NSNumber numberWithInt:0], nil];
                }else {
                    [DBOperate updateWithTwoConditions:T_ADDRESS_LIST theColumn:@"isReceiveDefault" theColumnValue:@"0" ColumnOne:@"memberId" valueOne:[NSString stringWithFormat:@"%d",_userId] columnTwo:@"1" valueTwo:[NSNumber numberWithInt:1]];
                    
                    ay = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:[[resultArray objectAtIndex:1] intValue]],[NSNumber numberWithInt:_userId],self.nameTextField.text,self.telTextField.text,[[self.areaTextField.text componentsSeparatedByString:@" "] objectAtIndex:0],[[self.areaTextField.text componentsSeparatedByString:@" "] objectAtIndex:1],[[self.areaTextField.text componentsSeparatedByString:@" "] objectAtIndex:2],self.addressTextField.text,self.postTextField.text,[NSNumber numberWithInt:[[resultArray objectAtIndex:2] intValue]],[NSNumber numberWithInt:0],[NSNumber numberWithInt:1], nil];
                }
                
                [DBOperate insertDataWithnotAutoID:ay tableName:T_ADDRESS_LIST];
            }else {
                NSArray *ay = [[NSArray alloc] init];
                if (_fromPrize == YES) {
                    [DBOperate updateWithTwoConditions:T_ADDRESS_LIST theColumn:@"isPrizeDefault" theColumnValue:@"0" ColumnOne:@"memberId" valueOne:[NSString stringWithFormat:@"%d",_userId] columnTwo:@"1" valueTwo:[NSNumber numberWithInt:1]];
                    
                    NSArray *dbArr = [DBOperate queryData:T_ADDRESS_LIST theColumn:@"memberId" equalValue:[NSString stringWithFormat:@"%d",_userId] theColumn:@"id" equalValue:self.addrId];
                    int _isReceiveDefault = [[[dbArr objectAtIndex:0] objectAtIndex:address_list_isReceiveDefault] intValue];
                    
                    [DBOperate deleteDataWithTwoConditions:T_ADDRESS_LIST columnOne:@"memberId" valueOne:[NSString stringWithFormat:@"%d",_userId] columnTwo:@"id" valueTwo:self.addrId];
                    
                    ay = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:[self.addrId intValue]],[NSNumber numberWithInt:_userId],self.nameTextField.text,self.telTextField.text,[[self.areaTextField.text componentsSeparatedByString:@" "] objectAtIndex:0],[[self.areaTextField.text componentsSeparatedByString:@" "] objectAtIndex:1],[[self.areaTextField.text componentsSeparatedByString:@" "] objectAtIndex:2],self.addressTextField.text,self.postTextField.text,[NSNumber numberWithInt:[[resultArray objectAtIndex:2] intValue]],[NSNumber numberWithInt:1],[NSNumber numberWithInt:_isReceiveDefault], nil];
                }else {
                    [DBOperate updateWithTwoConditions:T_ADDRESS_LIST theColumn:@"isReceiveDefault" theColumnValue:@"0" ColumnOne:@"memberId" valueOne:[NSString stringWithFormat:@"%d",_userId] columnTwo:@"1" valueTwo:[NSNumber numberWithInt:1]];
                    
                    NSArray *dbArr = [DBOperate queryData:T_ADDRESS_LIST theColumn:@"memberId" equalValue:[NSString stringWithFormat:@"%d",_userId] theColumn:@"id" equalValue:self.addrId];
                    int _isPrizeDefault = [[[dbArr objectAtIndex:0] objectAtIndex:address_list_isPrizeDefault] intValue];
                    
                    [DBOperate deleteDataWithTwoConditions:T_ADDRESS_LIST columnOne:@"memberId" valueOne:[NSString stringWithFormat:@"%d",_userId] columnTwo:@"id" valueTwo:self.addrId];
                    
                    ay = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:[self.addrId intValue]],[NSNumber numberWithInt:_userId],self.nameTextField.text,self.telTextField.text,[[self.areaTextField.text componentsSeparatedByString:@" "] objectAtIndex:0],[[self.areaTextField.text componentsSeparatedByString:@" "] objectAtIndex:1],[[self.areaTextField.text componentsSeparatedByString:@" "] objectAtIndex:2],self.addressTextField.text,self.postTextField.text,[NSNumber numberWithInt:[[resultArray objectAtIndex:2] intValue]],[NSNumber numberWithInt:_isPrizeDefault],[NSNumber numberWithInt:1], nil];
                }
                
                [DBOperate insertDataWithnotAutoID:ay tableName:T_ADDRESS_LIST];
            }
            
            if (myAddress != nil) {
                myAddress._isService = YES;
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

@end
