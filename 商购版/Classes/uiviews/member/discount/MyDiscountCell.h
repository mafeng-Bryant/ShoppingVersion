//
//  MyDiscountCell.h
//  shopping
//
//  Created by 来 云 on 13-1-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDiscountCell : UITableViewCell
{
    UIImageView *_cBgView;
    UILabel *_cName;
    UILabel *_cPrice;
    UILabel *_cPriceName;
    UILabel *_cStartTime;
    UILabel *_cEndTime;
    
    UIImageView *_recommendImageViewUnuse;
    UIImageView *_recommendImageViewUsed;
    UIImageView *_recommendImageViewEnd;
}
@property (nonatomic, retain) UIImageView *cBgView;
@property (nonatomic, retain) UILabel *cName;
@property (nonatomic, retain) UILabel *cPrice;
@property (nonatomic, retain) UILabel *cPriceName;
@property (nonatomic, retain) UILabel *cStartTime;
@property (nonatomic, retain) UILabel *cEndTime;
@property (nonatomic, retain) UIImageView *recommendImageViewUnuse;
@property (nonatomic, retain) UIImageView *recommendImageViewUsed;
@property (nonatomic, retain) UIImageView *recommendImageViewEnd;
@end
