//
//  myImageView.h
//  云来
//
//  Created by 掌商 on 11-7-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoadingView.h"

@protocol myImageViewDelegate
@optional
- (void)imageViewTouchesEnd:(NSString *)imageId;
- (void)imageViewDoubleTouchesEnd:(NSString *)imageId;
@end

@interface myImageView : UIImageView {
	id<myImageViewDelegate>		mydelegate;
	NSString *imageId;
	UIActivityIndicatorView *loadingView;
}

@property(nonatomic,assign)id<myImageViewDelegate> mydelegate;
@property(nonatomic,assign)UIActivityIndicatorView *loadingView;
@property(nonatomic,retain)NSString *imageId;

-(id)initWithFrame:(CGRect)frame withImageId:(NSString *)imageid;
-(id)initWithImage:(UIImage *)image withImageId:(NSString *)imageid;
-(void)startSpinner;
-(void)stopSpinner;

@end