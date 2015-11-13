//
//  GetPromotionSuccessAlertView.h
//  information
//
//  Created by MC374 on 12-12-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UATitledModalPanel.h"

@interface GetPromotionSuccessAlertView : UATitledModalPanel{
    UINavigationController *myNavigationController;
    NSArray *shareContentArray;
}

@property (nonatomic,retain)  UINavigationController *myNavigationController;
@property (nonatomic,retain)  NSArray *shareContentArray;

- (id)initWithFrame:(CGRect)frame;
@end
