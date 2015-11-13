//
//  myZoomImageView.h
//  AppStrom
//
//  Created by 掌商 on 11-8-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define MAXZOOM 2.0f
#define MINZOOM 0.5f
@protocol myZoomImageViewDelegate
@optional

- (void)changePicSize:(CGSize)newSize;

@end
@interface myZoomImageView : UIImageView {

	CGPoint startLocation;
	CGSize originalSize;
	CGRect beginRect;
	CGSize limitRect;
	CGAffineTransform originalTransform;
    CFMutableDictionaryRef touchBeginPoints;
	float rate;
	UIImage *originImage;
	id<myZoomImageViewDelegate> myZoomDelegate;
}
@property(nonatomic,assign)id<myZoomImageViewDelegate> myZoomDelegate;
@property(nonatomic,retain)UIImage *originImage;
@end
