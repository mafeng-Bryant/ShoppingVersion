//
//  LoadImageTableViewController.h
//  云来
//
//  Created by 掌商 on 11-5-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "imageDownLoadInWaitingObject.h"
#import "IconDownLoader.h"
@protocol LoadImageTableViewDelegate<NSObject>
-(UIImage*)getPhoto:(NSIndexPath *)indexPath;
-(NSString*)getPhotoURL:(NSIndexPath *)indexPath;
-(bool)savePhoto:(UIImage*)photo atIndexPath:(NSIndexPath*)indexPath;
@end


@interface LoadImageTableViewController : UITableViewController {
	NSMutableDictionary *imageDic;
	NSMutableDictionary *imageDownloadsInProgress;
	NSMutableArray *imageDownloadsInWaiting;	
	id<LoadImageTableViewDelegate> loadImageDelegate;
	int photoWith;
	int photoHigh;
}
@property(nonatomic,assign)int photoWith;
@property(nonatomic,assign)int photoHigh;
@property(nonatomic,assign)id<LoadImageTableViewDelegate> loadImageDelegate;
@property(nonatomic,retain)NSMutableArray *imageDownloadsInWaiting;
@property(nonatomic,retain)NSMutableDictionary *imageDic;
@property(nonatomic,retain)NSMutableDictionary *imageDownloadsInProgress;

//@property (nonatomic,retain)NSMutableArray *entries;
@end
