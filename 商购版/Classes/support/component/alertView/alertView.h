//
//  alertView.h
//  MBSNSBrowser
//
//  Created by 掌商 on 11-3-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface alertView : NSObject {

}
+ (void) alertView:(UIAlertView *) alertView1 clickedButtonAtIndex: (int) index;
+ (void) showAlert: (NSString *) message withCancelTitle:(NSString*)cancelTitle andOKTitle:(NSString*)okTitle;
+ (void) showAlert:(NSString*)message;
@end
