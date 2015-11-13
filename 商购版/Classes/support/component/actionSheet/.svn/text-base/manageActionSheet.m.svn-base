//
//  manageActionSheet.m
//  AppStrom
//
//  Created by 掌商 on 11-8-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "manageActionSheet.h"

@implementation manageActionSheet
@synthesize arr_menu;
@synthesize manageDeleage;
@synthesize actionID;

-(id)initActionSheetWithStrings:(NSArray*)strArray{
	if (self = [super init]) {
		self.arr_menu = strArray;
	}
	return self;
}
-(void)showActionSheet:(id)sender {
    UIActionSheet *popupQuery;
	popupQuery = [[UIActionSheet alloc] initWithTitle:nil
										     delegate:self 
								    cancelButtonTitle:nil 
							   destructiveButtonTitle:nil
									otherButtonTitles:nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleDefault;
	for (NSString *title in arr_menu){
		[popupQuery addButtonWithTitle:title];
	}
	[popupQuery addButtonWithTitle:@"取消"];
	popupQuery.cancelButtonIndex = popupQuery.numberOfButtons-1;
	
    [popupQuery showInView:(UIView*)sender];
    [popupQuery release];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != actionSheet.cancelButtonIndex) {
		int index = 0;//actionSheet.firstOtherButtonIndex;
		NSLog(@"index %d, buttonIndex: %d",index,buttonIndex);
		if (manageDeleage != nil) {
			[manageDeleage getChoosedIndex:actionID chooseIndex:buttonIndex-index];
		}
	}
}		


- (void)didPresentActionSheet:(UIActionSheet *)actionSheet{
	if (manageDeleage != nil) {
		[manageDeleage actionSheetAppear:actionID actionSheet:actionSheet];
	}
}

-(void)dealloc{
	self.arr_menu = nil;
	[super dealloc];
}
@end
