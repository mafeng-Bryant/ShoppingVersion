//
//  CustomNavigationController.m
//  information
//
//  Created by MC374 on 12-12-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomNavigationController.h"

@interface CustomNavigationController ()

@end

@implementation CustomNavigationController

-(void)popself
{
    [self popViewControllerAnimated:YES];
    
}

-(UIBarButtonItem*) createBackButton
{ 
  
    UIImage *image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"返回按钮" ofType:@"png"]];
    UIButton *barbutton = [UIButton buttonWithType:UIButtonTypeCustom];  
    barbutton.frame = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);  
    [barbutton addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    [barbutton setImage:image forState:UIControlStateNormal];
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:barbutton]; 
    return [barBtnItem autorelease];
    
} 

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated 

{ 
    [super pushViewController:viewController animated:animated]; 
    if (viewController.navigationItem.leftBarButtonItem== nil && [self.viewControllers count] > 1) { 
        viewController.navigationItem.leftBarButtonItem =[self createBackButton];
    } 
}  
@end
