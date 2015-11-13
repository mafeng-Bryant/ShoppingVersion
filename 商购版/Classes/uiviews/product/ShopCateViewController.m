//
//  ShopCateViewController.m
//  shopping
//
//  Created by yunlai on 13-1-16.
//
//

#import "ShopCateViewController.h"
#import "UIFolderTableView.h"
#import "CateTableCell.h"
#import "DBOperate.h"
#import "ShopSubCateViewController.h"
#import "productViewController.h"
#import "Common.h"

@interface ShopCateViewController ()

@end

@implementation ShopCateViewController
@synthesize productCateDataArray;
@synthesize menuController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"height:%f",self.view.frame.size.height);
    self.view.backgroundColor = [UIColor clearColor];
    
    UIImage *navImage = nil;
    int yValue = 0;
    if (IOS_VERSION >= 7.0) {
        navImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ios7_分类上bar" ofType:@"png"]];
        yValue = 20;
    }else {
        navImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"分类上bar" ofType:@"png"]];
    }
    UIImageView *navImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0 ,self.view.frame.size.width,navImage.size.height)];
    navImageView.image = navImage;
    [navImage release];
    [self.view addSubview:navImageView];
    
    //添加title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, yValue, self.view.frame.size.width-40, 44)];
    titleLabel.text = @"商品分类";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    [navImageView addSubview:titleLabel];
    [titleLabel release];
    [navImageView release];
    
    self.productCateDataArray = [DBOperate queryData:T_PRODUCT_CAT theColumn:@"parent_id" theColumnValue:[NSString stringWithFormat:@"%d",0] orderBy:@"sort_order" orderType:@"desc" withAll:NO];
    
    folderTableView = [[UIFolderTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(navImageView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(navImageView.frame)-49)];
    folderTableView.backgroundColor = [UIColor clearColor];
    folderTableView.delegate = self;
    folderTableView.dataSource = self;
    folderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:folderTableView];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [productCateDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cate_cell";
    
    CateTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[CateTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                     reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSArray *ay = [productCateDataArray objectAtIndex:indexPath.row];
    if (ay != nil && [ay count] > 0) {
        cell.title.text = [ay objectAtIndex:product_cat_name];
    }
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *cateAy = [productCateDataArray objectAtIndex:indexPath.row];
    NSArray *subCateAy = [DBOperate queryData:T_PRODUCT_CAT theColumn:@"parent_id" theColumnValue:[NSString stringWithFormat:@"%d",[[cateAy objectAtIndex:product_cat_id] intValue]] orderBy:@"sort_order" orderType:@"desc" withAll:NO];
    if (subCateAy != nil && [subCateAy count] > 0) {
        ShopSubCateViewController *subVc = [[ShopSubCateViewController alloc] initWithNibName:nil bundle:nil];
        subVc.cateVC = self;
        subVc.subCates = subCateAy;
        subVc.menuController = self.menuController;
        
        //添加下箭头
        CateTableCell *cell = (CateTableCell*)[folderTableView cellForRowAtIndexPath:indexPath];
        UIImageView *downImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 91, 16, 17, 17)];
        UIImage *rimg;
        rimg = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"下箭头" ofType:@"png"]];
        downImage.image = rimg;
        [rimg release];
        cell.rightImageView.hidden = YES;
        [cell.contentView addSubview:downImage];
        
        //添加箭头打开指引图片
        UIImageView *openImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 38, self.view.frame.size.width, 12)];
        UIImage *image;
        image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"一级产品展开" ofType:@"png"]];
        openImage.image = image;
        [image release];
        [cell.contentView addSubview:openImage];
        
        folderTableView.scrollEnabled = NO;
        UIFolderTableView *tv = (UIFolderTableView *)tableView;
        [tv openFolderAtIndexPath:indexPath WithContentView:subVc.view
                        openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                            // opening actions
                        }
                       closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                           // closing actions
                       }
                  completionBlock:^{
                      // completed actions
                      folderTableView.scrollEnabled = YES;
                      cell.rightImageView.hidden = NO;
                      [downImage removeFromSuperview];
                      [openImage removeFromSuperview];
                  }];
    }else{
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = [[cateAy objectAtIndex:product_cat_id] intValue];
        [menuController subCateBtnAction:btn];
    }
}

//每行行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 50.0;
}

-(CGFloat)tableView:(UIFolderTableView *)tableView xForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (void) dealloc{
    [productCateDataArray release],productCateDataArray = nil;
    [menuController release],menuController = nil;
    [super dealloc];
}

@end
