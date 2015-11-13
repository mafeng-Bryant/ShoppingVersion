//
//  searchButton.h
//  shopping
//
//  Created by siphp on 13-01-08.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface searchButton : UIButton


//设置title 颜色 并更改按钮大小 
- (void)setButtonTitle:(NSString *)title;

//随机生成各种颜色
- (UIColor *)randomColor;

@end

