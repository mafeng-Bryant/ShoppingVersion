//
//  newsCommentCellViewController.h
//  newsCommentCell
//
//  Created by siphp on 13-01-05.
//  Copyright 2012 __MyCompanyName__. All rights reserved.

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface newsCommentCellViewController : UITableViewCell 
{
	UIImageView *_picView;
    UILabel *_usernameLabel;
    UILabel *_contentLabel;
    UILabel *_createdLabel;
}
@property (nonatomic, retain) UIImageView *picView;
@property (nonatomic, retain) UILabel *usernameLabel;
@property (nonatomic, retain) UILabel *contentLabel;
@property (nonatomic, retain) UILabel *createdLabel;
@end
