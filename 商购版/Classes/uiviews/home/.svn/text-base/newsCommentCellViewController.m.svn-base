//
//  newsCommentCellViewController.m
//  newsCommentCell
//
//  Created by siphp on 13-01-05.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "newsCommentCellViewController.h"

#define MARGIN_TOP 10.0f
#define MARGIN_LEFT 10.0f

@implementation newsCommentCellViewController

@synthesize picView = _picView;
@synthesize usernameLabel = _usernameLabel;
@synthesize contentLabel = _contentLabel;
@synthesize createdLabel = _createdLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)CellIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:CellIdentifier];
    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //头像背景外框
        UIImage *backgroundImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"头像背景" ofType:@"png"]];
        UIImageView *backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake( MARGIN_LEFT , MARGIN_TOP , backgroundImage.size.width, backgroundImage.size.height)];
        backgroundImageView.image = backgroundImage;
        [self.contentView addSubview:backgroundImageView];
        [backgroundImageView release];
        
        //头像图片
        UIImageView *tempPicView = [[UIImageView alloc]initWithFrame:CGRectMake( MARGIN_LEFT + 6.0f , MARGIN_TOP + 6.0f , 40.0f, 40.0f)];
        self.picView = tempPicView;
        self.picView.layer.masksToBounds = YES;
        self.picView.layer.cornerRadius = 20;
        [self.contentView addSubview:self.picView];
        [tempPicView release];

        //用户名字
        UILabel *tempUsernameLabel = [[UILabel alloc]initWithFrame:CGRectMake( CGRectGetMaxX(self.picView.frame) + 10.0f , MARGIN_TOP , 100.0f, 20.0f)];
        tempUsernameLabel.backgroundColor = [UIColor clearColor];
        tempUsernameLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        tempUsernameLabel.font = [UIFont systemFontOfSize:12.0f];
        tempUsernameLabel.textColor = [UIColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1];
        tempUsernameLabel.text = @"";
        self.usernameLabel = tempUsernameLabel;
        [self.contentView addSubview:self.usernameLabel];
        [tempUsernameLabel release];
        
        //时间
        UILabel *tempCreatedLabel = [[UILabel alloc]initWithFrame:CGRectMake( CGRectGetMaxX(self.usernameLabel.frame) + 20.0f , MARGIN_TOP, 140.0f, 20.0f)];
        tempCreatedLabel.backgroundColor = [UIColor clearColor];
        tempCreatedLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        tempCreatedLabel.font = [UIFont systemFontOfSize:12.0f];
        tempCreatedLabel.textColor = [UIColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1];
        tempCreatedLabel.text = @"";
        self.createdLabel = tempCreatedLabel;
        [self.contentView addSubview:self.createdLabel];
        [tempCreatedLabel release];
        
        //内容
        UILabel *tempContentLabel = [[UILabel alloc]initWithFrame:CGRectMake( CGRectGetMaxX(self.picView.frame) + 10.0f , CGRectGetMaxY(self.usernameLabel.frame) , 250.0f, 35.0f)];
        tempContentLabel.backgroundColor = [UIColor clearColor];
        tempContentLabel.lineBreakMode = UILineBreakModeWordWrap;
        tempContentLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
        tempContentLabel.numberOfLines = 0;
        tempContentLabel.textColor = [UIColor darkTextColor];
        tempContentLabel.text = @"";
        self.contentLabel = tempContentLabel;
        [self.contentView addSubview:self.contentLabel];
        [tempContentLabel release];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
    _picView = nil;
    _usernameLabel = nil;
    _contentLabel = nil;
    _createdLabel = nil;
    [super dealloc];
}


@end
