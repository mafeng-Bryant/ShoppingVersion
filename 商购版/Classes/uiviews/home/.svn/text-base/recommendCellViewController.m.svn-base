//
//  recommendCellViewController.m
//  recommendCell
//
//  Created by siphp on 13-01-05.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "recommendCellViewController.h"
#import "myImageView.h"

//顶部有少2像素阴影
#define MARGIN_TOP 13.0f 
#define MARGIN_LEFT 15.0f

@implementation recommendCellViewController

@synthesize picView = _picView;
@synthesize likeImageView = _likeImageView;
@synthesize commentImageView = _commentImageView;
@synthesize priceImageView = _priceImageView;
@synthesize titleLabel = _titleLabel;
@synthesize priceLabel = _priceLabel;
@synthesize likeLabel = _likeLabel;
@synthesize commentLabel = _commentLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)CellIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:CellIdentifier];
    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *cellContentView = [[UIView alloc] initWithFrame:CGRectMake(15.0f , 5.0f , 290.0f , 340.0f)];
        cellContentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:cellContentView];
        [cellContentView release];
        
        //背景
        UIImage *cellbackgroundImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"精品推荐背景" ofType:@"png"]];
        UIImageView *cellbackgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f , 0.0f , 290.0f , 340.0f)];
        cellbackgroundImageView.image = cellbackgroundImage;
        [cellbackgroundImage release];
        [cellContentView addSubview:cellbackgroundImageView];
        [cellbackgroundImageView release];
        
        //图片
        myImageView *tempPicView = [[myImageView alloc] initWithFrame:CGRectMake( MARGIN_LEFT , MARGIN_TOP , 260.0f, 260.0f)];
        self.picView = tempPicView;
        self.picView.backgroundColor = [UIColor orangeColor];
        [cellContentView addSubview:self.picView];
        [tempPicView release];
        
        //右上角图标
        UIImageView *rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(cellbackgroundImageView.frame.size.width - 45.0f, -1.0f, 44.0f, 44.0f)];
        UIImage *rimg = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"精品推荐标签" ofType:@"png"]];
        rightImage.image = rimg;
        [rimg release];
        [cellContentView addSubview:rightImage];
        [rightImage release];
        
        //属性
        UIView *descView = [[UIView alloc]initWithFrame:CGRectMake( MARGIN_LEFT , CGRectGetMaxY(self.picView.frame) - 35.0f , 260.0f , 30.0f)];
        descView.backgroundColor = [UIColor colorWithRed:0.0 green: 0.0 blue: 0.0 alpha:0.3];
        [cellContentView addSubview:descView];
        [descView release];

        //价格背景
        UIImageView *tempPriceImageView = [[UIImageView alloc]initWithFrame:CGRectMake( -5.0f , 0.0f , 100.0f, 30.0f)];
        UIImage *priceImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"精品推荐价格标签" ofType:@"png"]];
        tempPriceImageView.image = [priceImage stretchableImageWithLeftCapWidth:2 topCapHeight:0];
        [priceImage release];
        self.priceImageView = tempPriceImageView;
        [descView addSubview:self.priceImageView];
        [tempPriceImageView release];
        
        //价格
        UILabel *tempPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake( 0.0f , 0.0f , 100.0f, 30.0f)];
        tempPriceLabel.backgroundColor = [UIColor clearColor];
        tempPriceLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        tempPriceLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
        tempPriceLabel.textColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1];
        tempPriceLabel.text = @"";
        self.priceLabel = tempPriceLabel;
        [descView addSubview:self.priceLabel];
        [tempPriceLabel release];
        
        //喜欢icon
        UIImageView *tempLikeImageView = [[UIImageView alloc]initWithFrame:CGRectMake( 145.0f , 7.0f , 16.0f, 16.0f)];
        UIImage *likeImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表喜欢icon" ofType:@"png"]];
        tempLikeImageView.image = likeImage;
        [likeImage release];
        self.likeImageView = tempLikeImageView;
        [descView addSubview:self.likeImageView];
        [tempLikeImageView release];
        
        //喜欢
        UILabel *tempLikeLabel = [[UILabel alloc]initWithFrame:CGRectMake( CGRectGetMaxX(self.likeImageView.frame) + 5.0f, 0.0f , 35.0f, 30.0f)];
        tempLikeLabel.backgroundColor = [UIColor clearColor];
        tempLikeLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        tempLikeLabel.font = [UIFont systemFontOfSize:12];
        tempLikeLabel.textColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1];
        tempLikeLabel.text = @"9";
        self.likeLabel = tempLikeLabel;
        [descView addSubview:self.likeLabel];
        [tempLikeLabel release];
        
        //评论icon
        UIImageView *tempCommentImageView = [[UIImageView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(self.likeLabel.frame) , 7.0f , 16.0f, 16.0f)];
        UIImage *commentImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表评论icon" ofType:@"png"]];
        tempCommentImageView.image = commentImage;
        [commentImage release];
        self.commentImageView = tempCommentImageView;
        [descView addSubview:self.commentImageView];
        [tempCommentImageView release];
        
        //评论
        UILabel *tempCommentLabel = [[UILabel alloc]initWithFrame:CGRectMake( CGRectGetMaxX(self.commentImageView.frame) + 5.0f, 0.0f , 35.0f, 30.0f)];
        tempCommentLabel.backgroundColor = [UIColor clearColor];
        tempCommentLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        tempCommentLabel.font = [UIFont systemFontOfSize:12];
        tempCommentLabel.textColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1];
        tempCommentLabel.text = @"9";
        self.commentLabel = tempCommentLabel;
        [descView addSubview:self.commentLabel];
        [tempCommentLabel release];
        
        //标题
        UILabel *tempTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake( MARGIN_LEFT , CGRectGetMaxX(self.picView.frame) + 5.0f , 260.0f, 40.0f)];
        tempTitleLabel.backgroundColor = [UIColor clearColor];
        tempTitleLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        tempTitleLabel.font = [UIFont systemFontOfSize:16.0f];
        tempTitleLabel.numberOfLines = 2; 
        tempTitleLabel.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1];
        tempTitleLabel.text = @"";
        self.titleLabel = tempTitleLabel;
        [cellContentView addSubview:self.titleLabel];
        [tempTitleLabel release];
        
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
    _picView = nil;
    _likeImageView = nil;
    _commentImageView = nil;
    _priceImageView = nil;
    _titleLabel = nil;
    _priceLabel = nil;
    _likeLabel = nil;
    _commentLabel = nil;
    [super dealloc];
}


@end
