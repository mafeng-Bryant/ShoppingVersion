//
//  PromotionAlertView.m
//  information
//
//  Created by 来 云 on 12-12-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PromotionAlertView.h"

@implementation PromotionAlertView
@synthesize _delegate;
//@synthesize totalPrice;
//@synthesize price;
//@synthesize name;

- (id)initWithFrame:(CGRect)frame withTotal:(NSString *)totalPrice withPrice:(NSString *)price withName:(NSString *)name{
	if ((self = [super initWithFrame:frame])) {
        
		self.headerLabel.text = @"";
        
        // Margin between edge of container frame and panel. Default = 20.0
        self.outerMarginX = 10.0f;
        self.outerMarginY = 120.0f;
        
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
        self.shouldBounce = YES;
        
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
        
        UILabel *labelStr1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 170, 30)];
        labelStr1.text = @"亲，您的订单总金额";
        labelStr1.font = [UIFont boldSystemFontOfSize:18.0f];
        labelStr1.textColor = [UIColor blackColor];
        labelStr1.textAlignment = UITextAlignmentLeft;
        labelStr1.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:labelStr1];
        [labelStr1 release];
        
        UILabel *labelStr2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labelStr1.frame), 20, 40, 30)];
        labelStr2.text = totalPrice;
        labelStr2.font = [UIFont boldSystemFontOfSize:18.0f];
        labelStr2.textColor = [UIColor colorWithRed:0.921 green:0.380 blue:0.000 alpha:1.0];
        labelStr2.textAlignment = UITextAlignmentLeft;
        labelStr2.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:labelStr2];
        [labelStr2 release];
        
        UILabel *labelStr3 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labelStr2.frame), 20, 50, 30)];
        labelStr3.text = @"元，";
        labelStr3.font = [UIFont boldSystemFontOfSize:18.0f];
        labelStr3.textColor = [UIColor blackColor];
        labelStr3.textAlignment = UITextAlignmentLeft;
        labelStr3.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:labelStr3];
        [labelStr3 release];
        
        UILabel *labelStr4 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(labelStr1.frame), 65, 30)];
        labelStr4.text = @"只需要";
        labelStr4.font = [UIFont boldSystemFontOfSize:18.0f];
        labelStr4.textColor = [UIColor blackColor];
        labelStr4.textAlignment = UITextAlignmentLeft;
        labelStr4.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:labelStr4];
        [labelStr4 release];
        
        UILabel *labelStr5 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labelStr4.frame), CGRectGetMaxY(labelStr1.frame), 30, 30)];
        labelStr5.text = price;
        CGSize size = [price sizeWithFont:[UIFont boldSystemFontOfSize:18.0f]];
        labelStr5.frame = CGRectMake(CGRectGetMaxX(labelStr4.frame), CGRectGetMaxY(labelStr1.frame), size.width, 30);
        labelStr5.font = [UIFont boldSystemFontOfSize:18.0f];
        labelStr5.textColor = [UIColor colorWithRed:0.921 green:0.380 blue:0.000 alpha:1.0];
        labelStr5.textAlignment = UITextAlignmentLeft;
        labelStr5.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:labelStr5];
        [labelStr5 release];
        
        UILabel *labelStr6 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labelStr5.frame), CGRectGetMaxY(labelStr1.frame), 150, 30)];
        labelStr6.text = @"元就可参加";
        labelStr6.font = [UIFont boldSystemFontOfSize:18.0f];
        labelStr6.textColor = [UIColor blackColor];
        labelStr6.textAlignment = UITextAlignmentLeft;
        labelStr6.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:labelStr6];
        [labelStr6 release];
        
        UIImage *proImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"满就送活动背景" ofType:@"png"]];
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(-2, CGRectGetMaxY(labelStr6.frame)+ 5, proImage.size.width, proImage.size.height)];
        bgView.image = proImage;
        [self.contentView addSubview:bgView];
        [proImage release];
        
        UILabel *labelStr = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 200, 84)];
        labelStr.text = name;
        labelStr.font = [UIFont boldSystemFontOfSize:20.0f];
        labelStr.textColor = [UIColor whiteColor];
        labelStr.textAlignment = UITextAlignmentLeft;
        labelStr.backgroundColor = [UIColor clearColor];
        [bgView addSubview:labelStr];
        [labelStr release];
        
        UIImage *leftImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"去加点菜button" ofType:@"png"]];
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(10, CGRectGetMaxY(bgView.frame) + 20, leftImage.size.width, leftImage.size.height);
        [leftButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [leftButton setBackgroundImage:leftImage forState:UIControlStateNormal];
        [self.contentView addSubview:leftButton];
        [leftImage release];
        
        UILabel *leftBtnTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 90, 35)];
        leftBtnTitle.text = @"再逛逛";
        leftBtnTitle.font = [UIFont boldSystemFontOfSize:18.0f];
        leftBtnTitle.textColor = [UIColor darkGrayColor];
        leftBtnTitle.textAlignment = UITextAlignmentCenter;
        leftBtnTitle.backgroundColor = [UIColor clearColor];
        [leftButton addSubview:leftBtnTitle];
        [leftBtnTitle release];
        
        UIImage *rightImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"菜够了button" ofType:@"png"]];
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(CGRectGetMaxX(leftButton.frame) + 5, CGRectGetMaxY(bgView.frame) + 20, rightImage.size.width, rightImage.size.height);
        [rightButton addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setBackgroundImage:rightImage forState:UIControlStateNormal];
        [self.contentView addSubview:rightButton];
        [rightImage release];
        
        UILabel *rightBtnTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 90, 35)];
        rightBtnTitle.text = @"结算";
        rightBtnTitle.font = [UIFont boldSystemFontOfSize:18.0f];
        rightBtnTitle.textColor = [UIColor darkGrayColor];
        rightBtnTitle.textAlignment = UITextAlignmentCenter;
        rightBtnTitle.backgroundColor = [UIColor clearColor];
        [rightButton addSubview:rightBtnTitle];
        [rightBtnTitle release];
        
        [bgView release];

	}	
	return self;
}

- (void)leftBtnAction
{
    [self hide];
    
    if ([_delegate respondsToSelector:@selector(leftGoOnAction)]) 
    {
        [_delegate leftGoOnAction];
    }
}

- (void)rightBtnAction
{
    [self hide];
    
    if ([_delegate respondsToSelector:@selector(rightFinishAction)]) 
    {
        [_delegate rightFinishAction];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) dealloc{
//    [totalPrice release];
//    [price release];
//    [name release];
    [super dealloc];
}
@end
