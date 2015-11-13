//
//  searchButton.m
//  shopping
//
//  Created by siphp on 13-01-08.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "searchButton.h"

@implementation searchButton

+ (id)buttonWithType:(UIButtonType)buttonType;
{
    self = [super buttonWithType:buttonType];
    if (self) {
        // Initialization code
    }
    return self;
}

//- (CGRect)imageRectForContentRect:(CGRect)contentRect
//{
//    return CGRectMake(self.frame.size.width/2 - 15.0f, 3.0f, 30.0f, 30.0f);
//}
//

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake( 10.0f , 0.0f , self.frame.size.width - 7.0f - 22.0f - 5.0f , 40.0f);    
}

//- (CGRect)backgroundRectForBounds:(CGRect)bounds
//{
//    return self.frame;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setButtonTitle:(NSString *)title
{
    //根据文字长度设置按钮大小
    CGSize constraint = CGSizeMake(20000.0f, 40.0f);
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    CGFloat fixWidth = (size.width + 5.0f) > 280.0f ? 280.0f : (size.width + 5.0f);
    self.frame = CGRectMake(10.0f , 10.0f , fixWidth + 7.0f + 22.0f + 10.0f , 40.0f);
    
    //背景图片
    UIImage *backgroundImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"搜索关键词按钮背景" ofType:@"png"]];
    [self setBackgroundImage:[backgroundImage stretchableImageWithLeftCapWidth:7 topCapHeight:0] forState:UIControlStateNormal];
    
    //文字
    [self setTitle:title forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];//[UIFont systemFontOfSize:16.0f];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = UITextAlignmentCenter;
    
    //未选中文字颜色
    [self setTitleColor:[self randomColor] forState:UIControlStateNormal];
}

//随机生成各种颜色
- (UIColor *)randomColor
{
    CGFloat r = arc4random()%255;
    CGFloat g = arc4random()%255;
    CGFloat b = arc4random()%255;
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:0.8];
}

@end
