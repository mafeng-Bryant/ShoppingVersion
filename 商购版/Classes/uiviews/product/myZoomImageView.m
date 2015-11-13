//
//  myZoomImageView.m
//  AppStrom
//
//  Created by 掌商 on 11-8-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "myZoomImageView.h"
@interface UITouch (TouchSorting)
- (NSComparisonResult)compareAddress:(id)obj;
@end

@implementation UITouch (TouchSorting)
- (NSComparisonResult)compareAddress:(id) obj 
{
    if ((void *) self < (void *) obj) return NSOrderedAscending;
    else if ((void *) self == (void *) obj) return NSOrderedSame;
	else return NSOrderedDescending;
}
@end

@implementation myZoomImageView
@synthesize originImage;
@synthesize myZoomDelegate;
// Prepare the drag view
- (id) initWithImage: (UIImage *) anImage
{
	if (self = [super initWithImage:anImage])
	{
		self.userInteractionEnabled = YES;
		self.multipleTouchEnabled = YES;
		self.exclusiveTouch = NO;
		self.originImage = anImage;
		originalSize = anImage.size;
		limitRect = anImage.size;
		originalTransform = CGAffineTransformIdentity;
		touchBeginPoints = CFDictionaryCreateMutable(NULL, 0, NULL, NULL);
		rate = anImage.size.width/anImage.size.height;
	}
	return self;
}
- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		self.userInteractionEnabled = YES;
		self.multipleTouchEnabled = YES;
		self.exclusiveTouch = NO;
		//self.originImage = anImage;
		//originalSize = anImage.size;
		limitRect = frame.size;
		originalTransform = CGAffineTransformIdentity;
		touchBeginPoints = CFDictionaryCreateMutable(NULL, 0, NULL, NULL);
		//rate = anImage.size.width/anImage.size.height;
	}
	return self;
}
// Create an incremental transform matching the current touch set
- (CGAffineTransform)incrementalTransformWithTouches:(NSSet *)touches 
{
	// Sort the touches by their memory addresses
    NSArray *sortedTouches = [[touches allObjects] sortedArrayUsingSelector:@selector(compareAddress:)];
    NSInteger numTouches = [sortedTouches count];
    
	// If there are no touches, simply return identify transform.
	if (numTouches == 0) return CGAffineTransformIdentity;
	
	// Handle single touch as a translation
	if (numTouches == 1) {
        UITouch *touch = [sortedTouches objectAtIndex:0];
        CGPoint beginPoint = *(CGPoint *)CFDictionaryGetValue(touchBeginPoints, touch);
        CGPoint currentPoint = [touch locationInView:self.superview];
		return CGAffineTransformMakeTranslation(currentPoint.x - beginPoint.x, currentPoint.y - beginPoint.y);
	}
	
	// If two or more touches, go with the first two (sorted by address)
	UITouch *touch1 = [sortedTouches objectAtIndex:0];
	UITouch *touch2 = [sortedTouches objectAtIndex:1];
	
    CGPoint beginPoint1 = *(CGPoint *)CFDictionaryGetValue(touchBeginPoints, touch1);
    CGPoint currentPoint1 = [touch1 locationInView:self.superview];
    CGPoint beginPoint2 = *(CGPoint *)CFDictionaryGetValue(touchBeginPoints, touch2);
  //  CGPoint currentPoint2 = [touch2 locationInView:self.superview];
	
	double layerX = self.center.x;
	double layerY = self.center.y;
	
	double x1 = beginPoint1.x - layerX;
	double y1 = beginPoint1.y - layerY;
	double x2 = beginPoint2.x - layerX;
	double y2 = beginPoint2.y - layerY;
	double x3 = currentPoint1.x - layerX;
	double y3 = currentPoint1.y - layerY;
	//double x4 = currentPoint2.x - layerX;
	//double y4 = currentPoint2.y - layerY;
	
	// Solve the system:
	//   [a b t1, -b a t2, 0 0 1] * [x1, y1, 1] = [x3, y3, 1]
	//   [a b t1, -b a t2, 0 0 1] * [x2, y2, 1] = [x4, y4, 1]
	
	double D = (y1-y2)*(y1-y2) + (x1-x2)*(x1-x2);
	if (D < 0.1) {
        return CGAffineTransformMakeTranslation(x3-x1, y3-y1);
    }
	
	/*double a = (y1-y2)*(y3-y4) + (x1-x2)*(x3-x4);
	double b = (y1-y2)*(x3-x4) - (x1-x2)*(y3-y4);
	double tx = (y1*x2 - x1*y2)*(y4-y3) - (x1*x2 + y1*y2)*(x3+x4) + x3*(y2*y2 + x2*x2) + x4*(y1*y1 + x1*x1);
	double ty = (x1*x2 + y1*y2)*(-y4-y3) + (y1*x2 - x1*y2)*(x3-x4) + y3*(y2*y2 + x2*x2) + y4*(y1*y1 + x1*x1);
	*/
    return CGAffineTransformMakeScale(1.4f, 1.4f);//CGAffineTransformMake(a/D, -b/D, b/D, a/D, tx/D, ty/D);
}

// Cache where each touch started
- (void)cacheBeginPointForTouches:(NSSet *)touches 
{
	for (UITouch *touch in touches) {
		CGPoint *point = (CGPoint *)CFDictionaryGetValue(touchBeginPoints, touch);
		if (point == NULL) {
			point = (CGPoint *)malloc(sizeof(CGPoint));
			CFDictionarySetValue(touchBeginPoints, touch, point);
		}
		*point = [touch locationInView:self.superview];
	}
}

// Clear out touches from the cache
- (void)removeTouchesFromCache:(NSSet *)touches 
{
    for (UITouch *touch in touches) {
        CGPoint *point = (CGPoint *)CFDictionaryGetValue(touchBeginPoints, touch);
        if (point != NULL) {
            free((void *)CFDictionaryGetValue(touchBeginPoints, touch));
            CFDictionaryRemoveValue(touchBeginPoints, touch);
        }
    }
}

// Limit zoom to a max and min value
- (void) setConstrainedTransform: (CGAffineTransform) aTransform
{
	self.transform = aTransform;
	CGAffineTransform concat;
	CGSize asize = self.frame.size;
	
	if (asize.width > MAXZOOM * originalSize.width)
	{
		concat = CGAffineTransformConcat(self.transform, CGAffineTransformMakeScale((MAXZOOM * originalSize.width / asize.width), 1.0f));
		self.transform = concat;
	}
	else if (asize.width < MINZOOM * originalSize.width)
	{
		concat = CGAffineTransformConcat(self.transform, CGAffineTransformMakeScale((MINZOOM * originalSize.width / asize.width), 1.0f));
		self.transform = concat;
	}
	if (asize.height > MAXZOOM * originalSize.height)
	{
		concat = CGAffineTransformConcat(self.transform, CGAffineTransformMakeScale(1.0f, (MAXZOOM * originalSize.height / asize.height)));
		self.transform = concat;
	}
	else if (asize.height < MINZOOM * originalSize.height)
	{
		concat = CGAffineTransformConcat(self.transform, CGAffineTransformMakeScale(1.0f, (MINZOOM * originalSize.height / asize.height)));
		self.transform = concat;
	}
	
	// Uncomment to force boundary checks
	
	/*	
	 if (self.frame.origin.x < 0)
	 {
	 concat = CGAffineTransformConcat(self.transform, CGAffineTransformMakeTranslation(-self.frame.origin.x, 0.0f));
	 self.transform = concat;
	 }
	 
	 if (self.frame.origin.y < 0)
	 {
	 concat = CGAffineTransformConcat(self.transform, CGAffineTransformMakeTranslation(0.0f, -self.frame.origin.y));
	 self.transform = concat;
	 }
	 
	 float dx = (self.frame.origin.x + self.frame.size.width) - self.superview.frame.size.width;
	 if (dx > 0.0f)
	 {
	 concat = CGAffineTransformConcat(self.transform, CGAffineTransformMakeTranslation(-dx, 0.0f));
	 self.transform = concat;
	 }
	 
	 float dy = (self.frame.origin.y + self.frame.size.height) - self.superview.frame.size.height;
	 if (dy > 0.0f)
	 {
	 concat = CGAffineTransformConcat(self.transform, CGAffineTransformMakeTranslation(0.0f, -dy));
	 self.transform = concat;
	 }
	 */
}

// Apply touches to create transform
- (void)updateOriginalTransformForTouches:(NSSet *)touches 
{
    if ([touches count] > 0) {
        CGAffineTransform incrementalTransform = [self incrementalTransformWithTouches:touches];
        [self setConstrainedTransform:CGAffineTransformConcat(originalTransform, incrementalTransform)];
		originalTransform = self.transform;
    }
}

// At start, store the touch begin points and set an original transform
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
	[[self superview] bringSubviewToFront:self];
    NSMutableSet *currentTouches = [[[event touchesForView:self] mutableCopy] autorelease];
    [currentTouches minusSet:touches];
    if ([currentTouches count] > 0) {
       // [self updateOriginalTransformForTouches:currentTouches];
        [self cacheBeginPointForTouches:currentTouches];
    }
    [self cacheBeginPointForTouches:touches];
	originalSize = self.image.size;
	beginRect = self.frame;
	//self.image = [[UIImage imageNamed:@"3.jpg"]fillSize:CGSizeMake(100, 100)];
}

// During movement, update the transform to match the touches
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
	NSArray *sortedTouches = [[touches allObjects] sortedArrayUsingSelector:@selector(compareAddress:)];
    NSInteger numTouches = [sortedTouches count];
    
	// If there are no touches, simply return identify transform.
	if (numTouches == 0) return;
	
	// Handle single touch as a translation
	if (numTouches == 1) {
		CGPoint ptCurr=[[touches anyObject] locationInView:self.superview];
		CGPoint ptpre=[[touches anyObject] previousLocationInView:self.superview];
		//CGPoint theCenter = self.center;
		float centerx = self.center.x+ptCurr.x - ptpre.x;
		float centery = self.center.y+ptCurr.y-ptpre.y;
		//CGPoint superviewCenter = self.superview.center;
	
		/*float centerwidth = (superviewCenter.x-centerx>0)?(superviewCenter.x-centerx):(centerx-superviewCenter.x);
		float centerheight = (superviewCenter.y-centery>0)?(superviewCenter.y-centery):(superviewCenter.y-centery);
		float framewidth = (self.image.size.width-self.superview.frame.size.width)>0?(self.image.size.width-self.superview.frame.size.width):(self.superview.frame.size.width-self.image.size.width);
		float frameheight = (self.image.size.height-self.superview.frame.size.height)>0?(self.image.size.height-self.superview.frame.size.height):(self.superview.frame.size.height-self.image.size.height);
		if (centerwidth> framewidth){
		
			return;
		}
		if (centerheight> frameheight) {
			return;
		}*/
		
		self.center = CGPointMake(centerx,centery);
		return;
	}
	UITouch *touch1 = [sortedTouches objectAtIndex:0];
	UITouch *touch2 = [sortedTouches objectAtIndex:1];
	
    CGPoint beginPoint1 = *(CGPoint *)CFDictionaryGetValue(touchBeginPoints, touch1);
    CGPoint currentPoint1 = [touch1 locationInView:self.superview];
    CGPoint beginPoint2 = *(CGPoint *)CFDictionaryGetValue(touchBeginPoints, touch2);
    CGPoint currentPoint2 = [touch2 locationInView:self.superview];
	float xbeginLength = beginPoint1.x - beginPoint2.x;
	xbeginLength = xbeginLength>0?xbeginLength:(0-xbeginLength);
	
	float ybeginLength = beginPoint1.y - beginPoint2.y;
	ybeginLength = ybeginLength>0?ybeginLength:(0-ybeginLength);
	
	float xcurrentLength = currentPoint1.x - currentPoint2.x;
	xcurrentLength = xcurrentLength>0?xcurrentLength:(0-xcurrentLength);
	
	float ycurrentLength = currentPoint1.y - currentPoint2.y;
	ycurrentLength = ycurrentLength>0?ycurrentLength:(0-ycurrentLength);

	float xlength = xcurrentLength - xbeginLength;
	float ylength = ycurrentLength - ybeginLength;

	if (xlength>ylength) {
		float xx = xlength;
		if (xx < 0) {
			xx = 0-xx;
		}
		if (xx<5.0f||(limitRect.width>(originalSize.width+xlength))) {
			return;
		}
		//self.frame =CGRectMake(beginRect.origin.x-xlength/2, beginRect.origin.y-xlength/2,beginRect.size.width+xlength, beginRect.size.height+xlength);// CGSizeMake(self.frame.size.width*2, self.frame.size.height*2);
		self.frame =CGRectMake(0, 0,beginRect.size.width+xlength, beginRect.size.height+xlength);// CGSizeMake(self.frame.size.width*2, self.frame.size.height*2);

		self.image = [originImage scaleToSize:CGSizeMake(originalSize.width+xlength, originalSize.height+xlength)];
	}
	else {
		float yy = ylength;
		if (yy < 0) {
			yy = 0-yy;
		}
		if (yy<5.0f||(limitRect.height>(originalSize.height+ylength))) {
			return;
		}
		//self.frame =CGRectMake(beginRect.origin.x-ylength/2, beginRect.origin.y-ylength/2, beginRect.size.width+ylength, beginRect.size.height+ylength);// CGSizeMake(self.frame.size.width*2, self.frame.size.height*2);
		self.frame =CGRectMake(0, 0, beginRect.size.width+ylength, beginRect.size.height+ylength);// CGSizeMake(self.frame.size.width*2, self.frame.size.height*2);

		self.image = [originImage scaleToSize:CGSizeMake(originalSize.width+ylength, originalSize.height+ylength)];

	}
	UIScrollView *scrollView = self.superview;
	scrollView.contentSize = self.image.size;
}

// Finish by removing touches, handling double-tap requests
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
  //  [self updateOriginalTransformForTouches:[event touchesForView:self]];
    [self removeTouchesFromCache:touches];
	
    for (UITouch *touch in touches) {
        if (touch.tapCount >= 2) {
            [self.superview bringSubviewToFront:self];
        }
    }
	
    NSMutableSet *remainingTouches = [[[event touchesForView:self] mutableCopy] autorelease];
    [remainingTouches minusSet:touches];
    [self cacheBeginPointForTouches:remainingTouches];
}

// Redirect cancel to ended
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event 
{
    [self touchesEnded:touches withEvent:event];
}

- (void)dealloc {
	if (touchBeginPoints) CFRelease(touchBeginPoints);
	[originImage release];
	[super dealloc];
}
@end
