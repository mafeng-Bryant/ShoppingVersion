//
//  CommonOperationParser.h
//  Profession
//
//  Created by MC374 on 12-8-9.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CommandOperationParser : NSObject {
	
}
+(BOOL)updateVersion:(int)commanId versionID:(NSNumber*)versionid desc:(NSString*)describe;
+(BOOL)updateMemberVersion:(int)commanId withUserId:(int)_userId versionID:(NSNumber*)versionid desc:(NSString*)describe;

//首页
+(NSMutableArray*)parseHome:(NSString*)jsonResult getVersion:(int*)ver;

//商品分类
+(NSMutableArray*)parseProductCatList:(NSString*)jsonResult getVersion:(int*)ver;

//商品列表
+(NSMutableArray*)parseProductList:(NSString*)jsonResult getVersion:(int*)ver withParam:(NSMutableDictionary*)param;

//商品更多
+(NSMutableArray*)parseProductMoreList:(NSString*)jsonResult getVersion:(int*)ver withParam:(NSMutableDictionary*)param;

//搜索关键词
+(NSMutableArray*)parseKeywordList:(NSString*)jsonResult getVersion:(int*)ver;

//获取某个商品列表
+(NSMutableArray*)parseSomeProductList:(NSString*)jsonResult getVersion:(int*)ver;

//精品推荐
+(NSMutableArray*)parseRecommend:(NSString*)jsonResult getVersion:(int*)ver;

//精品推荐更多
+(NSMutableArray*)parseRecommendMore:(NSString*)jsonResult getVersion:(int*)ver;

//特价专区
+(NSMutableArray*)parseSpecialOffer:(NSString*)jsonResult getVersion:(int*)ver;

//特价专区更多
+(NSMutableArray*)parseSpecialOfferMore:(NSString*)jsonResult getVersion:(int*)ver;

//活动资讯
+(NSMutableArray*)parseNews:(NSString*)jsonResult getVersion:(int*)ver;

//活动资讯更多
+(NSMutableArray*)parseNewsMore:(NSString*)jsonResult getVersion:(int*)ver;

//资讯评论
+(NSMutableArray*)parseNewsComment:(NSString*)jsonResult getVersion:(int*)ver;

//抽奖列表
+(NSMutableArray*)parseLotteryList:(NSString*)jsonResult getVersion:(int*)ver;

//抽奖列表更多
+(NSMutableArray*)parseLotteryMore:(NSString*)jsonResult getVersion:(int*)ver;

//抽奖成功
+(NSMutableArray*)parseSendLotteryWin:(NSString*)jsonResult getVersion:(int*)ver;

//会员登录
+ (NSMutableArray*)parseLogin:(NSString*)jsonResult getVersion:(int*)ver;
//会员注册
+ (NSMutableArray*)parseRegist:(NSString*)jsonResult getVersion:(int*)ver;
//新浪微博登录
+ (NSMutableArray*)parseSinaWeibo:(NSString*)jsonResult getVersion:(int*)ver;
//腾讯微博登录
+ (NSMutableArray*)parseTencentWeibo:(NSString*)jsonResult getVersion:(int*)ver;
//我的喜欢列表
+ (NSMutableArray*)parseLikesList:(NSString*)jsonResult getVersion:(int*)ver withMemberId:(int)_memberId isInsert:(BOOL)yesORno;
//我的产品收藏列表
+ (NSMutableArray*)parseProductList:(NSString*)jsonResult getVersion:(int*)ver withMemberId:(int)_memberId isInsert:(BOOL)yesORno;
//我的资讯收藏列表
+ (NSMutableArray*)parseNewsList:(NSString*)jsonResult getVersion:(int*)ver withMemberId:(int)_memberId isInsert:(BOOL)yesORno;
//轻松购列表 
+ (NSMutableArray*)parseEasyList:(NSString*)jsonResult getVersion:(int*)ver withUserId:(int)_userId isInsert:(BOOL)yesORno;
//设置轻松购的默认  删除 
+ (NSMutableArray*)parseResult:(NSString*)jsonResult getVersion:(int*)ver;
//编辑、增加轻松购
+ (NSMutableArray*)parseAddorEditReservationResult:(NSString*)jsonResult getVersion:(int*)ver;
//我的地址列表
+ (NSMutableArray*)parseAddressList:(NSString*)jsonResult getVersion:(int*)ver withMemberId:(int)_memberId isInsert:(BOOL)yesORno;
//编辑、增加地址
+ (NSMutableArray*)parseAddorEditAddressResult:(NSString*)jsonResult getVersion:(int*)ver;
//我的奖品列表
+ (NSMutableArray*)parseMyPrizeList:(NSString*)jsonResult getVersion:(int*)ver withMemberId:(int)_memberId isInsert:(BOOL)yesORno;
+ (NSMutableArray*)parseMyPrizeListMore:(NSString*)jsonResult getVersion:(int*)ver withMemberId:(int)_memberId;

//我的订单列表
+ (NSMutableArray*)parseMyOrdersList:(NSString*)jsonResult getVersion:(int*)ver withUserId:(int)_userId withType:(int)_type isInsert:(BOOL)yesORno;
//我的优惠卷列表
+ (NSMutableArray*)parseMyDiscountListResult:(NSString*)jsonResult getVersion:(int*)ver withUserId:(int)_userId isInsert:(BOOL)yesORno;
//我的评价列表
+ (NSMutableArray*)parseMyCommentList:(NSString*)jsonResult getVersion:(int*)ver withUserId:(int)_userId withType:(int)_type isInsert:(BOOL)yesORno;
//百宝箱自定义
+ (NSMutableArray*)parseMoreCat:(NSString*)jsonResult getVersion:(int*)ver;
//百宝箱自定义分类
+ (NSMutableArray*)parseMoreCatInfo:(NSString*)jsonResult getVersion:(int*)ver withCatId:(int)_catId;
//关于我们
+(NSMutableArray*)parseAboutUsList:(NSString*)jsonResult getVersion:(int*)ver;
//推荐应用
+ (NSMutableArray*)parseRecommendApp:(NSString*)jsonResult getVersion:(int*)ver;
//推荐应用更多
+ (NSMutableArray*)parseRecommendAppMore:(NSString*)jsonResult getVersion:(int*)ver;

//评论及收藏
+(NSMutableArray*)parseSendCommentAndFavorite:(NSString*)jsonResult getVersion:(int*)ver;

//设备令牌接口
+ (NSMutableArray*)parseApns:(NSString*)jsonResult getVersion:(int*)ver;
//解析引导页的图片
+ (NSMutableArray*)parseGuideImagesResult:(NSString*)jsonResult getVersion:(int*)ver;
//解析分店地图
+ (NSMutableArray*)parseShopMapResult:(NSString*)jsonResult getVersion:(int*)ver;

//获取产品评论列表
+(NSMutableArray*)parseProductCommentList:(NSString*)jsonResult getVersion:(int*)ver;
//提交订单
+(NSMutableArray*)parseSubmitOrder:(NSString*)jsonResult getVersion:(int*)ver;
//产品详情
+(NSMutableArray*)parseProductDetail:(NSString*)jsonResult getVersion:(int*)ver withParam:(NSMutableDictionary*)param;
+ (NSMutableArray*)parseGetPromotionCode:(NSString*)jsonResult getVersion:(int*)ver;
//解析物流价格
+ (NSMutableArray*)parseGetDeliveryFare:(NSString*)jsonResult getVersion:(int*)ver;
//解析订单支付确认
+ (NSMutableArray*)parsePayOrder:(NSString*)jsonResult getVersion:(int*)ver;
//资讯详情页面
+ (NSMutableArray*)parseNewDetail:(NSString*)jsonResult withNewId:(int)_newId;
@end
