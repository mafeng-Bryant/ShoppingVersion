//
//  MyDiscountDetailViewController.h
//  shopping
//
//  Created by 来 云 on 13-1-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDiscountDetailViewController : UIViewController
{
    BOOL _isSwith;
    UIButton *swithButton;
    UIView *mainView;
    UIView *rulesView;
    
    UILabel *titleLabel;
    
    NSMutableArray *__detailArray;
    
    UIView *vi;
}
@property (nonatomic, retain) NSMutableArray *detailArray;
@end

