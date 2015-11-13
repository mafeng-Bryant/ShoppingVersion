//
//  AutoScrollView.h
//  szeca
//
//  Created by MC374 on 12-5-18.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol AutoScrollViewDelegate <NSObject>

-(void) onCloseButtonClick;
-(void) onAdClick:(int)imageId;

@end


@interface AutoScrollView : UIView {
	NSMutableArray *scrollPicArray;
	UIImageView *currImageView;
	UIImageView *nextImageView;
	int currentDisplayIndex;
	int nextDisplayIndex;
	UIButton *closeAdButton;
	id<AutoScrollViewDelegate> delegate;
}
@property(nonatomic,retain) NSMutableArray *scrollPicArray;
@property(nonatomic,retain) UIImageView *currImageView;
@property(nonatomic,retain) UIImageView *nextImageView;
@property(nonatomic,retain) UIButton *closeAdButton;
@property(nonatomic) int currentDisplayIndex;
@property(nonatomic) int nextDisplayIndex;
@property(nonatomic,assign) id<AutoScrollViewDelegate> delegate;

-(id) initWithFrame:(CGRect)frame picArray:(NSArray*)scrollPicArray;
-(void) scrollTimer;
-(void) refershView;
-(void) handleClose:(id)sender;
-(void) updateImage:(UIImage*)newImage picArrayIndex:(int)picArrayIndex;
@end
