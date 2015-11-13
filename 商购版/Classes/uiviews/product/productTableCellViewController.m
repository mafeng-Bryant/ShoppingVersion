//
//  productTableCellViewController.m
//  productTableCell
//
//  Created by siphp on 13-01-05.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "productTableCellViewController.h"

#define MARGIN_TOP 7.0f
#define MARGIN_LEFT 9.0f

@implementation productTableCellViewController

@synthesize picView = _picView;
@synthesize likeImageView = _likeImageView;
@synthesize commentImageView = _commentImageView;
@synthesize titleLabel = _titleLabel;
@synthesize priceLabel = _priceLabel;
@synthesize originalLabel = _originalLabel;
@synthesize likeLabel = _likeLabel;
@synthesize commentLabel = _commentLabel;
@synthesize lineView = _lineView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)CellIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:CellIdentifier];
    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //背景
        UIImage *cellbackgroundImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表背景" ofType:@"png"]];
        UIImageView *cellbackgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f , 0.0f , self.frame.size.width , self.frame.size.height)];
        cellbackgroundImageView.image = cellbackgroundImage;
        [cellbackgroundImage release];
        self.backgroundView = cellbackgroundImageView;
        [cellbackgroundImageView release];
        //self.selectedBackgroundView = 
        
        //右箭头
        UIImageView *rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(300, 36, 16, 11)];
        UIImage *rimg;
        rimg = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"右箭头" ofType:@"png"]];
        rightImage.image = rimg;
        [rimg release];
        [self.contentView addSubview:rightImage];
        [rightImage release];
        
        //图片
        UIImageView *tempPicView = [[UIImageView alloc]initWithFrame:CGRectMake( MARGIN_LEFT , MARGIN_TOP , 70.0f, 70.0f)];
        //tempPicView.layer.masksToBounds = YES;
        //tempPicView.layer.cornerRadius = 10;
        //tempPicView.layer.borderWidth = 1;
        //tempPicView.layer.borderColor = [[UIColor redColor] CGColor];
        self.picView = tempPicView;
        [self.contentView addSubview:self.picView];
        [tempPicView release];
        
        //标题
        UILabel *tempTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake( CGRectGetMaxX(self.picView.frame) + 10.0f , MARGIN_TOP + 5.0f , 210.0f, 40.0f)];
        tempTitleLabel.backgroundColor = [UIColor clearColor];
        tempTitleLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        tempTitleLabel.font = [UIFont systemFontOfSize:16];
        tempTitleLabel.numberOfLines = 2; 
        tempTitleLabel.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1];
        tempTitleLabel.text = @"";
        self.titleLabel = tempTitleLabel;
        [self.contentView addSubview:self.titleLabel];
        [tempTitleLabel release];
        
        //价格
        UILabel *tempPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake( CGRectGetMaxX(self.picView.frame) + 10.0f , CGRectGetMaxY(self.titleLabel.frame) + 5.0f , 60.0f, 20.0f)];
        tempPriceLabel.backgroundColor = [UIColor clearColor];
        tempPriceLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        tempPriceLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
        tempPriceLabel.textColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1];
        tempPriceLabel.text = @"";
        self.priceLabel = tempPriceLabel;
        [self.contentView addSubview:self.priceLabel];
        [tempPriceLabel release];
        
        //优惠价格
        UILabel *tempOriginalLabel = [[UILabel alloc]initWithFrame:CGRectMake( CGRectGetMaxX(self.priceLabel.frame), CGRectGetMaxY(self.titleLabel.frame) + 5.0f , 60.0f, 20.0f)];
        tempOriginalLabel.backgroundColor = [UIColor clearColor];
        tempOriginalLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        tempOriginalLabel.font = [UIFont systemFontOfSize:12];
        tempOriginalLabel.textColor = [UIColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1];
        tempOriginalLabel.text = @"";
        tempOriginalLabel.hidden = YES;
        self.originalLabel = tempOriginalLabel;
        [self.contentView addSubview:self.originalLabel];
        [tempOriginalLabel release];
        
        //横线
        UIView *tempLineView = [[UIView alloc]initWithFrame:CGRectMake( CGRectGetMaxX(self.priceLabel.frame), CGRectGetMaxY(self.titleLabel.frame) + 15.0f , 60.0f, 1.0f)];
        tempLineView.backgroundColor = [UIColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1];
        tempLineView.hidden = YES;
        self.lineView = tempLineView;
        [self.contentView addSubview:self.lineView];
        [tempLineView release];
        
        //喜欢icon
        UIImageView *tempLikeImageView = [[UIImageView alloc]initWithFrame:CGRectMake( 210.0f , 60.0f , 16.0f, 16.0f)];
        UIImage *likeImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表喜欢icon" ofType:@"png"]];
        tempLikeImageView.image = likeImage;
        [likeImage release];
        self.likeImageView = tempLikeImageView;
        [self.contentView addSubview:self.likeImageView];
        [tempLikeImageView release];
        
        //评论icon
        UIImageView *tempCommentImageView = [[UIImageView alloc]initWithFrame:CGRectMake( 265.0f , 60.0f , 16.0f, 16.0f)];
        UIImage *commentImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"商品列表评论icon" ofType:@"png"]];
        tempCommentImageView.image = commentImage;
        [commentImage release];
        self.commentImageView = tempCommentImageView;
        [self.contentView addSubview:self.commentImageView];
        [tempCommentImageView release];
        
        //喜欢
        UILabel *tempLikeLabel = [[UILabel alloc]initWithFrame:CGRectMake( CGRectGetMaxX(self.likeImageView.frame) + 2.0f, CGRectGetMaxY(self.titleLabel.frame) + 5.0f , 35.0f, 20.0f)];
        tempLikeLabel.backgroundColor = [UIColor clearColor];
        tempLikeLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        tempLikeLabel.font = [UIFont systemFontOfSize:12];
        tempLikeLabel.textColor = [UIColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1];
        tempLikeLabel.text = @"";
        self.likeLabel = tempLikeLabel;
        [self.contentView addSubview:self.likeLabel];
        [tempLikeLabel release];
        
        //评论
        UILabel *tempCommentLabel = [[UILabel alloc]initWithFrame:CGRectMake( CGRectGetMaxX(self.commentImageView.frame) + 2.0f, CGRectGetMaxY(self.titleLabel.frame) + 5.0f , 35.0f, 20.0f)];
        tempCommentLabel.backgroundColor = [UIColor clearColor];
        tempCommentLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        tempCommentLabel.font = [UIFont systemFontOfSize:12];
        tempCommentLabel.textColor = [UIColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1];
        tempCommentLabel.text = @"";
        self.commentLabel = tempCommentLabel;
        [self.contentView addSubview:self.commentLabel];
        [tempCommentLabel release];
        
        
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
    _titleLabel = nil;
    _priceLabel = nil;
    _originalLabel = nil;
    _likeLabel = nil;
    _commentLabel = nil;
    _lineView = nil;
    [super dealloc];
}


@end
