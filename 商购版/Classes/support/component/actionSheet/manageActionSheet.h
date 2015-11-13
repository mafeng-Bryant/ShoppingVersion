//
//  manageActionSheet.h
//  AppStrom
//
//  Created by 掌商 on 11-8-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol manageActionSheetDelegate
- (void)getChoosedIndex:(int)actionID chooseIndex:(int)index;
- (void) actionSheetAppear:(int)actionID actionSheet:(UIActionSheet *)actionSheet;
@end

@interface manageActionSheet : NSObject<UIActionSheetDelegate> {
	NSArray *arr_menu;
	id<manageActionSheetDelegate> manageDeleage;
	int actionID;
}
@property(nonatomic,retain)NSArray *arr_menu;
@property(nonatomic,assign)id<manageActionSheetDelegate> manageDeleage;
@property(nonatomic,assign)int actionID;
-(id)initActionSheetWithStrings:(NSArray*)strArray;

-(void)showActionSheet:(id)sender;
@end
