//
//  alertView.m
//  MBSNSBrowser
//
//  Created by 掌商 on 11-3-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "alertView.h"


@implementation alertView
+ (void) showAlert: (NSString *) message withCancelTitle:(NSString*)cancelTitle andOKTitle:(NSString*)okTitle
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:okTitle,nil];
	[av show];
}
+ (void) alertView:(UIAlertView *) alertView1 clickedButtonAtIndex: (int) index
{
	if(index != alertView1.cancelButtonIndex)
	{
//		NSString *content = alertView1.message;
		
	}
	[alertView1 release];
}
+(void)showAlert:(NSString*)message{

	[self showAlert:message withCancelTitle:nil andOKTitle:@"确定"];
}

@end
