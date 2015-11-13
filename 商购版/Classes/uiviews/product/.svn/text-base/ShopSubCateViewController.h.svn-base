//
//  ShopSubCateViewController.h
//  shopping
//
//  Created by yunlai on 13-1-17.
//
//

#import <UIKit/UIKit.h>
#import "myImageView.h"
#import "IconDownLoader.h"

@class ShopCateViewController;
@class DDMenuController;

@interface ShopSubCateViewController : UIViewController<myImageViewDelegate,IconDownloaderDelegate>

@property (strong, nonatomic) NSArray *subCates;
@property (strong, nonatomic) ShopCateViewController *cateVC;
@property (strong, nonatomic) UIScrollView *cateScrollView;
@property (nonatomic,strong) DDMenuController *menuController;

@property (nonatomic,strong) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic,strong) NSMutableArray *imageDownloadsInWaiting;

- (void) initView;
@end
