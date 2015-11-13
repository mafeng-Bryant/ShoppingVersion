//
//  Common.h
//  Profession
//
//  Created by MC374 on 12-8-7.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"
#import "DBOperate.h"
#import "base64.h"
#import <SystemConfiguration/SystemConfiguration.h>
#include <netdb.h>
#import <CoreLocation/CoreLocation.h>

/////////宏编译控制

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define VIEW_HEIGHT [UIScreen mainScreen].bounds.size.height

#define IOS4 1
#define SHOW_NAV_TAB_BG 2
#define NAV_BG_PIC @"上bar.png"
#define TAB_BG_PIC @"下bar.png"
#define IOS7_NAV_BG_PIC @"ios7上bar.png" //ios7 上bar
//app背景图片
#define BG_IMAGE @"背景.png"

#define BTO_COLOR_RED 0.7
#define BTO_COLOR_GREEN 0
#define BTO_COLOR_BLUE 0

#define TAB_COLOR_RED 0.935
#define TAB_COLOR_GREEN 0.935
#define TAB_COLOR_BLUE  0.935

//特价专区标题颜色
#define SPE_COLOR_RED 0.011
#define SPE_COLOR_GREEN 0.321
#define SPE_COLOR_BLUE  0.047

#define dataBaseFile @"shopping.db"

#define DOWNLOAD_IMAGE_MAX_COUNT 3

#define SITE_ID 2

#define kAPPName @"仟吉西饼"

//loading提示
#define LOADING_TIPS @"云端同步中...";

//#define ACCESS_SERVER_LINK @"http://192.168.1.48:8080/SG_APPInterfaceServer/"
//#define ACCESS_SERVER_LINK @"http://192.168.1.110/SG_APPInterfaceServer/"
//#define ACCESS_SERVER_LINK @"http://app.yunlai.cn:8080/SG_APPInterfaceServer/"  
//#define ACCESS_SERVER_LINK @"http://202.104.149.214:8080/SG_APPInterfaceServer/"
#define ACCESS_SERVER_LINK @"http://app.yunlai.cn:8080/SG_APPInterfaceServer/"

//加密key
#define SignSecureKey  @"SGAPP9I0I6IyunlaiINTERFACE"

//微信接口
#define WEICHATID @"wx06aade63031e0298"

//分享
#define DETAIL_SHARE_LINK @"http://demo.sg.yunlai.cn/"
#define SHARE_CONTENTS @"这个内容不错,推荐给你"

#define NEED_UPDATE 1
#define NO_UPDATE 0

//微博接口
#define SINA @"sina"
#define TENCENT @"tencent"
#define SinaAppKey @"84604506"
#define SinaAppSecret @"a9753f903d2fa713abf7550fe20594b0"
#define QQAppKey @"801106679"
#define QQAppSecret @"14e3e1188d69231e59f6c98d4a9a5527"
#define redirectUrl @"http://our.3g.yunlai.cn"

//支付宝相关信息 此处不是很安全
#define ALIPAY_PARTNER @"2088711007868747";
#define ALIPAY_SELLER @"2953928019@qq.com";

//一天抽奖最多的次数
#define ONE_DATE_LOTTERY_TIMES 10

//首页是否显示分店地图 0 不显示 1显示
#define HOME_IS_SHOW_MAP 1

//设置commadid
//设备令牌
#define APNS_COMMAND_ID 1

#define OPERAT_INDEX_REFRESH 3
#define OPERAT_AD_REFRESH 4
#define OPERAT_SPECIAL_TAGS_REFRESH 5

//商品
#define OPERAT_PRODUCT_CAT_REFRESH 6
#define OPERAT_PRODUCT_REFRESH 7
#define OPERAT_PRODUCT_MORE 8

//关键词 搜索
#define OPERAT_KEYWORD_REFRESH 9
#define OPERAT_SEARCH_REFRESH 10
#define OPERAT_SEARCH_MORE 11

//首页特性商品列表
#define OPERAT_SPECIAL_TAGS_LIST_REFRESH 12
#define OPERAT_SPECIAL_TAGS_LIST_MORE 13

//首页推荐
#define OPERAT_RECOMMEND_LIST_REFRESH 14
#define OPERAT_RECOMMEND_LIST_MORE 15

//特价专区 , 特价商品列表
#define OPERAT_SPECIAL_OFFER_REFRESH 16
#define OPERAT_SPECIAL_OFFER_MORE 17
#define OPERAT_SPECIAL_OFFER_LIST_REFRESH 18
#define OPERAT_SPECIAL_OFFER_LIST_MORE 19

//活动资讯
#define OPERAT_NEWS_REFRESH 20
#define OPERAT_NEWS_MORE 21

//发送评论
#define OPERAT_SEND_NEWS_COMMENT 22
#define OPERAT_SEND_PRODUCTS_COMMENT 23

//发送收藏
#define OPERAT_SEND_NEWS_FAVORITE 24
#define OPERAT_SEND_PRODUCTS_FAVORITE 25
#define OPERAT_SEND_PRODUCTS_LIKE 26

//抽奖
#define OPERAT_LOTTERY_LIST_REFRESH 27
#define OPERAT_LOTTERY_LIST_MORE 28
#define OPERAT_SEND_LOTTERY_WIN 29

#define SHARE_CLIENT_PROMOTION_ID 30    //分享客户端获取优惠劵活动
#define SHARE_PRODUCT_PROMOTION_ID 31   //分享产品领取优惠劵活动
#define FULL_PROMOTION_ID   32          //满就送活动
#define GUIDE_COMMAND_ID    33          //引导页
#define POST_VER            34          //物流版本号

//资讯评论
#define OPERAT_NEWS_COMMENT_REFRESH 35
#define OPERAT_NEWS_COMMENT_MORE 36

//数据统计
#define PV_COMMAND_ID  37

//资讯详情页面
#define NEW_DETAIL_COMMAND_ID 38

//产品详情评论
#define PRODUCT_COMMENTLIST_COMMAND_ID 100
//提交订单
#define SUBMIT_ORDER_COMMAND_ID 101
//产品详情数据
#define OPERAT_PRODUCT_DETAIL_COMMAND_ID 102
//领取优惠券
#define GET_PROMOTION_CODE 103
//快递物流价格
#define GET_DELIVERY_FARE 104
//确认订单已经在线支付完成
#define COFIRM_ORDER_PAY 105

//会员中心
#define MEMBER_LOGIN_COMMAND_ID     200
#define MEMBER_REGIST_COMMAND_ID    201
#define MEMBER_INFO_COMMAND_ID      202  
#define SINAWEI_COMMAND_ID          203
#define TENCENTWEI_COMMAND_ID       204
#define EASYLIST_COMMAND_ID         205 //轻松购列表
#define EASYLISTMORE_COMMAND_ID     206 //轻松购列表 more
#define SETDEFAULT_COMMAND_ID       207 //set 轻松购
#define EASYLIST_DELETE_COMMAND_ID  208 //轻松购列表 delete
#define ADDOREDIT_EASYBOOK_COMMAND_ID      209 //增加 编辑轻松购
#define MEMBER_PRODUCTLIST_COMMAND_ID      210   //我的产品收藏列表
#define MEMBER_PRODUCTMORELIST_COMMAND_ID  211   //我的产品收藏列表 more
#define MEMBER_PRODUCTDELETE_COMMAND_ID    212   //我的产品收藏列表 delete
#define MEMBER_NEWSLIST_COMMAND_ID         213   //我的资讯收藏列表
#define MEMBER_NEWSMORELIST_COMMAND_ID     214   //我的资讯收藏列表 more
#define MEMBER_NEWSDELETE_COMMAND_ID       215   //我的资讯收藏列表 delete
#define MEMBER_LIKESLIST_COMMAND_ID        216   //我的喜欢列表  
#define MEMBER_LIKESMORELIST_COMMAND_ID    217   //我的喜欢列表 more
#define MEMBER_LIKESDELETE_COMMAND_ID      218   //我的喜欢列表 delete
#define MEMBER_ORDERSLIST_COMMAND_ID       219   //我的订单列表
#define MEMBER_ORDERSMORELIST_COMMAND_ID   220   //我的订单列表 more
#define CANCELORDER_COMMAND_ID             221   //取消订单
#define MEMBER_ADDRESSLIST_COMMAND_ID      222   //我的常用地址 
#define MEMBER_ADDRESSMORELIST_COMMAND_ID  223   //我的常用地址  more
#define MEMBER_ADDRESSDELETE_COMMAND_ID    224   //我的常用地址  delete
#define ADDOREDIT_ADDRESS_COMMAND_ID       225   //add edit  我的常用地址
#define MEMBER_PRIZELIST_COMMAND_ID        226   //我的奖品列表 
#define MEMBER_PRIZEMORELIST_COMMAND_ID    227   //我的奖品列表  more
#define SETPRIZEADDRESS_COMMAND_ID         228   //设置奖品的收货地址
#define MEMBER_DISCOUNTLIST_COMMAND_ID     229   //我的优惠卷列表 
#define MEMBER_DISCOUNTMORELIST_COMMAND_ID 230   //我的优惠卷列表  more
#define SURERECEIVEORDER_COMMAND_ID        231   //订单详情页面确认收货
#define MEMBER_WRITECOMMENT_COMMAND_ID     232   //订单详情页面写评价 我的评价列表写评价
#define MEMBER_COMMENTLIST_COMMAND_ID      233   //我的评价列表  
#define MEMBER_COMMENTMORELIST_COMMAND_ID  234   //我的评价列表 more

//百宝箱
#define MORE_CAT_COMMAND_ID                235   //自定义按钮
#define MORE_CAT_INFO_COMMAND_ID           236   //自定义按钮详情
#define OPERAT_ABOUTUS_INFO                237   //关于我们
#define OPERAT_SEND_FEEDBACK               238   //意见反馈
#define OPERAT_RECOMMEND_APP_REFRESH       239   //推荐应用
#define OPERAT_RECOMMEND_APP_MORE          240   //推荐应用 more
#define OPERAT_RECOMMEND_APP_AD_REFRESH    241   //推荐应用广告
#define MAP_COMMAND_ID                     242   //分店地图

// dufu add 2013.06.14
// 版本ID KEY
#define APP_SOFTWARE_VER_KEY    @"app_ver"
// 版本ID 当前版本号
#define CURRENT_APP_VERSION     0

//新版本提示语
#define TIPS_NEWVERSION @"发现新版本"

int	app_wechat_share_type;
enum share_wechat_type {
	app_to_wechat = 1,
	wechat_to_app
};

#define promotionPercent 0.8 //百分比

//定位
CLLocationManager *locManager;
CLLocationCoordinate2D myLocation;
NSOperationQueue *netWorkQueue;
NSMutableArray *netWorkQueueArray;
BOOL isShowPromotionAlert;  //是否弹出促销优惠活动

BOOL _isLogin;
BOOL _isChangedImage;
BOOL isFirstLoadTabBar;

int currentSelectingIndex;
NSString *orderID;


@interface Common : NSObject {

}

+(BOOL)connectedToNetwork;
+(NSString*)TransformJson:(NSMutableDictionary*)sourceDic withLinkStr:(NSString*)strurl;
+(NSString*)encodeBase64:(NSMutableData*)data;
+(NSString*)URLEncodedString:(NSString*)input;
+(NSString*)URLDecodedString:(NSString*)input;
+(NSNumber*)getVersion:(int)commandId;
+ (NSNumber*)getMemberVersion:(int)memberId commandID:(int)_commandId;
+(NSString*)getSecureString;
+(NSString*)getLotteryLogs:(NSString *)dateString;
+ (NSString*)getMacAddress;
+(double)lantitudeLongitudeToDist:(double)lon1 Latitude1:(double)lat1 long2:(double)lon2 Latitude2:(double)lat2;
@end
