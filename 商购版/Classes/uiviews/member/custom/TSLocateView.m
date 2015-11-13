//
//  UICityPicker.m
//  DDMates
//
//  Created by ShawnMa on 12/16/11.
//  Copyright (c) 2011 TelenavSoftware, Inc. All rights reserved.
//

#import "TSLocateView.h"
#import "DBOperate.h"
#define kDuration 0.3

@implementation TSLocateView

@synthesize titleLabel;
@synthesize locatePicker;
@synthesize locate;
@synthesize displayLabel = _displayLabel;
@synthesize cityStr = _cityStr;
@synthesize countryStr = _countryStr;
@synthesize stateStr = _stateStr;
@synthesize strArray;
- (id)initWithTitle:(NSString *)title withFrame:(CGRect)frame delegate:(id /*<UIActionSheetDelegate>*/)delegate
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"TSLocateView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        _displayLabel = [[UILabel alloc] initWithFrame:frame];
        _displayLabel.backgroundColor = [UIColor clearColor];
        
        _displayLabel.userInteractionEnabled = YES;
        self.delegate = delegate;
        self.titleLabel.text = title;
        self.locatePicker.dataSource = self;
        self.locatePicker.delegate = self;
        
        //加载数据
        provinces = [DBOperate getAllIDFromPri:@"name" whereContent:@"0"];
        provincesID = [DBOperate getAllIDFromPri:@"id" whereContent:@"0"];

        self.locate = [[TSLocation alloc] init];
        
        strArray = [[NSArray alloc] init];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    //NSLog(@"self.strArray====%@",self.strArray);
    self.countryStr = [self.strArray objectAtIndex:0];
    
    if ([self.countryStr isEqualToString:@""]) {
        self.cityStr = @"";
        self.stateStr = @"";
    }else {
        self.cityStr = [self.strArray objectAtIndex:1];
        self.stateStr = [self.strArray objectAtIndex:2];
    }
    
    NSLog(@"%@==%@==%@",self.countryStr,self.cityStr,self.stateStr);
    if (self.countryStr.length ==0 && self.cityStr.length == 0 && self.stateStr.length == 0) {
        self.countryStr = @"北京";
        self.cityStr= @"北京市";
        self.stateStr = @"东城区";
    }
    int party1 = [provinces indexOfObject:self.countryStr];
    
    [self.locatePicker selectRow:party1 inComponent:0 animated:YES];
    [self.locatePicker reloadAllComponents];
    NSMutableArray  *arrname = [DBOperate getAllIDFromPri:@"name" whereContent:[provincesID objectAtIndex:party1]];
    if (arrname.count > 0) {
        int party2 = [arrname indexOfObject:self.cityStr];
        
        [self.locatePicker selectRow:party2 inComponent:1 animated:YES];
        [self.locatePicker reloadAllComponents];
        
        NSMutableArray *array = [DBOperate getAllIDFromPri:@"id" whereContent:[provincesID objectAtIndex:party1]];
        
        NSArray *nameArr = [DBOperate getAllIDFromPri:@"name" whereContent:[array objectAtIndex:party2]];
        if (nameArr.count>0) {
            int party3 = [nameArr indexOfObject:self.stateStr];
            
            [self.locatePicker selectRow:party3 inComponent:2 animated:YES];
            [self.locatePicker reloadAllComponents];
            
        }else{
            self.locate.state = @"";
        }
    }
}

- (void)showInView:(UIView *) view
{
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [self setAlpha:1.0f];
    [self.layer addAnimation:animation forKey:@"DDLocateView"];
    
    self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    
    [view addSubview:self];
    [view addSubview:self.displayLabel];
}

#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int row1 = 0;
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    switch (component) {
        case 0:
            
            return [provinces count];
            break;
        case 1:
        {
            row1 = [pickerView selectedRowInComponent:0];
            arr = [DBOperate getAllIDFromPri:@"id" whereContent:[provincesID objectAtIndex:row1]];
            return arr.count;
        }
            
            break;
        default:
        {
            int  rrow2 = [pickerView selectedRowInComponent:1];
            
            int rrow1 = [pickerView selectedRowInComponent:0];
            NSMutableArray *arrr = [[NSMutableArray alloc] init];
            
            arrr = [DBOperate getAllIDFromPri:@"id" whereContent:[provincesID objectAtIndex:rrow1]];
            
            NSMutableArray *arrr1 = [[NSMutableArray alloc] init];
            if (arrr.count > 0) {
                arrr1 = [DBOperate getAllIDFromPri:@"id" whereContent:[arrr objectAtIndex:rrow2]];
            }else{
                self.cityStr = @"";
                self.stateStr = @"";
                self.locate.city = @"";
                self.locate.state = @"";
            }
            
            return arrr1.count;
        }
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    int row1 = 0;
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSMutableArray *arrname = [[NSMutableArray alloc] init];
    
    //NSLog(@"----------%d",component);
    switch (component) {
        case 0:
        {
            int index1 = [pickerView selectedRowInComponent:0];
            self.locate.country = [provinces objectAtIndex:index1];
            return [provinces objectAtIndex:row];
        }
            break;
        case 1:
        {
            row1 = [pickerView selectedRowInComponent:0];
            arr = [DBOperate getAllIDFromPri:@"id" whereContent:[provincesID objectAtIndex:row1]];
            arrname = [DBOperate getAllIDFromPri:@"name" whereContent:[provincesID objectAtIndex:row1]];
            int index2 = [pickerView selectedRowInComponent:1];
            self.locate.city = [arrname objectAtIndex:index2];
            return [arrname objectAtIndex:row];
        }
            break;
        case 2:
        {
            int index = [pickerView selectedRowInComponent:0];
            
            NSMutableArray *array = [DBOperate getAllIDFromPri:@"id" whereContent:[provincesID objectAtIndex:index]];
            
            int row2 = [pickerView selectedRowInComponent:1];
            NSArray *nameArr = [[NSArray alloc] init];
            nameArr = [DBOperate getAllIDFromPri:@"name" whereContent:[array objectAtIndex:row2]];
            int index3 = [pickerView selectedRowInComponent:2];
            self.locate.state = [nameArr objectAtIndex:index3];
            return [nameArr objectAtIndex:row];
        }
            break;
        default:
        {
            return nil;
        }
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
        {
            [self.locatePicker selectRow:0 inComponent:1 animated:NO];
            [self.locatePicker selectRow:0 inComponent:2 animated:NO];
            [self.locatePicker reloadComponent:0];
            [self.locatePicker reloadComponent:1];
            [self.locatePicker reloadComponent:2];
            self.locate.state = @"";
        }
            break;
        case 1:
        {
            [self.locatePicker selectRow:0 inComponent:2 animated:NO];
            [self.locatePicker reloadComponent:0];
            [self.locatePicker reloadComponent:1];
            [self.locatePicker reloadComponent:2];
            self.locate.state = @"";
        }
            
            break;
        default:
        {
            [self.locatePicker reloadComponent:0];       
            [self.locatePicker reloadComponent:1];
            [self.locatePicker reloadComponent:2];
        }
            break;
    }
}


#pragma mark - Button lifecycle

- (IBAction)cancel:(id)sender {
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    //[self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    if(self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:0];
    }
}

- (IBAction)locate:(id)sender {
    if (_displayLabel) {
        [_displayLabel removeFromSuperview];
    }
    
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    //[self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    if(self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:1];
    }
}

@end
