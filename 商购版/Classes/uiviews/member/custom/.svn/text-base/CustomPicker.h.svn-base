//
//  CustomPicker.h
//  shopping
//
//  Created by 来 云 on 13-1-11.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface CustomPicker : UIActionSheet <UIPickerViewDelegate,UIPickerViewDataSource>
{
    
}
@property (nonatomic, strong) UIPickerView   *pickerView;
@property (nonatomic, strong) UIDatePicker   *datepickerView;
@property (nonatomic, strong) NSMutableArray *pickerArray;
@property (nonatomic, strong) UILabel        *Label;
@property (nonatomic, strong) id             obj;
@property (nonatomic, strong) UILabel        *displayLabel;
@property (nonatomic, strong) NSDate       *myDate;

- (id)initWithTitle:(NSString *)title withFrame:(CGRect)frame delegate:(id)delegate PickerArray:(NSMutableArray *)picker_Array Obj:(id)object_done;

- (void)showInView:(UIView *)view;
- (void)showInDelegateView:(UIView *)view;
- (id)initWithDateAndTimePicker:(CGRect)frame withTime:(NSString *)timeStr;
- (id)initWithDatePicker:(CGRect)frame withTime:(NSString *)timeStr;
- (id)initWithTimePicker:(NSString *)timeStr;
- (void)timePickShowInView:(UIView *) view;
@end

