//
//  CustomSegment.h
//  shopping
//
//  Created by 来 云 on 13-1-9.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomSegmentDelegate <NSObject>
- (void)segmentWithIndex:(int)index;
@end

@interface CustomSegment : UIView
{
    id <CustomSegmentDelegate> delegate;
}
@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, assign) id<CustomSegmentDelegate> delegate;
@property (nonatomic, assign) BOOL repickPressed;

- (id)initWithSelectedImgArray:(NSArray *)selectedimageArray point:(CGPoint)SegmentPoint titleArray:(NSArray*)titles;
- (void)setSelectedIndex:(int)Index;
@end
