//
//  myImageView.m
//  云来
//
//  Created by 掌商 on 11-7-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "myImageView.h"


@implementation myImageView

@synthesize mydelegate;
@synthesize loadingView;
@synthesize imageId;

-(id)initWithFrame:(CGRect)frame withImageId:(NSString *)imageid{

	self = [super initWithFrame:frame];
	if (self != nil) {
		self.userInteractionEnabled = YES;
		self.imageId = imageid;
	}
	return self;
}
-(id)initWithImage:(UIImage *)image withImageId:(NSString *)imageid{

	self = [super initWithImage:image];
	if (self != nil) {
		self.userInteractionEnabled = YES;
		self.imageId = imageid;
	}
	return self;
	
}
-(void)dealloc{
    mydelegate = nil;
    self.imageId = nil;
	loadingView = nil;
	[super dealloc];
}

-(void)singleTap
{
    if (mydelegate && [(NSObject *)mydelegate respondsToSelector:@selector(imageViewTouchesEnd:)]) 
    {
        [mydelegate imageViewTouchesEnd:self.imageId];
    }
}
-(void)doubleTap
{
    if (mydelegate && [(NSObject *)mydelegate respondsToSelector:@selector(imageViewDoubleTouchesEnd:)]) 
    {
        [mydelegate imageViewDoubleTouchesEnd:self.imageId];
    }
}

#pragma mark -
#pragma mark touch event method

/*- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (_delegate && [(NSObject *)_delegate respondsToSelector:@selector(urlTouchesBegan:)]) {
		[_delegate urlTouchesBegan:self];
	}
}*/

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

	UITouch *touch = [touches anyObject];
    
    NSTimeInterval delaytime = 0.0;
    
    switch (touch.tapCount) 
    {
		case 1:
        {
			[self performSelector:@selector(singleTap) withObject:nil afterDelay:delaytime];
        }
			break;
		case 2:
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTap) object:nil];
			[self performSelector:@selector(doubleTap) withObject:nil afterDelay:delaytime];
		}
            break;
		default:
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTap) object:nil];
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doubleTap) object:nil];
			break;
	}
}

-(void)startSpinner{
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
	[spinner setCenter:CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0)];
	self.loadingView = spinner;
	[self addSubview:loadingView];
	[loadingView startAnimating];
	[spinner release];
}
-(void)stopSpinner{
	[loadingView stopAnimating];
	//[loadingView removeFromSuperview];
}
@end
