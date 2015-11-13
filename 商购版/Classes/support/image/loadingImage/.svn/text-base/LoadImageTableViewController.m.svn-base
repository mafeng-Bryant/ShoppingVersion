//
//  LoadImageTableViewController.m
//  云来
//
//  Created by 掌商 on 11-5-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoadImageTableViewController.h"
#import "Common.h"
#import "UIImageScale.h"
#import "downloadParam.h"
@implementation LoadImageTableViewController
@synthesize loadImageDelegate;
@synthesize imageDic;
@synthesize imageDownloadsInProgress;
@synthesize imageDownloadsInWaiting;
@synthesize	photoWith;
@synthesize	photoHigh;

//@synthesize entries;
#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	NSMutableDictionary *iD = [[NSMutableDictionary alloc]init];
	self.imageDic = iD;
	[iD release];
	NSMutableDictionary *idip = [[NSMutableDictionary alloc]init];
	self.imageDownloadsInProgress = idip;
	[idip release];
	NSMutableArray *wait = [[NSMutableArray alloc]init];
	self.imageDownloadsInWaiting = wait;
	[wait release];
	photoHigh = 55;
	photoWith = 55;
	loadImageDelegate = self;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
	/*for (IconDownLoader *one in imageDownloadsInProgress){
		NSLog(@"delegate = nil");
		one.delegate = nil;
		NSLog(@"after = nil");
	}
	for (IconDownLoader *one in imageDownloadsInWaiting){
		one.delegate = nil;
	}*/
    [super viewWillDisappear:animated];
}

/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return <#number of sections#>;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return <#number of rows in section#>;
}*/


// Customize the appearance of table view cells.
/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    return cell;
}*/


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


/*#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}
*/
- (void)viewDidUnload {
 self.imageDownloadsInWaiting = nil;
 self.imageDownloadsInProgress = nil;
 self.imageDic = nil;
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


#pragma mark -
#pragma mark Table cell image support

//- (void)startIconDownload:(NSString*)imageURL forIndexPath:(NSIndexPath *)indexPath withImageType:(int)Type
//{
//    IconDownLoader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
//    if (iconDownloader == nil && imageURL != nil && imageURL.length > 1) 
//    {
//		NSLog(@"headPortraits %@",imageURL);
//		if ([imageDownloadsInProgress count]>= 5) {
//			imageDownLoadInWaitingObject *one = [[imageDownLoadInWaitingObject alloc]init:imageURL withIndexPath:indexPath withImageType:Type];
//			[imageDownloadsInWaiting addObject:one];
//			[one release];
//			return;
//		}
//		
//        iconDownloader = [[IconDownLoader alloc] init];
//        iconDownloader.downloadURL = imageURL;
//        iconDownloader.indexPathInTableView = indexPath;
//		iconDownloader.imageType = Type;
//		NSLog(@"set delegate");
//        iconDownloader.delegate = self;
//        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
//        [iconDownloader startDownload];
//        [iconDownloader release];   
//    }
//}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
//- (void)loadImagesForOnscreenRows
//{
//	NSLog(@"load images for on screen");
//    //if ([self.entries count] > 0)
//    //{
//        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
//        for (NSIndexPath *indexPath in visiblePaths)
//        {
//            //GroupInfo *cardRecord = [self.entries objectAtIndex:indexPath.row];
//            UIImage *cardIcon = [[imageDic objectForKey:[NSNumber numberWithInt:indexPath.row]]scaleToSize:CGSizeMake(photoWith, photoHigh)];
//			UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//            if (!cardIcon) // avoid the app icon download if the app already has an icon
//            {
//				////////////获取本地图片缓存
//				if (loadImageDelegate != nil) {
//					NSLog(@"load image delegate != nil or not1");
//					cardIcon = [[loadImageDelegate getPhoto:indexPath]scaleToSize:CGSizeMake(photoWith, photoHigh)];
//				}
//				
//				if (cardIcon == nil) {
//					if (loadImageDelegate != nil) {
//						NSLog(@"load image delegate != nil or not2");
//					NSString *photoURL = [loadImageDelegate getPhotoURL:indexPath];
//						[self startIconDownload:photoURL forIndexPath:indexPath withImageType:CUSTOMER_PHOTO];
//					}
//					
//				}
//				else {
//					cell.imageView.image = cardIcon;
//					[imageDic setObject:cardIcon forKey:[NSNumber numberWithInt:indexPath.row]];
//				}
//            }
//			else {
//				cell.imageView.image = cardIcon;
//			}
//			
//        }
//}

// called by our ImageDownloader when an icon is ready to be displayed
//- (void)appImageDidLoad:(NSIndexPath *)indexPath withImageType:(int)Type
//{
//    IconDownLoader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
//    if (iconDownloader != nil)
//    {
//        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
//        
//        // Display the newly loaded image
//		NSLog(@"card icon %f",iconDownloader.cardIcon.size.width);
//		if(iconDownloader.cardIcon.size.width>2.0){ 
//			UIImage *photo = [iconDownloader.cardIcon scaleToSize:CGSizeMake(photoWith, photoHigh)];
//			if (loadImageDelegate != nil) {
//			[loadImageDelegate savePhoto:iconDownloader.cardIcon atIndexPath:indexPath];
//			}
//			cell.imageView.image = photo;
//			[self.tableView reloadData];
//			[imageDic setObject:photo forKey:[NSNumber numberWithInt:[indexPath row]]];
//		}
//		
//		[imageDownloadsInProgress removeObjectForKey:indexPath];
//		NSLog(@"after remove object");
//		if ([imageDownloadsInWaiting count]>0) {
//			imageDownLoadInWaitingObject *one = [imageDownloadsInWaiting objectAtIndex:0];
//			[self startIconDownload:one.imageURL forIndexPath:one.indexPath withImageType:CUSTOMER_PHOTO];
//			[imageDownloadsInWaiting removeObjectAtIndex:0];
//		}
//		
//    }
//}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//	if (!decelerate)
//	{
//        //[self loadImagesForOnscreenRows];
//    }
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    //[self loadImagesForOnscreenRows];
//}
- (void)dealloc {
	NSLog(@"loadimage dealloc %d",[imageDownloadsInProgress count]);
	for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
	loadImageDelegate = nil;
	self.imageDic=nil;
	self.imageDownloadsInProgress=nil;
	self.imageDownloadsInWaiting=nil;
    [super dealloc];
}


@end

