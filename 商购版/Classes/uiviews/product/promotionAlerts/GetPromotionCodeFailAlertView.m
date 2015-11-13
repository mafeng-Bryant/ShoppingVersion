//
//  GetPromotionCodeFailAlertView.m
//  information
//
//  Created by MC374 on 12-12-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GetPromotionCodeFailAlertView.h"

#define MARGIN 20

@implementation GetPromotionCodeFailAlertView

- (id)initWithFrame:(CGRect)frame showType:(int)type{
	if ((self = [super initWithFrame:frame])) {
        
		self.headerLabel.text = @"";
        
        // Margin between edge of container frame and panel. Default = 20.0
        self.outerMarginX = 10.0f;
        
//        self.outerMarginY = 170.0f;
        
        // Margin between edge of panel and the content area. Default = 20.0
        self.innerMargin = 0.0f;
        
        // Border color of the panel. Default = [UIColor whiteColor]
        self.borderColor = [UIColor clearColor];
        
        // Border width of the panel. Default = 1.5f;
        self.borderWidth = 0.0f;
        
        // Corner radius of the panel. Default = 4.0f
        self.cornerRadius = 10.0f;
        
        // Color of the panel itself. Default = [UIColor colorWithWhite:0.0 alpha:0.8]
        self.contentColor = [UIColor whiteColor];
        
        // Shows the bounce animation. Default = YES
        self.shouldBounce = NO;
        
        // Height of the title view. Default = 40.0f
        [self setTitleBarHeight:0];
        
        // The gradient style (Linear, linear reversed, radial, radial reversed, center highlight). Default = UAGradientBackgroundStyleLinear
        [[self titleBar] setGradientStyle:(0)];
        
        // The line mode of the gradient view (top, bottom, both, none). Top is a white line, bottom is a black line.
        [[self titleBar] setLineMode: pow(2, 0)];
        
        // The noise layer opacity. Default = 0.4
        //[[self titleBar] setNoiseOpacity:(((arc4random() % 10) + 1) * 0.1)];
        
        // The header label, a UILabel with the same frame as the titleBar
        //[self headerLabel].font = [UIFont boldSystemFontOfSize:floor(self.titleBarHeight / 2.0)];
        
        //判断type是已经领取过了的还是活动结束，展现不同UI
        UIImage *image = nil;
        NSString *showString = nil;
        if (type == finished) {
            image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"表情失败" ofType:@"png"]];
            showString = @"Sorry,本次活动的优惠券已经派发完毕。请关注我们下次活动吧！";
        }else if(type == joined){
            image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"表情好奇" ofType:@"png"]];
            showString = @"亲，您已经参加过了，请关注我们的下次活动吧。";
        }
        
        //添加图片
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN, MARGIN, 64, 64)];
        imageview.image = image;
        [image release],image = nil;
        [self.contentView addSubview:imageview];
        [imageview release],imageview = nil;
        
        UILabel *descLabel = nil;
        descLabel = [[UILabel alloc] initWithFrame:CGRectMake(108, MARGIN,180,30 )];
        [descLabel setLineBreakMode:UILineBreakModeWordWrap];
        [descLabel setMinimumFontSize:18.0f];
        [descLabel setNumberOfLines:0];
        [descLabel setFont:[UIFont systemFontOfSize:18.0f]];
        descLabel.backgroundColor = [UIColor clearColor];
        CGSize constraint = CGSizeMake(180, 20000.0f);
        CGSize size = [showString sizeWithFont:[UIFont systemFontOfSize:18.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        float fixHeight = size.height;
        fixHeight = fixHeight == 0 ? 30.f : fixHeight;
        [descLabel setText:showString];
        [descLabel setFrame:CGRectMake(108, 25, 180, fixHeight)];        
        [self.contentView addSubview:descLabel]; 
        [descLabel release];
        
        //设置outerMarginY的值来改变弹出框的高度
        self.outerMarginY = ([UIScreen mainScreen].bounds.size.height - (fixHeight+MARGIN*2))/2;
    }
    return self;
}

@end
