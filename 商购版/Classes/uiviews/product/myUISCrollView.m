//
//  myUISCrollView.m
//  jvrenye
//
//  Created by 掌商 on 11-10-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "myUISCrollView.h"


@implementation myUISCrollView
@synthesize mydelegate;
-(void)doubleTap{
	CGFloat zs = self.zoomScale;
	zs = (zs == self.minimumZoomScale) ? self.maximumZoomScale : self.minimumZoomScale;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];            
	self.zoomScale = zs;    
	[UIView commitAnimations];
	
}
-(void)singleTap{

	[mydelegate touchOnce];
}
- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view{
	UITouch *touch = [touches anyObject];
    
    NSTimeInterval delaytime = 0.3;//自己根据需要调整
    
	switch (touch.tapCount) {
		case 1:
			[self performSelector:@selector(singleTap) withObject:nil afterDelay:delaytime];
			break;
		case 2:{
			[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTap) object:nil];
			[self performSelector:@selector(doubleTap) withObject:nil afterDelay:delaytime];
			
		}
            break;
		default:
			break;
	}
}

@end
