//
//  UINavigationBarCustomImage.m
//  jvrenye
//
//  Created by 掌商 on 11-10-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UINavigationBarCustomImage.h"
#import "Common.h"

@implementation UINavigationBar(CustomImage) 
#ifdef SHOW_NAV_TAB_BG
- (void)drawRect:(CGRect)rect {
	UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NAV_BG_PIC ofType:nil]];
    UIImage *image = img;//[UIImage imageNamed:NAV_BG_PIC];  
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)]; 
	[img release];
} 
#endif
@end
