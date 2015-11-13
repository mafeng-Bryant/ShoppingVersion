//
//  PayOrderViewController.h
//  shopping
//
//  Created by yunlai on 13-1-30.
//
//

#import <UIKit/UIKit.h>

@class ReservationInfo;



@interface PayOrderViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSArray *orderArray;
    ReservationInfo *info;
}

@property (nonatomic,retain) NSArray *orderArray;
@property (nonatomic,retain) ReservationInfo *info;
@end
