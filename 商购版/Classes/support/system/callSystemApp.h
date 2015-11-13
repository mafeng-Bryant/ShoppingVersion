//
//  callSystemApp.h
//  AppStrom
//
//  Created by 掌商 on 11-9-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface callSystemApp : NSObject {

}
+(void)makeCall:(NSString *)phoneNumber;
+(void)sendMessageTo:(NSString*)phone inUIViewController:(UIViewController*)vc withContent:(NSString*)body;
///收件人，cc：抄送  subject：主题   body：内容
+(void)sendEmail:(NSString *)to cc:(NSString*)cc subject:(NSString*)subject body:(NSString*)body;
+(void)openMaps:(NSString*)addressText;
+(NSString*)getCurrentTime;
+(void)locationManagerUpdateToLocation:(NSString *)newLocation fromLocation:(CLLocation *)oldLocation;
+(void)setActivityIndicator:(bool)isShow;
@end
