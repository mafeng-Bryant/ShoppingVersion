//
//  MyDiscountDetailViewController.m
//  shopping
//
//  Created by 来 云 on 13-1-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MyDiscountDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DBOperate.h"
#import "Common.h"
@interface MyDiscountDetailViewController ()

@end

@implementation MyDiscountDetailViewController
@synthesize detailArray = __detailArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        __detailArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    
    CGFloat xValue = IOS_VERSION < 7.0 ? 0.0f : 20.0f;
    vi = [[UIView alloc] initWithFrame:CGRectMake(0, xValue, self.view.frame.size.width, VIEW_HEIGHT - 20.0f)];
    vi.backgroundColor = [UIColor blackColor];
    [self.view addSubview:vi];
    
    UIImage *navImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"优惠券上bar" ofType:@"png"]];
    UIImageView *navImageView = [[UIImageView alloc] initWithFrame:CGRectMake((320 - navImage.size.width) * 0.5 , 0 , navImage.size.width, navImage.size.height)];
    navImageView.userInteractionEnabled = YES;
    navImageView.image = navImage;
    [vi addSubview:navImageView];
    
    UIImage *backImg = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"优惠券返回" ofType:@"png"]];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom]; 
    backButton.tag = 11;
    backButton.frame = CGRectMake(10, (44 - backImg.size.height) * 0.5, backImg.size.width, backImg.size.height);  
	[backButton addTarget:self action:@selector(buttonEvents:) forControlEvents:UIControlEventTouchUpInside];
	[backButton setBackgroundImage:backImg forState:UIControlStateNormal]; 
    [navImageView addSubview:backButton];
    
    UIImage *btnImg = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"信息icon" ofType:@"png"]];
    swithButton = [UIButton buttonWithType:UIButtonTypeCustom]; 
    swithButton.tag = 22;
    swithButton.frame = CGRectMake(navImageView.frame.size.width - btnImg.size.width - 10, (44 - btnImg.size.height) * 0.5, btnImg.size.width, btnImg.size.height);  
	[swithButton addTarget:self action:@selector(buttonEvents:) forControlEvents:UIControlEventTouchUpInside];
	[swithButton setBackgroundImage:btnImg forState:UIControlStateNormal]; 
    [navImageView addSubview:swithButton];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(backButton.frame), 0, swithButton.frame.origin.x - CGRectGetMaxX(backButton.frame), 44)];
    titleLabel.text = [self.detailArray objectAtIndex:mydiscountlist_name];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    //titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [navImageView addSubview:titleLabel];
    [self addMainView];
    
    [self addRulesView];
}

- (void)addMainView
{
    mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, vi.frame.size.height - 44)];
    mainView.backgroundColor = [UIColor clearColor];
    [vi addSubview:mainView];
    
    UIImage *bgImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"代金券背景" ofType:@"png"]];
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake((320 - bgImage.size.width) * 0.5 , 0 , bgImage.size.width, bgImage.size.height)];
    bgImageView.image = bgImage;
    [mainView addSubview:bgImageView];
    
    UILabel *_cName = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 200, 20)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_cName.frame), 15, 35)];
    label.text = @"¥";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:20.0f];
    label.textAlignment = UITextAlignmentLeft;
    label.backgroundColor = [UIColor clearColor];
    [bgImageView addSubview:label];
    [label release];
    
    UILabel *_cPrice = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), CGRectGetMaxY(_cName.frame), 50, 35)];
    _cPrice.text = [self.detailArray objectAtIndex:mydiscountlist_price];
    _cPrice.textColor = [UIColor whiteColor];
    _cPrice.font = [UIFont boldSystemFontOfSize:24.0f];
    _cPrice.textAlignment = UITextAlignmentLeft;
    _cPrice.backgroundColor = [UIColor clearColor];
    [bgImageView addSubview:_cPrice];
    [_cPrice release];
    
    UILabel *_cPriceName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cPrice.frame), CGRectGetMaxY(_cName.frame), 100, 35)];
    _cPriceName.text = [self.detailArray objectAtIndex:mydiscountlist_unitname];
    _cPriceName.textColor = [UIColor whiteColor];
    _cPriceName.font = [UIFont boldSystemFontOfSize:20.0f];
    _cPriceName.textAlignment = UITextAlignmentLeft;
    _cPriceName.backgroundColor = [UIColor clearColor];
    [bgImageView addSubview:_cPriceName];
    [_cPriceName release];
    
    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cName.frame), 20, 80, 15)];
    time.text = @"有效期";
    time.font = [UIFont systemFontOfSize:14.0f];
    time.textColor = [UIColor whiteColor];
    time.textAlignment = UITextAlignmentRight;
    time.backgroundColor = [UIColor clearColor];
    [bgImageView addSubview:time];
    [time release];
    
    UILabel *_cStartTime = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cName.frame), CGRectGetMaxY(time.frame), 80, 15)];
    _cStartTime.tag = 1;
    _cStartTime.font = [UIFont systemFontOfSize:14.0f];
    _cStartTime.textColor = [UIColor whiteColor];
    _cStartTime.textAlignment = UITextAlignmentRight;
    _cStartTime.backgroundColor = [UIColor clearColor];
    [bgImageView addSubview:_cStartTime];
    
    int createTime1 = [[self.detailArray objectAtIndex:mydiscountlist_starttime] intValue];
    NSDate* date1 = [NSDate dateWithTimeIntervalSince1970:createTime1];
    NSDateFormatter *outputFormat1 = [[NSDateFormatter alloc] init];
    [outputFormat1 setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString1 = [outputFormat1 stringFromDate:date1];
    [outputFormat1 release];
    _cStartTime.text = dateString1;
    [_cStartTime release];
    
    UILabel *_cEndTime = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cName.frame), CGRectGetMaxY(_cStartTime.frame), 80, 15)];
    _cEndTime.font = [UIFont systemFontOfSize:14.0f];
    _cEndTime.textColor = [UIColor whiteColor];
    _cEndTime.textAlignment = UITextAlignmentRight;
    _cEndTime.backgroundColor = [UIColor clearColor];
    [bgImageView addSubview:_cEndTime];
    
    int createTime2 = [[self.detailArray objectAtIndex:mydiscountlist_endtime] intValue];
    NSDate* date2 = [NSDate dateWithTimeIntervalSince1970:createTime2];
    NSDateFormatter *outputFormat2 = [[NSDateFormatter alloc] init];
    [outputFormat2 setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString2 = [outputFormat2 stringFromDate:date2];
    [outputFormat2 release];
    _cEndTime.text = dateString2;
    [_cEndTime release];
    
    UIImage *bigImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"优惠券详情" ofType:@"png"]];
    UIImageView *bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(bgImageView.frame.origin.x, CGRectGetMaxY(bgImageView.frame), bigImage.size.width, vi.frame.size.height - CGRectGetMaxY(bgImageView.frame) - 44)];
    bottomView.image = [bigImage stretchableImageWithLeftCapWidth:0 topCapHeight:bigImage.size.height * 0.5];
    [mainView addSubview:bottomView];
    bottomView.userInteractionEnabled = YES;
    
    UIView *whiteVi = [[UIView alloc] initWithFrame:CGRectMake(5, 10, 294, bottomView.frame.size.height - 20)];
    whiteVi.backgroundColor = [UIColor whiteColor];
    whiteVi.layer.masksToBounds = YES;
    whiteVi.layer.cornerRadius = 6;
    [bottomView addSubview:whiteVi];
    
    UILabel *labelStr = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 280, 30)];
    labelStr.text = @"条款声明";
    labelStr.font = [UIFont boldSystemFontOfSize:14.0f];
    labelStr.textColor = [UIColor blackColor];
    labelStr.textAlignment = UITextAlignmentLeft;
    labelStr.backgroundColor = [UIColor clearColor];
    [whiteVi addSubview:labelStr];
    [labelStr release];
    
    UITextView *contentView = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(labelStr.frame), whiteVi.frame.size.width, whiteVi.frame.size.height - CGRectGetMaxY(labelStr.frame))];
    contentView.textColor = [UIColor darkTextColor];
    contentView.editable = NO;
    contentView.scrollEnabled = YES;
    contentView.showsHorizontalScrollIndicator = YES;
    contentView.font = [UIFont systemFontOfSize:13.0f];
    contentView.backgroundColor = [UIColor clearColor];
    contentView.text = [self.detailArray objectAtIndex:mydiscountlist_desc];
    [whiteVi addSubview:contentView];
    [contentView release];
    
    [bgImageView release];
    [bottomView release];
    [whiteVi release];
}

- (void)addRulesView
{
    rulesView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, vi.frame.size.height - 44)];
    rulesView.backgroundColor = [UIColor clearColor];
    [vi addSubview:rulesView];
    
    UIImage *bgImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"优惠券背面" ofType:@"png"]];
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake((320 - bgImage.size.width) * 0.5 , 0 , bgImage.size.width, vi.frame.size.height - 44)];
    bgImageView.image = [bgImage stretchableImageWithLeftCapWidth:0 topCapHeight:bgImage.size.height * 0.5];
    [rulesView addSubview:bgImageView];
    
    UILabel *labelStr = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 274, 400)];
    labelStr.text = @"说明：凡涉及到优惠券的任何活动，均应适用本规则，但该活动有特别规定的适用其特别规定。\n\n1、优惠券仅限当前客户端注册用户领取；\n\n2、优惠券只能用于购买当前客户端中商品；\n\n3、单笔交易成交价格（不包括运费及其他费用）必须大于或者等于活动指定优惠券最低使用金额；\n\n4、用户必须在优惠券指定有效期内使用；\n\n5、优惠券活动中每张优惠券仅限被使用一次，超出有效期仍未使用，该优惠券失效；\n\n6、交易过程中若产生纠纷时，如最终结果是退款给买家，买家所得到的退款金额仅限于买家实际付款的金额，不包括优惠券部分的金额；\n\n7、由于帐户盗用等非常规原因或用户自身原因造成不能使用优惠券的，与本公司无涉；\n\n8、本公司有权随时调整、更新、修改本规则。 ";
    labelStr.font = [UIFont systemFontOfSize:12.0f];
    labelStr.textColor = [UIColor colorWithRed:0.462 green:0.462 blue:0.462 alpha:1.0];
    labelStr.textAlignment = UITextAlignmentLeft;
    labelStr.numberOfLines = 0;
    labelStr.lineBreakMode = UILineBreakModeWordWrap;
    labelStr.backgroundColor = [UIColor clearColor];
    [bgImageView addSubview:labelStr];
    [labelStr release];
    
    [bgImageView release];
    rulesView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc
{
    [swithButton release];
    [mainView release];
    [rulesView release];
    [vi release];
    [titleLabel release];
    [__detailArray release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark ----private methods
- (void)buttonEvents:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 11) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }else {
        
        if (_isSwith == NO)
        {
            mainView.hidden = YES;
            titleLabel.text = @"优惠卷规则";    
            [UIView beginAnimations:nil context:rulesView];
            [UIView setAnimationDuration:1];
            rulesView.hidden = NO;
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:vi cache:YES];
            [UIView commitAnimations];
            
            _isSwith = YES;
        }
        else
        {
            rulesView.hidden = YES;
            //titleLabel.text = [self.detailArray objectAtIndex:mydiscountlist_name];
            [UIView beginAnimations:nil context:mainView];
            [UIView setAnimationDuration:1];
            mainView.hidden = NO;
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:vi cache:YES];
            [UIView commitAnimations];
            _isSwith = NO;
            
        }
    }
}
@end
