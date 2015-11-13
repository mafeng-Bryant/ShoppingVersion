//
//  lotteryCellViewController.m
//  lotteryCell
//
//  Created by siphp on 13-01-05.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "lotteryCellViewController.h"
#import "Common.h"
#import "myImageView.h"

#define MARGIN_TOP 10.0f
#define MARGIN_LEFT 10.0f

@implementation lotteryCellViewController

@synthesize picView = _picView;
@synthesize titleLabel = _titleLabel;
@synthesize priceLabel = _priceLabel;
@synthesize winNumLabel = _winNumLabel;
@synthesize timeTitleLabel = _timeTitleLabel;
@synthesize timeLabel = _timeLabel;
@synthesize statusLabel = _statusLabel;
@synthesize statusImageView = _statusImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)CellIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:CellIdentifier];
    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //背景
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake( MARGIN_LEFT , MARGIN_TOP , 300.0f , 202.0f)];
        backgroundView.backgroundColor = [UIColor clearColor];
        backgroundView.layer.cornerRadius = 10;
        
        //添加四个边阴影
//        backgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
//        backgroundView.layer.shadowOffset = CGSizeMake(0, 0);
//        backgroundView.layer.shadowOpacity = 0.5;
//        backgroundView.layer.shadowRadius = 2.0;
        [self.contentView addSubview:backgroundView];
        [backgroundView release];
        
        UIView *cellContentView = [[UIView alloc] initWithFrame:CGRectMake( 0.0f , 0.0f , 300.0f , 202.0f)];
        cellContentView.backgroundColor = [UIColor clearColor];
        cellContentView.layer.masksToBounds = YES;
        cellContentView.layer.cornerRadius = 10;
        [backgroundView addSubview:cellContentView];
        [cellContentView release];
        
        //content 背景
        UIImage *contentBackgroundImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"抽奖列表背景" ofType:@"png"]];
        cellContentView.backgroundColor = [UIColor colorWithPatternImage:contentBackgroundImage];
        [contentBackgroundImage release];
         
        //标题
        UILabel *tempTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake( 10.0f , 0.0f , 280.0f, 40.0f)];
        tempTitleLabel.backgroundColor = [UIColor clearColor];
        tempTitleLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        tempTitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
        tempTitleLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
        tempTitleLabel.text = @"";
        self.titleLabel = tempTitleLabel;
        [cellContentView addSubview:self.titleLabel];
        [tempTitleLabel release];
        
        //图片
        myImageView *tempPicView = [[myImageView alloc]initWithFrame:CGRectMake( 0.0f , CGRectGetMaxY(self.titleLabel.frame) , 300.0f, 122.0f) withImageId:[NSString stringWithFormat:@"%d",0]];
        self.picView = tempPicView;
        self.picView.backgroundColor = [UIColor clearColor];
        [cellContentView addSubview:self.picView];
        [tempPicView release];
        
        //价格
        UILabel *tempPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake( 10.0f , CGRectGetMaxY(self.picView.frame) , 80.0f, 20.0f)];
        tempPriceLabel.backgroundColor = [UIColor clearColor];
        tempPriceLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        tempPriceLabel.font = [UIFont systemFontOfSize:12.0f];
        tempPriceLabel.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1];
        tempPriceLabel.text = @"";
        self.priceLabel = tempPriceLabel;
        [cellContentView addSubview:self.priceLabel];
        [tempPriceLabel release];
        
        //中奖人数
        UILabel *tempWinNumTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake( CGRectGetMaxX(self.priceLabel.frame) , CGRectGetMaxY(self.picView.frame) , 65.0f, 20.0f)];
        tempWinNumTitleLabel.backgroundColor = [UIColor clearColor];
        tempWinNumTitleLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        tempWinNumTitleLabel.font = [UIFont systemFontOfSize:12.0f];
        tempWinNumTitleLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
        tempWinNumTitleLabel.text = @"已中奖人数:";
        [cellContentView addSubview:tempWinNumTitleLabel];
        [tempWinNumTitleLabel release];
        
        UILabel *tempWinNumLabel = [[UILabel alloc]initWithFrame:CGRectMake( CGRectGetMaxX(tempWinNumTitleLabel.frame) , CGRectGetMaxY(self.picView.frame) , 35.0f, 20.0f)];
        tempWinNumLabel.backgroundColor = [UIColor clearColor];
        tempWinNumLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        tempWinNumLabel.font = [UIFont systemFontOfSize:12.0f];
        tempWinNumLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
        tempWinNumLabel.text = @"";
        self.winNumLabel = tempWinNumLabel;
        [cellContentView addSubview:self.winNumLabel];
        [tempWinNumLabel release];
        
        //时间
        UILabel *tempTimeTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake( 10.0f , CGRectGetMaxY(self.winNumLabel.frame) , 60.0f, 20.0f)];
        tempTimeTitleLabel.backgroundColor = [UIColor clearColor];
        tempTimeTitleLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        tempTimeTitleLabel.font = [UIFont systemFontOfSize:12.0f];
        tempTimeTitleLabel.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
        tempTimeTitleLabel.text = @"截止时间:";
        tempTimeTitleLabel.hidden = YES;
        self.timeTitleLabel = tempTimeTitleLabel;
        [cellContentView addSubview:self.timeTitleLabel];
        [tempTimeTitleLabel release];
        
        UILabel *tempTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake( CGRectGetMaxX(tempTimeTitleLabel.frame) , CGRectGetMaxY(self.winNumLabel.frame) , 120.0f, 20.0f)];
        tempTimeLabel.backgroundColor = [UIColor clearColor];
        tempTimeLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        tempTimeLabel.font = [UIFont systemFontOfSize:12.0f];
        tempTimeLabel.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
        tempTimeLabel.text = @"";
        tempTimeLabel.hidden = YES;
        self.timeLabel = tempTimeLabel;
        [cellContentView addSubview:self.timeLabel];
        [tempTimeLabel release];
        
        //状态
        UIImageView *tempStatusImageView = [[UIImageView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(self.winNumLabel.frame) + MARGIN_LEFT , CGRectGetMaxY(self.picView.frame) + MARGIN_TOP , 120.0f, 40.0f)];
        self.statusImageView = tempStatusImageView;
        self.statusImageView.backgroundColor = [UIColor clearColor];
        self.statusImageView.hidden = YES;
        [self.contentView addSubview:self.statusImageView];
        [tempStatusImageView release];
        
        UILabel *tempStatusLabel = [[UILabel alloc]initWithFrame:CGRectMake( CGRectGetMaxX(self.winNumLabel.frame) + MARGIN_LEFT , CGRectGetMaxY(self.picView.frame) + MARGIN_TOP , 120.0f, 40.0f)];
        tempStatusLabel.backgroundColor = [UIColor clearColor];
        tempStatusLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        tempStatusLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
        tempStatusLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];
        tempStatusLabel.text = @"";
        tempStatusLabel.textAlignment = UITextAlignmentCenter;
        self.statusLabel = tempStatusLabel;
        [self.contentView addSubview:self.statusLabel];
        [tempStatusLabel release];

    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
    [_picView release];
    [_titleLabel release];
    [_priceLabel release];
    [_winNumLabel release];
    [_timeTitleLabel release];
    [_timeLabel release];
    [_statusLabel release];
    [_statusImageView release];
    [super dealloc];
}


@end
