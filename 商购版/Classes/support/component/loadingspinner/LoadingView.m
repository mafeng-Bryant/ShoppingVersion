//
//  LoadingView.m
//  shoucai
//
//  Created by MC374 on 12-2-28.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LoadingView.h"



@implementation LoadingView
@synthesize loadingSpinner;

- (void)initLoading{
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
	self.loadingSpinner = spinner;
	[spinner release];
}

-(void)startSpinner:(UIView*)view{
	[loadingSpinner setCenter:CGPointMake(view.frame.size.width / 2.0, view.frame.size.height / 2.0)]; // I do this because I'm in landscape mod
	[loadingSpinner startAnimating];
	[view addSubview:loadingSpinner];
	//[view bringSubviewToFront:gspinner];
}
-(void)stopSpinner{
	[loadingSpinner stopAnimating];
	[loadingSpinner removeFromSuperview];
}

-(void) dealloc{
	self.loadingSpinner = nil;
	[super dealloc];
}

@end
