//
//  SendMsgToWeChat.m
//  information
//
//  Created by MC374 on 12-7-20.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SendMsgToWeChat.h"
#import "WXApi.h"
#import "WXApiObject.h"

@implementation SendMsgToWeChat


- (void) sendImageContent:(UIImage*)image
{
    //发送内容给微信
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:image];
	
	NSString *filePath = [NSTemporaryDirectory() stringByAppendingFormat:@"temp.png"];
	[UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = [NSData dataWithContentsOfFile:filePath] ;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    
    [WXApi sendReq:req];
}

- (void) RespImageContent:(UIImage*)image
{
    WXMediaMessage *message = [WXMediaMessage message];
	[message setThumbImage:image];
	
	NSString *filePath = [NSTemporaryDirectory() stringByAppendingFormat:@"temp.png"];
	[UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
	
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = [NSData dataWithContentsOfFile:filePath] ;
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[[GetMessageFromWXResp alloc] init] autorelease];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
}

- (void) sendTextContent:(NSString*)nsText
{
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = YES;
    req.text = nsText;
    
    [WXApi sendReq:req];
}

-(void) RespTextContent:(NSString *)nsText
{
    GetMessageFromWXResp* resp = [[[GetMessageFromWXResp alloc] init] autorelease];
    resp.text = nsText;
    resp.bText = YES;
    
    [WXApi sendResp:resp];
}

-(void) onSentMediaMessage:(BOOL) bSent
{
    // 通过微信发送消息后， 返回本App
    NSString *strTitle = [NSString stringWithFormat:@"发送结果"];
    NSString *strMsg = [NSString stringWithFormat:@"发送媒体消息结果:%u", bSent];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}


-(void) onShowMediaMessage:(WXMediaMessage *) message
{
    // 微信启动， 有消息内容。
    [self viewContent:message];
}

- (void) sendNewsContent:(NSString*)newstitle 
				newsDescription:(NSString*)newsDescription newsImage:(UIImage*)image 
                  newUrl:(NSString*)url shareType:(int)type
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = newstitle;
    message.description = newsDescription;
    [message setThumbImage:image];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = url;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    if (type == 0) {
        req.scene = WXSceneTimeline; //选择发送到朋友圈，默认值为WXSceneSession，发送到会话
    }else if(type == 1){
        req.scene = WXSceneSession;
    }
    
    [WXApi sendReq:req];
}

-(void) RespNewsContent:(NSString*)newstitle 
		newsDescription:(NSString*)newsDescription newsImage:(UIImage*)image 
				 newUrl:(NSString*)url
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = newstitle;
    message.description = newsDescription;
    [message setThumbImage:image];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = url;
    
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[[GetMessageFromWXResp alloc] init] autorelease];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
}

-(void) sendMusicContent:(NSString*)title musicDesception:(NSString*)description
			  musicImage:(UIImage*)image musicUrl:(NSString*)url 
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title =title;
    message.description = description;
    [message setThumbImage:image];
	
    WXMusicObject *ext = [WXMusicObject object];
    ext.musicUrl = url;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    
    [WXApi sendReq:req];
}

-(void) RespMusicContent:(NSString*)title musicDesception:(NSString*)description
			  musicImage:(UIImage*)image musicUrl:(NSString*)url
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title =title;
    message.description = description;
    [message setThumbImage:image];
    WXMusicObject *ext = [WXMusicObject object];
    ext.musicUrl = url;
    
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[[GetMessageFromWXResp alloc] init] autorelease];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
}

-(void) sendVideoContent:(NSString*)title videoDesception:(NSString*)description
			  videoImage:(UIImage*)image videoUrl:(NSString*)url
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description =description;
    [message setThumbImage:image];
    
    WXVideoObject *ext = [WXVideoObject object];
    ext.videoUrl = url;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    
    [WXApi sendReq:req];
}

-(void) RespVideoContent:(NSString*)title videoDesception:(NSString*)description
			  videoImage:(UIImage*)image videoUrl:(NSString*)url
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:image];
    
    WXVideoObject *ext = [WXVideoObject object];
    ext.videoUrl = url;
    
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[[GetMessageFromWXResp alloc] init] autorelease];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
}


@end
