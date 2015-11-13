//
//  ShopCateViewController.h
//  shopping
//
//  Created by yunlai on 13-1-16.
//
//

#import <UIKit/UIKit.h>

@class UIFolderTableView;
@class DDMenuController;
@class ShopSubCateViewController;

@interface ShopCateViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    UIFolderTableView *folderTableView;
    NSArray *productCateDataArray;
    DDMenuController *menuController;
}

@property (nonatomic,retain) NSArray *productCateDataArray;
@property (nonatomic,retain) DDMenuController *menuController;
@end
