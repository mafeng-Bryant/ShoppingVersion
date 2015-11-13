//
//  IconDownLoader.m
//  MBSNSBrowser
//
//  Created by 掌商 on 11-1-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IconDownLoader.h"
#import "callSystemApp.h"
#define kCardIconHeight 48

@implementation IconDownLoader
@synthesize imageType;
@synthesize downloadURL;
@synthesize indexPathInTableView;
@synthesize delegate;
@synthesize activeDownload;
@synthesize imageConnection;
@synthesize cardIcon;
#pragma mark
/*-(id)init{

	if (self = [super init]) {
        delegateExist = YES;
    }
    return self;
}*/
- (void)dealloc
{
	[callSystemApp setActivityIndicator:NO];
    [downloadURL release];
    [indexPathInTableView release];
    
    [activeDownload release];
    
    [imageConnection cancel];
    [imageConnection release];
    [cardIcon release];
    [super dealloc];
}

- (void)startDownload
{
    self.activeDownload = [NSMutableData data];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                             [NSURLRequest requestWithURL:
                              [NSURL URLWithString:downloadURL]] delegate:self];
    self.imageConnection = conn;
    [conn release];
	[callSystemApp setActivityIndicator:YES];
}

- (void)cancelDownload
{
	[callSystemApp setActivityIndicator:NO];
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}


#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.activeDownload = nil;
    [callSystemApp setActivityIndicator:NO];
	self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connectionyin
{
    NSLog(@"image download finish");
	[callSystemApp setActivityIndicator:NO];
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
//	NSLog(@"image size width %f",image.size.width);
    if(image.size.width > 2.0)
	{
    /*if (image.size.width != kCardIconHeight && image.size.height != kCardIconHeight)
	{
        CGSize itemSize = CGSizeMake(kCardIconHeight, kCardIconHeight);
		UIGraphicsBeginImageContext(itemSize);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
		self.cardIcon = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
    }
    else
    {*/
        self.cardIcon = image;
   // }
	}
	else{
		self.cardIcon = nil;
	}
    
    self.activeDownload = nil;
    [image release];
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
	
    // call our delegate and tell it that our icon is ready for display
	
	if (delegate != nil) {
		[delegate appImageDidLoad:self.indexPathInTableView withImageType:imageType];
	}else{
        NSLog(@"delegate == nil");
    }
    
}

@end

