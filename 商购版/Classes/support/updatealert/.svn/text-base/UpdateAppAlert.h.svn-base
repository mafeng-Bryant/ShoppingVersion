//
//  UpdateAppAlert.h
//  information
//
//  Created by MC374 on 12-7-27.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UpdateAppAlert : NSObject {
	NSString *updateurl;
	NSString *remindMessage;
	UIViewController *theSuperViewController;
	UIAlertView *alertV;
}
@property(nonatomic,retain)UIAlertView *alertV;
@property(nonatomic,retain)UIViewController *theSuperViewController;
@property(nonatomic,retain)NSString *updateurl;
@property(nonatomic,retain)NSString *remindMessage;
-(void)showAlert;
-(id)initWithContent:(NSString*)title
			 content:(NSString*)content leftbtn:(NSString*)leftTitle
			rightbtn:(NSString*)righttitle url:(NSString*)appurl onViewController:(UIViewController*)theViewController;
@end
