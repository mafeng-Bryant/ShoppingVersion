//
//  PromotionAlertView.h
//  information
//
//  Created by 来 云 on 12-12-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UATitledModalPanel.h"

@protocol PromotionAlertViewDelegate <NSObject>

- (void)leftGoOnAction;
- (void)rightFinishAction;
@end

@interface PromotionAlertView : UATitledModalPanel{
    id<PromotionAlertViewDelegate> _delegate;
    
//    NSString *totalPrice;
//    NSString *price;
//    NSString *name;
}
@property (nonatomic, assign) id<PromotionAlertViewDelegate> _delegate;
//@property (nonatomic, retain) NSString *totalPrice;
//@property (nonatomic, retain) NSString *price;
//@property (nonatomic, retain) NSString *name;

- (id)initWithFrame:(CGRect)frame withTotal:(NSString *)totalPrice withPrice:(NSString *)price withName:(NSString *)name;
@end
