//
//  UpdateAppAlert.m
//  information
//
//  Created by MC374 on 12-7-27.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UpdateAppAlert.h"


@implementation UpdateAppAlert
@synthesize updateurl;
@synthesize theSuperViewController;
@synthesize alertV;
@synthesize remindMessage;

-(id)initWithContent:(NSString*)title 
			 content:(NSString*)content leftbtn:(NSString*)leftTitle 
			rightbtn:(NSString*)righttitle url:(NSString*)appurl onViewController:(UIViewController*)theViewController{
	
	if ([super init]!=nil) {
		self.theSuperViewController = theViewController;
		self.updateurl = appurl;
		UIAlertView *av = nil;
		av = [[UIAlertView alloc] 
			  initWithTitle:title message:content
			  delegate:self cancelButtonTitle:leftTitle otherButtonTitles:righttitle,nil];
		self.alertV = av;
		[av release];
		
	}
	return self;
}
-(void)showAlert{
	
	[alertV show];
	
}
- (void) alertView:(UIAlertView *) alertView1 clickedButtonAtIndex: (int) index
{
	if(index != alertView1.cancelButtonIndex)
	{		
		NSURL *url = [NSURL URLWithString:updateurl];
		[[UIApplication sharedApplication] openURL:url];
	}
	//self.alertV = nil;
	//[alertView1 release];
}

-(void)dealloc{
	if (alertV != nil) {
		[alertV dismissWithClickedButtonIndex:0 animated:YES];
		self.alertV = nil;
	}
	
	self.theSuperViewController = nil;
	self.updateurl = nil;
	self.remindMessage = nil;
	[super dealloc];
}

@end
