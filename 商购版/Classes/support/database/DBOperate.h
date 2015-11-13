//
//  DBOperate.h
//  Shopping
//
//  Created by zhu zhu chao on 11-3-22.
//  Copyright 2011 sal. All rights reserved.
//

#import <Foundation/Foundation.h>
#define	WHOLE_COLUMN 0
#define T_DEVTOKEN @"t_devtoken"
#define T_VERSION @"t_version"
#define T_SYSTEM_CONFIG @"t_system_config"
#define T_GUIDE_IMAGES @"t_guide_images"
#define T_SCAN_HISTORY  @"t_scan_history"
#define T_AD_LIST @"t_ad_list"
#define T_SPECIAL_TAGS @"t_special_tags"
#define T_PRODUCT @"t_product"
#define T_PRODUCT_CAT @"t_product_cat"
#define T_PRODUCT_PIC @"t_product_pic"
#define T_RECOMMEND_PRODUCT @"t_recommend_product"
#define T_RECOMMEND_PRODUCT_PIC @"t_recommend_product_pic"
#define T_SPECIAL_OFFER @"t_special_offer"
#define T_NEWS @"t_news"
#define T_SHOPCAR @"t_shopcar"
#define T_SHOPCAR_PIC  @"t_shopcar_pic"
#define T_LOTTERY @"t_lottery"
#define T_LOTTERY_PIC @"t_lottery_pic"

#define T_MEMBER_INFO @"t_member_info"
#define T_WEIBO_USERINFO @"t_weibo_userinfo"
#define T_MEMBER_VERSION @"t_member_version"
#define T_FAVORITE_NEWS @"t_favorite_news"
#define T_EASYBOOK_LIST @"t_easybook_list"
#define T_MYORDERS_LIST @"t_myorders_list"
#define T_ORDER_PRODUCTS_LIST @"t_order_products_list"
#define T_ORDER_PRODUCTS_PICS @"t_order_products_pics"
#define T_ADDRESS_LIST @"t_address_list"
#define T_MY_PRIZES @"t_my_prizes"
#define T_MY_PRIZES_PIC @"t_my_prizes_pic"
#define T_MYDISCOUNT_LIST @"t_mydiscount_list"
#define T_SENDSTYLE @"t_sendstyle"

#define T_FAVORITED_PRODUCTS @"t_favorited_products"
#define T_FAVORITED_NEWS @"t_favorited_news"
#define T_FAVORITED_LIKES @"t_favorited_likes"

#define T_MORE_CAT @"t_more_cat"
#define T_MORE_CATINFO @"t_more_catinfo"
#define T_RECOMMEND_APP @"t_recommend_app"
#define T_RECOMMEND_APP_AD @"t_recommend_app_ad"
#define T_ABOUTUS_INFO @"t_aboutus_info"

#define T_HISTORY_PRODUCT @"t_history_product"
#define T_HISTORY_PRODUCT_PIC @"t_history_product_pic"
#define T_HISTORY_NEW @"t_history_new"

#define T_LOTTERY_LOGS @"t_lottery_logs"
#define T_SUBBRANCH @"t_subbranch"

#define T_SHARE_CLIENT_PROMOTION @"t_share_client_promotion"
#define T_SHARE_PRODUCT_PROMOTION @"t_share_product_promotion"
#define T_FULL_PROMOTION @"t_full_promotion"

#define T_PRODUCTS_ACCESS @"t_products_access"
#define T_CATS_ACCESS @"t_cats_access"
#define T_ADS_ACCESS @"t_ads_access"
#define T_TIME_ACCESS @"t_time_access"
#define T_APNS_ACCESS @"t_apns_access"

#define T_APP_INFO @"t_app_info"

#define C_T_DEVTOKEN @"create table t_devtoken\
(id INTEGER PRIMARY KEY,\
token DOUBLE)"
enum devtoken {
	devtoken_id,
	devtoken_token
};

#define C_T_VERSION @"create table t_version\
(command_id INTEGER,\
ver INTEGER,\
desc TEXT)"
enum version {
	version_command_id,
	version_ver,
	version_desc
};

#define C_T_SYSTEM_CONFIG @"create table t_system_config\
(tag TEXT,\
value TEXT)"
enum system_config {
	system_config_tag,
    system_config_value
};

#define C_T_GUIDE_IMAGES @"create table t_guide_images\
(id INTEGER PRIMARY KEY,imageUrl TEXT,imageName TEXT )"

enum guide_images {
    guide_images_id,
	guide_images_imageUrl,
	guide_images_imageName
};

//二维码扫描历史记录
#define C_T_SCAN_HISTORY @"create table t_scan_history\
(id INTEGER PRIMARY KEY,\
type TEXT,\
info TEXT,\
result TEXT,\
created INTEGER)"
enum scan_history {
	scan_history_id,
	scan_history_type,
	scan_history_info,
    scan_history_result,
    scan_history_created
};

//广告
#define C_T_AD_LIST @"create table t_ad_list\
(id INTEGER,\
img TEXT,\
url TEXT,\
ad_type INTEGER,\
info_id INTEGER,\
sort_order INTEGER)"
enum ad_list {
	ad_list_id,
	ad_list_img,
    ad_list_url,
	ad_list_ad_type,
	ad_list_info_id,
	ad_list_sort_order
};

//首页icon
#define C_T_SPECIAL_TAGS @"create table t_special_tags\
(id INTEGER,\
name TEXT,\
icon TEXT,\
sort_order INTEGER)"
enum special_tags {
	special_tags_id,
	special_tags_name,
    special_tags_icon,
	special_tags_sort_order
};

//商品
#define C_T_PRODUCT @"create table t_product\
(id INTEGER,\
cat_id INTEGER,\
title TEXT,\
content TEXT,\
promotion_price INTEGER,\
price INTEGER,\
likes INTEGER,\
favorites INTEGER,\
unit TEXT,\
salenum INTEGER,\
comment_num INTEGER,\
sort_order INTEGER,\
is_big_pic INTEGER,\
pic TEXT,\
sum INTEGER,\
freType INTEGER,\
pics TEXT)"
enum product {
	product_id,
    product_catid,
    product_title,
    product_content,
    product_promotion_price,
    product_price,
    product_likes,
    product_favorites,
    product_unit,
    product_salenum,
    product_comment_num,
    product_sort_order,
    product_is_big_pic,
    product_pic,
    product_sum,
    product_freType,
    product_pics
};

//商品分类
#define C_T_PRODUCT_CAT @"create table t_product_cat\
(id INTEGER,\
parent_id INTEGER,\
name TEXT,\
pic TEXT,\
sort_order INTEGER,\
version INTEGER)"
enum product_cat {
	product_cat_id,
    product_cat_parent_id,
    product_cat_name,
    product_cat_pic,
    product_cat_sort_order,
    product_cat_version
};

//商品图片
#define C_T_PRODUCT_PIC @"create table t_product_pic\
(id INTEGER PRIMARY KEY,\
product_id INTEGER ,\
pic TEXT,\
thumb_pic TEXT,\
cat_id INTEGER \
)"
enum product_pic {
	product_pic_id,
	product_pic_product_id,
	product_pic_pic,
	product_pic_thumb_pic,
	product_pic_cat_id
};

//购物车
#define C_T_SHOPCAR @"create table t_shopcar\
(product_id INTEGER,product_count INTEGER,product_price TEXT,product_promotionprice TEXT,product_name TEXT,product_pic_url TEXT,isSelect INTEGER,sum INTEGER)"
enum shopcar {
	shopcar_product_id,
	shopcar_product_count,
    shopcar_product_price,
    shopcar_product_promotionprice,
    shopcar_product_name,
    shopcar_product_pic_url,
    shopcar_product_isSelect,
    shopcar_product_sum
};

#define C_T_SHOPCAR_PIC @"create table t_shopcar_pic\
(id INTEGER PRIMARY KEY,\
product_id INTEGER ,\
pic TEXT,\
thumb_pic TEXT,\
cat_id INTEGER \
)"
enum shopcar_pic {
	shopcar_pic_id,
	shopcar_pic_product_id,
	shopcar_pic_pic,
	shopcar_pic_thumb_pic,
	shopcar_pic_cat_id
};

//精品推荐
#define C_T_RECOMMEND_PRODUCT @"create table t_recommend_product\
(id INTEGER,\
cat_id INTEGER,\
title TEXT,\
content TEXT,\
promotion_price INTEGER,\
price INTEGER,\
likes INTEGER,\
favorites INTEGER,\
unit TEXT,\
salenum INTEGER,\
comment_num INTEGER,\
sort_order INTEGER,\
is_big_pic INTEGER,\
pic TEXT,\
sum INTEGER,\
freType INTEGER,\
pics TEXT)"
enum recommend_product {
	recommend_product_id,
    recommend_product_catid,
    recommend_product_title,
    recommend_product_content,
    recommend_product_promotion_price,
    recommend_product_price,
    recommend_product_likes,
    recommend_product_favorites,
    recommend_product_unit,
    recommend_product_salenum,
    recommend_product_comment_num,
    recommend_product_sort_order,
    recommend_product_is_big_pic,
    recommend_product_pic,
    recommend_product_sum,
    recommend_product_freType,
    recommend_product_pics
};

//精品推荐图片
#define C_T_RECOMMEND_PRODUCT_PIC @"create table t_recommend_product_pic\
(id INTEGER PRIMARY KEY,\
product_id INTEGER ,\
pic TEXT,\
thumb_pic TEXT,\
cat_id INTEGER \
)"
enum recommend_product_pic {
	recommend_product_pic_id,
	recommend_product_pic_product_id,
	recommend_product_pic_pic,
	recommend_product_pic_thumb_pic,
	recommend_product_pic_cat_id
};

//特价专区
#define C_T_SPECIAL_OFFER @"create table t_special_offer\
(id INTEGER PRIMARY KEY,\
name TEXT,\
banner TEXT,\
info_id1 INTEGER,\
img1 TEXT,\
info_id2 INTEGER,\
img2 TEXT,\
info_id3 INTEGER,\
img3 TEXT,\
sort_order INTEGER \
)"
enum special_offer {
	special_offer_id,
	special_offer_name,
	special_offer_banner,
	special_offer_info_id1,
	special_offer_img1,
    special_offer_info_id2,
    special_offer_img2,
    special_offer_info_id3,
    special_offer_img3,
    special_offer_sort_order
};

//活动资讯
#define C_T_NEWS @"create table t_news\
(id INTEGER,\
title TEXT,\
content TEXT,\
updatetime INTEGER,\
comments INTEGER,\
recommend TEXT,\
thumb_pic TEXT,\
recommend_img TEXT,\
sort_order INTEGER \
)"
enum news {
	news_id,
    news_title,
    news_content,
    news_updatetime,
    news_comments,
    news_recommend,
    news_thumb_pic,
    news_recommend_img,
    news_sort_order
};

//抽奖
#define C_T_LOTTERY @"create table t_lottery\
(id INTEGER,\
name TEXT,\
starttime INTEGER,\
endtime INTEGER,\
desc TEXT,\
product_name TEXT,\
product_desc TEXT,\
product_price INTEGER,\
product_sum INTEGER,\
win_num INTEGER,\
users TEXT,\
win_users TEXT,\
probability TEXT,\
status INTEGER,\
sort_order INTEGER,\
pic TEXT,\
pics TEXT)"
enum lottery {
	lottery_id,
    lottery_name,
    lottery_starttime,
    lottery_endtime,
    lottery_desc,
    lottery_product_name,
    lottery_product_desc,
    lottery_product_price,
    lottery_product_sum,
    lottery_win_num,
    lottery_users,
    lottery_win_users,
    lottery_probability,
    lottery_status,
    lottery_sort_order,
    lottery_pic,
    lottery_pics
};

//抽奖图片
#define C_T_LOTTERY_PIC @"create table t_lottery_pic\
(id INTEGER PRIMARY KEY,\
lottery_id INTEGER ,\
pic TEXT,\
thumb_pic TEXT\
)"
enum lottery_pic {
	lottery_pic_id,
	lottery_pic_lottery_id,
	lottery_pic_pic,
	lottery_pic_thumb_pic
};

//会员
#define C_T_MEMBER_INFO @"create table t_member_info\
(id INTEGER PRIMARY KEY,\
memberId INTEGER ,\
memberName TEXT ,\
memberPassword TEXT ,\
image TEXT,\
imageName TEXT\
)"
enum member_info {
	member_info_id,
	member_info_memberId,
	member_info_name,
	member_info_password,
	member_info_image,
	member_info_imageName
};

#define C_T_MEMBER_VERSION @"create table t_member_version\
(id INTEGER,\
memberId INTEGER,\
ver INTEGER,\
desc TEXT\
)"
enum member_version {
	member_version_commandId,
    member_version_memberId,
	member_version_ver,
	member_version_desc
};

#define C_T_WEIBO_USERINFO @"create table t_weibo_userinfo\
(weiboType TEXT,weiboUserName TEXT,uid TEXT,\
userProfileImage TEXT,oauthToken TEXT,oauthTokenSecret TEXT,\
accessToken TEXT,expiresTime INTEGER,status INTEGER,oauthTime INTEGER,openId TEXT,openKey TEXT)"
enum weiboinfo {
	weibo_type,
	weibo_user_name,
	weibo_user_id,
	weibo_profile_image,
	weibo_oauth_token,
	weibo_oauth_token_secret,
	weibo_access_token,
	weibo_expires_time,
	weibo_status,
	weibo_oauth_time,
	weibo_open_id,
	weibo_open_key
};

#define C_T_FAVORITE_NEWS @"create table t_favorite_news\
(id INTEGER,title TEXT, content TEXT,created INTEGER,comments INTEGER,\
recommend INTEGER,thumb_pic TEXT,recommend_img TEXT,sort_order INTEGER,stauts INTEGER)"
enum favoritenews {
	favoritenews_id,
    favoritenews_title,
	favoriyenews_content,
	favoritenews_created,
	favoritenews_comments,
	favoritenews_recommend,
	favoritenews_thumb_pic,
	favoritenews_recommend_img,
	favoritenews_sort_order,
    favoritenews_stauts
};

#define C_T_EASYBOOK_LIST @"create table t_easybook_list\
(id INTEGER,memberId INTEGER, easyname TEXT,\
consignee TEXT,mobile TEXT,address TEXT,province TEXT,\
city TEXT,area TEXT,zip_code TEXT,payway INTEGER,payment TEXT,post_id INTEGER,send_time INTEGER,issure INTEGER,invoice_type INTEGER,invoice_title_type INTEGER,invoice_title_cont TEXT,invoice_content TEXT,is_default INTEGER,updatetime INTEGER)"
enum easybook_list {
	easybook_list_id,
    easybook_list_memberId,
	easybook_list_easyname,
	easybook_list_consignee,
    easybook_list_mobile,
    easybook_list_address,
	easybook_list_province, 
    easybook_list_city,
    easybook_list_area,
    easybook_list_zip_code,
    easybook_list_payway,
    easybook_list_payment,
    easybook_list_post_id,
    easybook_list_send_time,
    easybook_list_issure,
    easybook_list_invoice_type,
    easybook_list_invoice_title_type,
    easybook_list_invoice_title_cont,
    easybook_list_invoice_content,
    easybook_list_is_default,
    easybook_list_updatetime
};

#define C_T_MYORDERS_LIST @"create table t_myorders_list\
(id INTEGER,memberId INTEGER,type INTEGER,telephone TEXT,closetime INTEGER,billno INTEGER,transaction_id TEXT,payresult INTEGER,price TEXT,contact_remark TEXT,createtime INTEGER,paytime INTEGER,confirmtime INTEGER,contact_address TEXT,contact_code TEXT,contact_mobile TEXT,contact_name TEXT,updatetime INTEGER,logistics TEXT,logistics_num TEXT,url TEXT,product_sum INTEGER,logistics_price TEXT,pri_price TEXT,full_price TEXT,pic TEXT)"
enum myorders_list {
	myorders_list_id,
    myorders_list_memberId,
	myorders_list_type,
    myorders_list_telephone,
    myorders_list_closetime,
    myorders_list_billno,
    myorders_list_transaction_id,
    myorders_list_payresult,
    myorders_list_price,
    myorders_list_contact_remark,
    myorders_list_createtime,
    myorders_list_paytime,
    myorders_list_confirmtime,
    myorders_list_contact_address,
    myorders_list_contact_code,
    myorders_list_contact_mobile,
    myorders_list_contact_name,
    myorders_list_updatetime,
    myorders_list_logistics,
    myorders_list_logistics_num,
    myorders_list_url,
    myorders_list_product_sum,
    myorders_list_logistics_price,
    myorders_list_pri_price,
    myorders_list_full_price,
    myorders_list_pic
};

#define C_T_ORDER_PRODUCTS_LIST @"create table t_order_products_list\
(order_id INTEGER,memberId INTEGER,product_num INTEGER,status INTEGER,product_id INTEGER,cat_id INTEGER,title TEXT,content TEXT,promotion_price INTEGER,price INTEGER,likes INTEGER,favorites INTEGER,unit TEXT,salenum INTEGER,comment_num INTEGER,sort_order INTEGER,is_big_pic INTEGER,pic TEXT,sum INTEGER,freType INTEGER,is_comment INTEGER)"
enum order_products_list {
    order_products_list_order_id,
    order_products_list_memberId,
	order_products_list_product_num,
    order_products_list_status,
    order_products_list_product_id,
    order_products_list_catid,
    order_products_list_title,
    order_products_list_content,
    order_products_list_promotion_price,
    order_products_list_price,
    order_products_list_likes,
    order_products_list_favorites,
    order_products_list_unit,
    order_products_list_salenum,
    order_products_list_comment_num,
    order_products_list_sort_order,
    order_products_list_is_big_pic,
    order_products_list_pic,
    order_products_list_sum,
    order_products_list_freType,
    order_products_list_is_comment
};

#define C_T_ORDER_PRODUCTS_PICS @"create table t_order_products_pics\
(order_id INTEGER,product_id INTEGER,memberId INTEGER,pic TEXT,thumb_pic TEXT)"
enum book_products_pics {
	book_products_pics_order_id,
    book_products_pics_product_id,
    book_products_pics_memberId,
    book_products_pics_pic,
    book_products_pics_thumb_pic
};

#define C_T_ADDRESS_LIST @"create table t_address_list\
(id INTEGER,memberId INTEGER,name TEXT,mobile TEXT,province TEXT,city TEXT,area TEXT,address TEXT,zip_code TEXT,updatetime INTEGER,isPrizeDefault INTEGER,isReceiveDefault INTEGER)"
enum address_list {
	address_list_id,
    address_list_memberId,
	address_list_name,
    address_list_mobile,
	address_list_province,
    address_list_city,
    address_list_area,
    address_list_address,
    address_list_zip_code,
    address_list_updatetime,
    address_list_isPrizeDefault,
    address_list_isReceiveDefault
};

#define C_T_MY_PRIZES @"create table t_my_prizes\
(id INTEGER,\
memberId INTEGER,\
name TEXT,\
starttime INTEGER,\
endtime INTEGER ,\
pic TEXT,\
des TEXT,\
isreceive INTEGER,\
created INTEGER,\
product_name TEXT,\
product_des TEXT,\
product_price INTEGER,\
product_sum INTEGER,\
pics TEXT)"

enum my_prizes {
    my_prizes_id,
    my_prizes_memberId,
    my_prizes_name,
	my_prizes_starttime,
	my_prizes_endtime,
	my_prizes_pic,
	my_prizes_des,
	my_prizes_isreceive,
	my_prizes_created,
	my_prizes_product_name,
	my_prizes_product_des,
	my_prizes_product_price,
	my_prizes_product_sum,
    my_prizes_pics
};

#define C_T_MY_PRIZES_PIC @"create table t_my_prizes_pic\
(id INTEGER PRIMARY KEY,\
prizeId INTEGER ,\
pic TEXT,\
thumb_pic TEXT)"
enum my_prizes_pic {
	my_prizes_pic_id,
    my_prizes_pic_prizeId,
	my_prizes_pic_pic,
	my_prizes_pic_thumb_pic
};

#define C_T_MYDISCOUNT_LIST @"create table t_mydiscount_list\
(id INTEGER,memberId INTEGER, billno TEXT,name TEXT,tip TEXT,price TEXT,unitname TEXT,starttime INTEGER,endtime INTEGER,imageurl TEXT,desc TEXT,status INTEGER,url TEXT,updatetime INTEGER,useprice TEXT)"
enum mydiscountlist {
	mydiscountlist_id,
	mydiscountlist_memberId,
	mydiscountlist_billno,
    mydiscountlist_name,
    mydiscountlist_tip,
    mydiscountlist_price,
    mydiscountlist_unitname,
    mydiscountlist_starttime,
    mydiscountlist_endtime,
    mydiscountlist_imageurl,
    mydiscountlist_desc,
    mydiscountlist_status,
    mydiscountlist_url,
    mydiscountlist_updatetime,
    mydiscountlist_useprice
};

#define C_T_SENDSTYLE @"create table t_sendstyle\
(id INTEGER,\
name TEXT,\
price INTEGER,\
content TEXT,\
url TEXT)"

enum sendstyle {
    sendstyle_id,
    sendstyle_name,
    sendstyle_price,
	sendstyle_content,
	sendstyle_url
};

enum my_commentlist {
    my_commentlist_status,
    my_commentlist_id,
    my_commentlist_cat_id,
	my_commentlist_title,
	my_commentlist_content,
	my_commentlist_promotion_price,
	my_commentlist_price,
	my_commentlist_likes,
	my_commentlist_favorites,
	my_commentlist_unit,
	my_commentlist_salenum,
	my_commentlist_comment_num,
    my_commentlist_sort_order,
	my_commentlist_is_big_pic,
    my_commentlist_pic,
    my_commentlist_sum,
    my_commentlist_fre_type,
    my_commentlist_info_id,
    my_commentlist_order_id,
    my_commentlist_commentContent,
    my_commentlist_commentCreated,
    my_commentlist_pics
};

#define C_T_SHARE_CLIENT_PROMOTION @"create table t_share_client_promotion\
(proid INTEGER PRIMARY KEY,\
name TEXT,\
tip TEXT,\
price TEXT,\
startTime INTEGER,\
endTime INTEGER,\
image TEXT,\
imageName TEXT,\
desc TEXT,\
shareContent TEXT,\
shareImg TEXT,\
shareImgName TEXT,\
unitName TEXT,\
hasShow INTEGER)"
enum shareclientpromotion {
	shareclientpromotion_proid,
	shareclientpromotion_name,
	shareclientpromotion_tip,
    shareclientpromotion_price,
    shareclientpromotion_startTime,
    shareclientpromotion_endTime,
    shareclientpromotion_img,
    shareclientpromotion_img_name,
    shareclientpromotion_desc,
    shareclientpromotion_shareContent,
    shareclientpromotion_shareImg,
    shareclientpromotion_shareImg_name,
    shareclientpromotion_unitName,
    shareclientpromotion_hasShow
};

#define C_T_SHARE_PRODUCT_PROMOTION @"create table t_share_product_promotion\
(proid INTEGER PRIMARY KEY,\
name TEXT,\
price TEXT,\
startTime INTEGER,\
endTime INTEGER,\
image TEXT,\
imageName TEXT,\
desc TEXT,\
unitName TEXT,\
usePrice TEXT)"
enum shareproductpromotion {
	shareproductpromotion_proid,
	shareproductpromotion_name,
    shareproductpromotion_price,
    shareproductpromotion_startTime,
    shareproductpromotion_endTime,
    shareproductpromotion_image,
    shareproductpromotion_image_name,
    shareproductpromotion_desc,
    shareproductpromotion_unitName,
    shareproductpromotion_usePrice
};

#define C_T_FULL_PROMOTION @"create table t_full_promotion\
(fid INTEGER,\
name TEXT,\
type INTEGER,\
total TEXT,\
price TEXT,\
startTime INTEGER,\
endTime INTEGER)"
enum fullpromotion {
	fullpromotion_fid,
	fullpromotion_name,
    fullpromotion_type,
    fullpromotion_total,
    fullpromotion_price,
    fullpromotion_startTime,
    fullpromotion_endTime
    
};

#define C_T_FAVORITED_PRODUCTS @"create table t_favorited_products\
(user_id INTEGER,\
product_id INTEGER \
)"
enum favorited_products {
    favorited_products_user_id,
    favorited_products_product_id
};

#define C_T_FAVORITED_NEWS @"create table t_favorited_news\
(user_id INTEGER,\
news_id INTEGER \
)"
enum favorited_news {
    favorited_news_user_id,
    favorited_news_news_id
};

#define C_T_FAVORITED_LIKES @"create table t_favorited_likes\
(user_id INTEGER,\
likes_id INTEGER \
)"
enum favorited_likes {
    favorited_likes_user_id,
    favorited_likes_likes_id
};

//更多分类
#define C_T_MORE_CAT @"create table t_more_cat\
(id INTEGER PRIMARY KEY,catId INTEGER,name TEXT,imageurl TEXT,imagename TEXT,version INTEGER,sort INTEGER)"
enum morecat {
    morecat_id,
	morecat_catId,
	morecat_catName,
	morecat_catImageurl,
    morecat_catImagename,
    morecat_version,
    morecat_sort
};

#define C_T_MORE_CATINFO @"create table t_more_catinfo\
(id INTEGER PRIMARY KEY,cat_Id INTEGER,catId INTEGER,imageurl TEXT,imagename TEXT,desc TEXT,sort TEXT,updatetime INTEGER)"
enum morecatinfo {
    morecatinfo_id,
    morecatinfo_cat_Id,
	morecatinfo_catId,
	morecatinfo_catImageurl,
    morecatinfo_catImagename,
    morecatinfo_desc,
    morecatinfo_sort,
    morecatinfo_updatetime
};

#define C_T_RECOMMEND_APP @"create table t_recommend_app\
(id INTEGER PRIMARY KEY,\
name TEXT,\
url TEXT,\
icon TEXT,\
`desc` TEXT,\
sort_order INTEGER\
)"
enum recommand_app {
	recommand_app_id,
    recommand_app_name,
	recommand_app_url,
	recommand_app_icon,
	recommand_app_desc,
	recommand_app_sort_order
};

#define C_T_RECOMMEND_APP_AD @"create table t_recommend_app_ad\
(id INTEGER PRIMARY KEY,\
url TEXT,\
img TEXT)"
enum recommend_app_ad {
    recommend_app_ad_id,
	recommend_app_ad_url,
    recommend_app_ad_img
};

#define C_T_ABOUTUS_INFO @"create table t_aboutus_info\
(logo TEXT,logo_name TEXT,tel TEXT,mobile TEXT,fax TEXT,email TEXT,description TEXT)"
enum aboutus_info {
	aboutus_info_logo,
	aboutus_info_logo_name,
	aboutus_info_tel,
	aboutus_info_mobile,
	aboutus_info_fax,
	aboutus_info_email,
	aboutus_info_description
};

//历史记录
#define C_T_HISTORY_PRODUCT @"create table t_history_product\
(id INTEGER,\
cat_id INTEGER,\
title TEXT,\
content TEXT,\
promotion_price INTEGER,\
price INTEGER,\
likes INTEGER,\
favorites INTEGER,\
unit TEXT,\
salenum INTEGER,\
comment_num INTEGER,\
sort_order INTEGER,\
is_big_pic INTEGER,\
pic TEXT,\
sum INTEGER,\
freType INTEGER,\
pics TEXT)"
enum history_product {
	history_product_id,
    history_product_catid,
    history_product_title,
    history_product_content,
    history_product_promotion_price,
    history_product_price,
    history_product_likes,
    history_product_favorites,
    history_product_unit,
    history_product_salenum,
    history_product_comment_num,
    history_product_sort_order,
    history_product_is_big_pic,
    history_product_pic,
    history_product_sum,
    history_product_freType,
    history_product_pics
};

//历史记录图片
#define C_T_HISTORY_PRODUCT_PIC @"create table t_history_product_pic\
(id INTEGER PRIMARY KEY,\
product_id INTEGER ,\
pic TEXT,\
thumb_pic TEXT,\
cat_id INTEGER \
)"
enum history_product_pic {
    history_product_pic_id,
	history_product_pic_product_id,
	history_product_pic_pic,
	history_product_pic_thumb_pic,
	history_product_pic_cat_id
};


#define C_T_HISTORY_NEW @"create table t_history_new\
(id INTEGER,\
title TEXT,\
content TEXT,\
updatetime INTEGER,\
comments INTEGER,\
recommend TEXT,\
thumb_pic TEXT,\
recommend_img TEXT,\
sort_order INTEGER \
)"
enum history_new {
	history_new_id,
    history_new_title,
    history_new_content,
    history_new_updatetime,
    history_new_comments,
    history_new_recommend,
    history_new_thumb_pic,
    history_new_recommend_img,
    history_new_sort_order
};

//摇奖记录
#define C_T_LOTTERY_LOGS @"create table t_lottery_logs\
(id INTEGER PRIMARY KEY,\
date TEXT,\
count INTEGER \
)"
enum lottery_logs {
	lottery_logs_id,
	lottery_logs_date,
	lottery_logs_count
};

#define C_T_SUBBRANCH @"create table t_subbranch(id INTEGER PRIMARY KEY,name TEXT,\
tel TEXT,addr TEXT,location TEXT)"
enum subbranch{
	subbranch_id,
	subbranch_name,
	subbranch_tel,
	subbranch_addr,
	subbranch_location
};


#define C_T_PRODUCTS_ACCESS @"create table t_products_access(productId INTEGER ,currentTime INTEGER,stayTime INTEGER,visitCount INTEGER,type INTEGER,infoId INTEGER)"
enum products_access{
	products_access_productId,
	products_access_currentTime,
	products_access_stayTime,
	products_access_visitCount,
	products_access_type,
    products_access_infoId
};

#define C_T_CATS_ACCESS @"create table t_cats_access(catId INTEGER ,currentTime INTEGER,visitCount INTEGER)"
enum cats_access{
	cats_access_catId,
	cats_access_currentTime,
	cats_access_visitCount
};

#define C_T_ADS_ACCESS @"create table t_ads_access(adId INTEGER ,currentTime INTEGER,visitCount INTEGER)"
enum ads_access{
	ads_access_adId,
	ads_access_currentTime,
	ads_access_visitCount
};

#define C_T_TIME_ACCESS @"create table t_time_access(currentTime INTEGER,stayTime INTEGER)"
enum time_access{
	time_access_currentTime,
	time_access_stayTime
};

#define C_T_APNS_ACCESS @"create table t_apns_access(type INTEGER,infoId INTEGER,currentTime INTEGER)"
enum apns_access{
	apns_access_type,
	apns_access_infoId,
	apns_access_currentTime
};

// tpye=0 自动升级  ；  tpye=1 评分提醒
#define C_T_APP_INFO @"create table t_app_info(type INTEGER, ver INTEGER, url TEXT,remide INTEGER ,remark TEXT)"
enum app_info {
	app_info_type,
	app_info_ver,
	app_info_url,
	app_info_remide,
    app_info_remark
};

@interface DBOperate : NSObject {
    
}

//创建表
+(BOOL)createTable;

//////插入一整行，array数组元素个数需与该表列数一致  忽略第一个字段id 因为已经设着它为自增
+(BOOL)insertData:(NSArray *)data tableName:(NSString *)aName;

//插入一行不忽略第一个id字段
+(BOOL)insertDataWithnotAutoID:(NSArray *)data tableName:(NSString *)aName;

//俩个条件
+(NSArray *)queryData:(NSString *)aName theColumn:(NSString *)aColumn equalValue:(id)aColumnValue theColumn:(NSString*)bColumn equalValue:(id)bColumnValue;

//俩个条件 一个否条件
+(NSArray *)queryData:(NSString *)aName theColumn:(NSString *)aColumn noEqualValue:(id)aColumnValue theColumn:(NSString*)bColumn equalValue:(id)bColumnValue;

////////查询整个表，或是查询某个条件下的一整行
+(NSArray *)queryData:(NSString *)aName theColumn:(NSString *)aColumn theColumnValue:(NSString *)aColumnValue withAll:(BOOL)yesNO;

//查询整个表 支持一个条件跟排序
+(NSMutableArray *)queryData:(NSString *)aName theColumn:(NSString *)aColumn theColumnValue:(NSString *)aColumnValue orderBy:(NSString *)orderByString orderType:(NSString *)orderTypeString withAll:(BOOL)yesNO;

//查询整个表 支持多个条件跟排序
+(NSMutableArray *)queryData:(NSString *)aName theColumn:(NSString *)aColumn theColumnValue:(NSString *)aColumnValue orderByOne:(NSString *)orderByStringOne orderTypeOne:(NSString *)orderTypeStringOne orderByTwo:(NSString *)orderByStringTwo orderTypeTwo:(NSString *)orderTypeStringTwo withAll:(BOOL)yesNO;
//查询整个表 支持多个条件跟排序2
+(NSMutableArray *)queryData:(NSString *)aName theColumn:(NSString *)aColumn theColumnValue:(NSString *)aColumnValue theColumn:(NSString *)bColumn theColumnValue:(NSString *)bColumnValue orderByOne:(NSString *)orderByStringOne orderTypeOne:(NSString *)orderTypeStringOne orderByTwo:(NSString *)orderByStringTwo orderTypeTwo:(NSString *)orderTypeStringTwo withAll:(BOOL)yesNO;

//////查询某列一个值或是返回一整列的值
+(NSArray *)selectColumn:(NSString *)theColumn 
			   tableName:(NSString *)aTableName 
			   conColumn:(NSString *)aColumn 
		  conColumnValue:(NSString *)aColumnValue 
		 withWholeColumn:(BOOL)yesNO;

////////////删除某个条件下的某一行 如 delete from tableName where colunm=aValue
+(BOOL)deleteData:(NSString *)tableName tableColumn:(NSString *)column columnValue:(id)aValue;

//删除整个表数据
+(BOOL)deleteData:(NSString *)tableName;

//1个条件更新 数据
+(BOOL)updateData:(NSString *)tableName tableColumn:(NSString *)column columnValue:(NSString *)aValue 
  conditionColumn:(NSString *)conColumn conditionColumnValue:(id)conValue;

//2个条件更新 数据
+(BOOL)updateData:(NSString *)tableName tableColumn:(NSString *)column columnValue:(NSString *)aValue 
 conditionColumn1:(NSString *)conColumn1 conditionColumnValue1:(id)conValue1
 conditionColumn2:(NSString *)conColumn2 conditionColumnValue2:(id)conValue2;

///////按正序或倒序查询某表的某列前n条记录
+(NSArray *)selectTopNColumn:(NSString *)theColumn tableName:(NSString *)aTableName rowNum:(NSInteger)n;

///倒序或是正序查询一列
//select theColumn from aTableName where aColumn=aColumnValue order by ID descOrAsc
+(NSArray *)selectColumnWithOrder:(NSString *)theColumn 
						tableName:(NSString *)aTableName 
						conColumn:(NSString *)aColumn 
				   conColumnValue:(NSString *)aColumnValue 
						  orderBy:(NSString *)descOrAsc;


//add by zhanghao
+(NSArray *)getSearchIndex:(NSString *)tableName;

+(NSArray *)getContentForIndex:(NSString *)index InTable:(NSString *)tableName;

+(NSArray *)qureyWithTwoConditions:(NSString *)tabelName 
						 ColumnOne:(NSString *)columnOne 
						  valueOne:(NSString *)valueOne 
						 columnTwo:(NSString *)columnTwo
						  valueTwo:(NSString *)valueTwo;


+(BOOL)updateWithTwoConditions:(NSString *)tabelName 
					 theColumn:(NSString *)Column 
				theColumnValue:(NSString *)aValue 
					 ColumnOne:(NSString *)columnOne 
					  valueOne:(NSString *)valueOne 
					 columnTwo:(NSString *)columnTwo 
					  valueTwo:(NSString *)valueTwo;

+(BOOL)deleteDataWithTwoConditions:(NSString *)tableName 
						 columnOne:(NSString *)columnOne 
						  valueOne:(NSString *)valueOne 
						 columnTwo:(NSString *)columnTwo
						  valueTwo:(NSString *)valueTwo;
//查询全国省市区
+ (NSMutableArray *)getAllIDFromPri:(NSString *)selectContent  whereContent:(NSString *)whereContent;

//查询商品记录 整合图片记录
+(NSArray *)queryData:(NSString *)aName thePicName:(NSString *)picName theColumn:(NSString *)aColumn theColumnValue:(NSString *)aColumnValue orderBy:(NSString *)orderByString orderType:(NSString *)orderTypeString withAll:(BOOL)yesNO;
//查询我的奖品记录 整合图片记录
+(NSArray *)queryData:(NSString *)aName thePicName:(NSString *)picName theColumn:(NSString *)aColumn theColumnValue:(NSString *)aColumnValue orderByOne:(NSString *)orderByStringOne orderTypeOne:(NSString *)orderTypeStringOne orderByTwo:(NSString *)orderByStringTwo orderTypeTwo:(NSString *)orderTypeStringTwo withAll:(BOOL)yesNO;

+(NSArray *)queryData:(NSString *)aName oneColumn:(NSString *)aColumn equalValue:(id)aColumnValue twoColumn:(NSString*)bColumn equalValue:(id)bColumnValue;

//两个条件 在区间内查找
+(NSArray *)queryData:(NSString *)aName oneColumn:(NSString *)aColumn equalValue:(id)aColumnValue twoColumn:(NSString*)bColumn equalValue:(id)bColumnValue;
+(NSArray *)queryData:(NSString *)aName oneColumn:(NSString *)aColumn equalValue:(id)aColumnValue twoColumn:(NSString*)bColumn equalValue:(id)bColumnValue threeColumn:(NSString *)cColumn equalValue:(id)cColumnValue;
//两个条件 在区间内删除
+(BOOL)deleteDataWithTwoConditions:(NSString *)tableName
						 oneColumn:(NSString *)columnOne
						  oneValue:(NSString *)valueOne
						 twoColumn:(NSString *)columnTwo
						  twoValue:(NSString *)valueTwo;
//三个条件 在区间内删除
+(BOOL)deleteDataWithTwoConditions:(NSString *)tableName
						 oneColumn:(NSString *)columnOne
						  oneValue:(NSString *)valueOne
						 twoColumn:(NSString *)columnTwo
						  twoValue:(NSString *)valueTwo
                       threeColumn:(NSString *)columnThree
                        threeValue:(NSString *)valueThree;
//查询整个表 支持多个条件跟排序1
+(NSArray *)queryData:(NSString *)aName theColumn:(NSString *)aColumn theColumnValue:(NSString *)aColumnValue theColumn:(NSString *)bColumn theColumnValue:(NSString *)bColumnValue orderByOne:(NSString *)orderByStringOne orderTypeOne:(NSString *)orderTypeStringOne withAll:(BOOL)yesNO;

@end
