//
//  CateTableCell.m
//  top100
//
//  Created by Dai Cloud on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CateTableCell.h"

@implementation CateTableCell

@synthesize title=_title;
@synthesize imageview=_imageview;
@synthesize rightImageView=_rightImageView;

- (void)dealloc
{
    [_title release];
    [_imageview release];
    [_rightImageView release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tmall_bg_main"]];
        
        self.title = [[[UILabel alloc] initWithFrame:CGRectMake(18, 10, 230, 30)] autorelease];
        self.title.font = [UIFont systemFontOfSize:20.0f];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.opaque = NO;
        [self.contentView addSubview:self.title];
        
        self.imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 49, 320, 1)];
        self.imageview.image = [UIImage imageNamed:@"商品一级分类分割线"];
        [self.contentView addSubview:self.imageview];
        
        self.rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - 91, 16, 17, 17)];
		UIImage *rimg;
		rimg = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"圆右箭头" ofType:@"png"]];
		self.rightImageView.image = rimg;
		[rimg release];
		[self.contentView addSubview:self.rightImageView];
		[self.rightImageView release];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
