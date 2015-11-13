//
//  MyOrdersCell.h
//  shopping
//
//  Created by 来 云 on 13-1-14.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrdersCell : UITableViewCell
{
    UIImageView *_cImageView;
	UILabel *_cOrderTime;
	UILabel *_cOrderNumber;
	UILabel *_cOrderPrice;
    UILabel *_cOrderSum;
	UIImageView *_cTypeSuccessImageView;
    UIImageView *_cTypeWaitSendImageView;
    UIImageView *_cTypeWaitReceiveImageView;
    UIImageView *_cTypePayImageView;
    UIImageView *_cTypeCancelImageView;
}
@property (nonatomic, retain) UIImageView *cImageView;
@property (nonatomic, retain) UILabel *cOrderTime;
@property (nonatomic, retain) UILabel *cOrderNumber;
@property (nonatomic, retain) UILabel *cOrderPrice;
@property (nonatomic, retain) UILabel *cOrderSum;
@property (nonatomic, retain) UIImageView *cTypeSuccessImageView;
@property (nonatomic, retain) UIImageView *cTypeWaitSendImageView;
@property (nonatomic, retain) UIImageView *cTypeWaitReceiveImageView;
@property (nonatomic, retain) UIImageView *cTypePayImageView;
@property (nonatomic, retain) UIImageView *cTypeCancelImageView;
@end
