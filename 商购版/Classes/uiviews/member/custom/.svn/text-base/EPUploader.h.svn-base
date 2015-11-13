//
//  EPUploader.h
//  MyTextPick
//
//  Created by LuoHui on 12-9-18.
//  Copyright 2012 bontec. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EPUploaderDelegate <NSObject>

- (void)receiveResult:(NSString *)result;

@end


@interface EPUploader : NSObject {
    NSURLConnection *connect;
	NSURL *serverURL;
    NSData *fileData;
    id delegate;
    SEL doneSelector;
    SEL errorSelector;
    BOOL uploadDidSucceed;
	
	id <EPUploaderDelegate> uploaderDelegate;
 
}

@property(nonatomic,retain)NSURL *serverURL;
@property(nonatomic,retain)NSData *fileData;
@property(nonatomic,retain)id delegate;
@property(nonatomic,assign)id <EPUploaderDelegate> uploaderDelegate;
 
-(id)initWithURL: (NSURL *)serverURL
		   filePath: (NSData *)fileData
		   delegate: (id)delegate
	   doneSelector: (SEL)doneSelector
	  errorSelector: (SEL)errorSelector;


- (void)upload;
- (NSURLRequest *)postRequestWithURL: (NSURL *)url
                                data: (NSData *)data
                                dict:(NSMutableDictionary *)dict;

- (void)uploadSucceeded: (BOOL)success;

- (id)initWithURL1: (NSURL *)aServerURL   // IN
          filePath: (NSData *)aFilePath // IN
          delegate: (id)aDelegate         // IN
      doneSelector: (SEL)aDoneSelector    // IN
     errorSelector: (SEL)anErrorSelector;
- (void)upload1;
@end
