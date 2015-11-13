//
//  scanHistoryCellViewController.h
//  scanHistory
//
//  Created by siphp on 13-01-05.
//  Copyright 2012 __MyCompanyName__. All rights reserved.

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface scanHistoryCellViewController : UITableViewCell 
{
    UILabel *_titleLabel;
    UILabel *_timeLable;
    UILabel *_infoLabel;
}
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UILabel *infoLabel;
@end
