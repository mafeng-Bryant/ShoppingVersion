//
//  SendMsgToWeChat.h
//  information
//
//  Created by MC374 on 12-7-20.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WXApiObject.h"

@interface SendMsgToWeChat : NSObject {

}
- (void) sendImageContent:(UIImage*)image;
- (void) RespImageContent:(UIImage*)image;
- (void) sendTextContent:(NSString*)nsText;
-(void) RespTextContent:(NSString *)nsText;
-(void) onSentMediaMessage:(BOOL) bSent;
-(void) onShowMediaMessage:(WXMediaMessage *) message;
- (void) sendNewsContent:(NSString*)newstitle 
		 newsDescription:(NSString*)newsDescription newsImage:(UIImage*)image 
				  newUrl:(NSString*)url shareType:(int)type;
-(void) RespNewsContent:(NSString*)newstitle 
		newsDescription:(NSString*)newsDescription newsImage:(UIImage*)image 
				 newUrl:(NSString*)url;
-(void) sendMusicContent:(NSString*)title musicDesception:(NSString*)description
			  musicImage:(UIImage*)image musicUrl:(NSString*)url ;
-(void) RespMusicContent:(NSString*)title musicDesception:(NSString*)description
			  musicImage:(UIImage*)image musicUrl:(NSString*)url;
-(void) sendVideoContent:(NSString*)title videoDesception:(NSString*)description
			  videoImage:(UIImage*)image videoUrl:(NSString*)url;
-(void) RespVideoContent:(NSString*)title videoDesception:(NSString*)description
			  videoImage:(UIImage*)image videoUrl:(NSString*)url;
@end
