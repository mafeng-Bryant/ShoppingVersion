//
//  AutoScrollView.m
//  szeca
//
//  Created by MC374 on 12-5-18.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AutoScrollView.h"


@implementation AutoScrollView
@synthesize scrollPicArray;
@synthesize currImageView;
@synthesize nextImageView;
@synthesize currentDisplayIndex;
@synthesize nextDisplayIndex;
@synthesize closeAdButton;
@synthesize delegate;

-(id) initWithFrame:(CGRect)frame picArray:(NSMutableArray*)picArray{
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor blueColor];
		self.scrollPicArray = picArray;
		self.userInteractionEnabled = YES;
	}
	self.clipsToBounds = YES;
	[self refershView];
	if ([picArray count] > 1) {
		[NSTimer scheduledTimerWithTimeInterval:7 target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
	}
	return self;
}

-(void)scrollTimer
{	
	UIImageView *upImageView = [[UIImageView alloc] initWithFrame:
								CGRectMake(0, 0, self.frame.size.width,self.frame.size.height)];
	if (scrollPicArray != nil && currentDisplayIndex < [scrollPicArray count]) {
		upImageView.image = [scrollPicArray objectAtIndex:currentDisplayIndex];
	}
	
	[self addSubview:upImageView];
	[upImageView release];
	
	[UIView beginAnimations:@"animateImageOff" context:NULL]; // Begin animation
	[UIView setAnimationDuration:1.0];
	[upImageView setFrame:CGRectOffset([currImageView frame], 0 ,-currImageView.frame.size.height)]; // Move imageView off screen
	[UIView commitAnimations]; // End animations
	
	
	UIImageView *downImageView = [[UIImageView alloc] initWithFrame:
								  CGRectMake(0, self.frame.size.height, self.frame.size.width,self.frame.size.height)];
	if (scrollPicArray != nil && nextDisplayIndex < [scrollPicArray count]) {
		downImageView.image = [scrollPicArray objectAtIndex:nextDisplayIndex];
	}

	[self addSubview:downImageView];
	[downImageView release];
	
	[UIView beginAnimations:@"animateImageOff" context:NULL]; // Begin animation
	[UIView setAnimationDuration:1.0];
	[downImageView setFrame:CGRectMake(0,0, self.frame.size.width,self.frame.size.height)]; // Move imageView off screen
	[UIView commitAnimations]; // End animations
	
	currentDisplayIndex = nextDisplayIndex;
	nextDisplayIndex++;
	if (nextDisplayIndex == [scrollPicArray count]) {
		nextDisplayIndex = 0;
	}
	self.clipsToBounds = YES;
	
	if (closeAdButton != nil) {
		[self addSubview:closeAdButton];
	}
}

-(void)refershView{
	currentDisplayIndex = 0;
	nextDisplayIndex = 1;
	UIImageView *upImageView = [[UIImageView alloc] initWithFrame:
								CGRectMake(0, 0, self.frame.size.width,self.frame.size.height)];
	if(scrollPicArray != nil && [scrollPicArray count] > 0){
		upImageView.image = [scrollPicArray objectAtIndex:0];
	}	
	self.currImageView = upImageView;
	[self addSubview:currImageView];
	[upImageView release];
	
	UIImageView *downImageView = [[UIImageView alloc] initWithFrame:
								  CGRectMake(0, self.frame.size.height, self.frame.size.width,self.frame.size.height)];
	if (scrollPicArray != nil && [scrollPicArray count] > 1) {
		downImageView.image = [scrollPicArray objectAtIndex:1];
	}
	
	self.nextImageView = downImageView;
	[self addSubview:nextImageView];
	[downImageView release];
	
	UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	closeButton.frame = CGRectMake(292, 8, 24, 24);
	[closeButton addTarget:self action:@selector(handleClose:)
		  forControlEvents:UIControlEventTouchUpInside];
	[closeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft]; 
	UIImage *image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"关闭" ofType:@"png"]];
	[closeButton setImage:image forState:UIControlStateNormal];
	[image release];
	self.closeAdButton = closeButton; 
	[self addSubview:closeAdButton];
}

-(void) handleClose:(id)sender{
	NSLog(@"handleClose");
	[delegate onCloseButtonClick];
}

- (void)dealloc{

	self.closeAdButton = nil;
	self.currImageView = nil;
	self.scrollPicArray = nil;
	self.nextImageView = nil;
	[super dealloc];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	NSLog(@"autoScrollView touch");	
	[delegate onAdClick:currentDisplayIndex];
}

-(void) updateImage:(UIImage*)newImage picArrayIndex:(int)picArrayIndex{
	if (picArrayIndex >= 0 && picArrayIndex < [scrollPicArray count]) {
		[scrollPicArray replaceObjectAtIndex:picArrayIndex withObject:newImage];
		[self refershView];
	}
}

@end
