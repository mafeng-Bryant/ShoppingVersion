//
//  WritingInvoiceViewController.m
//  shopping
//
//  Created by 来 云 on 13-1-10.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "WritingInvoiceViewController.h"
#import "shoppingAppDelegate.h"

@interface WritingInvoiceViewController ()

@end

@implementation WritingInvoiceViewController
@synthesize invoicetypeTextField = _invoicetypeTextField;
@synthesize invoicetitleTextField = _invoicetitleTextField;
@synthesize invoicetitlenameTextField = _invoicetitlenameTextField;
@synthesize _delegate;
@synthesize info;

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
    self.title = @"填写发票";

    //self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"背景.png"]];
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
    
    _invoicetypeTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + xValue, 10, 200, 30)];
    _invoicetypeTextField.font = [UIFont systemFontOfSize:14.0f];
    _invoicetypeTextField.textAlignment = UITextAlignmentRight;
    _invoicetypeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _invoicetypeTextField.returnKeyType = UIReturnKeyNext;
    _invoicetypeTextField.borderStyle = UITextBorderStyleNone;
    _invoicetypeTextField.backgroundColor = [UIColor clearColor];
    [_invoicetypeTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    _invoicetypeTextField.text = @"普通发票";
    _invoicetypeTextField.enabled = NO;
    
    _invoicetitleTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + xValue, 10, 200, 30)];
    _invoicetitleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _invoicetitleTextField.returnKeyType = UIReturnKeyNext;
    _invoicetitleTextField.font = [UIFont systemFontOfSize:14.0f];
    _invoicetitleTextField.textAlignment = UITextAlignmentRight;
    _invoicetitleTextField.borderStyle = UITextBorderStyleNone;
    _invoicetitleTextField.backgroundColor = [UIColor clearColor];
    [_invoicetitleTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    _invoicetitlenameTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + xValue, 10, 200, 30)];
    _invoicetitlenameTextField.font = [UIFont systemFontOfSize:14.0f];
    _invoicetitlenameTextField.delegate = self;
    _invoicetitlenameTextField.textAlignment = UITextAlignmentRight;
    _invoicetitlenameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _invoicetitlenameTextField.returnKeyType = UIReturnKeyDone;
    _invoicetitlenameTextField.borderStyle = UITextBorderStyleNone;
    _invoicetitlenameTextField.backgroundColor = [UIColor clearColor];
    [_invoicetitlenameTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    [label release];
    
    //self.invoicetypeTextField.text = info.invoice_style;
    if (info.invoice_title == nil) {
        _invoicetitleTextField.text = @"单位";
    }else {
        _invoicetitleTextField.text = info.invoice_title;
        if ([info.invoice_title isEqualToString:@"单位"]) {
            _isPerson = NO;
        }else {
            _isPerson = YES;
        }
    }
    self.invoicetitlenameTextField.text = info.invoice_titleName;
}

- (void)dealloc
{
    [_invoicetypeTextField release];
    [_invoicetitleTextField release];
    [_invoicetitlenameTextField release];
    
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
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    //ios7新特性,解决分割线短一点
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    switch (indexPath.row) {
        case 0:
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake( 10, 10, 80, 30)];
            label.text = @"发票类型：";
            label.font = [UIFont systemFontOfSize:16.0f];
            label.textAlignment = UITextAlignmentLeft;
            label.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label];
            [label release];
            
            [cell.contentView addSubview:_invoicetypeTextField];
        }
            break;
        case 1:
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake( 10, 10, 80, 30)];
            label.text = @"发票抬头：";
            label.font = [UIFont systemFontOfSize:16.0f];
            label.textAlignment = UITextAlignmentLeft;
            label.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label];
            [label release];
            
            [cell.contentView addSubview:_invoicetitleTextField];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn addTarget:self action:@selector(selectTitle) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(_invoicetitleTextField.frame.origin.x, 10, 200, 30);
            [cell.contentView addSubview:btn];
        }
            break;
        case 2:
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake( 10, 10, 80, 30)];
            
            label.font = [UIFont systemFontOfSize:16.0f];
            label.textAlignment = UITextAlignmentLeft;
            label.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label];
            [label release];
            if (_isPerson == NO) {
                label.text = @"单位名称：";
            }else {
                label.text = @"个人名称：";
            }
            
            [cell.contentView addSubview:_invoicetitlenameTextField];
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
    if (textField == self.invoicetitlenameTextField) {
        [self.invoicetitlenameTextField resignFirstResponder];
    }
    return YES;
}

#pragma mark ----UIActionSheetDelegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1){
        if ([self.invoicetitleTextField.text isEqualToString:@"个人"]) {
            _isPerson = YES;
            [self.tableView reloadData];
        }else {
            _isPerson = NO;
            [self.tableView reloadData];
        }
    }
}
#pragma mark -----private methods
- (void)selectTitle
{
    [self.invoicetitlenameTextField resignFirstResponder];
    
    shoppingAppDelegate *delegate =  (shoppingAppDelegate *)[UIApplication sharedApplication].delegate;
    
    CustomPicker *picker = [[CustomPicker alloc] initWithTitle:nil withFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 200) delegate:self PickerArray:[NSMutableArray arrayWithObjects:@"单位",@"个人", nil] Obj:self.invoicetitleTextField];
    picker.delegate  = self;
    [picker showInDelegateView:delegate.window];
}

- (void)sureAction
{
    [self.invoicetitlenameTextField resignFirstResponder];
    if (self.invoicetitlenameTextField.text.length == 0) {
//        MBProgressHUD *mprogressHUD = [[MBProgressHUD alloc] initWithView:self.tableView];
//        mprogressHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-信息.png"]] autorelease];
//        mprogressHUD.mode = MBProgressHUDModeCustomView;
//        mprogressHUD.labelText = @"请填写完整的信息";
//        [self.view addSubview:mprogressHUD];
//        [self.view bringSubviewToFront:mprogressHUD];
//        [mprogressHUD show:YES];
//        [mprogressHUD hide:YES afterDelay:1.5];
//        [mprogressHUD release];
        
        info.invoice_style = self.invoicetypeTextField.text;
        info.invoice_title = self.invoicetitleTextField.text;
        info.invoice_titleName = @"";
        [self.navigationController popViewControllerAnimated:YES];
    }else {        
        info.invoice_style = self.invoicetypeTextField.text;
        info.invoice_title = self.invoicetitleTextField.text;
        info.invoice_titleName = self.invoicetitlenameTextField.text;
        [self.navigationController popViewControllerAnimated:YES];        
    }
}
@end
