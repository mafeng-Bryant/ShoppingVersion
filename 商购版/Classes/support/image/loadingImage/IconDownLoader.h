//
//  IconDownLoader.h
//  MBSNSBrowser
//
//  Created by 掌商 on 11-1-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GroupInfo;
@class CardGroupViewController;

@protocol IconDownloaderDelegate 

- (void)appImageDidLoad:(NSIndexPath *)indexPath withImageType:(int)Type;

@end

@interface IconDownLoader : NSObject {
	NSString *downloadURL;
    NSIndexPath *indexPathInTableView;
    id <IconDownloaderDelegate> delegate;
    NSMutableData *activeDownload;
    NSURLConnection *imageConnection;
	UIImage *cardIcon;
	int imageType;

}
@property (nonatomic, assign) int imageType;
@property (nonatomic, retain) NSString *downloadURL;
@property (nonatomic, retain) NSIndexPath *indexPathInTableView;
@property (nonatomic, assign) id <IconDownloaderDelegate> delegate;
@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *imageConnection;
@property (nonatomic, retain) UIImage *cardIcon;
- (void)startDownload;
- (void)cancelDownload;

@end

