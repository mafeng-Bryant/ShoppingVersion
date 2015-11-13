//
//  MyDiscountCell.m
//  shopping
//
//  Created by 来 云 on 13-1-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MyDiscountCell.h"

@implementation MyDiscountCell
@synthesize cBgView = _cBgView;
@synthesize cName = _cName;
@synthesize cPrice = _cPrice;
@synthesize cPriceName = _cPriceName;
@synthesize cStartTime = _cStartTime;
@synthesize cEndTime = _cEndTime;
@synthesize recommendImageViewUnuse = _recommendImageViewUnuse;
@synthesize recommendImageViewUsed = _recommendImageViewUsed;
@synthesize recommendImageViewEnd = _recommendImageViewEnd;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImage *bgImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"代金券背景" ofType:@"png"]];
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake((320 - bgImage.size.width) * 0.5 , 0 , bgImage.size.width, bgImage.size.height)];
        bgImageView.image = bgImage;
        //bgImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:bgImageView];
        _cBgView = bgImageView;
        
        _cName = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 200, 20)];
		_cName.text = @"";
        _cName.textColor = [UIColor whiteColor];
		_cName.font = [UIFont systemFontOfSize:14.0f];
		_cName.textAlignment = UITextAlignmentLeft;
		_cName.backgroundColor = [UIColor clearColor];
		[bgImageView addSubview:_cName];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_cName.frame), 15, 40)];
		label.text = @"¥";
        label.textColor = [UIColor whiteColor];
		label.font = [UIFont boldSystemFontOfSize:16.0f];
		label.textAlignment = UITextAlignmentLeft;
		label.backgroundColor = [UIColor clearColor];
		[bgImageView addSubview:label];
        [label release];
        
		_cPrice = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), CGRectGetMaxY(_cName.frame), 50, 40)];
		_cPrice.text = @"";
        _cPrice.textColor = [UIColor whiteColor];
		_cPrice.font = [UIFont boldSystemFontOfSize:18.0f];
		_cPrice.textAlignment = UITextAlignmentLeft;
		_cPrice.backgroundColor = [UIColor clearColor];
		[bgImageView addSubview:_cPrice];
        
        _cPriceName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cPrice.frame), CGRectGetMaxY(_cName.frame), 100, 40)];
		_cPriceName.text = @"";
        _cPriceName.textColor = [UIColor whiteColor];
		_cPriceName.font = [UIFont boldSystemFontOfSize:18.0f];
		_cPriceName.textAlignment = UITextAlignmentLeft;
		_cPriceName.backgroundColor = [UIColor clearColor];
		[bgImageView addSubview:_cPriceName];
        
        
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cName.frame), 20, 80, 15)];
		time.text = @"有效期";
		time.font = [UIFont systemFontOfSize:14.0f];
        time.textColor = [UIColor whiteColor];
		time.textAlignment = UITextAlignmentRight;
		time.backgroundColor = [UIColor clearColor];
		[bgImageView addSubview:time];
        [time release];
        
        _cStartTime = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cName.frame), CGRectGetMaxY(time.frame), 80, 15)];
		_cStartTime.text = @"";
		_cStartTime.font = [UIFont systemFontOfSize:14.0f];
        _cStartTime.textColor = [UIColor whiteColor];
		_cStartTime.textAlignment = UITextAlignmentRight;
		_cStartTime.backgroundColor = [UIColor clearColor];
		[bgImageView addSubview:_cStartTime];
        
        _cEndTime = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cName.frame), CGRectGetMaxY(_cStartTime.frame), 80, 15)];
		_cEndTime.text = @"";
		_cEndTime.font = [UIFont systemFontOfSize:14.0f];
        _cEndTime.textColor = [UIColor whiteColor];
		_cEndTime.textAlignment = UITextAlignmentRight;
		_cEndTime.backgroundColor = [UIColor clearColor];
		[bgImageView addSubview:_cEndTime];
        
        //        UIImage *recommendImage1 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"推荐" ofType:@"png"]];
        //        _recommendImageViewUnuse = [[UIImageView alloc] initWithFrame:CGRectMake( 285.0f, 0.0f, 30.0f , 30.0f)];
        //		_recommendImageViewUnuse.image = recommendImage1;
        //		[recommendImage1 release];
        //		[self.contentView addSubview:_recommendImageViewUnuse];
        //		_recommendImageViewUnuse.hidden = YES;
        
        UIImage *recommendImage2 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"已消费" ofType:@"png"]];
        _recommendImageViewUsed = [[UIImageView alloc] initWithFrame:CGRectMake( bgImageView.frame.size.width - recommendImage2.size.width - 10, (bgImageView.frame.size.height-recommendImage2.size.height) *0.5, recommendImage2.size.width , recommendImage2.size.height)];
		_recommendImageViewUsed.image = recommendImage2;
		[recommendImage2 release];
		[bgImageView addSubview:_recommendImageViewUsed];
		_recommendImageViewUsed.hidden = YES;
        
        UIImage *recommendImage3 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"已过期" ofType:@"png"]];
        _recommendImageViewEnd = [[UIImageView alloc] initWithFrame:CGRectMake( bgImageView.frame.size.width - recommendImage3.size.width - 10, (bgImageView.frame.size.height-recommendImage3.size.height) *0.5, recommendImage3.size.width , recommendImage3.size.height)];
		_recommendImageViewEnd.image = recommendImage3;
		[recommendImage3 release];
		[bgImageView addSubview:_recommendImageViewEnd];
		_recommendImageViewEnd.hidden = YES;
        
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
    [_cBgView release];
    [_cName release];
    [_cPrice release];
    [_cPriceName release];
    [_cStartTime release];
    [_cEndTime release];
    [_recommendImageViewUnuse release];
    [_recommendImageViewUsed release];
    [_recommendImageViewEnd release];
    [super dealloc];
}
@end

