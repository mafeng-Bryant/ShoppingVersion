//
//  scanViewController.m
//  myBarCode
//
//  Created by lai yun on 13-1-18.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "scanViewController.h"
#import "scanResultViewController.h"
#import <QRCodeReader.h>
#import "scanHistoryViewController.h"

@interface scanViewController ()

@end

@implementation scanViewController

@synthesize loadingImageView;
@synthesize widController;

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
    self.view.backgroundColor = [UIColor blackColor];
    
    CGFloat fixHeight = 0.0f;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        fixHeight = self.view.frame.size.height < 548 ? -44.0f : 20.0f;
    }else{
        fixHeight = self.view.frame.size.height < 548 ? -44.0f : 0.0f;
    }
    
    UIImage *loadingImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"云拍启动" ofType:@"png"]];
    UIImageView *tempLoadingImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f , fixHeight , loadingImage.size.width , loadingImage.size.height)];
    tempLoadingImageView.image = loadingImage;
    [loadingImage release];
    self.loadingImageView = tempLoadingImageView;
    [self.view addSubview:self.loadingImageView];
    [tempLoadingImageView release];
    
}

-(void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    self.loadingImageView.hidden = NO;
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    ZXingWidgetController *tempWidController = [[ZXingWidgetController alloc] initWithDelegate:self OneDMode:NO];  
    QRCodeReader *qrcodeReader = [[QRCodeReader alloc] init];  
    NSSet *readers = [[NSSet alloc ] initWithObjects:qrcodeReader,nil];  
    [qrcodeReader release];  
    tempWidController.readers = readers;  
    [readers release];  
    NSBundle *mainBundle = [NSBundle mainBundle];  
    //aiff  
    tempWidController.soundToPlay =[NSURL fileURLWithPath:[mainBundle pathForResource:@"beep-beep" ofType:@"aiff"] isDirectory:NO];  
    self.widController = tempWidController;
    //[self presentModalViewController:self.widController animated:NO];
    [self.view addSubview:self.widController.view];
    [tempWidController release];

}

-(void) viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController.navigationBar setTranslucent:NO];
}

#pragma mark -
#pragma mark 扫描委托

//摄像头启动后事件 
- (void)zxingControllerDidStartRunning:(ZXingWidgetController*)controller {
    
    self.loadingImageView.hidden = YES;
    
    //loading 开场动画
    CGRect topLoadingFrame = controller.overlayView.topLoadingImageView.frame;
    CGRect bottomeLoadingFrame = controller.overlayView.bottomLoadingImageView.frame;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationCurveLinear
                     animations:^{
                         
                         controller.overlayView.topLoadingImageView.frame = CGRectMake(0.0f , controller.overlayView.topLoadingImageView.frame.origin.y - controller.overlayView.topLoadingImageView.frame.size.height , controller.overlayView.topLoadingImageView.frame.size.width , controller.overlayView.topLoadingImageView.frame.size.height);
                         
                         controller.overlayView.bottomLoadingImageView.frame = CGRectMake(0.0f , controller.overlayView.bottomLoadingImageView.frame.origin.y + controller.overlayView.bottomLoadingImageView.frame.size.height , controller.overlayView.bottomLoadingImageView.frame.size.width , controller.overlayView.bottomLoadingImageView.frame.size.height);
                         
                         
                     } completion:^(BOOL finished){
                         controller.overlayView.topLoadingImageView.hidden = YES;
                         controller.overlayView.bottomLoadingImageView.hidden = YES;
                         controller.overlayView.topLoadingImageView.frame = topLoadingFrame;
                         controller.overlayView.bottomLoadingImageView.frame = bottomeLoadingFrame;
                     }
     ];
    
}

//正常扫描退出事件  
- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result {
    
    //[self dismissModalViewControllerAnimated:NO];
    
    scanResultViewController *scanResultView = [[scanResultViewController alloc] init];;
    scanResultView.resultString = result;
    scanResultView.dataFromScan = YES;
    [self.navigationController pushViewController:scanResultView animated:YES];
    [scanResultView release];
    
}  
//扫描界面退出按钮事件  
- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller {  
    
    //[self dismissModalViewControllerAnimated:NO];
    [self.navigationController popViewControllerAnimated:YES];
    
}

//扫描界面历史记录按钮事件  
- (void)zxingControllerGoHistory:(ZXingWidgetController*)controller {  
    
    scanHistoryViewController *scanHistoryView = [[scanHistoryViewController alloc] init];
    [self.navigationController pushViewController:scanHistoryView animated:YES];
    [scanHistoryView release];
    
}

- (void)goHome
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark 当前view的截屏
- (UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.loadingImageView = nil;
    self.widController = nil;
}

- (void)dealloc {
	[self.loadingImageView release];
    [self.widController release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return NO;
}

@end
