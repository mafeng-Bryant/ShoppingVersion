//
//  specialOfferCellViewController.h
//  specialOfferCell
//
//  Created by siphp on 13-01-05.
//  Copyright 2012 __MyCompanyName__. All rights reserved.

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class myImageView;

@interface specialOfferCellViewController : UITableViewCell 
{
    myImageView *_bannerView;
	myImageView *_picView1;
    myImageView *_picView2;
    myImageView *_picView3;
    UILabel *_titleLabel;
}
@property (nonatomic, retain) myImageView *bannerView;
@property (nonatomic, retain) myImageView *picView1;
@property (nonatomic, retain) myImageView *picView2;
@property (nonatomic, retain) myImageView *picView3;
@property (nonatomic, retain) UILabel *titleLabel;

@end
