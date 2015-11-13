//
//  CustomPicker.m
//  shopping
//
//  Created by 来 云 on 13-1-11.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "CustomPicker.h"
#define kDuration 0.3
@implementation CustomPicker

@synthesize Label         = _Label;
@synthesize pickerArray   = _pickerArray;
@synthesize pickerView    = _pickerView;
@synthesize obj           = _obj;
@synthesize displayLabel  = _displayLabel;
@synthesize datepickerView = _datepickerView;
@synthesize myDate = _myDate;

- (id)initWithTitle:(NSString *)title withFrame:(CGRect)frame delegate:(id)delegate PickerArray:(NSMutableArray *)picker_Array Obj:(id)object_done
{
    self = [super init];
    
    if (self)
    {
        
        _displayLabel = [[UILabel alloc] initWithFrame:frame];
        _displayLabel.backgroundColor = [UIColor clearColor];
        _displayLabel.userInteractionEnabled = YES;
        
        self.title = title;
        self.pickerArray = picker_Array;
        self.obj = object_done;
        self.frame = CGRectMake(0, _displayLabel.frame.size.height + 200, 320,220);
        [self setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        self.backgroundColor = [UIColor colorWithRed:0.9608 green:0.9608 blue:0.9608 alpha:1.0];
        
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 7.0f, 200.0f, 30.0f)];
        labelTitle.textAlignment = 1;
        labelTitle.text = self.title;
        labelTitle.font = [UIFont systemFontOfSize:13];
        labelTitle.textColor = [UIColor whiteColor];
        labelTitle.backgroundColor = [UIColor clearColor];
        [self addSubview:labelTitle];
        
//        UISegmentedControl *cancleButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"取消"]];
//        cancleButton.momentary = YES;
//        cancleButton.frame = CGRectMake(10, 7.0f, 50.0f, 30.0f);
//        cancleButton.segmentedControlStyle = UISegmentedControlStyleBar;
//        cancleButton.tintColor = [UIColor blackColor];
//        [cancleButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventValueChanged];
//        [self addSubview:cancleButton];
        
        UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"确定"]];
        closeButton.momentary = YES;
        closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
        closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
        closeButton.tintColor = [UIColor blackColor];
        [closeButton addTarget:self action:@selector(dismissActionSheet) forControlEvents:UIControlEventValueChanged];
        [self addSubview:closeButton];
        
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, 320, 100)];
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_pickerView];
        
    }
    
    return self;
    
}

- (id)initWithDateAndTimePicker:(CGRect)frame withTime:(NSString *)timeStr
{
    self = [super init];
    if (self) {
        _displayLabel = [[UILabel alloc] initWithFrame:frame];
        _displayLabel.backgroundColor = [UIColor clearColor];
        _displayLabel.userInteractionEnabled = YES;
        
        self.frame = CGRectMake(0, 480, 320,220 );
        [self setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 7.0f, 200.0f, 30.0f)];
        labelTitle.textAlignment = 1;
        labelTitle.text = self.title;
        labelTitle.font = [UIFont systemFontOfSize:13];
        labelTitle.textColor = [UIColor whiteColor];
        labelTitle.backgroundColor = [UIColor clearColor];
        [self addSubview:labelTitle];
        
        UISegmentedControl *cancleButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"取消"]];
        cancleButton.momentary = YES;
        cancleButton.frame = CGRectMake(10, 7.0f, 50.0f, 30.0f);
        cancleButton.segmentedControlStyle = UISegmentedControlStyleBar;
        cancleButton.tintColor = [UIColor blackColor];
        [cancleButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventValueChanged];
        [self addSubview:cancleButton];
        
        UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"确定"]];
        closeButton.momentary = YES;
        closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
        closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
        closeButton.tintColor = [UIColor blackColor];
        [closeButton addTarget:self action:@selector(dismissActionSheet) forControlEvents:UIControlEventValueChanged];
        [self addSubview:closeButton];
        
        _datepickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, 320, 200)];
        
        //NSLog(@"===%@",timeStr);
        if (timeStr != nil) {
            NSDateFormatter *dateFormate = [[NSDateFormatter alloc] init];
            [dateFormate setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSDate *currentDate = [dateFormate dateFromString:timeStr];
            _datepickerView.date = currentDate;
        }else {
            NSDate *now=[NSDate date];
            _datepickerView.date=now;
        }
        _datepickerView.datePickerMode=UIDatePickerModeDateAndTime;
        _datepickerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_datepickerView];
        
    }
    return self;
}

- (id)initWithDatePicker:(CGRect)frame withTime:(NSString *)timeStr
{
    self = [super init];
    if (self) {
        _displayLabel = [[UILabel alloc] initWithFrame:frame];
        _displayLabel.backgroundColor = [UIColor clearColor];
        _displayLabel.userInteractionEnabled = YES;
        
        self.frame = CGRectMake(0, 480, 320,220 );
        [self setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 7.0f, 200.0f, 30.0f)];
        labelTitle.textAlignment = 1;
        labelTitle.text = self.title;
        labelTitle.font = [UIFont systemFontOfSize:13];
        labelTitle.textColor = [UIColor whiteColor];
        labelTitle.backgroundColor = [UIColor clearColor];
        [self addSubview:labelTitle];
        
        UISegmentedControl *cancleButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"取消"]];
        cancleButton.momentary = YES;
        cancleButton.frame = CGRectMake(10, 7.0f, 50.0f, 30.0f);
        cancleButton.segmentedControlStyle = UISegmentedControlStyleBar;
        cancleButton.tintColor = [UIColor blackColor];
        [cancleButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventValueChanged];
        [self addSubview:cancleButton];
        
        UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"确定"]];
        closeButton.momentary = YES;
        closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
        closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
        closeButton.tintColor = [UIColor blackColor];
        [closeButton addTarget:self action:@selector(dismissActionSheet) forControlEvents:UIControlEventValueChanged];
        [self addSubview:closeButton];
        
        
        _datepickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, 320, 200)];
        
        if (timeStr != nil) {
            NSDateFormatter *dateFormate = [[NSDateFormatter alloc] init];
            [dateFormate setDateFormat:@"yyyy-MM-dd"];
            NSDate *currentDate = [dateFormate dateFromString:timeStr];
            _datepickerView.date = currentDate;
        }else {
            NSDate *now=[NSDate date];
            _datepickerView.date=now;
        }
        
        _datepickerView.datePickerMode = UIDatePickerModeDate;
        _datepickerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_datepickerView];
        
    }
    return self;
}

- (id)initWithTimePicker:(NSString *)timeStr
{
    self = [super init];
    if (self) {
        _displayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 480-250)];
        _displayLabel.backgroundColor = [UIColor clearColor];
        _displayLabel.userInteractionEnabled = YES;
        
        self.frame = CGRectMake(0, 480, 320,220 );
        [self setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 7.0f, 200.0f, 30.0f)];
        labelTitle.textAlignment = 1;
        labelTitle.text = self.title;
        labelTitle.font = [UIFont systemFontOfSize:13];
        labelTitle.textColor = [UIColor whiteColor];
        labelTitle.backgroundColor = [UIColor clearColor];
        [self addSubview:labelTitle];
        
        UISegmentedControl *cancleButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"取消"]];
        cancleButton.momentary = YES;
        cancleButton.frame = CGRectMake(10, 7.0f, 50.0f, 30.0f);
        cancleButton.segmentedControlStyle = UISegmentedControlStyleBar;
        cancleButton.tintColor = [UIColor blackColor];
        [cancleButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventValueChanged];
        [self addSubview:cancleButton];
        
        UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"确定"]];
        closeButton.momentary = YES;
        closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
        closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
        closeButton.tintColor = [UIColor blackColor];
        [closeButton addTarget:self action:@selector(dismissActionSheet) forControlEvents:UIControlEventValueChanged];
        [self addSubview:closeButton];
        
        
        _datepickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, 320, 200)];
        
        if (timeStr != nil) {
            NSDateFormatter *dateFormate = [[NSDateFormatter alloc] init];
            [dateFormate setDateFormat:@"HH:mm"];
            NSDate *currentDate = [dateFormate dateFromString:timeStr];
            _datepickerView.date = currentDate;
        }else {
            NSDate *now=[NSDate date];
            _datepickerView.date=now;
        }
        
        _datepickerView.datePickerMode = UIDatePickerModeTime;
        _datepickerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_datepickerView];
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if ([self.obj isKindOfClass:[UIButton class]])
    {
        UIButton *btn = (UIButton *)self.obj;
        
        if ([self.pickerArray containsObject:btn.titleLabel.text])
        {
            
            int index = [self.pickerArray indexOfObject:btn.titleLabel.text];
            [_pickerView selectRow:index inComponent:0 animated:YES];
            
        }
        
    }
    
    if ([self.obj isKindOfClass:[UILabel class]])
    {
        
        UILabel *label = (UILabel *)self.obj;
        
        if ([self.pickerArray containsObject:label.text])
        {
            
            int index = [self.pickerArray indexOfObject:label.text];
            NSLog(@"%d",index);
            [_pickerView selectRow:index inComponent:0 animated:YES];
            
        }
        
    }
    
    if ([self.obj isKindOfClass:[UITextField class]])
    {
        
        UITextField *field = (UITextField *)self.obj;
        
        if ([self.pickerArray containsObject:field.text])
        {
            
            int index = [self.pickerArray indexOfObject:field.text];
            [_pickerView selectRow:index inComponent:0 animated:YES];
            
        }
    }
    
}

- (void)showInView:(UIView *) view
{
    [view addSubview:self];
    [view addSubview:self.displayLabel];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    self.frame = CGRectMake(0, view.frame.size.height - 320, 320,220 );
    [UIView commitAnimations];
}

- (void)showInDelegateView:(UIView *) view
{
    [view addSubview:self];
    [view addSubview:self.displayLabel];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    self.frame = CGRectMake(0, view.frame.size.height - 200, 320,260 );
    [UIView commitAnimations];
}

- (void)timePickShowInView:(UIView *) view
{
    [view addSubview:self];
    [view addSubview:self.displayLabel];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    self.frame = CGRectMake(0, view.frame.size.height - 320 + 65, 320,220 );
    [UIView commitAnimations];
}
#pragma mark - Button lifecycle

- (void)cancel {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    self.frame = CGRectMake(0, 480, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    [_displayLabel removeFromSuperview];
    
    if(self.delegate)
    {
        [self.delegate actionSheet:self clickedButtonAtIndex:0];
    }
    
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];
}

- (void)dismissActionSheet
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    self.frame = CGRectMake(0, 480, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
    
    [_displayLabel removeFromSuperview];
    
    if (_datepickerView!=nil) {
        self.myDate = _datepickerView.date;
    }
    
    if(self.delegate)
    {
        [self.delegate actionSheet:self clickedButtonAtIndex:1];
    }
    
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];
}


#pragma mark - picker delegate and datasouce

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickerArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.pickerArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if ([self.obj isKindOfClass:[UIButton class]])
    {
        UIButton *btn = (UIButton *)self.obj;
        [btn setTitle:[self.pickerArray objectAtIndex:row] forState:UIControlStateNormal];
        
    }
    
    if ([self.obj isKindOfClass:[UILabel class]])
    {
        UILabel *label = (UILabel *)self.obj;
        label.text = [self.pickerArray objectAtIndex:row];
    }
    
    if ([self.obj isKindOfClass:[UITextField class]])
    {
        UITextField *field = (UITextField *)self.obj;
        field.text = [self.pickerArray objectAtIndex:row];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[self.pickerArray objectAtIndex:row] forKey:@"checktime"];
}

@end
