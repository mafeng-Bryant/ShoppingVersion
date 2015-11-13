//
//  TableFooterView.m
//  shopping
//
//  Created by yunlai on 13-2-25.
//
//

#import "TableFooterView.h"


@implementation TableFooterView
@synthesize activityIndicator;
@synthesize infoLabel;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];//调用父类初始化函数
	if (self != nil)
	{
//        self.backgroundColor = [UIColor greenColor];
        UIActivityIndicatorView *tempSpinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
        [tempSpinner setCenter:CGPointMake((self.frame.size.width-tempSpinner.frame.size.width)/2,frame.size.height/2)];
        self.activityIndicator = tempSpinner;
        [tempSpinner release];
        [self addSubview:activityIndicator];
        
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.hidden = YES;
        label.textAlignment = UITextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.backgroundColor = [UIColor clearColor];
        self.infoLabel = label;
        [label release];
        [self addSubview:infoLabel];
    }
    return self;
}

- (void) dealloc
{
    [activityIndicator release];
    [infoLabel release];
    [super dealloc];
}
@end
