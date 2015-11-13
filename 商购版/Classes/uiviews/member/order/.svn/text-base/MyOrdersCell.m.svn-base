//
//  MyOrdersCell.m
//  shopping
//
//  Created by 来 云 on 13-1-14.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MyOrdersCell.h"
#define kImageViewX  7
#define kSpace  12

@implementation MyOrdersCell
@synthesize cImageView = _cImageView;
@synthesize cOrderTime = _cOrderTime;
@synthesize cOrderNumber = _cOrderNumber;
@synthesize cOrderPrice = _cOrderPrice;
@synthesize cOrderSum = _cOrderSum;
@synthesize cTypeSuccessImageView = _cTypeSuccessImageView;
@synthesize cTypeWaitSendImageView = _cTypeWaitSendImageView;
@synthesize cTypeWaitReceiveImageView = _cTypeWaitReceiveImageView;
@synthesize cTypePayImageView = _cTypePayImageView;
@synthesize cTypeCancelImageView = _cTypeCancelImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //背景
        UIImage *cellbackgroundImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表背景" ofType:@"png"]];
        UIImageView *cellbackgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f , 0.0f , self.frame.size.width , self.frame.size.height)];
        cellbackgroundImageView.image = cellbackgroundImage;
        [cellbackgroundImage release];
        self.backgroundView = cellbackgroundImageView;
        [cellbackgroundImageView release];
		
		//图片
        UIImage *defaultImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表默认图片" ofType:@"png"]];
		_cImageView = [[UIImageView alloc] init];
		[_cImageView setFrame:CGRectMake(7,8, 70, 70)];
		[_cImageView setImage:defaultImage];
		[self.contentView addSubview:_cImageView];
        [defaultImage release];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cImageView.frame) + 10, kSpace, 70, 20)];
		label.text = @"下单时间：";
		label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor darkGrayColor];
		label.textAlignment = UITextAlignmentLeft;
		label.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:label];
        [label release];
		
        _cOrderTime = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), kSpace, 150, 20)];
		_cOrderTime.text = @"";
		_cOrderTime.font = [UIFont systemFontOfSize:14];
        _cOrderTime.textColor = [UIColor darkGrayColor];
		_cOrderTime.textAlignment = UITextAlignmentLeft;
		_cOrderTime.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:_cOrderTime];
		
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cImageView.frame) + 10, CGRectGetMaxY(label.frame), 60, 20)];
		label2.text = @"订单号：";
		label2.font = [UIFont systemFontOfSize:14];
        label2.textColor = [UIColor darkGrayColor];
		label2.textAlignment = UITextAlignmentLeft;
		label2.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:label2];
        [label2 release];

		_cOrderNumber = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label2.frame), CGRectGetMaxY(label.frame), 150, 20)];
		_cOrderNumber.text = @"";
		_cOrderNumber.font = [UIFont systemFontOfSize:14.0f];
        _cOrderNumber.textColor = [UIColor darkGrayColor];
		_cOrderNumber.textAlignment = UITextAlignmentLeft;
		_cOrderNumber.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:_cOrderNumber];
        
        _cOrderPrice = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cImageView.frame) + 10, CGRectGetMaxY(label2.frame), 80, 20)];
		_cOrderPrice.text = @"";
		_cOrderPrice.font = [UIFont systemFontOfSize:16.0f];
        _cOrderPrice.textColor = [UIColor redColor];
		_cOrderPrice.textAlignment = UITextAlignmentLeft;
		_cOrderPrice.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:_cOrderPrice];
        
        _cOrderSum = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cOrderPrice.frame), CGRectGetMaxY(label2.frame), 100, 20)];
		_cOrderSum.text = @"";
		_cOrderSum.font = [UIFont systemFontOfSize:14.0f];
        _cOrderSum.textColor = [UIColor darkGrayColor];
		_cOrderSum.textAlignment = UITextAlignmentLeft;
		_cOrderSum.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:_cOrderSum];
        
        //右箭头
        UIImageView *rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(300, 36, 16, 11)];
        UIImage *rimg;
        rimg = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"右箭头" ofType:@"png"]];
        rightImage.image = rimg;
        [rimg release];
        [self.contentView addSubview:rightImage];
        [rightImage release];
        
        _cTypeSuccessImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 320 - 67, 55.0f, 67.0f , 22.0f)];
		UIImage *recommendImage1 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"交易成功" ofType:@"png"]];
		_cTypeSuccessImageView.image = recommendImage1;
		[recommendImage1 release];
		[self.contentView addSubview:_cTypeSuccessImageView];
		_cTypeSuccessImageView.hidden = YES;
        
        _cTypeWaitSendImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 320 - 67, 55.0f, 67.0f , 22.0f)];
		UIImage *recommendImage2 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"等待发货" ofType:@"png"]];
		_cTypeWaitSendImageView.image = recommendImage2;
		[recommendImage2 release];
		[self.contentView addSubview:_cTypeWaitSendImageView];
		_cTypeWaitSendImageView.hidden = YES;
        
        _cTypeWaitReceiveImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 320 - 67, 55.0f, 67.0f , 22.0f)];
		UIImage *recommendImage5 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"等待收货" ofType:@"png"]];
		_cTypeWaitReceiveImageView.image = recommendImage5;
		[recommendImage5 release];
		[self.contentView addSubview:_cTypeWaitReceiveImageView];
		_cTypeWaitReceiveImageView.hidden = YES;
        
        _cTypePayImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 320 - 67, 55.0f, 67.0f , 22.0f)];
		UIImage *recommendImage3 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"等待支付" ofType:@"png"]];
		_cTypePayImageView.image = recommendImage3;
		[recommendImage3 release];
		[self.contentView addSubview:_cTypePayImageView];
		_cTypePayImageView.hidden = YES;
        
        _cTypeCancelImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 320 - 67, 55.0f, 67.0f , 22.0f)];
		UIImage *recommendImage4 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"关闭订单" ofType:@"png"]];
		_cTypeCancelImageView.image = recommendImage4;
		[recommendImage4 release];
		[self.contentView addSubview:_cTypeCancelImageView];
		_cTypeCancelImageView.hidden = YES;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [_cImageView release];
    [_cOrderTime release];
    [_cOrderNumber release];
    [_cOrderPrice release];
    [_cOrderSum release];
    [_cTypeSuccessImageView release];
    [_cTypeWaitSendImageView release];
    [_cTypeWaitReceiveImageView release];
    [_cTypePayImageView release];
    [_cTypeCancelImageView release];
    [super dealloc];
}

@end
