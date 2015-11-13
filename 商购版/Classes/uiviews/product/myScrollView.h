//
//  myScrollView.h
//  AppStrom
//
//  Created by 掌商 on 11-8-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "myZoomImageView.h"

@interface myScrollView : UIScrollView {
	myZoomImageView *myZoom;

}
@property(nonatomic,retain)myZoomImageView *myZoom;
@end
