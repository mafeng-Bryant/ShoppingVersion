//
//  newsCellViewController.m
//  newsCell
//
//  Created by siphp on 13-01-05.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "newsCellViewController.h"

#define MARGIN_TOP 7.0f
#define MARGIN_LEFT 9.0f

@implementation newsCellViewController

@synthesize picView = _picView;
@synthesize recommendImageView = _recommendImageView;
@synthesize titleLabel = _titleLabel;
@synthesize descLabel = _descLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)CellIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:CellIdentifier];
    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //背景
        UIImage *cellbackgroundImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"活动资讯列表背景" ofType:@"png"]];
        UIImageView *cellbackgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f , 0.0f , self.frame.size.width , self.frame.size.height)];
        cellbackgroundImageView.image = cellbackgroundImage;
        [cellbackgroundImage release];
        self.backgroundView = cellbackgroundImageView;
        [cellbackgroundImageView release];
        //self.selectedBackgroundView = 
        
        //右箭头
        UIImageView *rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(300, 31, 16, 11)];
        UIImage *rimg;
        rimg = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"右箭头" ofType:@"png"]];
        rightImage.image = rimg;
        [rimg release];
        [self.contentView addSubview:rightImage];
        [rightImage release];
        
        //图片背景外框
        UIImageView *backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake( MARGIN_LEFT , MARGIN_TOP , 80.0f, 60.0f)];
        UIImage *backgroundImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"活动资讯列表外框" ofType:@"png"]];
        backgroundImageView.image = backgroundImage;
        [self.contentView addSubview:backgroundImageView];
        [backgroundImageView release];
        
        //图片
        UIImageView *tempPicView = [[UIImageView alloc]initWithFrame:CGRectMake( MARGIN_LEFT + 2.0f , MARGIN_TOP + 2.0f , 76.0f, 56.0f)];
        self.picView = tempPicView;
        [self.contentView addSubview:self.picView];
        [tempPicView release];

        //标题
        UILabel *tempTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake( CGRectGetMaxX(self.picView.frame) + 10.0f , MARGIN_TOP + 5.0f , 180.0f, 20.0f)];
        tempTitleLabel.backgroundColor = [UIColor clearColor];
        tempTitleLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        tempTitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
        tempTitleLabel.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1];
        tempTitleLabel.text = @"";
        self.titleLabel = tempTitleLabel;
        [self.contentView addSubview:self.titleLabel];
        [tempTitleLabel release];
        
        //推荐图片
        UIImageView *tempRecommendImageView = [[UIImageView alloc]initWithFrame:CGRectMake( 280.0f , 0.0f , 30.0f, 30.0f)];
        UIImage *recommendImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"推荐" ofType:@"png"]];
        tempRecommendImageView.image = recommendImage;
        tempRecommendImageView.hidden = YES;
        [recommendImage release];
        self.recommendImageView = tempRecommendImageView;
        [self.contentView addSubview:self.recommendImageView];
        [tempRecommendImageView release];
        
        //描述
        UILabel *tempDescLabel = [[UILabel alloc]initWithFrame:CGRectMake( CGRectGetMaxX(self.picView.frame) + 10.0f , CGRectGetMaxY(self.titleLabel.frame) + 3.0f, 200.0f, 30.0f)];
        tempDescLabel.backgroundColor = [UIColor clearColor];
        tempDescLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        tempDescLabel.font = [UIFont systemFontOfSize:12.0f];
        tempDescLabel.numberOfLines = 2; 
        tempDescLabel.textColor = [UIColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1];
        tempDescLabel.text = @"";
        self.descLabel = tempDescLabel;
        [self.contentView addSubview:self.descLabel];
        [tempDescLabel release];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
    _picView = nil;
    _recommendImageView = nil;
    _titleLabel = nil;
    _descLabel = nil;
    [super dealloc];
}


@end
