//
//  newsCommentViewController.m
//  newsCommentView
//
//  Created by siphp on 13-01-05.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "newsCommentViewController.h"
#import "Common.h"
#import "DBOperate.h"
#import "UIImageScale.h"
#import "FileManager.h"
#import "downloadParam.h"
#import "imageDownLoadInWaitingObject.h"
#import "newsCommentCellViewController.h"
#import "newsDetailViewController.h"
#import "alertView.h"

@implementation newsCommentViewController

@synthesize myTableView;
@synthesize newsId;
@synthesize infoTitle;
@synthesize commentItems;
@synthesize spinner;
@synthesize moreLabel;
@synthesize _reloading;
@synthesize _loadingMore;
@synthesize imageDownloadsInProgress;
@synthesize imageDownloadsInWaiting;
@synthesize containerView;
@synthesize textView;
@synthesize progressHUD;
@synthesize tempTextContent;
@synthesize userId;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = self.infoTitle;
    
    NSMutableArray *tempCommentItems = [[NSMutableArray alloc] init];
	self.commentItems = tempCommentItems;
	[tempCommentItems release];
    
    NSMutableDictionary *idip = [[NSMutableDictionary alloc]init];
	self.imageDownloadsInProgress = idip;
	[idip release];
	
	NSMutableArray *wait = [[NSMutableArray alloc]init];
	self.imageDownloadsInWaiting = wait;
	[wait release];
    
    picWidth = 52.0f;
    picHeight = 52.0f;
    
    //增加的遮盖图层
    UIImage *coverImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"上bar底部遮盖" ofType:@"png"]];
    UIImageView *coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f , 0.0f , coverImage.size.width , coverImage.size.height)];
    coverImageView.image = coverImage;
    [coverImage release];
    [self.view addSubview:coverImageView];
	[coverImageView release];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    //获取当前用户的user_id
	NSMutableArray *memberArray = (NSMutableArray *)[DBOperate queryData:T_MEMBER_INFO theColumn:@"" theColumnValue:@"" withAll:YES];
	if ([memberArray count] > 0)
	{
		self.userId = [[memberArray objectAtIndex:0] objectAtIndex:member_info_memberId];
	}
	else
	{
		self.userId = @"0";
	}
    
    //添加loading图标
    UIActivityIndicatorView *tempSpinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
    [tempSpinner setCenter:CGPointMake(self.view.frame.size.width / 3, self.view.frame.size.height / 2.0)];
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
    
    //网络获取
    [self accessItemService];
    
}

//添加数据表视图
-(void)addTableView;
{
	//初始化tableView
    if ([self.myTableView isDescendantOfView:self.view]) 
    {
        [self.myTableView reloadData];
    }
    else
    {
        UITableView *tempTableView = [[UITableView alloc] initWithFrame:CGRectMake( 0.0f , 0.0f , self.view.frame.size.width , self.view.frame.size.height - 40.0f)];
        [tempTableView setDelegate:self];
        [tempTableView setDataSource:self];
        tempTableView.scrollsToTop = YES;
        self.myTableView = tempTableView;
        [tempTableView release];
        self.myTableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:myTableView];
        [self.view sendSubviewToBack:self.myTableView];
        [self.myTableView reloadData];
        
        //分割线
        //self.myTableView.separatorColor = [UIColor clearColor];
        
        //遮盖物离顶部距离
        UIImage *coverImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"上bar底部遮盖" ofType:@"png"]];
        UIView *topMarginView = [[UIView alloc] initWithFrame:CGRectMake(0.0f , 0.0f , self.view.frame.size.width , coverImage.size.height)];
        [coverImage release];
        self.myTableView.tableHeaderView = topMarginView;
        [topMarginView release];
        
        //下拉更新
        _refreshHeaderView = nil;
        _reloading = NO;
        _loadingMore = NO;
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.myTableView.bounds.size.height, self.view.frame.size.width, self.myTableView.bounds.size.height)];
        view.delegate = self;
        [self.myTableView addSubview:view];
        _refreshHeaderView = view;
        [view release];
        [_refreshHeaderView refreshLastUpdatedDate];
        
        //底部工具栏
        self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.myTableView.frame), self.view.frame.size.width, 40.0f)];
        self.textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, 308, 40)];
        self.textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
        self.textView.minNumberOfLines = 1;
        self.textView.maxNumberOfLines = 3;
        self.textView.returnKeyType = UIReturnKeyDefault; //just as an example
        self.textView.font = [UIFont systemFontOfSize:15.0f];
        self.textView.textColor = [UIColor grayColor];
        self.textView.delegate = self;
        self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        self.textView.backgroundColor = [UIColor whiteColor];
        self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.textView.text = @"评论";
        
        //工具栏背景
        UIImage *toolBackgroundImg = [[UIImage imageNamed:@"MessageEntryBackground.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:22];
        UIImageView *toolBackground = [[UIImageView alloc] initWithImage:toolBackgroundImg];
        toolBackground.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
        toolBackground.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        //文本框
        UIImage *rawEntryBackground = [[UIImage imageNamed:@"MessageEntryInputField.png"]  stretchableImageWithLeftCapWidth:13 topCapHeight:22];
        UIImageView *entryImageView = [[UIImageView alloc] initWithImage:rawEntryBackground];
        entryImageView.frame = CGRectMake(5, 0, 315, 40);
        entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        entryImageView.tag = 2000;
        
        [self.containerView addSubview:toolBackground];
        [self.containerView addSubview:self.textView];
        [self.containerView addSubview:entryImageView];
        
        //字数统计
        UILabel *remainCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(265.0f, 5.0f, 50.0f, 20.0f)];
        [remainCountLabel setFont:[UIFont systemFontOfSize:12.0f]];
        remainCountLabel.textColor = [UIColor colorWithRed:0.5 green: 0.5 blue: 0.5 alpha:1.0];
        remainCountLabel.tag = 2004;
        remainCountLabel.text = @"140/140";
        remainCountLabel.hidden = YES;
        remainCountLabel.backgroundColor = [UIColor clearColor];
        remainCountLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        remainCountLabel.textAlignment = UITextAlignmentCenter;
        [self.containerView addSubview:remainCountLabel];
        [remainCountLabel release];
        
        //添加发送按钮
        UIImage *sendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
        UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
        
        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sendBtn.frame = CGRectMake(self.containerView.frame.size.width - 55, 8, 50, 27);
        sendBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [sendBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
        sendBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
        sendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        sendBtn.tag = 2003;
        sendBtn.hidden = YES;
        [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sendBtn addTarget:self action:@selector(publishComment:) forControlEvents:UIControlEventTouchUpInside];
        [sendBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
        [sendBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
        [self.containerView addSubview:sendBtn];
        
        [self.view addSubview:self.containerView];
    }

}

//滚动loading图片
- (void)loadImagesForOnscreenRows
{
    NSArray *visiblePaths = [self.myTableView indexPathsForVisibleRows];
	for (NSIndexPath *indexPath in visiblePaths)
	{
		int countItems = [self.commentItems count];
		if (countItems >[indexPath row])
		{
            newsCommentCellViewController *newsCommentCell = (newsCommentCellViewController *)[self.myTableView cellForRowAtIndexPath:indexPath];
            
            NSArray *commentArray = [self.commentItems objectAtIndex:[indexPath row]];
			NSString *picUrl = [commentArray objectAtIndex:news_comment_head_img];
            NSString *picName = [Common encodeBase64:(NSMutableData *)[picUrl dataUsingEncoding: NSUTF8StringEncoding]];
            
            if (picUrl.length > 1) 
            {
                UIImage *pic = [[FileManager getPhoto:picName] fillSize:CGSizeMake(picWidth, picHeight)];
                if (pic.size.width > 2)
                {
                    newsCommentCell.picView.image = pic;
                }
                else
                {
                    UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"默认头像" ofType:@"png"]];
                    newsCommentCell.picView.image = [defaultPic fillSize:CGSizeMake(picWidth, picHeight)];
                    
                    if (self.myTableView.dragging == NO && self.myTableView.decelerating == NO)
                    {
                        [self startIconDownload:picUrl forIndexPath:indexPath];
                    }
                }
            }
            else
            {
                UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"默认头像" ofType:@"png"]];
                newsCommentCell.picView.image = [defaultPic fillSize:CGSizeMake(picWidth, picHeight)];
            }
			
		}
		
	}
}

//保存缓存图片
-(bool)savePhoto:(UIImage*)photo atIndexPath:(NSIndexPath*)indexPath
{
    int countItems = [self.commentItems count];
	
	if (countItems > [indexPath row]) 
	{
		NSArray *commentArray = [self.commentItems objectAtIndex:[indexPath row]];
        NSString *picUrl = [commentArray objectAtIndex:news_comment_head_img];
        NSString *picName = [Common encodeBase64:(NSMutableData *)[picUrl dataUsingEncoding: NSUTF8StringEncoding]];
        
		//保存缓存图片
		if([FileManager savePhoto:picName withImage:photo])
		{
			return YES;
		}
		else 
		{
			return NO;
		}
		
	}
	return NO;
}

//获取网络图片
- (void)startIconDownload:(NSString*)photoURL forIndexPath:(NSIndexPath*)indexPath
{
    IconDownLoader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil && photoURL != nil && photoURL.length > 1) 
    {
		if ([imageDownloadsInProgress count]>= 5) {
			imageDownLoadInWaitingObject *one = [[imageDownLoadInWaitingObject alloc]init:photoURL withIndexPath:indexPath withImageType:CUSTOMER_PHOTO];
			[imageDownloadsInWaiting addObject:one];
			[one release];
			return;
		}
        IconDownLoader *iconDownloader = [[IconDownLoader alloc] init];
        iconDownloader.downloadURL = photoURL;
        iconDownloader.indexPathInTableView = indexPath;
		iconDownloader.imageType = CUSTOMER_PHOTO;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
        [iconDownloader release];
    }
}

//回调 获到网络图片后的回调函数
- (void)appImageDidLoad:(NSIndexPath *)indexPath withImageType:(int)Type
{
    IconDownLoader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        newsCommentCellViewController *newsCommentCell = (newsCommentCellViewController *)[self.myTableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        
        // Display the newly loaded image
		if(iconDownloader.cardIcon.size.width>2.0)
		{ 
			//保存图片
			[self savePhoto:iconDownloader.cardIcon atIndexPath:indexPath];
			
			UIImage *pic = [iconDownloader.cardIcon fillSize:CGSizeMake(picWidth, picHeight)];
			newsCommentCell.picView.image = pic;
		}
		
		[imageDownloadsInProgress removeObjectForKey:indexPath];
		if ([imageDownloadsInWaiting count]>0) 
		{
			imageDownLoadInWaitingObject *one = [imageDownloadsInWaiting objectAtIndex:0];
			[self startIconDownload:one.imageURL forIndexPath:one.indexPath];
			[imageDownloadsInWaiting removeObjectAtIndex:0];
		}
		
    }
}

//更新记录
-(void)update
{
    //重新reload
    //[self.myTableView reloadData];
    [self addTableView];
    
    //回归常态
    [self backNormal];
    
}

//更多的操作
-(void)appendTableWith:(NSMutableArray *)data
{
    //合并数据
	if (data != nil && [data count] > 0) 
	{
		for (int i = 0; i < [data count];i++ ) 
		{
			NSArray *newsArray = [data objectAtIndex:i];
			[self.commentItems addObject:newsArray];
		}
		
		NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:[data count]];
		for (int ind = 0; ind < [data count]; ind++) 
		{
			NSIndexPath *newPath = [NSIndexPath indexPathForRow:[self.commentItems indexOfObject:[data objectAtIndex:ind]] inSection:0];
			[insertIndexPaths addObject:newPath];
		}
		[self.myTableView insertRowsAtIndexPaths:insertIndexPaths 
								withRowAnimation:UITableViewRowAnimationFade];
		
	}	
	
	[self moreBackNormal];
}


//网络获取数据
-(void)accessItemService
{
    NSString *reqUrl = @"comment/list.do?param=%@";
	
	NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
								 [Common getSecureString],@"keyvalue",
								 [NSNumber numberWithInt: SITE_ID],@"site_id",
                                 [NSNumber numberWithInt: self.newsId],@"id",
                                 [NSNumber numberWithInt: 1],@"type",
								 [NSNumber numberWithInt: 0],@"created",
								 nil];
	
	[[DataManager sharedManager] accessService:jsontestDic
									   command:OPERAT_NEWS_COMMENT_REFRESH
								  accessAdress:reqUrl 
									  delegate:self
									 withParam:nil];
}

//网络获取更多数据
-(void)accessMoreService
{
    NSString *reqUrl = @"comment/list.do?param=%@";
    
    NSArray *commentArray = [self.commentItems objectAtIndex:[self.commentItems count]-1];
    int created = [[commentArray objectAtIndex:news_comment_created] intValue];
	
	NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
								 [Common getSecureString],@"keyvalue",
								 [NSNumber numberWithInt: SITE_ID],@"site_id",
                                 [NSNumber numberWithInt: self.newsId],@"id",
                                 [NSNumber numberWithInt: 1],@"type",
								 [NSNumber numberWithInt: created],@"created",
								 nil];
	
	[[DataManager sharedManager] accessService:jsontestDic
									   command:OPERAT_NEWS_COMMENT_MORE
								  accessAdress:reqUrl
									  delegate:self
									 withParam:nil];

}

//回归常态
-(void)backNormal
{
    //移出loading
    [self.spinner removeFromSuperview];
    
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:NO];
}

//更多回归常态
-(void)moreBackNormal
{
    _loadingMore = NO;
    
	//loading图标移除
	if (self.spinner != nil) {
		[self.spinner stopAnimating];
	}
    
	if (self.moreLabel) {
        self.moreLabel.text = @"上拉加载更多";	
    }
	
}

//网络请求回调函数
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver
{
    switch(commandid)
    {
        //刷新
        case OPERAT_NEWS_COMMENT_REFRESH:
            self.commentItems = resultArray;
            [self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
            break;
            
        //更多
        case OPERAT_NEWS_COMMENT_MORE:
            [self performSelectorOnMainThread:@selector(appendTableWith:) withObject:resultArray waitUntilDone:NO];
            break;
            
        //评论
        case OPERAT_SEND_NEWS_COMMENT:
        {
            NSMutableArray* array = (NSMutableArray*)resultArray;
            int isSuccess = [[array objectAtIndex:0] intValue];
            
            if (isSuccess == 1 ) {
                if (self.progressHUD) {
                    self.progressHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-ok.png"]] autorelease];
                    self.progressHUD.mode = MBProgressHUDModeCustomView;
                    self.progressHUD.labelText = @"评论成功";
                }
            }else if(isSuccess == 0 ){
                if (self.progressHUD) {
                    self.progressHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示icon-信息.png"]] autorelease];
                    //self.progressHUD.mode = MBProgressHUDModeDeterminate;
                    self.progressHUD.mode = MBProgressHUDModeCustomView;
                    self.progressHUD.labelText = @"发送失败";
                }
            }
            
            [self performSelectorOnMainThread:@selector(commentSuccess:) withObject:resultArray waitUntilDone:NO];
        }
        
        default:   ;
    }
}

-(void)buttonChange:(BOOL)isKeyboardShow
{
	//判断软键盘显示
	if (isKeyboardShow)
	{
        UIButton *sendBtn = (UIButton *)[self.containerView viewWithTag:2003];
        
		//增长输入框
        if (sendBtn.hidden)
        {
            UIImageView *entryImageView = (UIImageView *)[self.containerView viewWithTag:2000];
            CGRect entryFrame = entryImageView.frame;
            entryFrame.size.width -= 60.0f;
            
            CGRect textFrame = self.textView.frame;
            textFrame.size.width -= 60.0f;
            
            entryImageView.frame = entryFrame;
            self.textView.frame = textFrame;
        }
        
		//显示字数统计
		UILabel *remainCountLabel = (UILabel *)[self.containerView viewWithTag:2004];
		remainCountLabel.hidden = NO;
		
		//显示发送按钮
		sendBtn.hidden = NO;
        
	}
	else
	{
		
		//隐藏字数统计
		UILabel *remainCountLabel = (UILabel *)[self.containerView viewWithTag:2004];
		remainCountLabel.hidden = YES;
		
		//隐藏发送按钮
		UIButton *sendBtn = (UIButton *)[self.containerView viewWithTag:2003];
		sendBtn.hidden = YES;
		
		//缩小输入框
		UIImageView *entryImageView = (UIImageView *)[self.containerView viewWithTag:2000];
		CGRect entryFrame = entryImageView.frame;
		entryFrame.size.width += 60.0f;
		
		CGRect textFrame = self.textView.frame;
		textFrame.size.width += 60.0f;
		
		entryImageView.frame = entryFrame;
		self.textView.frame = textFrame;
        
	}
    
}

//发表评论
-(void)publishComment:(id)sender
{
	NSString *content = self.textView.text;
	
	//把回车 转化成 空格
	content = [content stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
	content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
	
	if ([content length] > 0)
	{
		if ([content length] > 140)
		{
			[alertView showAlert:@"评论内容不能超过140个字符"];
		}
		else
		{
			MBProgressHUD *progressHUDTmp = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
			self.progressHUD = progressHUDTmp;
			[progressHUDTmp release];
			self.progressHUD.delegate = self;
			self.progressHUD.labelText = @"发送中... ";
			[self.view addSubview:self.progressHUD];
			[self.view bringSubviewToFront:self.progressHUD];
			[self.progressHUD show:YES];
			
			NSString *reqUrl = @"/member/comment.do?param=%@";
			
			NSDictionary *jsontestDic = [NSDictionary dictionaryWithObjectsAndKeys:
										 [Common getSecureString],@"keyvalue",
										 [NSNumber numberWithInt: SITE_ID],@"site_id",
										 self.userId,@"user_id",
										 [NSNumber numberWithInt: 1],@"type",
										 [NSNumber numberWithInt: self.newsId],@"info_id",
										 content,@"content",
										 nil];
			
			[[DataManager sharedManager] accessService:jsontestDic
											   command:OPERAT_SEND_NEWS_COMMENT
										  accessAdress:reqUrl
											  delegate:self
											 withParam:nil];
			
			[self.textView resignFirstResponder];
            
		}
	}
	else
	{
		//[alertView showAlert:@"请输入留言内容"];
		[self.textView resignFirstResponder];
	}
}

//编辑中
-(void)doEditing
{
	UILabel *remainCountLabel = (UILabel *)[self.containerView viewWithTag:2004];
	int textCount = [self.textView.text length];
	if (textCount > 140)
    {
		remainCountLabel.textColor = [UIColor colorWithRed:1.0 green: 0.0 blue: 0.0 alpha:1.0];
	}
    else
    {
		remainCountLabel.textColor = [UIColor colorWithRed:0.5 green: 0.5 blue: 0.5 alpha:1.0];
	}
	
	remainCountLabel.text = [NSString stringWithFormat:@"%d/140",140 - [self.textView.text length]];
}

//关闭键盘
-(void)hiddenKeyboard
{
    //输入内容 存起来
	self.tempTextContent = self.textView.text;
    self.textView.text = @"评论";
	self.textView.textColor = [UIColor grayColor];
	[self.textView resignFirstResponder];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

//评论成功
- (void)commentSuccess:(NSMutableArray *)resultArray
{
	self.tempTextContent = @"";
    self.textView.text = @"评论";
    self.textView.textColor = [UIColor grayColor];
	if (self.progressHUD) {
		[progressHUD hide:YES afterDelay:1.0f];
	}
    
    [self performSelector:@selector(ViewFrashData) withObject:nil afterDelay:NO];
}

//模拟下拉动作
-(void) ViewFrashData{
    [myTableView setContentOffset:CGPointMake(0, -70) animated:NO];
    [self performSelector:@selector(doneManualRefresh) withObject:nil afterDelay:0.0];
}

//触发更新
-(void)doneManualRefresh{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:myTableView];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:myTableView];
}

#pragma mark -
#pragma mark progressHUD委托
//在该函数 [progressHUD hide:YES afterDelay:1.0f] 执行后回调

- (void)hudWasHidden:(MBProgressHUD *)hud{
	
	if (self.progressHUD) {
		[self.progressHUD removeFromSuperview];
		self.progressHUD = nil;
	}
	
}

#pragma mark -
#pragma mark 键盘通知调用
//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
	
	//新增一个遮罩按钮
    UIButton *bgBtn = (UIButton *)[self.view viewWithTag:2005];
    if (bgBtn != nil) {
        [bgBtn removeFromSuperview];
    }  //解决评论后不能拖动的问题
	UIButton *backGrougBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	backGrougBtn.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - (keyboardBounds.size.height + containerFrame.size.height));
	backGrougBtn.tag = 2005;
	[backGrougBtn addTarget:self action:@selector(hiddenKeyboard) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:backGrougBtn];
	
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	containerView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
	
	//更改按钮状态
	[self buttonChange:YES];
	
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	containerView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
    
	//移出遮罩按钮
	UIButton *backGrougBtn = (UIButton *)[self.view viewWithTag:2005];
	[backGrougBtn removeFromSuperview];
	
	//更改按钮状态
	[self buttonChange:NO];
}

#pragma mark -
#pragma mark HPGrowingTextView 委托
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
	
	CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	containerView.frame = r;
}

- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView
{
	//判断用户是否登陆
	if (_isLogin == YES)
	{
		if ([self.userId intValue] != 0)
		{
			return YES;
		}
		else
		{
			LoginViewController *login = [[LoginViewController alloc] init];
            login.delegate = self;
			[self.navigationController pushViewController:login animated:YES];
			[login release];
			return NO;
		}
        
	}
	else
	{
		LoginViewController *login = [[LoginViewController alloc] init];
        login.delegate = self;
		[self.navigationController pushViewController:login animated:YES];
		[login release];
		return NO;
	}
    
}

- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView
{
	if([growingTextView.text isEqualToString:@"评论"])
	{
        //内容设置回来
		growingTextView.text = self.tempTextContent;
	}
	growingTextView.textColor = [UIColor blackColor];
	
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	[self performSelectorOnMainThread:@selector(doEditing) withObject:nil waitUntilDone:NO];
	return YES;
}

#pragma mark -
#pragma mark 登录接口回调
- (void)loginWithResult:(BOOL)isLoginSuccess{
    
	if (isLoginSuccess)
    {
        //获取当前用户的user_id
        NSMutableArray *memberArray = (NSMutableArray *)[DBOperate queryData:T_MEMBER_INFO theColumn:@"" theColumnValue:@"" withAll:YES];
        if ([memberArray count] > 0)
        {
            self.userId = [[memberArray objectAtIndex:0] objectAtIndex:member_info_memberId];
        }
        else
        {
            self.userId = @"0";
        }
        
		//评论操作，调用评论接口
        [self.textView becomeFirstResponder];
        
	}
//    else
//    {
//		[alertView showAlert:@"登录失败，请重试！"];
//	}
    
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.commentItems count] >= 20)
    {
        return [self.commentItems count] + 1;
    }
    else
    {
        if ([self.commentItems count] == 0)
        {
            return 1;
        }
        else
        {
            return [self.commentItems count];
        }
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.commentItems != nil && [self.commentItems count] > 0)
    {
        if ([indexPath row] == [self.commentItems count])
        {
            //更多
            return 50.0f;
        }
        else 
        {
            //记录
            CGSize constraint = CGSizeMake(250.0f, 20000.0f);
            CGSize size = [[[self.commentItems objectAtIndex:[indexPath row]] objectAtIndex:news_comment_content] sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            float fixHeight = size.height;
            int height = fixHeight == 0 ? 70.f : MAX(70.0f,fixHeight + 40);
            
            return height;
        }
    }
    else
    {
        //没有记录
        return 50.0f;
    }
	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"";
	UITableViewCell *cell;
	
    //ios7新特性,解决分割线短一点
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
	int commentItemsCount =  [self.commentItems count];
    int cellType;
    if (self.commentItems != nil && commentItemsCount > 0)
    {
        if ([indexPath row] == commentItemsCount)
        {
            //更多
            CellIdentifier = @"moreCell";
            cellType = 1;
        }
        else 
        {
            //记录
            CellIdentifier = @"listCell";
            cellType = 2;
        }
    }
    else
    {
        //没有记录
        CellIdentifier = @"noneCell";
        cellType = 0;
    }
	
	cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) 
	{
        switch(cellType)
		{
            //没有记录
			case 0:
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                self.myTableView.separatorColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UILabel *noneLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 300, 30)];
				noneLabel.tag = 101;
				[noneLabel setFont:[UIFont systemFontOfSize:12.0f]];
				noneLabel.textColor = [UIColor colorWithRed:0.3 green: 0.3 blue: 0.3 alpha:1.0];
				noneLabel.text = @"还没有人说什么哦，赶紧抢先第一个发言吧!";			
				noneLabel.textAlignment = UITextAlignmentCenter;
				noneLabel.backgroundColor = [UIColor clearColor];
				[cell.contentView addSubview:noneLabel];
				[noneLabel release];
                
                break;
            }
            //更多
			case 1:
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                self.myTableView.separatorColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UILabel *tempMoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, 10, 120, 30)];
                tempMoreLabel.tag = 200;
                [tempMoreLabel setFont:[UIFont systemFontOfSize:14.0f]];
				tempMoreLabel.textColor = [UIColor colorWithRed:0.3 green: 0.3 blue: 0.3 alpha:1.0];
                tempMoreLabel.text = @"上拉加载更多";			
                tempMoreLabel.textAlignment = UITextAlignmentCenter;
                tempMoreLabel.backgroundColor = [UIColor clearColor];
                self.moreLabel = tempMoreLabel;
                [tempMoreLabel release];
                [cell.contentView addSubview:self.moreLabel];
                cell.tag = 201;
                break;
            }
            //记录
			case 2:
            {
                cell = [[[newsCommentCellViewController alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                
                break;
            }
				
			default:   ;
		}
        
        cell.backgroundColor = [UIColor clearColor];
	}
	
	if (cellType == 2)
    {
        //数据填充
        NSArray *commentArray = [self.commentItems objectAtIndex:[indexPath row]];
        
        newsCommentCellViewController *newsCommentCell = (newsCommentCellViewController *)cell;
        
        //用户名
        newsCommentCell.usernameLabel.text = [commentArray objectAtIndex:news_comment_user_name];
        
        //时间
        int createTime = [[commentArray objectAtIndex:news_comment_created] intValue];
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:createTime];
        NSDateFormatter *outputFormat = [[NSDateFormatter alloc] init];
        [outputFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *dateString = [outputFormat stringFromDate:date];
        [outputFormat release];
        newsCommentCell.createdLabel.text = [NSString stringWithFormat:@"%@ 发表",dateString];
        
        //内容
        newsCommentCell.contentLabel.text = [commentArray objectAtIndex:news_comment_content];
        CGSize constraint = CGSizeMake(250.0f, 20000.0f);
        CGSize size = [newsCommentCell.contentLabel.text sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        newsCommentCell.contentLabel.frame = CGRectMake(CGRectGetMaxX(newsCommentCell.picView.frame) + 10, CGRectGetMaxY(newsCommentCell.usernameLabel.frame), 250, size.height);
        
        //图片
        NSString *picUrl = [commentArray objectAtIndex:news_comment_head_img];
        NSString *picName = [Common encodeBase64:(NSMutableData *)[picUrl dataUsingEncoding: NSUTF8StringEncoding]];
        
        if (picUrl.length > 1) 
        {
            UIImage *pic = [[FileManager getPhoto:picName] fillSize:CGSizeMake(picWidth, picHeight)];
            if (pic.size.width > 2)
            {
                newsCommentCell.picView.image = pic;
            }
            else
            {
                UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"默认头像" ofType:@"png"]];
                newsCommentCell.picView.image = [defaultPic fillSize:CGSizeMake(picWidth, picHeight)];
                
				if (tableView.dragging == NO && tableView.decelerating == NO)
				{
					[self startIconDownload:picUrl forIndexPath:indexPath];
				}
            }
        }
        else
        {
            UIImage *defaultPic = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"默认头像" ofType:@"png"]];
            newsCommentCell.picView.image = [defaultPic fillSize:CGSizeMake(picWidth, picHeight)];
        }
        
        return newsCommentCell;
        
	}
    
    return cell; 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	//do nothing...
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
    
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
    if (_isAllowLoadingMore && !_loadingMore && [self.commentItems count] > 0)
    {
        float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (bottomEdge > scrollView.contentSize.height + 10.0f) 
        {
            //松开 载入更多
            self.moreLabel.text=@"松开加载更多";
            
        }
        else
        {
            self.moreLabel.text=@"上拉加载更多";
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	//[super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    if (!decelerate)
	{
		[self loadImagesForOnscreenRows];
    }
    
    if (_isAllowLoadingMore && !_loadingMore)
    {
        float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (bottomEdge > scrollView.contentSize.height + 10.0f) 
        {
            //松开 载入更多
            _loadingMore = YES;
            
            self.moreLabel.text=@" 加载中 ...";
            
            UITableViewCell *cell = (UITableViewCell *)[self.myTableView viewWithTag:201];
            
            //添加loading图标
            UIActivityIndicatorView *tempSpinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
            [tempSpinner setCenter:CGPointMake(cell.frame.size.width / 3, cell.frame.size.height / 2.0)];
            self.spinner = tempSpinner;
            [cell.contentView addSubview:self.spinner];
            [self.spinner startAnimating];
            [tempSpinner release];
            
            //数据
            [self accessMoreService];
        }
        else
        {
            self.moreLabel.text=@"上拉加载更多";
        }
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (bottomEdge >= scrollView.contentSize.height && bottomEdge > self.myTableView.frame.size.height && [self.commentItems count] >= 20)
    {
        _isAllowLoadingMore = YES;
    }
    else 
    {
        _isAllowLoadingMore = NO;
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTableView];
    
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
    
    //网络获取
    [self accessItemService];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
	self.myTableView.delegate = nil;
	self.myTableView = nil;
    self.infoTitle = nil;
    self.commentItems = nil;
	self.spinner = nil;
    self.moreLabel = nil;
    _refreshHeaderView.delegate = nil;
	_refreshHeaderView = nil;
    for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
	self.imageDownloadsInProgress = nil;
	self.imageDownloadsInWaiting = nil;
    self.containerView = nil;
	self.textView.delegate = nil;
	self.textView = nil;
    self.progressHUD.delegate = nil;
	self.progressHUD = nil;
    self.tempTextContent = nil;
    self.userId = nil;
}


- (void)dealloc {
	self.myTableView.delegate = nil;
	self.myTableView = nil;
    [self.infoTitle release];
    self.commentItems = nil;
	self.spinner = nil;
    self.moreLabel = nil;
    _refreshHeaderView.delegate = nil;
	_refreshHeaderView = nil;
    for (IconDownLoader *one in [imageDownloadsInProgress allValues]){
		one.delegate = nil;
	}
	self.imageDownloadsInProgress = nil;
	self.imageDownloadsInWaiting = nil;
    self.containerView = nil;
	self.textView.delegate = nil;
	self.textView = nil;
    self.progressHUD.delegate = nil;
	self.progressHUD = nil;
    self.tempTextContent = nil;
    self.userId = nil;
    [super dealloc];
}

@end
