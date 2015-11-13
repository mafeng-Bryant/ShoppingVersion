//
//  NetPopupWindow.m
//  hkh1229
//
//  Created by yunlai on 13-6-5.
//
//

#import "NetPopupWindow.h"

#import <QuartzCore/QuartzCore.h>

static NetPopupWindow *popupWindow = nil;

#define LabelWidth 100.f
#define LabelHeight 40.f
#define LabelText @"网络不给力"

@implementation NetPopupWindow

@synthesize labeView;

- (id)init
{
    self = [super init];
    if (self) {
        isShow = NO;
    }
    
    return self;
}

+ (NetPopupWindow *)defaultExample
{
    @synchronized(self) {
        if (popupWindow == nil) {
            popupWindow = [[NetPopupWindow alloc]init];
        }
    }
    return popupWindow;
}

- (void)hide
{
    [UIView animateWithDuration:1.0 animations:^(void) {
        labeView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [labeView removeFromSuperview];
        [labeView release];
        isShow = NO;
    }];
}

- (void)viewCreate
{
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    labeView = [[UIView alloc] initWithFrame:CGRectMake(0.f, height/3, LabelWidth, LabelWidth)];
    labeView.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.8];
    labeView.layer.cornerRadius = 8.f;
    labeView.layer.masksToBounds = YES;
    
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_face_cry" ofType:@"png"]];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(LabelWidth/2 - image.size.width/2, LabelWidth/4, image.size.width, image.size.height)];
    imageView.image = image;
    [labeView addSubview:imageView];
    [imageView release];
    
    UILabel *labe = [[UILabel alloc] init];
    labe.textAlignment = UITextAlignmentCenter;
    labe.backgroundColor = [UIColor clearColor];
    labe.textColor = [UIColor whiteColor];
    labe.textAlignment = UITextAlignmentCenter;
    labe.numberOfLines = 0;
    labe.font = [UIFont systemFontOfSize:13.f];
    labe.lineBreakMode = UILineBreakModeWordWrap;
    labe.text = LabelText;
    
    CGPoint point = CGPointMake(width/2, height/3);
    labeView.center = point;
    labe.frame = CGRectMake(0.f, 3*LabelWidth/5, LabelWidth, 40.f);
    
    [labeView addSubview:labe];
    [labe release];
}

- (void)showCustemAlertViewIninView:(UIView *)superview
{
    if (isShow == NO) {
        isShow = YES;
        
        [self viewCreate];
        
        [superview addSubview:labeView];
        
        CAKeyframeAnimation *animation=nil;
        animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        animation.duration = 0.8;
        animation.delegate = self;
        animation.removedOnCompletion = YES;
        animation.fillMode = kCAFillModeForwards;
        NSMutableArray *values = [NSMutableArray array];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        animation.values = values;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [labeView.layer addAnimation:animation forKey:nil];
        
        [self performSelector:@selector(hide) withObject:nil afterDelay:2.f];
    }
}

@end
