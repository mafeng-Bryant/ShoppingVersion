//
//  searchViewController.m
//  shopping
//
//  Created by lai yun on 13-1-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "searchViewController.h"
#import "Common.h"
#import "searchResultViewController.h"
#import "searchButton.h"

#define MAX_KEYWORDS_NUM 15

@interface searchViewController ()

@end

@implementation searchViewController

@synthesize spinner;
@synthesize searchBar;
@synthesize keywordItems;
@synthesize buttonsView;
@synthesize randomKeywordItems;
@synthesize clickedSearchButton;

-(id)init
{
	self = [super init];
	if(self)
	{
		//注册键盘通知
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(keyboardWillShow:) 
													 name:UIKeyboardWillShowNotification 
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(keyboardWillHide:) 
													 name:UIKeyboardWillHideNotification 
												   object:nil];		
	}
	
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


//取消searchbar背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BG_IMAGE]];
    
    currentWidth = 0.0f;
    currentHeight = 0.0f;
    
    //关键词数据初始化
	NSMutableArray *tempKeywordItems = [[NSMutableArray alloc] init];
	self.keywordItems = tempKeywordItems;
	[tempKeywordItems release];
    
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake( 0.0f , 0.0f , self.view.frame.size.width , 44.0f )];
    [self.view addSubview:searchBarView];
    [searchBarView release];
    
    //搜索bar
    self.searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0f , 0.0f , 250.0f , 44.0f)] autorelease];
    
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:self.searchBar.bounds.size];

    //self.searchBar.backgroundImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NAV_BG_PIC ofType:nil]];
//    for (UIView *subview in searchBar.subviews)
//    {  
//		if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
//		{  
//			[subview removeFromSuperview];  
//			break;  
//		}  
//	}
//    //ios7新特性--- 解决UISearchBar的背景色
//    if ([searchBar respondsToSelector:@selector(barTintColor)]) {
//        [searchBar setBarTintColor:[UIColor clearColor]];
//    }
    
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
    self.searchBar.delegate = self;
    [searchBarView addSubview:self.searchBar];

    //取消按钮
    UIImage *cancelImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"搜索取消按钮" ofType:@"png"]];
    
	UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
	cancelButton.frame = CGRectMake( CGRectGetMaxX(searchBar.frame) , 2.0f , 55.0f , 40.0f);
	[cancelButton addTarget:self action:@selector(backHome) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setBackgroundImage:cancelImage forState:UIControlStateNormal];
    [cancelButton setTitle:@"取 消" forState:UIControlStateNormal];
    cancelButton.titleLabel.textAlignment = UITextAlignmentCenter;
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:12];
	[searchBarView addSubview:cancelButton];
	[cancelImage release];
    
    //添加到navigationController
    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBarView]; 
    self.navigationItem.leftBarButtonItem = searchButtonItem;
    [searchButtonItem release];
    
    //添加loading图标
	UIActivityIndicatorView *tempSpinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
	[tempSpinner setCenter:CGPointMake(self.view.frame.size.width / 3, (self.view.frame.size.height ) / 2.0)];
	self.spinner = tempSpinner;
	UILabel *loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 100, 20)];
	loadingLabel.font = [UIFont systemFontOfSize:14];
	loadingLabel.textColor = [UIColor colorWithRed:0.5 green: 0.5 blue: 0.5 alpha:1.0];
	loadingLabel.text = LOADING_TIPS;		
	loadingLabel.textAlignment = UITextAlignmentCenter;
	loadingLabel.backgroundColor = [UIColor clearColor];
	[self.spinner addSubview:loadingLabel];
    [loadingLabel release];
	[self.view addSubview:self.spinner];
	[self.spinner startAnimating];
	[tempSpinner release];
    
    //摇一摇提示层
    UIView *shakeTipView = [[UIView alloc] initWithFrame:CGRectMake( 0.0f , 0.0f , self.view.frame.size.width , 70.0f )];
    shakeTipView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:shakeTipView];
    [shakeTipView release];
    
    UIImage *shakeTipImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"摇晃手机图片" ofType:@"png"]];
    UIImageView *shakeTipImageView = [[UIImageView alloc]initWithFrame:CGRectMake(60.0f , 20.0f , shakeTipImage.size.width , shakeTipImage.size.height)];
    shakeTipImageView.image = shakeTipImage;
    [shakeTipImage release];
    [shakeTipView addSubview:shakeTipImageView];
	[shakeTipImageView release];
    
    UILabel *shakeTipLabel = [[UILabel alloc]initWithFrame:CGRectMake( 100.0f , 18.0f , 160.0f , 40.0f )];
	shakeTipLabel.font = [UIFont systemFontOfSize:16];
	shakeTipLabel.textColor = [UIColor colorWithRed:0.6 green: 0.6 blue: 0.6 alpha:1.0];
	shakeTipLabel.text = @"试试看 摇晃您的手机";		
	shakeTipLabel.textAlignment = UITextAlignmentCenter;
	shakeTipLabel.backgroundColor = [UIColor clearColor];
	[shakeTipView addSubview:shakeTipLabel];
	[shakeTipLabel release];
    
    //按钮层
    UIView *tempButtonsView = [[UIView alloc] initWithFrame:CGRectMake( 0.0f , CGRectGetMaxY(shakeTipView.frame) , self.view.frame.size.width , self.view.frame.size.height - shakeTipView.frame.size.height - 44.0f)];
    tempButtonsView.backgroundColor = [UIColor clearColor];
    self.buttonsView = tempButtonsView;
    [self.view addSubview:self.buttonsView];
    [tempButtonsView release];
    
    //增加的遮盖图层
    UIImage *coverImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"上bar底部遮盖" ofType:@"png"]];
    UIImageView *coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f , 0.0f , coverImage.size.width , coverImage.size.height)];
    coverImageView.image = coverImage;
    [coverImage release];
    [self.view addSubview:coverImageView];
	[coverImageView release];
    
    //网络请求
    [self accessItemService];
    
}

-(void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
}

//设置支持第一相应 以支持摇一摇
-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
    
    //成为第一响应者 以支持摇一摇
    [self becomeFirstResponder];
    
    if (self.clickedSearchButton != nil)
    {
        isAnimate = YES;
        
        CGAffineTransform unscale = CGAffineTransformMakeScale(1.0f, 1.0f);
        [self.clickedSearchButton.titleLabel setAlpha:1.0f];
        [self.clickedSearchButton.titleLabel setFrame:self.clickedSearchButton.frame];
        [UIView animateWithDuration:0.3f animations:^{
            [self.clickedSearchButton setAlpha:1.0f];
            [self.clickedSearchButton setTransform:unscale];
        } completion:^(BOOL finished){
            
            isAnimate = NO;
            
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    //取消成为第一响应者
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

//返回
-(void)backHome
{
    [self.navigationController popViewControllerAnimated:YES];
}

//添加按钮
-(void)addSearchButton
{
    searchButton *sButton =[searchButton buttonWithType:UIButtonTypeCustom];
    [sButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [sButton setButtonTitle:[self randomKeyWords]];
    
    if ((currentWidth + sButton.frame.size.width) > (self.view.frame.size.width - 20.0f)) 
    {
        currentWidth = 0.0f;
        currentHeight = currentHeight + 40.0f + 10.0f;
    }
    
    [sButton setFrame:CGRectMake(currentWidth + 10.0f , currentHeight , sButton.frame.size.width , sButton.frame.size.height)];
    
    currentWidth = CGRectGetMaxX(sButton.frame);

    [self.buttonsView addSubview:sButton];
    
    CGAffineTransform scale = CGAffineTransformMakeScale(5.0f, 5.0f);
    CGAffineTransform unscale = CGAffineTransformMakeScale(1.0f, 1.0f);
    [sButton setTransform:scale];
    [sButton setAlpha:0.0f];
    [UIView animateWithDuration:0.15 animations:^{
        [sButton setAlpha:1.0f];
        [sButton setTransform:unscale];
    } completion:^(BOOL finished){
        
        if (([self.keywordItems count] - [self.randomKeywordItems count] < MAX_KEYWORDS_NUM) && [self.randomKeywordItems count] > 0) 
        {
            [self addSearchButton];
        }
        else 
        {
            isAnimate = NO;
        }
        
    }];
}

//按钮动画弹出效果
- (void)searchButtonClick:(id)sender
{
    searchButton *sButton = (searchButton*)sender;
    CGAffineTransform scale = CGAffineTransformMakeScale(5.0f, 5.0f);
    [sButton.titleLabel setAlpha:0.0f];
    [UIView animateWithDuration:0.3 animations:^{
        [sButton setAlpha:0.0f];
        [sButton setTransform:scale];
    } completion:^(BOOL finished){
        self.clickedSearchButton = sButton;
        searchResultViewController *searchResultView = [[searchResultViewController alloc] init];
        searchResultView.keyWord = sButton.titleLabel.text;
        [self.navigationController pushViewController:searchResultView animated:YES];
        [searchResultView release];
    }];
}

//随机获取关键词
- (NSString *)randomKeyWords
{
    NSString *keyWord = @"";
    if ([self.randomKeywordItems count] > 0)
    {
        int random = ([self.randomKeywordItems count] - 1) <= 0 ? 0 : arc4random()%([self.randomKeywordItems count] - 1);
        keyWord = [self.randomKeywordItems objectAtIndex:random];
        [self.randomKeywordItems removeObjectAtIndex:random];
    }
    return keyWord;
}

//更新记录
-(void)update
{
    //移出loading
    [self.spinner removeFromSuperview];
    
    if ([self.keywordItems count] > 0)
    {
        isAnimate = YES;
        self.randomKeywordItems = [[NSMutableArray alloc] initWithArray:self.keywordItems];
        [self addSearchButton];
    }
}

//网络获取
-(void)accessItemService
{
    NSString *reqUrl = @"keyword.do?param=%@";
	
	NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
								 [Common getSecureString],@"keyvalue",
								 [NSNumber numberWithInt: SITE_ID],@"site_id",
                                 nil];
	
	[[DataManager sharedManager] accessService:jsontestDic
									   command:OPERAT_KEYWORD_REFRESH 
								  accessAdress:reqUrl 
									  delegate:self
									 withParam:nil];
}

//网络请求回调函数
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver
{
    self.keywordItems = resultArray;
    [self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
}

#pragma mark -
#pragma mark 键盘通知调用
//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
	
    UIButton *backgroundButton = (UIButton *)[self.view viewWithTag:100];
    if (![backgroundButton isDescendantOfView:self.view]) 
    {
        //新增一个遮罩按钮
        UIButton *backgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backgroundButton.frame = CGRectMake( 0.0f , 0.0f, self.view.frame.size.width, self.view.frame.size.height - keyboardBounds.size.height);
        backgroundButton.tag = 100;
        [backgroundButton addTarget:self action:@selector(hiddenKeyboard) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backgroundButton];
	}
}

-(void) keyboardWillHide:(NSNotification *)note{
    
	//移出遮罩按钮
    UIButton *backgroundButton = (UIButton *)[self.view viewWithTag:100];
	[backgroundButton removeFromSuperview];
    
}

//关闭键盘
-(void)hiddenKeyboard
{
	[self.searchBar resignFirstResponder];
    
    //成为第一响应者 以支持摇一摇
    [self becomeFirstResponder];
}

//搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchContent = [self.searchBar.text stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
    searchContent = [self.searchBar.text stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    searchContent = [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([searchContent length] > 0)
    {
        searchResultViewController *searchResultView = [[searchResultViewController alloc] init];
        searchResultView.keyWord = searchContent;
        [self.navigationController pushViewController:searchResultView animated:YES];
        [searchResultView release];
    }
}

#pragma mark -
#pragma mark 摇一摇监测
- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent*)event {
	//if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake)
    if (motion == UIEventSubtypeMotionShake)
    {
        //重新随机
        if (!isAnimate) 
        {
            isAnimate = YES;
            currentWidth = 0.0f;
            currentHeight = 0.0f;
            [self.randomKeywordItems removeAllObjects];
            self.randomKeywordItems = [[NSMutableArray alloc] initWithArray:self.keywordItems];
            NSArray *viewsToRemove = [self.buttonsView subviews]; 
            for (UIView *v in viewsToRemove) 
            {
                [v removeFromSuperview];
            }
            //震动接口
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            
            [self addSearchButton];
        }
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.spinner = nil;
    self.searchBar = nil;
    self.keywordItems = nil;
    self.buttonsView = nil;
    self.randomKeywordItems = nil;
    self.clickedSearchButton = nil;
}

- (void)dealloc 
{
    self.spinner = nil;
    self.searchBar = nil;
    self.keywordItems = nil;
    self.buttonsView = nil;
    self.randomKeywordItems = nil;
    self.clickedSearchButton = nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
