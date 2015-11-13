//
//  CommonOperation.m
//  Profession
//
//  Created by MC374 on 12-8-9.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CommandOperation.h"
#import "Common.h"
#import "CommandOperationParser.h"

#import "shoppingAppDelegate.h"
#import "NetPopupWindow.h"

Class object_getClass(id object);

@implementation CommandOperation
@synthesize reqStr;
@synthesize delegate;
@synthesize requestParam;
@synthesize commandid;

- (id)initWithReqStr:(NSString*)rstr command:(int)cmd delegate:(id <CommandOperationDelegate>)theDelegate params:(NSMutableDictionary*)param{
	
	self = [super init];
	if (self != nil)
	{
		self.reqStr = rstr;
		self.delegate = theDelegate;
        _originalClass = object_getClass(theDelegate);
		commandid = cmd;
		self.requestParam = param;
	}
    return self;
}
-(NSMutableArray*)parseJsonandGetVersion:(int*)ver{
	NSString *resultStr = [[NSString alloc]initWithData:[self AccessService] encoding: NSUTF8StringEncoding];
	NSLog(@"data from server result %@",resultStr);
	
	NSMutableArray *resultArray = nil;
	
    if ([resultStr isEqualToString:@"{}"] || [resultStr isEqualToString:@"{\"Error\":\"4001\"}"] || [resultStr isEqualToString:@"{\"Error\":\"4002\"}"] || [resultStr isEqualToString:@"{\"Error\":\"4003\"}"])
    {
        *ver = NO_UPDATE;
        NSLog(@"------数据为空或请求发生错误 结果: %@",resultStr);
    }
    else
    {
        switch (commandid) 
        {
            case OPERAT_INDEX_REFRESH:{
                resultArray = [CommandOperationParser parseHome:resultStr getVersion:ver];
            }
                break;
            case OPERAT_PRODUCT_CAT_REFRESH:{
                resultArray = [CommandOperationParser parseProductCatList:resultStr getVersion:ver];
            }
                break;
            case OPERAT_PRODUCT_REFRESH:{
                resultArray = [CommandOperationParser parseProductList:resultStr getVersion:ver withParam:self.requestParam];
            }
                break;
            case OPERAT_PRODUCT_MORE:{
                resultArray = [CommandOperationParser parseProductMoreList:resultStr getVersion:ver withParam:self.requestParam];
            }
                break;
            case OPERAT_KEYWORD_REFRESH:{
                resultArray = [CommandOperationParser parseKeywordList:resultStr getVersion:ver];
            }
                break;
            case OPERAT_SEARCH_REFRESH:{
                resultArray = [CommandOperationParser parseSomeProductList:resultStr getVersion:ver];
            }
                break;
            case OPERAT_SEARCH_MORE:{
                resultArray = [CommandOperationParser parseSomeProductList:resultStr getVersion:ver];
            }
                break;
            case OPERAT_SPECIAL_TAGS_LIST_REFRESH:{
                resultArray = [CommandOperationParser parseSomeProductList:resultStr getVersion:ver];
            }
                break;
            case OPERAT_SPECIAL_TAGS_LIST_MORE:{
                resultArray = [CommandOperationParser parseSomeProductList:resultStr getVersion:ver];
            }
                break;   
            case OPERAT_RECOMMEND_LIST_REFRESH:{
                resultArray = [CommandOperationParser parseRecommend:resultStr getVersion:ver];
            }
                break;
            case OPERAT_RECOMMEND_LIST_MORE:{
                resultArray = [CommandOperationParser parseRecommendMore:resultStr getVersion:ver];
            }
                break;   
            case OPERAT_SPECIAL_OFFER_REFRESH:{
                resultArray = [CommandOperationParser parseSpecialOffer:resultStr getVersion:ver];
            }
                break;
            case OPERAT_SPECIAL_OFFER_MORE:{
                resultArray = [CommandOperationParser parseSpecialOfferMore:resultStr getVersion:ver];
            }
                break;
            case OPERAT_SPECIAL_OFFER_LIST_REFRESH:{
                resultArray = [CommandOperationParser parseSomeProductList:resultStr getVersion:ver];
            }
                break;
            case OPERAT_SPECIAL_OFFER_LIST_MORE:{
                resultArray = [CommandOperationParser parseSomeProductList:resultStr getVersion:ver];
            }
                break;
            case OPERAT_NEWS_REFRESH:{
                resultArray = [CommandOperationParser parseNews:resultStr getVersion:ver];
            }
                break;
            case OPERAT_NEWS_MORE:{
                resultArray = [CommandOperationParser parseNewsMore:resultStr getVersion:ver];
            }
                break;
            case OPERAT_NEWS_COMMENT_REFRESH:{
                resultArray = [CommandOperationParser parseNewsComment:resultStr getVersion:ver];
            }
                break;
            case OPERAT_NEWS_COMMENT_MORE:{
                resultArray = [CommandOperationParser parseNewsComment:resultStr getVersion:ver];
            }
                break;
            case OPERAT_LOTTERY_LIST_REFRESH:{
                resultArray = [CommandOperationParser parseLotteryList:resultStr getVersion:ver];
            }
                break;
            case OPERAT_LOTTERY_LIST_MORE:{
                resultArray = [CommandOperationParser parseLotteryMore:resultStr getVersion:ver];
            }
                break;
            case OPERAT_SEND_LOTTERY_WIN:{
                resultArray = [CommandOperationParser parseSendLotteryWin:resultStr getVersion:ver];
            }
                break;
            case MEMBER_LOGIN_COMMAND_ID:{
                resultArray = [CommandOperationParser parseLogin:resultStr getVersion:ver];
            }
                break;
            case MEMBER_REGIST_COMMAND_ID:{
                resultArray = [CommandOperationParser parseRegist:resultStr getVersion:ver];
            }
                break;
            case SINAWEI_COMMAND_ID:{
                resultArray = [CommandOperationParser parseSinaWeibo:resultStr getVersion:ver];
            }
                break;
            case TENCENTWEI_COMMAND_ID:{
                resultArray = [CommandOperationParser parseTencentWeibo:resultStr getVersion:ver];
            }
                break;
            case MEMBER_LIKESLIST_COMMAND_ID:{
                resultArray = [CommandOperationParser parseLikesList:resultStr getVersion:ver withMemberId:[[requestParam objectForKey:@"user_id"] intValue] isInsert:YES];
            }
                break;
            case MEMBER_LIKESMORELIST_COMMAND_ID:{
                resultArray = [CommandOperationParser parseLikesList:resultStr getVersion:ver withMemberId:[[requestParam objectForKey:@"user_id"] intValue] isInsert:NO];
            }	break;
            case MEMBER_LIKESDELETE_COMMAND_ID:{
                resultArray = [CommandOperationParser parseResult:resultStr getVersion:ver];
            }	break;
            case MEMBER_PRODUCTLIST_COMMAND_ID:{
                resultArray = [CommandOperationParser parseProductList:resultStr getVersion:ver withMemberId:[[requestParam objectForKey:@"user_id"] intValue] isInsert:YES];
            }
                break;
            case MEMBER_PRODUCTMORELIST_COMMAND_ID:{
                resultArray = [CommandOperationParser parseProductList:resultStr getVersion:ver withMemberId:[[requestParam objectForKey:@"user_id"] intValue] isInsert:NO];
            }	break;
            case MEMBER_PRODUCTDELETE_COMMAND_ID:{
                resultArray = [CommandOperationParser parseResult:resultStr getVersion:ver];
            }	break;
            case MEMBER_NEWSLIST_COMMAND_ID:{
                resultArray = [CommandOperationParser parseNewsList:resultStr getVersion:ver withMemberId:[[requestParam objectForKey:@"user_id"] intValue] isInsert:YES];
            }
                break;
            case MEMBER_NEWSMORELIST_COMMAND_ID:{
                resultArray = [CommandOperationParser parseNewsList:resultStr getVersion:ver withMemberId:[[requestParam objectForKey:@"user_id"] intValue] isInsert:NO];
            }	break;
            case MEMBER_NEWSDELETE_COMMAND_ID:{
                resultArray = [CommandOperationParser parseResult:resultStr getVersion:ver];
            }	break;
            case EASYLIST_COMMAND_ID:{
                NSString *userId = [requestParam objectForKey:@"user_id"];
                resultArray = [CommandOperationParser parseEasyList:resultStr getVersion:ver withUserId:[userId intValue] isInsert:YES];
            }
                break;
            case EASYLISTMORE_COMMAND_ID:{
                NSString *userId = [requestParam objectForKey:@"user_id"];
                resultArray = [CommandOperationParser parseEasyList:resultStr getVersion:ver withUserId:[userId intValue] isInsert:NO];
            }
                break;
            case SETDEFAULT_COMMAND_ID:{
                resultArray = [CommandOperationParser parseResult:resultStr getVersion:ver];
            }
                break;
            case EASYLIST_DELETE_COMMAND_ID:{
                resultArray = [CommandOperationParser parseResult:resultStr getVersion:ver];
            }
                break;
            case ADDOREDIT_EASYBOOK_COMMAND_ID:{
                resultArray = [CommandOperationParser parseAddorEditReservationResult:resultStr getVersion:ver];
            }
                break;
            case MEMBER_ADDRESSLIST_COMMAND_ID:{
                resultArray = [CommandOperationParser parseAddressList:resultStr getVersion:ver withMemberId:[[requestParam objectForKey:@"user_id"] intValue] isInsert:YES];
            }
                break;
            case MEMBER_ADDRESSMORELIST_COMMAND_ID:{
                resultArray = [CommandOperationParser parseAddressList:resultStr getVersion:ver withMemberId:[[requestParam objectForKey:@"user_id"] intValue] isInsert:NO];
            }
                break;
            case MEMBER_ADDRESSDELETE_COMMAND_ID:{
                resultArray = [CommandOperationParser parseResult:resultStr getVersion:ver];
            }
                break;
            case ADDOREDIT_ADDRESS_COMMAND_ID:{
                resultArray = [CommandOperationParser parseAddorEditAddressResult:resultStr getVersion:ver];
            }
                break;
            case MEMBER_PRIZELIST_COMMAND_ID:{
                resultArray = [CommandOperationParser parseMyPrizeList:resultStr getVersion:ver withMemberId:[[requestParam objectForKey:@"user_id"] intValue] isInsert:YES];
            }
                break;
            case MEMBER_PRIZEMORELIST_COMMAND_ID:{
                resultArray = [CommandOperationParser parseMyPrizeListMore:resultStr getVersion:ver withMemberId:[[requestParam objectForKey:@"user_id"] intValue]];
            }
                break;
            case SETPRIZEADDRESS_COMMAND_ID:{
                resultArray = [CommandOperationParser parseResult:resultStr getVersion:ver];
            }
                break;
            case MEMBER_ORDERSLIST_COMMAND_ID:{
                resultArray = [CommandOperationParser parseMyOrdersList:resultStr getVersion:ver withUserId:[[requestParam objectForKey:@"user_id"] intValue] withType:[[requestParam objectForKey:@"condition"] intValue] isInsert:YES];
            }
                break;
            case MEMBER_ORDERSMORELIST_COMMAND_ID:{
                resultArray = [CommandOperationParser parseMyOrdersList:resultStr getVersion:ver withUserId:[[requestParam objectForKey:@"user_id"] intValue] withType:[[requestParam objectForKey:@"condition"] intValue] isInsert:NO];
            }
                break;
            case CANCELORDER_COMMAND_ID:{
                resultArray = [CommandOperationParser parseResult:resultStr getVersion:ver];
            }
                break;
            case MEMBER_DISCOUNTLIST_COMMAND_ID:{
                resultArray = [CommandOperationParser parseMyDiscountListResult:resultStr getVersion:ver withUserId:[[requestParam objectForKey:@"user_id"] intValue] isInsert:YES];
            }
                break;
            case MEMBER_DISCOUNTMORELIST_COMMAND_ID:{
                resultArray = [CommandOperationParser parseMyDiscountListResult:resultStr getVersion:ver withUserId:[[requestParam objectForKey:@"user_id"] intValue] isInsert:NO];
            }
                break;
            case SURERECEIVEORDER_COMMAND_ID:{
                resultArray = [CommandOperationParser parseResult:resultStr getVersion:ver];
            }
                break;
            case MEMBER_WRITECOMMENT_COMMAND_ID:{
                resultArray = [CommandOperationParser parseResult:resultStr getVersion:ver];
            }
                break;
            case MEMBER_COMMENTLIST_COMMAND_ID:{
                resultArray = [CommandOperationParser parseMyCommentList:resultStr getVersion:ver withUserId:[[requestParam objectForKey:@"user_id"] intValue] withType:[[requestParam objectForKey:@"type"] intValue] isInsert:YES];
            }
                break;
            case MEMBER_COMMENTMORELIST_COMMAND_ID:{
                resultArray = [CommandOperationParser parseMyCommentList:resultStr getVersion:ver withUserId:[[requestParam objectForKey:@"user_id"] intValue] withType:[[requestParam objectForKey:@"type"] intValue] isInsert:NO];
            }
            //百宝箱自定义
            case MORE_CAT_COMMAND_ID:{
                resultArray = [CommandOperationParser parseMoreCat:resultStr getVersion:ver];
            }
                break;
            //百宝箱自定义分类
            case MORE_CAT_INFO_COMMAND_ID:{
                int catId = [[requestParam objectForKey:@"cat_id"] intValue];
                resultArray = [CommandOperationParser parseMoreCatInfo:resultStr getVersion:ver withCatId:catId];
            }
                break;
            case OPERAT_ABOUTUS_INFO:{
                resultArray = [CommandOperationParser parseAboutUsList:resultStr getVersion:ver];
            }
                break;
                //推荐应用
            case OPERAT_RECOMMEND_APP_REFRESH:{
                resultArray = [CommandOperationParser parseRecommendApp:resultStr getVersion:ver];
            }
                break;
                //推荐应用更多
            case OPERAT_RECOMMEND_APP_MORE:{
                resultArray = [CommandOperationParser parseRecommendAppMore:resultStr getVersion:ver];
            }
                break;
            case OPERAT_SEND_FEEDBACK:{
                resultArray = [CommandOperationParser parseSendCommentAndFavorite:resultStr getVersion:ver];
            }
                break;
                
            case APNS_COMMAND_ID:
            {
                resultArray = [CommandOperationParser parseApns:resultStr getVersion:ver];
                break;
            }
            case GUIDE_COMMAND_ID:{
                resultArray = [CommandOperationParser parseGuideImagesResult:resultStr getVersion:ver];
            }
                break;
            case MAP_COMMAND_ID:{
                resultArray = [CommandOperationParser parseShopMapResult:resultStr getVersion:ver];
            }
                break;
                
                
            case OPERAT_SEND_NEWS_COMMENT:{
                resultArray = [CommandOperationParser parseSendCommentAndFavorite:resultStr getVersion:ver];
            }
                break;
            case OPERAT_SEND_PRODUCTS_COMMENT:{
                resultArray = [CommandOperationParser parseSendCommentAndFavorite:resultStr getVersion:ver];
            }
                break;
            case OPERAT_SEND_NEWS_FAVORITE:
            case OPERAT_SEND_PRODUCTS_LIKE:{
                resultArray = [CommandOperationParser parseSendCommentAndFavorite:resultStr getVersion:ver];
            }
                break;
            case OPERAT_SEND_PRODUCTS_FAVORITE:{
                resultArray = [CommandOperationParser parseSendCommentAndFavorite:resultStr getVersion:ver];
            }
                break;
            case PRODUCT_COMMENTLIST_COMMAND_ID:{
                resultArray = [CommandOperationParser parseProductCommentList:resultStr getVersion:ver];
            }
                break;
            case SUBMIT_ORDER_COMMAND_ID:{
                resultArray = [CommandOperationParser parseSubmitOrder:resultStr getVersion:ver];
            }
                break;
            case OPERAT_PRODUCT_DETAIL_COMMAND_ID:{
                resultArray = [CommandOperationParser parseProductDetail:resultStr getVersion:ver withParam:self.requestParam];
            }
                break;
            case GET_PROMOTION_CODE:{
                resultArray = [CommandOperationParser parseGetPromotionCode:resultStr getVersion:ver];
            }
                break;
            case GET_DELIVERY_FARE:{
                resultArray = [CommandOperationParser parseGetDeliveryFare:resultStr getVersion:ver];
            }
                break;
            case COFIRM_ORDER_PAY:{
                resultArray = [CommandOperationParser parsePayOrder:resultStr getVersion:ver];
            }
                break;
            case PV_COMMAND_ID:{
                resultArray = [CommandOperationParser parseResult:resultStr getVersion:ver];
            }
                break;
            case NEW_DETAIL_COMMAND_ID:{
                resultArray = [CommandOperationParser parseNewDetail:resultStr withNewId:[[requestParam objectForKey:@"new_id"] intValue]];
            }
                break;
                
            default:
                resultArray = nil;
                break;
        }
    }
    
	[resultStr release];
	return resultArray;
}

-(NSData*)AccessService{
	
	NSURL *url;
	url = [NSURL URLWithString:reqStr];
	NSLog(@"url:%@",url);
	//NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                          timeoutInterval:15];
    
	NSURLResponse *response; 
	NSError *error = nil;
	NSData* dataReply = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
	if(error != nil)
	{
		NSException *exception =[NSException exceptionWithName:@"网络异常"
								 
														reason:[error  localizedDescription]
								 
													  userInfo:[error userInfo]];
		
		@throw exception;
		NSLog(@"NSURLConnection error %@",[error  localizedDescription]);
	}
	return dataReply;
}

- (void)show
{
    shoppingAppDelegate *app = (shoppingAppDelegate *)[UIApplication sharedApplication].delegate;
    [[NetPopupWindow defaultExample] showCustemAlertViewIninView:app.window];
}

- (void)main
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSMutableArray* result;
	int ver;
	NSLog(@"star thread");
	@try {
		result =[self parseJsonandGetVersion:&ver];
	}
	@catch (NSException *exception) {
		NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
        //网络异常
		if (![self isCancelled]&& delegate != nil)
		{
			Class currentClass = object_getClass(delegate);
            if  (currentClass == _originalClass)
            {
                [delegate didFinishCommand:nil cmd:commandid withVersion:0];
            }
		}
        [netWorkQueueArray removeObject:self.reqStr];
		self.reqStr = nil;
		[pool release];
        
        //if(![Common connectedToNetwork])
        {
            [self performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
        }
        
		return;
	}
    if (![self isCancelled]&& delegate != nil)
	{
		//NSLog(@"deleget result  %@",result);
        Class currentClass = object_getClass(delegate);
        if  (currentClass == _originalClass)
        {
            [delegate didFinishCommand:result cmd:commandid withVersion:ver];
        }
		
	}
    [netWorkQueueArray removeObject:self.reqStr];
	self.reqStr = nil;
	[pool release];
}

-(void)dealloc{
	delegate = nil;
	self.reqStr = nil;
	self.requestParam = nil;
	[super dealloc];
}
@end
