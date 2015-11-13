// -*- Mode: ObjC; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-

/**
 * Copyright 2009 Jeff Verkoeyen
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "OverlayView.h"

static const CGFloat kPadding = 60;

@interface OverlayView()
@property (nonatomic,retain) UILabel *instructionsLabel;
@end


@implementation OverlayView

@synthesize delegate, oneDMode;
@synthesize points = _points;
@synthesize cropRect;
@synthesize instructionsLabel;
@synthesize scanLine;
@synthesize scanLine1;
@synthesize scanLine2;
@synthesize topLoadingImageView;
@synthesize bottomLoadingImageView;

- (id) initWithFrame:(CGRect)theFrame oneDMode:(BOOL)isOneDModeEnabled {
    
    self = [super initWithFrame:theFrame];
    
    if(self){

        CGFloat rectSize = self.frame.size.width - kPadding * 2;
        if (!oneDMode) 
        {
            cropRect = CGRectMake(kPadding, ((self.frame.size.height - rectSize) / 2) - 20.0f, rectSize, rectSize);
        } 
        else
        {
            CGFloat rectSize2 = self.frame.size.height - kPadding * 2;
            cropRect = CGRectMake(kPadding, kPadding, rectSize, rectSize2);		
        }
        self.backgroundColor = [UIColor clearColor];
        self.oneDMode = isOneDModeEnabled;
        
        //增加的背景图层
        
        CGFloat fixHeight = self.frame.size.height < 568 ? -44.0f : 0.0f;
        
        CGFloat btnfixH = self.frame.size.height < 568 ? 0.0f : 20.0f;
        
        UIImage *backgroundImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"云拍扫描界面" ofType:@"png"]];
        UIImageView *backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake( 0.0f , fixHeight , backgroundImage.size.width , backgroundImage.size.height)];
        backgroundImageView.image = backgroundImage;
        [backgroundImage release];
        [self addSubview:backgroundImageView];
        [backgroundImageView release];
        
        //标识 文本
        UIImage *logoImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"yunpai_scan_tip_icon" ofType:@"png"]];
        UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake( cropRect.origin.x , (cropRect.origin.y + cropRect.size.height) + 60.0f , logoImage.size.width , logoImage.size.height)];
        logoImageView.image = logoImage;
        [logoImage release];
        [self addSubview:logoImageView];
        [logoImageView release];
        
        UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake( CGRectGetMaxX(logoImageView.frame) + 10.0f , logoImageView.frame.origin.y , 170.0f, 30.0f)];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        tipLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0f];
        tipLabel.textColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1];
        tipLabel.numberOfLines = 2;
        tipLabel.text = @"将二维码图案放在取景框内 即可自动扫描";
        [self addSubview:tipLabel];
        [tipLabel release];
        
        //关闭按钮
        UIImage *cancelImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"云拍关闭按钮" ofType:@"png"]];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake( 20.0f , 20.0f + btnfixH , 30.0f, 30.0f);
        [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setBackgroundImage:cancelImage forState:UIControlStateNormal];
        [self addSubview:cancelButton];
        [cancelImage release];
        
        //历史记录
        UIImage *historyImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"云拍历史记录按钮" ofType:@"png"]];
        
        UIButton *historyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        historyButton.frame = CGRectMake( 270.0f , 20.0f + btnfixH , 30.0f, 30.0f);
        [historyButton addTarget:self action:@selector(history) forControlEvents:UIControlEventTouchUpInside];
        [historyButton setBackgroundImage:historyImage forState:UIControlStateNormal];
        [self addSubview:historyButton];
        [historyImage release];
        
        //添加扫描线
        UIImage *scanLineImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"yunpai_scan_line" ofType:@"png"]];
        UIImageView *tempScanLineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(cropRect.origin.x , (cropRect.origin.y + (cropRect.size.height/2)) , scanLineImage.size.width , scanLineImage.size.height)];
        tempScanLineImageView.image = scanLineImage;
        [scanLineImage release];
        self.scanLine = tempScanLineImageView;
        [self addSubview:self.scanLine];
        [tempScanLineImageView release];
        
        //添加扫描线
        UIView *tempScanLine1 = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f , cropRect.origin.y - 30.0f , 1.0f , (cropRect.size.height + 60.0f))];
        tempScanLine1.backgroundColor = [UIColor colorWithRed:0.0 green: 1.0 blue: 0.0 alpha:0.6];;
        self.scanLine1 = tempScanLine1;
        [self addSubview:self.scanLine1];
        [tempScanLine1 release];
        
        UIView *tempScanLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f , (cropRect.origin.y + (cropRect.size.height/2)) , self.frame.size.width , 1.0f)];
        tempScanLine2.backgroundColor = [UIColor colorWithRed:0.0 green: 1.0 blue: 0.0 alpha:0.6];;
        self.scanLine2 = tempScanLine2;
        [self addSubview:self.scanLine2];
        [tempScanLine2 release];
        
        [self scanAnimate:YES];
        
        UIImage *loadingImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"yunpai_start_bg" ofType:@"png"]];

        //顶部
        UIImageView *tempTopLoadingImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f , fixHeight , loadingImage.size.width , loadingImage.size.height/2)];
        tempTopLoadingImageView.image = loadingImage;
        tempTopLoadingImageView.contentMode = UIViewContentModeTop;
        tempTopLoadingImageView.clipsToBounds = YES;
        self.topLoadingImageView = tempTopLoadingImageView;
        [self addSubview:self.topLoadingImageView];
        [tempTopLoadingImageView release];

        //底部
        UIImageView *tempBottomLoadingImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f , CGRectGetMaxY(self.topLoadingImageView.frame) , loadingImage.size.width , loadingImage.size.height/2)];
        tempBottomLoadingImageView.image = loadingImage;
        tempBottomLoadingImageView.contentMode = UIViewContentModeBottom;
        tempBottomLoadingImageView.clipsToBounds = YES;
        self.bottomLoadingImageView = tempBottomLoadingImageView;
        [self addSubview:self.bottomLoadingImageView];
        [tempBottomLoadingImageView release];
        
        [loadingImage release];
        
    }
    return self;
}

//扫描动画
- (void)scanAnimate:(BOOL)isUpOrDown
{
    /*
    [UIView animateWithDuration:(arc4random()%2 + 2)
                          delay:0.0
						options:UIViewAnimationCurveLinear
                     animations:^{
     
                         if (self.scanLine.frame.origin.y == ((cropRect.origin.y + cropRect.size.height) - self.scanLine.frame.size.height))
                         {
                             self.scanLine.frame = CGRectMake(cropRect.origin.x , cropRect.origin.y , self.scanLine.frame.size.width , self.scanLine.frame.size.height);
                         }
                         else 
                         {
                             self.scanLine.frame = CGRectMake(cropRect.origin.x , ((cropRect.origin.y + cropRect.size.height) - self.scanLine.frame.size.height) , self.scanLine.frame.size.width , self.scanLine.frame.size.height);
                         }
                         
                     } completion:^(BOOL finished){
                         
                         [self scanAnimate];
                     }
     ];
     */
    [UIView animateWithDuration:0.8
                          delay:0.0
						options:UIViewAnimationCurveLinear
                     animations:^{
                         
                         //竖线
                         if (arc4random()%2)
                         {
                             CGFloat randomNum = arc4random()%(int)(self.frame.size.width - kPadding*2 - 40.0f);
                             self.scanLine1.frame = CGRectMake(kPadding + 20.0f + randomNum , cropRect.origin.y - 30.0f , self.scanLine1.frame.size.width , self.scanLine1.frame.size.height);
                         }
                         else
                         {
                             CGFloat randomNum = (self.frame.size.width - kPadding - 20.0f) - arc4random()%(int)(self.frame.size.width - kPadding*2 - 40.0f);
                             self.scanLine1.frame = CGRectMake(randomNum - self.scanLine1.frame.size.width , cropRect.origin.y - 30.0f , self.scanLine1.frame.size.width , self.scanLine1.frame.size.height);
                         }
                         
                         //横线
                         if (arc4random()%2)
                         {
                             CGFloat randomNum = arc4random()%100 + cropRect.origin.y + 20.0f;
                             self.scanLine2.frame = CGRectMake(0.0f , randomNum , self.scanLine2.frame.size.width , self.scanLine2.frame.size.height);
                         }
                         else
                         {
                             CGFloat randomNum = ((cropRect.origin.y + cropRect.size.height) - 20.0f - self.scanLine2.frame.size.height) - arc4random()%100;
                             self.scanLine2.frame = CGRectMake(0.0f , randomNum, self.scanLine2.frame.size.width , self.scanLine2.frame.size.height);
                         }
                         
                     } completion:^(BOOL finished){
                         BOOL upOrDown = isUpOrDown ? NO : YES;
                         [self scanAnimate:upOrDown];
                     }
     ];
}

//历史记录
- (void)history
{
    if (delegate != nil) 
    {
        [delegate goHistory];
    }
}

- (void)cancel:(id)sender 
{
    // call delegate to cancel this scanner
    if (delegate != nil) 
    {
        [delegate cancelled];
    }
}

- (void) dealloc {
    [_points release];
    [instructionsLabel release];
    [scanLine release];
    [scanLine1 release];
    [scanLine2 release];
    [topLoadingImageView release];
    [bottomLoadingImageView release];
    [super dealloc];
}


- (void)drawRect:(CGRect)rect inContext:(CGContextRef)context {
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y);
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
	CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height);
	CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y);
	CGContextStrokePath(context);
}

- (CGPoint)map:(CGPoint)point {
    CGPoint center;
    center.x = cropRect.size.width/2;
    center.y = cropRect.size.height/2;
    float x = point.x - center.x;
    float y = point.y - center.y;
    int rotation = 90;
    switch(rotation) {
    case 0:
        point.x = x;
        point.y = y;
        break;
    case 90:
        point.x = -y;
        point.y = x;
        break;
    case 180:
        point.x = -x;
        point.y = -y;
        break;
    case 270:
        point.x = y;
        point.y = -x;
        break;
    }
    point.x = point.x + center.x;
    point.y = point.y + center.y;
    return point;
}

#define kTextMargin 10

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
	CGContextRef c = UIGraphicsGetCurrentContext();
	CGFloat white[4] = {1.0f, 0.0f, 0.0f, 0.0f};
	CGContextSetStrokeColor(c, white);
	CGContextSetFillColor(c, white);
	[self drawRect:cropRect inContext:c];
	CGContextSaveGState(c);
    
    
//	if (oneDMode)
//    {
//        //条形码的界面文本提示
//        NSString *text = NSLocalizedStringWithDefaultValue(@"OverlayView 1d instructions", nil, [NSBundle mainBundle], @"Place a red line over the bar code to be scanned.", @"Place a red line over the bar code to be scanned.");
//        UIFont *helvetica15 = [UIFont fontWithName:@"Helvetica" size:15];
//        CGSize textSize = [text sizeWithFont:helvetica15];
//        
//		CGContextRotateCTM(c, M_PI/2);
//        // Invert height and width, because we are rotated.
//        CGPoint textPoint = CGPointMake(self.bounds.size.height / 2 - textSize.width / 2, self.bounds.size.width * -1.0f + 20.0f);
//        [text drawAtPoint:textPoint withFont:helvetica15];
//	}
//	else 
//    {
//        //二维码界面文本提示
//        NSString *displayedMessage = NSLocalizedStringWithDefaultValue(@"OverlayView displayed message", nil, [NSBundle mainBundle], @"Place a barcode inside the viewfinder rectangle to scan it.", @"Place a barcode inside the viewfinder rectangle to scan it.");
//        UIFont *font = [UIFont systemFontOfSize:18];
//        CGSize constraint = CGSizeMake(rect.size.width  - 2 * kTextMargin, cropRect.origin.y);
//        CGSize displaySize = [displayedMessage sizeWithFont:font constrainedToSize:constraint];
//        CGRect displayRect = CGRectMake((rect.size.width - displaySize.width) / 2 , cropRect.origin.y - displaySize.height, displaySize.width, displaySize.height);
//        [displayedMessage drawInRect:displayRect withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
//	}
//    
    
	CGContextRestoreGState(c);
	int offset = rect.size.width / 2;
    
//    
//	if (oneDMode) 
//    {
//        //条形码的界面 红色条形
//		CGFloat red[4] = {1.0f, 0.0f, 0.0f, 1.0f};
//		CGContextSetStrokeColor(c, red);
//		CGContextSetFillColor(c, red);
//		CGContextBeginPath(c);
//		//		CGContextMoveToPoint(c, rect.origin.x + kPadding, rect.origin.y + offset);
//		//		CGContextAddLineToPoint(c, rect.origin.x + rect.size.width - kPadding, rect.origin.y + offset);
//		CGContextMoveToPoint(c, rect.origin.x + offset, rect.origin.y + kPadding);
//		CGContextAddLineToPoint(c, rect.origin.x + offset, rect.origin.y + rect.size.height - kPadding);
//		CGContextStrokePath(c);
//	}
    
    //扫描时 定位方块
	if( nil != _points ) 
    {
		CGFloat green[4] = {0.0f, 1.0f, 0.0f, 1.0f};
		CGContextSetStrokeColor(c, green);
		CGContextSetFillColor(c, green);
		if (oneDMode) 
        {
			CGPoint val1 = [self map:[[_points objectAtIndex:0] CGPointValue]];
			CGPoint val2 = [self map:[[_points objectAtIndex:1] CGPointValue]];
			CGContextMoveToPoint(c, offset, val1.x);
			CGContextAddLineToPoint(c, offset, val2.x);
			CGContextStrokePath(c);
		}
		else 
        {
			CGRect smallSquare = CGRectMake(0, 0, 10, 10);
			for( NSValue* value in _points ) 
            {
				CGPoint point = [self map:[value CGPointValue]];
				smallSquare.origin = CGPointMake(
                                         cropRect.origin.x + point.x - smallSquare.size.width / 2,
                                         cropRect.origin.y + point.y - smallSquare.size.height / 2);
				[self drawRect:smallSquare inContext:c];
			}
		}
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setPoints:(NSMutableArray*)pnts {
    [pnts retain];
    [_points release];
    _points = pnts;
	
    if (pnts != nil) {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.25];
    }
    [self setNeedsDisplay];
}

- (void) setPoint:(CGPoint)point {
    if (!_points) {
        _points = [[NSMutableArray alloc] init];
    }
    if (_points.count > 3) {
        [_points removeObjectAtIndex:0];
    }
    [_points addObject:[NSValue valueWithCGPoint:point]];
    [self setNeedsDisplay];
}


//- (void)layoutSubviews 
//{
//    [super layoutSubviews];
//
//    if (oneDMode) 
//    {
//        
//    }
//    else
//    {
//
//    }
//}

@end
