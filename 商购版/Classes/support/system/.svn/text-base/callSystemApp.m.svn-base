//
//  callSystemApp.m
//  AppStrom
//
//  Created by 掌商 on 11-9-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "callSystemApp.h"
#import <MessageUI/MessageUI.h>
#import "alertView.h"
#import "Common.h"
@implementation callSystemApp
#ifdef IOS4
+ (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
	
	switch (result) {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
			break;
		case MessageComposeResultFailed:
			NSLog(@"发短信错误");
			break;
		case MessageComposeResultSent:
			break;
			
		default:
			break;
	}
	[controller dismissModalViewControllerAnimated:YES]; 
	
}
#endif
+(NSString*)getCurrentTime{
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]autorelease];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    //NSLog(@"Date%@", [dateFormatter stringFromDate:[NSDate date]]);
	return [dateFormatter stringFromDate:[NSDate date]];
   /* [dateFormatter release]; 
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	formatter.dateFormat = @"YYYYMMddhhmmss";
	return [formatter stringFromDate:[NSDate date]];*/
}
+(NSString*)cleanPhoneNumber:(NSString*)phoneNumber
{
	
		phoneNumber=[phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [phoneNumber length])];
		phoneNumber=[phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [phoneNumber length])];
		phoneNumber=[phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [phoneNumber length])];
		phoneNumber=[phoneNumber stringByReplacingOccurrencesOfString:@")" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [phoneNumber length])];
		phoneNumber=[phoneNumber stringByReplacingOccurrencesOfString:@"+86" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [phoneNumber length])];
		return phoneNumber;
	
	
  /*  NSString* number = [NSString stringWithString:phoneNumber];
	
    NSString* number1 = [[[number stringByReplacingOccurrencesOfString:@" " withString:@""]
                          stringByReplacingOccurrencesOfString:@"(" withString:@""] 
                         stringByReplacingOccurrencesOfString:@")" withString:@""];
    
    return number1; */   
}
+(void)makeCall:(NSString *)phoneNumber
{
#ifdef IOS4
	BOOL canSendSMS = [MFMessageComposeViewController canSendText];
	if (canSendSMS) {
		
		NSString* numberAfterClear = [self cleanPhoneNumber:phoneNumber];    
		
		NSURL *phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", numberAfterClear]];
		NSLog(@"make call, URL=%@", phoneNumberURL);
		
		[[UIApplication sharedApplication] openURL:phoneNumberURL]; 
	}
	else {
		[alertView showAlert:@"系统不支持电话功能"];
	}
#endif
}
+(void)sendMessageTo:(NSString*)phone inUIViewController:(UIViewController*)vc withContent:(NSString*)body{
#ifdef IOS4
	BOOL canSendSMS = [MFMessageComposeViewController canSendText];
	if (canSendSMS) {
		MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
		picker.messageComposeDelegate = self;
		picker.body =body;
		NSArray *phoneArray = [NSArray arrayWithObject:phone];
		picker.recipients = phoneArray;
		[vc presentModalViewController:picker animated:YES];
		[picker release];
	}
	else{
		[alertView showAlert:@"系统不支持短信功能"];
	}
#endif
}
+(void)sendEmail:(NSString *)to cc:(NSString*)cc subject:(NSString*)subject body:(NSString*)body
{
	NSString* str = [NSString stringWithFormat:@"mailto:%@?cc=%@&subject=%@&body=%@",to, cc, subject, body];
	str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
+(void)locationManagerUpdateToLocation:(NSString *)newLocation fromLocation:(CLLocation *)oldLocation
{	
	NSLog(@"newlocation1:%@",newLocation);
	newLocation = [Common URLEncodedString:newLocation]; 
	//newLocation = @"中国广东省深圳市南山区高新德英语培训";
	//newLocation = [newLocation stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]; 
	//NSLog(@"newlocation %@",newLocation);
	CLLocationCoordinate2D loc = [oldLocation coordinate];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%@",loc.latitude,loc.longitude,newLocation]]];
}
+(void)openMaps:(NSString*)addressText {
    //打开地图 
	addressText = [Common URLEncodedString:addressText]; 
	NSString *urlText = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", addressText]; 
	NSLog(@"urlText =============== %@", urlText);
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
}
+(void)setActivityIndicator:(bool)isShow{

	UIApplication *app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = isShow;

}
@end
