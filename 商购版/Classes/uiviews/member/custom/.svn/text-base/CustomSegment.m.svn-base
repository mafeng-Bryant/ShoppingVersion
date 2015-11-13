//
//  CustomSegment.m
//  shopping
//
//  Created by 来 云 on 13-1-9.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "CustomSegment.h"

@implementation CustomSegment
@synthesize arr = _arr;
@synthesize delegate = _delegate;
@synthesize repickPressed = _repickPressed;

- (id)initWithSelectedImgArray:(NSArray *)selectedimageArray point:(CGPoint)SegmentPoint titleArray:(NSArray*)titles
{
    self = [super init];
    if (self) {
        _repickPressed = NO;
        self.arr = selectedimageArray;
        UIImage *img = [UIImage imageNamed:[selectedimageArray objectAtIndex:0]];
        float x;
        if (SegmentPoint.x == 0) {
            x = 320/2-img.size.width/2;
        }else{
            x = SegmentPoint.x;
        }
        self.frame = CGRectMake(x, SegmentPoint.y, img.size.width, img.size.height);
        float w = img.size.width/selectedimageArray.count;
        
        for (int i = 0; i<selectedimageArray.count; i++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
            [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal]; //设置颜色
            btn.tag = i+1;
            [btn addTarget:self action:@selector(ButtonItems:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(w*i, 0, w, img.size.height);
            [self addSubview:btn];
            
            if (i == 0) {
                [self ButtonItems:btn];
            }
        }
        
        
        
        
    }
    return self;
}

- (void)setSelectedIndex:(int)Index{
    Index = Index < self.arr.count ? Index : 0;
    
    for (UIButton *btn1 in [self subviews]) {
        
        if (btn1.tag-1 == Index) {
            
            [self ButtonItems:btn1];
            return;
        }
        
    }
}

- (void)ButtonItems:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    int index = btn.tag-1;
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[self.arr objectAtIndex:index]]];
    _repickPressed ? [self ButtonEnableControl] : [self ButtonEnableControl:btn];
    [_delegate segmentWithIndex:index];
    
}

- (void)ButtonEnableControl:(UIButton *)btn{
    
    for (UIButton *btn1 in [self subviews]) {
        
        btn1.enabled = btn1 == btn ? NO : YES ;
        
    }
}

- (void)ButtonEnableControl{
    
    for (UIButton *btn1 in [self subviews]) {
        
        btn1.enabled = YES;
        
    }
}
@end

