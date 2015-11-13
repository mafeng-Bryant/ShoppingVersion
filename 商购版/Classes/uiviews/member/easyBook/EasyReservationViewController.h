//
//  EasyReservationViewController.h
//  shopping
//
//  Created by 来 云 on 13-1-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CommandOperation.h"
@interface EasyReservationViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,CommandOperationDelegate,MBProgressHUDDelegate>
{
    UITableView *_myTableView;
    NSMutableArray *__listArray;
    UIActivityIndicatorView *indicatorView;
    MBProgressHUD *progressHUD;
    
    UIActivityIndicatorView *spinner;
    
    NSString *userId;
    NSString *bookId;
    NSString *infoId;
    
    UILabel *noLabel;
}
@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, retain) NSMutableArray *listArray;
@property(nonatomic,retain) CommandOperation *commandOper;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *bookId;
@property (nonatomic, retain) NSString *infoId;
@property (nonatomic, assign) int rowValue;
@property(nonatomic,retain) UIActivityIndicatorView *spinner;
@end
