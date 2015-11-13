//
//  specialOfferCellViewController.m
//  specialOfferCell
//
//  Created by siphp on 13-01-05.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "specialOfferCellViewController.h"
#import "Common.h"
#import "myImageView.h"

#define MARGIN_TOP 7.0f
#define MARGIN_LEFT 9.0f

@implementation specialOfferCellViewController

@synthesize bannerView = _bannerView;
@synthesize picView1 = _picView1;
@synthesize picView2 = _picView2;
@synthesize picView3 = _picView3;
@synthesize titleLabel = _titleLabel;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)CellIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:CellIdentifier];
    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //背景
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake( 9.0f , 7.0f , 302.0f , 198.0f)];
        backgroundView.backgroundColor = [UIColor clearColor];
        backgroundView.layer.cornerRadius = 10;
        
        //添加四个边阴影
//        backgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
//        backgroundView.layer.shadowOffset = CGSizeMake(0, 0);
//        backgroundView.layer.shadowOpacity = 0.5;
//        backgroundView.layer.shadowRadius = 2.0;
        [self.contentView addSubview:backgroundView];
        [backgroundView release];
        
        UIView *cellContentView = [[UIView alloc] initWithFrame:CGRectMake( 0.0f , 0.0f , 302.0f , 198.0f)];
        cellContentView.backgroundColor = [UIColor whiteColor];
        cellContentView.layer.masksToBounds = YES;
        cellContentView.layer.cornerRadius = 10;
        [backgroundView addSubview:cellContentView];
        [cellContentView release];
        
        //title背景
        UIImageView *tempTitleImageView = [[UIImageView alloc]initWithFrame:CGRectMake( 0.0f , 0.0f , 302.0f, 36.0f)];
        UIImage *titleImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"特价专区上bar" ofType:@"png"]];
        tempTitleImageView.image = titleImage;
        [titleImage release];
        [cellContentView addSubview:tempTitleImageView];
        [tempTitleImageView release];
        
        //标题
        UILabel *tempTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake( 10.0f , 0.0f , 282.0f, 36.0f)];
        tempTitleLabel.backgroundColor = [UIColor clearColor];
        tempTitleLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        tempTitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
        tempTitleLabel.textColor = [UIColor colorWithRed:SPE_COLOR_RED green:SPE_COLOR_GREEN blue:SPE_COLOR_BLUE alpha:1];
        tempTitleLabel.text = @"";
        self.titleLabel = tempTitleLabel;
        [cellContentView addSubview:self.titleLabel];
        [tempTitleLabel release];
        
        //banner
        myImageView *tempBannerView = [[myImageView alloc]initWithFrame:CGRectMake( 0.0f , CGRectGetMaxY(self.titleLabel.frame) + 1.0f , 302.0f, 110.0f) withImageId:[NSString stringWithFormat:@"%d",0]];
        self.bannerView = tempBannerView;
        self.bannerView.backgroundColor = [UIColor clearColor];
        [cellContentView addSubview:self.bannerView];
        [tempBannerView release];
        
        //小图1
        myImageView *tempPicView1 = [[myImageView alloc]initWithFrame:CGRectMake( 0.0f , CGRectGetMaxY(self.bannerView.frame) + 1.0f , 100.0f, 50.0f) withImageId:[NSString stringWithFormat:@"%d",0]];
        self.picView1 = tempPicView1;
        self.picView1.backgroundColor = [UIColor clearColor];
        [cellContentView addSubview:self.picView1];
        [tempPicView1 release];
        
        //小图2
        myImageView *tempPicView2 = [[myImageView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(self.picView1.frame) + 1.0f , CGRectGetMaxY(self.bannerView.frame) + 1.0f , 100.0f, 50.0f) withImageId:[NSString stringWithFormat:@"%d",0]];
        self.picView2 = tempPicView2;
        self.picView2.backgroundColor = [UIColor clearColor];
        [cellContentView addSubview:self.picView2];
        [tempPicView2 release];
        
        //小图3
        myImageView *tempPicView3 = [[myImageView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(self.picView2.frame) + 1.0f , CGRectGetMaxY(self.bannerView.frame) + 1.0f , 100.0f, 50.0f) withImageId:[NSString stringWithFormat:@"%d",0]];
        self.picView3 = tempPicView3;
        self.picView3.backgroundColor = [UIColor clearColor];
        [cellContentView addSubview:self.picView3];
        [tempPicView3 release];

    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
    _bannerView = nil;
    _picView1 = nil;
    _picView2 = nil;
    _picView3 = nil;
    _titleLabel = nil;
    [super dealloc];
}


@end
