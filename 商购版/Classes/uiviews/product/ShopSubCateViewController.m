//
//  ShopSubCateViewController.m
//  shopping
//
//  Created by yunlai on 13-1-17.
//
//

#import "ShopSubCateViewController.h"
#import "DBOperate.h"
#import "myImageView.h"
#import "Common.h"
#import "FileManager.h"
#import "UIImageScale.h"
#import "downloadParam.h"
#import "imageDownLoadInWaitingObject.h"

#define COLUMN 4
#define ROWWIDTH 60
#define INNERMARGIN 3.0
#define COLUMN_MARGIN 8
#define ROW_MARGIN 20

@interface ShopSubCateViewController ()

@end

@implementation ShopSubCateViewController

@synthesize subCates=_subCates;
@synthesize cateVC=_cateVC;
@synthesize cateScrollView=_cateScrollView;
@synthesize menuController=_menuController;
@synthesize imageDownloadsInProgress=_imageDownloadsInProgress;
@synthesize imageDownloadsInWaiting=_imageDownloadsInWaiting;

- (void)dealloc
{
    [_subCates release];
    [_cateVC release];
    [_cateScrollView release];
    [_menuController release];
    for (IconDownLoader *one in [self.imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
    [_imageDownloadsInProgress release];
    [_imageDownloadsInWaiting release];
    [super dealloc];
}

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
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    
    self.imageDownloadsInProgress = [[NSMutableDictionary alloc]init];
	self.imageDownloadsInWaiting = [[NSMutableArray alloc]init];
    
    self.cateScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    self.cateScrollView.backgroundColor = [UIColor clearColor];
    self.cateScrollView.pagingEnabled = NO;
    [self.view addSubview:self.cateScrollView];
    [self initView];
}

- (void) initView{
    
    int total = self.subCates.count;
    int rows = (total / COLUMN) + ((total % COLUMN) > 0 ? 1 : 0);
    for (int i=0; i<total; i++) {
        int row = i / COLUMN;
        int column = i % COLUMN;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(column*(ROWWIDTH + COLUMN_MARGIN)+COLUMN_MARGIN, row*(ROWWIDTH + ROW_MARGIN)+ 10, ROWWIDTH, ROWWIDTH)];
        view.backgroundColor = [UIColor clearColor];
        
        UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, ROWWIDTH, ROWWIDTH)];
        UIImage *image = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"瀑布流商品小图外框" ofType:@"png"]];
        backImageView.image = image;
        [image release];
        backImageView.backgroundColor = [UIColor clearColor];
        [view addSubview:backImageView];
        [backImageView release];
        
        //具体分类数据
        NSArray *ay = [self.subCates objectAtIndex:i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(INNERMARGIN, INNERMARGIN, ROWWIDTH - 2*INNERMARGIN, ROWWIDTH-2*INNERMARGIN);
        btn.tag = [[ay objectAtIndex:product_cat_id] intValue];//100+ i;
        [btn addTarget:self.menuController
                action:@selector(subCateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *imageUrl = [ay objectAtIndex:product_cat_pic];
        NSString *picName = [Common encodeBase64:(NSMutableData *)[imageUrl dataUsingEncoding: NSUTF8StringEncoding]];
        
        UIImage *photo = [FileManager getPhoto:picName];
        if (photo != nil && photo.size.width > 0)
        {
            [btn setBackgroundImage:photo forState:UIControlStateNormal];
        }
        else
        {
            [btn setBackgroundImage:[UIImage imageNamed:@"商品列表默认图片.png"]
                           forState:UIControlStateNormal];
            NSLog(@"imageUrl:%@",imageUrl);
            [self startIconDownload:imageUrl forIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        
        [view addSubview:btn];
        [self.cateScrollView addSubview:view];
        [view release];
        
        UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectMake(column*(ROWWIDTH + COLUMN_MARGIN)+COLUMN_MARGIN, row*(ROWWIDTH +ROW_MARGIN)+ ROWWIDTH+14, ROWWIDTH, 16)] autorelease];
        lbl.textAlignment = UITextAlignmentCenter;
        lbl.textColor = [UIColor colorWithRed:104/255.0
                                        green:104/255.0
                                         blue:104/255.0
                                        alpha:1.0];
        lbl.font = [UIFont systemFontOfSize:12.0f];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.text = [ay objectAtIndex:product_cat_name];
        [self.cateScrollView addSubview:lbl];
    }
    
    float totalHeight = ROWWIDTH * rows + 18 + ROW_MARGIN * rows;
    float screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    //根据二级分类的个数来决定当前view和scrollview的高度
    if (totalHeight > screenHeight - 44 - 49 - 50 - 20) {
        CGRect viewFrame = self.view.frame;
        CGSize svrollViewSize = self.view.frame.size;
        svrollViewSize.height = totalHeight;
        
        viewFrame.size.height = screenHeight - 44 - 49 - 50 - 20;
        self.view.frame = viewFrame;
        self.cateScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, viewFrame.size.height);;
        self.cateScrollView.contentSize = svrollViewSize;
    }else{
        CGRect viewFrame = self.view.frame;
        viewFrame.size.height = totalHeight;
        self.cateScrollView.contentSize = viewFrame.size;
        self.cateScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, totalHeight);
        
        self.view.frame = viewFrame;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取网络图片
- (void)startIconDownload:(NSString*)photoURL forIndexPath:(NSIndexPath*)indexPath
{
    IconDownLoader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil && photoURL != nil && photoURL.length > 1)
    {
		if ([self.imageDownloadsInProgress count]>= 2) {
			imageDownLoadInWaitingObject *one = [[imageDownLoadInWaitingObject alloc]init:photoURL withIndexPath:indexPath withImageType:CUSTOMER_PHOTO];
			[self.imageDownloadsInWaiting addObject:one];
			[one release];
			return;
		}
        IconDownLoader *iconDownloader = [[IconDownLoader alloc] init];
        iconDownloader.downloadURL = photoURL;
        iconDownloader.indexPathInTableView = indexPath;
		iconDownloader.imageType = CUSTOMER_PHOTO;
        iconDownloader.delegate = self;
        [self.imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
        [iconDownloader release];
    }
}

//回调 获到网络图片后的回调函数
- (void)appImageDidLoad:(NSIndexPath *)indexPath withImageType:(int)Type
{
    IconDownLoader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        // Display the newly loaded image
		if(iconDownloader.cardIcon.size.width>2.0)
		{
			//保存图片
            NSArray *ay = [self.subCates objectAtIndex:iconDownloader.indexPathInTableView.row];
            NSString *picName = [Common encodeBase64:(NSMutableData *)[[ay objectAtIndex:product_cat_pic] dataUsingEncoding: NSUTF8StringEncoding]];
            NSLog(@"picName:%@",picName);
            [FileManager savePhoto:picName withImage:iconDownloader.cardIcon];
            
            UIButton *button = (UIButton*)[self.cateScrollView viewWithTag:[[ay objectAtIndex:product_cat_id] intValue]];
            [button setBackgroundImage:iconDownloader.cardIcon forState:UIControlStateNormal];
		}
		
		[self.imageDownloadsInProgress removeObjectForKey:indexPath];
		if ([self.imageDownloadsInWaiting count]>0)
		{
			imageDownLoadInWaitingObject *one = [self.imageDownloadsInWaiting objectAtIndex:0];
			[self startIconDownload:one.imageURL forIndexPath:one.indexPath];
			[self.imageDownloadsInWaiting removeObjectAtIndex:0];
		}
    }
}

@end
