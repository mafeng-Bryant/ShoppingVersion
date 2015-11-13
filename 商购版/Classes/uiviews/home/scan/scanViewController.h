//
//  scanViewController.h
//  myBarCode
//
//  Created by lai yun on 13-1-18.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXingWidgetController.h"
#import "QRCodeReader.h"

@interface scanViewController : UIViewController<ZXingDelegate>
{
	UIImageView *loadingImageView;
    ZXingWidgetController *widController;
    
}

@property(nonatomic,retain) UIImageView *loadingImageView;
@property(nonatomic,retain) ZXingWidgetController *widController;

@end
