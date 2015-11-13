//
//  scanHistoryCellViewController.m
//  scanHistory
//
//  Created by siphp on 13-01-05.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "scanHistoryCellViewController.h"

@implementation scanHistoryCellViewController

@synthesize titleLabel = _titleLabel;
@synthesize timeLabel = _timeLabel;
@synthesize infoLabel = _infoLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)CellIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:CellIdentifier];
    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //内容
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(10.0f , 10.0f , 300.0f , 70.0f)];
        contentView.layer.masksToBounds = YES;
        contentView.layer.cornerRadius = 5;
        contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:contentView];
        [contentView release];
        
        //content 背景
        UIImage *contentBackgroundImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"云拍扫描结果背景" ofType:@"png"]];
        contentView.backgroundColor = [UIColor colorWithPatternImage:contentBackgroundImage];
        [contentBackgroundImage release];
        
        //分割线
        UIView *separationLineView = [[UIView alloc] initWithFrame:CGRectMake(60.0f , 0.0f , 4.0f , contentView.frame.size.height)];
        separationLineView.backgroundColor = [UIColor clearColor];
        separationLineView.layer.borderColor = [[UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1] CGColor];
        separationLineView.layer.borderWidth = 1.0f;
        [contentView addSubview:separationLineView];
        [separationLineView release];
        
        //标题
        UILabel *tempTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake( 0.0f , 0.0f , 60.0f, contentView.frame.size.height)];
        tempTitleLabel.backgroundColor = [UIColor clearColor];
        tempTitleLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        tempTitleLabel.font = [UIFont systemFontOfSize:14.0f];
        tempTitleLabel.textColor = [UIColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1];
        tempTitleLabel.text = @"";
        tempTitleLabel.textAlignment = UITextAlignmentCenter;
        self.titleLabel = tempTitleLabel;
        [contentView addSubview:self.titleLabel];
        [tempTitleLabel release];
        
        //时间
        UILabel *tempTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake( 80.0f , 5.0f , contentView.frame.size.width - 90.0f, 20.0f)];
        tempTimeLabel.backgroundColor = [UIColor clearColor];
        tempTimeLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        tempTimeLabel.font = [UIFont systemFontOfSize:12.0f];
        tempTimeLabel.textColor = [UIColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1];
        tempTimeLabel.text = @"";
        self.timeLabel = tempTimeLabel;
        [contentView addSubview:self.timeLabel];
        [tempTimeLabel release];
        
        //内容
        UILabel *tempInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake( 80.0f , CGRectGetMaxY(self.timeLabel.frame) , contentView.frame.size.width - 90.0f, 35.0f)];
        tempInfoLabel.backgroundColor = [UIColor clearColor];
        tempInfoLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        tempInfoLabel.font = [UIFont systemFontOfSize:14.0f];
        tempInfoLabel.textColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:1];
        tempInfoLabel.text = @"";
        tempInfoLabel.numberOfLines = 2;
        self.infoLabel = tempInfoLabel;
        [contentView addSubview:self.infoLabel];
        [tempInfoLabel release];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
    [_titleLabel release];
    [_timeLable release];
    [_infoLabel release];
    [super dealloc];
}


@end
