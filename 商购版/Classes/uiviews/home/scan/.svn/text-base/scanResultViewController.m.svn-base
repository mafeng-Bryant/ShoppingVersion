//
//  scanResultViewController.m
//  myBarCode
//
//  Created by lai yun on 13-1-18.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "scanResultViewController.h"
#import <UniversalResultParser.h>
#import <ParsedResult.h>
#import <ResultAction.h>
#import "AddContactAction.h"
#import "CallAction.h"
#import "EmailAction.h"
#import "OpenUrlAction.h"
#import "ShowMapAction.h"
#import "SMSAction.h"
#import "DBOperate.h"

@interface scanResultViewController ()

@end

@implementation scanResultViewController

@synthesize resultString;
@synthesize dataFromScan;
@synthesize result;
@synthesize contentView;
@synthesize contentScrollView;
@synthesize typeString;
@synthesize info;

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
    self.view.backgroundColor = [UIColor clearColor];
    self.title = @"扫描结果";
    
    //初始化数据
    self.result = [UniversalResultParser parsedResultForString:self.resultString];
    self.typeString = @"";
    self.info = @"";
    
    //返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];  
    backButton.frame = CGRectMake(0.0f, 0.0f, 40.0f, 40.0f);
    [backButton addTarget:self action:@selector(backHome) forControlEvents:UIControlEventTouchDown];
    [backButton setBackgroundImage:[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"返回按钮" ofType:@"png"]] forState:UIControlStateNormal];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton]; 
    self.navigationItem.leftBarButtonItem = backItem;
    
    
    //取消按钮
//    UIImage *cancelImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"云拍取消按钮" ofType:@"png"]];
//	UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//	cancelButton.frame = CGRectMake( 0.0f , 0.0f , 55.0f , 40.0f);
//	[cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
//    [cancelButton setBackgroundImage:cancelImage forState:UIControlStateNormal];
//    [cancelImage release];
//    [cancelButton setTitle:@"取 消" forState:UIControlStateNormal];
//    cancelButton.titleLabel.textAlignment = UITextAlignmentCenter;
//    cancelButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
//    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton]; 
//    self.navigationItem.rightBarButtonItem = cancelItem;
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取 消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = cancelItem;
    [cancelItem release];
    
    //背景
    UIImage *backgroundImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"云拍背景" ofType:@"png"]];
    UIImageView *backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f , 0.0f , backgroundImage.size.width , backgroundImage.size.height)];
    backgroundImageView.image = backgroundImage;
    [backgroundImage release];
    [self.view addSubview:backgroundImageView];
	[backgroundImageView release];
    
    //主体
    UIScrollView *tmpScroll = [[UIScrollView alloc] initWithFrame:CGRectMake( 0.0f , 0.0f , self.view.frame.size.width, self.view.frame.size.height - 44.0f)];
    tmpScroll.contentSize = CGSizeMake(self.view.frame.size.width, tmpScroll.frame.size.height);
    tmpScroll.pagingEnabled = NO;
    tmpScroll.showsHorizontalScrollIndicator = NO;
    tmpScroll.showsVerticalScrollIndicator = NO;
    tmpScroll.backgroundColor = [UIColor clearColor];
    self.contentScrollView = tmpScroll;
    [tmpScroll release];
    [self.view addSubview:self.contentScrollView];
    
    //内容
    UIView *tempContentView = [[UIView alloc] initWithFrame:CGRectMake(10.0f , 10.0f , 300.0f , 140.0f)];
    tempContentView.layer.masksToBounds = YES;
    tempContentView.layer.cornerRadius = 5;
    tempContentView.backgroundColor = [UIColor clearColor];
    self.contentView = tempContentView;
    [self.contentScrollView addSubview:self.contentView];
    [tempContentView release];
    
    //标题背景
    UIImage *titleImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"云拍扫描结果标题背景" ofType:@"png"]];
    UIImageView *titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f , 0.0f , titleImage.size.width , titleImage.size.height)];
    titleImageView.image = titleImage;
    [titleImage release];
    [self.contentView addSubview:titleImageView];
	[titleImageView release];
    
    //content 背景
    UIImage *contentBackgroundImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"云拍扫描结果背景" ofType:@"png"]];
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:contentBackgroundImage];
    [contentBackgroundImage release];
    
    CGFloat lineHeight = 40.0f;
    CGFloat fixHeight = titleImageView.frame.size.height;
    BOOL isOperate = NO;
    
    //判断扫描的结果是否有操作
    if ([result.actions count] > 0)
    {
        //判断是哪种类型
        ResultAction *resultActions = [[result actions] objectAtIndex:0];
        if ([resultActions isMemberOfClass:[AddContactAction class]])
        {
            self.typeString = @"名片";
            
            //标题
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake( 0.0f , 0.0f , titleImageView.frame.size.width, titleImageView.frame.size.height)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
            titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0f];
            titleLabel.textColor = [UIColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1];
            titleLabel.text = self.typeString;
            titleLabel.textAlignment = UITextAlignmentCenter;
            [self.contentView addSubview:titleLabel];
            [titleLabel release];
            
            //结果类型转换
            AddContactAction *contactAction = [[result actions] objectAtIndex:0];
            
            //姓名
            NSString *name = contactAction.name;
            self.info = name;
            if (name.length > 0)
            {
                isOperate = YES;
                
                //顶部线
                UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f , fixHeight , self.contentView.frame.size.width, 1)];
                topLineView.backgroundColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1];
                [self.contentView addSubview:topLineView];
                [topLineView release];
                
                UILabel *nameTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake( 0.0f , fixHeight , 60.0f, lineHeight)];
                nameTitleLabel.backgroundColor = [UIColor clearColor];
                nameTitleLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
                nameTitleLabel.font = [UIFont systemFontOfSize:14.0f];
                nameTitleLabel.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1];
                nameTitleLabel.text = @"姓名";
                nameTitleLabel.textAlignment = UITextAlignmentCenter;
                [self.contentView addSubview:nameTitleLabel];
                [nameTitleLabel release];
                
                UILabel *nameInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake( 80.0f , fixHeight , self.contentView.frame.size.width - 90.0f, lineHeight)];
                nameInfoLabel.backgroundColor = [UIColor clearColor];
                nameInfoLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
                nameInfoLabel.font = [UIFont systemFontOfSize:14.0f];
                nameInfoLabel.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1];
                nameInfoLabel.text = name;
                nameInfoLabel.textAlignment = UITextAlignmentLeft;
                [self.contentView addSubview:nameInfoLabel];
                [nameInfoLabel release];
                
                //增加高度
                fixHeight = fixHeight + lineHeight;
            }
            
            //职业
            NSString *job = contactAction.jobTitle;
            if (job.length > 0)
            {
                isOperate = YES;
                
                //顶部线
                UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f , fixHeight , self.contentView.frame.size.width, 1)];
                topLineView.backgroundColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1];
                [self.contentView addSubview:topLineView];
                [topLineView release];
                
                UILabel *jobTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake( 0.0f , fixHeight , 60.0f, lineHeight)];
                jobTitleLabel.backgroundColor = [UIColor clearColor];
                jobTitleLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
                jobTitleLabel.font = [UIFont systemFontOfSize:14.0f];
                jobTitleLabel.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1];
                jobTitleLabel.text = @"职位";
                jobTitleLabel.textAlignment = UITextAlignmentCenter;
                [self.contentView addSubview:jobTitleLabel];
                [jobTitleLabel release];
                
                UILabel *InfoLabel = [[UILabel alloc]initWithFrame:CGRectMake( 80.0f , fixHeight , self.contentView.frame.size.width - 90.0f, lineHeight)];
                InfoLabel.backgroundColor = [UIColor clearColor];
                InfoLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
                InfoLabel.font = [UIFont systemFontOfSize:14.0f];
                InfoLabel.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1];
                InfoLabel.text = job;
                InfoLabel.textAlignment = UITextAlignmentLeft;
                [self.contentView addSubview:InfoLabel];
                [InfoLabel release];
                
                //增加高度
                fixHeight = fixHeight + lineHeight;
            }
            
            //电话
            NSArray *phoneArray = contactAction.phoneNumbers;
            for (NSString *phone in phoneArray) 
            {
                if (phone.length > 0)
                {
                    isOperate = YES;
                    
                    //顶部线
                    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f , fixHeight , self.contentView.frame.size.width, 1)];
                    topLineView.backgroundColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1];
                    [self.contentView addSubview:topLineView];
                    [topLineView release];
                    
                    UILabel *phoneTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake( 0.0f , fixHeight , 60.0f, lineHeight)];
                    phoneTitleLabel.backgroundColor = [UIColor clearColor];
                    phoneTitleLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
                    phoneTitleLabel.font = [UIFont systemFontOfSize:14.0f];
                    phoneTitleLabel.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1];
                    phoneTitleLabel.text = @"电话";
                    phoneTitleLabel.textAlignment = UITextAlignmentCenter;
                    [self.contentView addSubview:phoneTitleLabel];
                    [phoneTitleLabel release];
                    
                    UILabel *phoneInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake( 80.0f , fixHeight , self.contentView.frame.size.width - 90.0f, lineHeight)];
                    phoneInfoLabel.backgroundColor = [UIColor clearColor];
                    phoneInfoLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
                    phoneInfoLabel.font = [UIFont systemFontOfSize:14.0f];
                    phoneInfoLabel.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1];
                    phoneInfoLabel.text = phone;
                    phoneInfoLabel.textAlignment = UITextAlignmentLeft;
                    [self.contentView addSubview:phoneInfoLabel];
                    [phoneInfoLabel release];
                    
                    //增加高度
                    fixHeight = fixHeight + lineHeight;
                }
            }
            
            //邮箱
            NSString *email = contactAction.email;
            if (email.length > 0)
            {
                isOperate = YES;
                
                //顶部线
                UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f , fixHeight , self.contentView.frame.size.width, 1)];
                topLineView.backgroundColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1];
                [self.contentView addSubview:topLineView];
                [topLineView release];
                
                UILabel *emailTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake( 0.0f , fixHeight , 60.0f, lineHeight)];
                emailTitleLabel.backgroundColor = [UIColor clearColor];
                emailTitleLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
                emailTitleLabel.font = [UIFont systemFontOfSize:14.0f];
                emailTitleLabel.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1];
                emailTitleLabel.text = @"邮箱";
                emailTitleLabel.textAlignment = UITextAlignmentCenter;
                [self.contentView addSubview:emailTitleLabel];
                [emailTitleLabel release];
                
                UILabel *emailInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake( 80.0f , fixHeight , self.contentView.frame.size.width - 90.0f, lineHeight)];
                emailInfoLabel.backgroundColor = [UIColor clearColor];
                emailInfoLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
                emailInfoLabel.font = [UIFont systemFontOfSize:14.0f];
                emailInfoLabel.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1];
                emailInfoLabel.text = email;
                emailInfoLabel.textAlignment = UITextAlignmentLeft;
                [self.contentView addSubview:emailInfoLabel];
                [emailInfoLabel release];
                
                //增加高度
                fixHeight = fixHeight + lineHeight;
            }
            
            //网址
            NSString *url = contactAction.urlString;
            if (url.length > 0)
            {
                isOperate = YES;
                
                //顶部线
                UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f , fixHeight , self.contentView.frame.size.width, 1)];
                topLineView.backgroundColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1];
                [self.contentView addSubview:topLineView];
                [topLineView release];
                
                UILabel *urlTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake( 0.0f , fixHeight , 60.0f, lineHeight)];
                urlTitleLabel.backgroundColor = [UIColor clearColor];
                urlTitleLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
                urlTitleLabel.font = [UIFont systemFontOfSize:14.0f];
                urlTitleLabel.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1];
                urlTitleLabel.text = @"网址";
                urlTitleLabel.textAlignment = UITextAlignmentCenter;
                [self.contentView addSubview:urlTitleLabel];
                [urlTitleLabel release];
                
                UILabel *urlInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake( 80.0f , fixHeight , self.contentView.frame.size.width - 90.0f, lineHeight)];
                urlInfoLabel.backgroundColor = [UIColor clearColor];
                urlInfoLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
                urlInfoLabel.font = [UIFont systemFontOfSize:14.0f];
                urlInfoLabel.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1];
                urlInfoLabel.text = url;
                urlInfoLabel.textAlignment = UITextAlignmentLeft;
                [self.contentView addSubview:urlInfoLabel];
                [urlInfoLabel release];
                
                //增加高度
                fixHeight = fixHeight + lineHeight;
            }
            
            //备忘录
            NSString *note = contactAction.note;
            if (note.length > 0)
            {
                isOperate = YES;
                
                //顶部线
                UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f , fixHeight , self.contentView.frame.size.width, 1)];
                topLineView.backgroundColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1];
                [self.contentView addSubview:topLineView];
                [topLineView release];
                
                UILabel *noteTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake( 0.0f , fixHeight , 60.0f, lineHeight)];
                noteTitleLabel.backgroundColor = [UIColor clearColor];
                noteTitleLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
                noteTitleLabel.font = [UIFont systemFontOfSize:14.0f];
                noteTitleLabel.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1];
                noteTitleLabel.text = @"备忘录";
                noteTitleLabel.textAlignment = UITextAlignmentCenter;
                [self.contentView addSubview:noteTitleLabel];
                [noteTitleLabel release];
                
                UILabel *noteInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake( 80.0f , fixHeight , self.contentView.frame.size.width - 90.0f, lineHeight)];
                noteInfoLabel.backgroundColor = [UIColor clearColor];
                noteInfoLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
                noteInfoLabel.font = [UIFont systemFontOfSize:14.0f];
                noteInfoLabel.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1];
                noteInfoLabel.text = note;
                noteInfoLabel.textAlignment = UITextAlignmentLeft;
                [self.contentView addSubview:noteInfoLabel];
                [noteInfoLabel release];
                
                //增加高度
                fixHeight = fixHeight + lineHeight;
            }
            
            //公司
            NSString *org = contactAction.organization;
            if (org.length > 0)
            {
                isOperate = YES;
                
                //顶部线
                UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f , fixHeight , self.contentView.frame.size.width, 1)];
                topLineView.backgroundColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1];
                [self.contentView addSubview:topLineView];
                [topLineView release];
                
                UILabel *orgTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake( 0.0f , fixHeight , 60.0f, lineHeight)];
                orgTitleLabel.backgroundColor = [UIColor clearColor];
                orgTitleLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
                orgTitleLabel.font = [UIFont systemFontOfSize:14.0f];
                orgTitleLabel.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1];
                orgTitleLabel.text = @"公司";
                orgTitleLabel.textAlignment = UITextAlignmentCenter;
                [self.contentView addSubview:orgTitleLabel];
                [orgTitleLabel release];
                
                //自适应高度
                CGSize constraint = CGSizeMake(self.contentView.frame.size.width - 90.0f, 20000.0f);
                CGSize size = [org sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
                CGFloat InfoFixHeight = (size.height + 10.0f) < lineHeight ? lineHeight : (size.height + 10.0f);
                
                UILabel *orgInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake( 80.0f , fixHeight , self.contentView.frame.size.width - 90.0f, InfoFixHeight)];
                orgInfoLabel.backgroundColor = [UIColor clearColor];
                orgInfoLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
                orgInfoLabel.font = [UIFont systemFontOfSize:14.0f];
                orgInfoLabel.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1];
                orgInfoLabel.text = org;
                orgInfoLabel.numberOfLines = 0;
                orgInfoLabel.textAlignment = UITextAlignmentLeft;
                [self.contentView addSubview:orgInfoLabel];
                [orgInfoLabel release];
                
                //增加高度
                fixHeight = fixHeight + orgInfoLabel.frame.size.height;;
            }
            
            //地址
            NSString *address = contactAction.address;
            if (address.length > 0)
            {
                isOperate = YES;
                
                //顶部线
                UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f , fixHeight , self.contentView.frame.size.width, 1)];
                topLineView.backgroundColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1];
                [self.contentView addSubview:topLineView];
                [topLineView release];
                
                UILabel *addressTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake( 0.0f , fixHeight , 60.0f, lineHeight)];
                addressTitleLabel.backgroundColor = [UIColor clearColor];
                addressTitleLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
                addressTitleLabel.font = [UIFont systemFontOfSize:14.0f];
                addressTitleLabel.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1];
                addressTitleLabel.text = @"地址";
                addressTitleLabel.textAlignment = UITextAlignmentCenter;
                [self.contentView addSubview:addressTitleLabel];
                [addressTitleLabel release];
                
                //自适应高度
                CGSize constraint = CGSizeMake(self.contentView.frame.size.width - 90.0f, 20000.0f);
                CGSize size = [address sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
                CGFloat InfoFixHeight = (size.height + 10.0f) < lineHeight ? lineHeight : (size.height + 10.0f);
                
                UILabel *addressInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake( 80.0f , fixHeight , self.contentView.frame.size.width - 90.0f, InfoFixHeight)];
                addressInfoLabel.backgroundColor = [UIColor clearColor];
                addressInfoLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
                addressInfoLabel.font = [UIFont systemFontOfSize:14.0f];
                addressInfoLabel.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1];
                addressInfoLabel.text = address;
                addressInfoLabel.numberOfLines = 0;
                addressInfoLabel.textAlignment = UITextAlignmentLeft;
                [self.contentView addSubview:addressInfoLabel];
                [addressInfoLabel release];
                
                //增加高度
                fixHeight = fixHeight + addressInfoLabel.frame.size.height;
            }
            
            //完成 设置总体高度
            self.contentView.frame = CGRectMake(self.contentView.frame.origin.x , self.contentView.frame.origin.y , self.contentView.frame.size.width , fixHeight);
            
            //分割线
            UIView *separationLineView = [[UIView alloc] initWithFrame:CGRectMake(60.0f , titleImageView.frame.size.height , 4.0f, fixHeight - titleImageView.frame.size.height)];
            separationLineView.backgroundColor = [UIColor clearColor];
            separationLineView.layer.borderColor = [[UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1] CGColor];
            separationLineView.layer.borderWidth = 1.0f;
            [self.contentView addSubview:separationLineView];
            [separationLineView release];
            
            //添加保存按钮
            if (isOperate)
            {
                UIImage *operateImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"云拍操作按钮" ofType:@"png"]];
                
                UIButton *operateButton = [UIButton buttonWithType:UIButtonTypeCustom];
                operateButton.frame = CGRectMake( self.contentView.frame.origin.x , CGRectGetMaxY(self.contentView.frame) + 10.0f , operateImage.size.width, operateImage.size.height);
                [operateButton addTarget:self action:@selector(performAction) forControlEvents:UIControlEventTouchUpInside];
                [operateButton setBackgroundImage:operateImage forState:UIControlStateNormal];
                
                operateButton.titleLabel.textAlignment = UITextAlignmentCenter;
                operateButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
                [operateButton setTitle:@"添加到通讯录" forState:UIControlStateNormal];
                [operateButton setTitleColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0] forState:UIControlStateNormal];
                
                [self.contentScrollView addSubview:operateButton];
                [operateImage release];
                
                fixHeight = fixHeight + operateButton.frame.size.height + 10.0f;
            }
            
            //设置主体高度 10为顶部间距
            self.contentScrollView.contentSize = CGSizeMake(self.view.frame.size.width, fixHeight + 10.0f);
        }
        else
        {
            self.typeString = @"文本";
            NSString *infoTitleString = @"内容";
            NSString *operateString = @"";
            
            if ([resultActions isMemberOfClass:[CallAction class]])
            {
                isOperate = YES;
                self.typeString = @"电话";
                infoTitleString = @"号码";
                operateString = @"拨打电话";
            }
            else if([resultActions isMemberOfClass:[EmailAction class]])
            {
                isOperate = YES;
                self.typeString = @"邮箱";
                operateString = @"发送邮件";
            }
            else if([resultActions isMemberOfClass:[OpenUrlAction class]])
            {
                isOperate = YES;
                self.typeString = @"网页";
                infoTitleString = @"网址";
                operateString = @"打开网址";
                
                //识别到云来的网址 直接打开
                NSString *reuqestString = [NSString stringWithFormat:@"%@",self.resultString];
                NSString *yunlaiString = @"yunlai.cn";
                if ([reuqestString rangeOfString:yunlaiString options:NSCaseInsensitiveSearch].location != NSNotFound) 
                {
                    [self performSelector:@selector(performAction) withObject:nil afterDelay:0.0];
                }
                
            }
            else if([resultActions isMemberOfClass:[ShowMapAction class]])
            {
                isOperate = YES;
                self.typeString = @"地图";
                infoTitleString = @"地址";
                operateString = @"打开地图";
            }
            else if([resultActions isMemberOfClass:[SMSAction class]])
            {
                isOperate = YES;
                self.typeString = @"短信";
                operateString = @"发送短信";
            }
            
            self.info = [result stringForDisplay];
            
            //标题
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake( 0.0f , 0.0f , titleImageView.frame.size.width, titleImageView.frame.size.height)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
            titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0f];
            titleLabel.textColor = [UIColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1];
            titleLabel.text = self.typeString;
            titleLabel.textAlignment = UITextAlignmentCenter;
            [self.contentView addSubview:titleLabel];
            [titleLabel release];
            
            //顶部线
            UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f , fixHeight , self.contentView.frame.size.width, 1)];
            topLineView.backgroundColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1];
            [self.contentView addSubview:topLineView];
            [topLineView release];
            
            UILabel *infoTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake( 0.0f , fixHeight , 60.0f, lineHeight)];
            infoTitleLabel.backgroundColor = [UIColor clearColor];
            infoTitleLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
            infoTitleLabel.font = [UIFont systemFontOfSize:14.0f];
            infoTitleLabel.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1];
            infoTitleLabel.text = infoTitleString;
            infoTitleLabel.textAlignment = UITextAlignmentCenter;
            [self.contentView addSubview:infoTitleLabel];
            [infoTitleLabel release];
            
            //自适应高度
            CGSize constraint = CGSizeMake(self.contentView.frame.size.width - 90.0f, 20000.0f);
            CGSize size = [self.info sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            CGFloat InfoFixHeight = (size.height + 10.0f) < lineHeight ? lineHeight : (size.height + 10.0f);
            
            UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake( 80.0f , fixHeight , self.contentView.frame.size.width - 90.0f, InfoFixHeight)];
            infoLabel.backgroundColor = [UIColor clearColor];
            infoLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
            infoLabel.font = [UIFont systemFontOfSize:14.0f];
            infoLabel.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1];
            infoLabel.text = self.info;
            infoLabel.numberOfLines = 0;
            infoLabel.textAlignment = UITextAlignmentLeft;
            [self.contentView addSubview:infoLabel];
            [infoLabel release];
            
            //增加高度
            fixHeight = fixHeight + infoLabel.frame.size.height;
            
            //完成 设置总体高度
            self.contentView.frame = CGRectMake(self.contentView.frame.origin.x , self.contentView.frame.origin.y , self.contentView.frame.size.width , fixHeight);
            
            //分割线
            UIView *separationLineView = [[UIView alloc] initWithFrame:CGRectMake(60.0f , titleImageView.frame.size.height , 4.0f, fixHeight - titleImageView.frame.size.height)];
            separationLineView.backgroundColor = [UIColor clearColor];
            separationLineView.layer.borderColor = [[UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1] CGColor];
            separationLineView.layer.borderWidth = 1.0f;
            [self.contentView addSubview:separationLineView];
            [separationLineView release];
            
            //添加保存按钮
            if (isOperate)
            {
                UIImage *operateImage = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"云拍操作按钮" ofType:@"png"]];
                
                UIButton *operateButton = [UIButton buttonWithType:UIButtonTypeCustom];
                operateButton.frame = CGRectMake( self.contentView.frame.origin.x , CGRectGetMaxY(self.contentView.frame) + 10.0f , operateImage.size.width, operateImage.size.height);
                [operateButton addTarget:self action:@selector(performAction) forControlEvents:UIControlEventTouchUpInside];
                [operateButton setBackgroundImage:operateImage forState:UIControlStateNormal];
                
                operateButton.titleLabel.textAlignment = UITextAlignmentCenter;
                operateButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
                [operateButton setTitle:operateString forState:UIControlStateNormal];
                [operateButton setTitleColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0] forState:UIControlStateNormal];
                
                [self.contentScrollView addSubview:operateButton];
                [operateImage release];
                
                fixHeight = fixHeight + operateButton.frame.size.height + 10.0f;
            }
            
            //设置主体高度 10为顶部间距
            self.contentScrollView.contentSize = CGSizeMake(self.view.frame.size.width, fixHeight + 10.0f);
        }
        
    }
    else
    {
        //纯文本
        self.info = [result stringForDisplay];
        self.typeString = @"文本";
        
        //标题
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake( 0.0f , 0.0f , titleImageView.frame.size.width, titleImageView.frame.size.height)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0f];
        titleLabel.textColor = [UIColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1];
        titleLabel.text = self.typeString;
        titleLabel.textAlignment = UITextAlignmentCenter;
        [self.contentView addSubview:titleLabel];
        [titleLabel release];
        
        //顶部线
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f , fixHeight , self.contentView.frame.size.width, 1)];
        topLineView.backgroundColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1];
        [self.contentView addSubview:topLineView];
        [topLineView release];
        
        UILabel *infoTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake( 0.0f , fixHeight , 60.0f, lineHeight)];
        infoTitleLabel.backgroundColor = [UIColor clearColor];
        infoTitleLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        infoTitleLabel.font = [UIFont systemFontOfSize:14.0f];
        infoTitleLabel.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1];
        infoTitleLabel.text = @"内容";
        infoTitleLabel.textAlignment = UITextAlignmentCenter;
        [self.contentView addSubview:infoTitleLabel];
        [infoTitleLabel release];
        
        //自适应高度
        CGSize constraint = CGSizeMake(self.contentView.frame.size.width - 90.0f, 20000.0f);
        CGSize size = [self.info sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        CGFloat InfoFixHeight = (size.height + 10.0f) < lineHeight ? lineHeight : (size.height + 10.0f);
        
        UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake( 80.0f , fixHeight , self.contentView.frame.size.width - 90.0f, InfoFixHeight)];
        infoLabel.backgroundColor = [UIColor clearColor];
        infoLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        infoLabel.font = [UIFont systemFontOfSize:14.0f];
        infoLabel.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1];
        infoLabel.text = self.info;
        infoLabel.numberOfLines = 0;
        infoLabel.textAlignment = UITextAlignmentLeft;
        [self.contentView addSubview:infoLabel];
        [infoLabel release];
        
        //增加高度
        fixHeight = fixHeight + infoLabel.frame.size.height;
        
        //完成 设置总体高度
        self.contentView.frame = CGRectMake(self.contentView.frame.origin.x , self.contentView.frame.origin.y , self.contentView.frame.size.width , fixHeight);
        
        //分割线
        UIView *separationLineView = [[UIView alloc] initWithFrame:CGRectMake(60.0f , titleImageView.frame.size.height , 4.0f, fixHeight - titleImageView.frame.size.height)];
        separationLineView.backgroundColor = [UIColor clearColor];
        separationLineView.layer.borderColor = [[UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1] CGColor];
        separationLineView.layer.borderWidth = 1.0f;
        [self.contentView addSubview:separationLineView];
        [separationLineView release];
    }
    
}

-(void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
    
    
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //历史记录
    if (dataFromScan) 
    {
        if (self.resultString.length > 0 && self.info.length > 0)
        {
            //当前时间
            NSTimeInterval cTime = [[NSDate date] timeIntervalSince1970];
            long long int currentTime = (long long int)cTime;
            NSNumber *time = [NSNumber numberWithInt: currentTime];
            
            NSMutableArray *scanArray = [[NSMutableArray alloc] init];
            [scanArray addObject:self.typeString];
            [scanArray addObject:self.info];
            [scanArray addObject:resultString];
            [scanArray addObject:time];
            [DBOperate insertData:scanArray tableName:T_SCAN_HISTORY];
            [scanArray release];
            
            //保证数据只有20条
            NSMutableArray *historyItems = (NSMutableArray *)[DBOperate queryData:T_SCAN_HISTORY theColumn:@"" theColumnValue:@"" orderBy:@"created" orderType:@"desc" withAll:NO];
            
            for (int i = [historyItems count] - 1; i > 19; i--)
            {
                NSArray *historyArray = [historyItems objectAtIndex:i];
                NSString *historyId = [historyArray objectAtIndex:scan_history_id];
                [DBOperate deleteData:T_SCAN_HISTORY tableColumn:@"id" columnValue:historyId];
            }
            
            dataFromScan = NO;
        }
    }
}

//返回首页
- (void)backHome
{
    if (dataFromScan) 
    {
        [self.navigationController popViewControllerAnimated:NO];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

//取消 放回扫描页面
- (void)cancel
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//操作
- (void)performAction
{
    ResultAction *action = [[result actions] objectAtIndex:0];
    [action performActionWithController:self shouldConfirm:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.resultString = nil;
    self.result = nil;
    self.contentView = nil;
    self.contentScrollView = nil;
    self.typeString = nil;
    self.info = nil;
}

- (void)dealloc {
    [self.resultString release];
    [self.result release];
    [self.contentView release];
    [self.contentScrollView release];
    [self.typeString release];
    [self.info release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
