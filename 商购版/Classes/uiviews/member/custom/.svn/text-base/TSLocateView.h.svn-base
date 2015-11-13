//
//  UICityPicker.h
//  DDMates
//
//  Created by ShawnMa on 12/16/11.
//  Copyright (c) 2011 TelenavSoftware, Inc. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "TSLocation.h"

@interface TSLocateView : UIActionSheet<UIPickerViewDelegate, UIPickerViewDataSource> {
@private
    NSMutableArray *provinces;
    NSMutableArray *provincesID;
    NSMutableArray	*cities;
    NSMutableArray *states;
}

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UIPickerView *locatePicker;
@property (retain, nonatomic) TSLocation *locate;
@property (retain, nonatomic) NSString *countryStr;
@property (retain, nonatomic) NSString *cityStr;
@property (retain, nonatomic) NSString *stateStr;
@property (nonatomic, retain) UILabel *displayLabel;
@property (nonatomic, retain) NSArray *strArray;

- (id)initWithTitle:(NSString *)title withFrame:(CGRect)frame delegate:(id /*<UIActionSheetDelegate>*/)delegate;

- (void)showInView:(UIView *)view;

@end
