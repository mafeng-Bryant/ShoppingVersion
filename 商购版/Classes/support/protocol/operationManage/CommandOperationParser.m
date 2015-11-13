//
//  CommonOperationParser.m
//  Profession
//
//  Created by MC374 on 12-8-9.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CommandOperationParser.h"
#import "DBOperate.h"
#import "Common.h"
#import "SBJson.h"
#import "NSObject+SBJson.h"
#import "FileManager.h"

@implementation CommandOperationParser

+(BOOL)updateVersion:(int)commanId versionID:(NSNumber*)versionid desc:(NSString*)describe{
	if (versionid==nil) {
		return NO;
	}
	NSArray *ar_ver = [NSArray arrayWithObjects:[NSNumber numberWithInt:commanId],versionid,describe,nil];
	[DBOperate deleteData:T_VERSION tableColumn:@"command_id" columnValue:[NSNumber numberWithInt:commanId]];
	[DBOperate insertDataWithnotAutoID:ar_ver tableName:T_VERSION];
	return YES;
}

+(BOOL)updateMemberVersion:(int)commanId withUserId:(int)_userId versionID:(NSNumber*)versionid desc:(NSString*)describe
{
	if (versionid==nil) {
		return NO;
	}
	NSArray *ar_ver = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:commanId],[NSNumber numberWithInt:_userId],versionid,describe,nil];
    [DBOperate deleteDataWithTwoConditions:T_MEMBER_VERSION columnOne:@"id" valueOne:[NSString stringWithFormat:@"%d",commanId] columnTwo:@"memberId" valueTwo:[NSString stringWithFormat:@"%d", _userId]];
	[DBOperate insertDataWithnotAutoID:ar_ver tableName:T_MEMBER_VERSION];
	return YES;
}

//首页
+(NSMutableArray*)parseHome:(NSString*)jsonResult getVersion:(int*)ver
{
    *ver = NO_UPDATE;
	
	NSDictionary *resultDic = [jsonResult JSONValue];
	
	//广告版本号
	NSNumber *adVer = [resultDic objectForKey:@"ad_ver"];
    
    //标签版本号
	NSNumber *tagsVer = [resultDic objectForKey:@"tags_ver"];
    
    //是否显示精品推荐
    NSNumber *isShowRecommend = [resultDic objectForKey:@"isdisplay_recommend"];
    
    //是否显示特价专区
    NSNumber *isShowSpecialOffer = [resultDic objectForKey:@"isdisplay_specialoffer"];
	
	//更新广告数据
	NSArray *adListArray = [resultDic objectForKey:@"infos"];
	
	//删除广告的数据
	NSArray *adDelsArray = [resultDic objectForKey:@"ad_dels"];
    
    //更新标签数据
    NSArray *tagsListArray = [resultDic objectForKey:@"special_tags"];
    
    //删除广告的数据
	NSArray *tagsDelsArray = [resultDic objectForKey:@"tags_dels"];
	
	//删除需要更新的广告数据
	if ([adDelsArray count] > 0)
	{
		for(NSDictionary *delDic in adDelsArray)
		{
			NSNumber *delID = [NSNumber numberWithInteger:[[delDic objectForKey:@"id"] intValue]];
            
            //这里还要删除缓存图片
            
            //删除记录
			[DBOperate deleteData:T_AD_LIST
					  tableColumn:@"id" 
					  columnValue:delID];
			
		}
		*ver = NEED_UPDATE;
	}
	
	//保存广告数据
	if ([adListArray count] > 0) 
	{
		for (int i = 0; i < [adListArray count];i++ ) 
		{
			//非空判断 例子
			//[infoArray addObject:[infoDic objectForKey:@"xxx"] == [NSNull null] ? @"" : [infoDic objectForKey:@"xxx"]];
			
			NSDictionary *infoDic = [adListArray objectAtIndex:i];
			NSMutableArray *infoArray = [[NSMutableArray alloc]init];
			[infoArray addObject:[infoDic objectForKey:@"id"]];
			[infoArray addObject:[infoDic objectForKey:@"img"]];
			[infoArray addObject:[infoDic objectForKey:@"url"]];
			[infoArray addObject:[infoDic objectForKey:@"ad_type"]];
			[infoArray addObject:[infoDic objectForKey:@"info_id"]];
            [infoArray addObject:[infoDic objectForKey:@"sort_order"]];
            
			//插入数据库
			[DBOperate insertDataWithnotAutoID:infoArray tableName:T_AD_LIST];
			
			[infoArray release];
		}
		*ver = NEED_UPDATE;
	}
    
    //删除需要更新的标签数据
	if ([tagsDelsArray count] > 0)
	{
		for(NSDictionary *delDic in tagsDelsArray)
		{
			NSNumber *delID = [NSNumber numberWithInteger:[[delDic objectForKey:@"id"] intValue]];
            
            //这里还要删除缓存图片
            
            //删除记录
			[DBOperate deleteData:T_SPECIAL_TAGS
					  tableColumn:@"id" 
					  columnValue:delID];
			
		}
		*ver = NEED_UPDATE;
	}
	
	//保存需要更新的标签数据
	if ([tagsListArray count] > 0) 
	{
		for (int i = 0; i < [tagsListArray count];i++ ) 
		{
			//非空判断 例子
			//[infoArray addObject:[infoDic objectForKey:@"xxx"] == [NSNull null] ? @"" : [infoDic objectForKey:@"xxx"]];
			
			NSDictionary *infoDic = [tagsListArray objectAtIndex:i];
			NSMutableArray *infoArray = [[NSMutableArray alloc]init];
			[infoArray addObject:[infoDic objectForKey:@"id"]];
			[infoArray addObject:[infoDic objectForKey:@"name"]];
			[infoArray addObject:[infoDic objectForKey:@"icon"]];
			[infoArray addObject:[infoDic objectForKey:@"sort_order"]];
            
			//插入数据库
			[DBOperate insertDataWithnotAutoID:infoArray tableName:T_SPECIAL_TAGS];
			
			[infoArray release];
		}
		*ver = NEED_UPDATE;
	}
    
    //是否显示精品推荐,特价专区 入库
    
    [DBOperate deleteData:T_SYSTEM_CONFIG tableColumn:@"tag" columnValue:@"isShowRecommend"];
    [DBOperate deleteData:T_SYSTEM_CONFIG tableColumn:@"tag" columnValue:@"isShowSpecialOffer"];
    
    NSMutableArray *isShowRecommendArray = [[NSMutableArray alloc]init];
    [isShowRecommendArray addObject:@"isShowRecommend"];
    [isShowRecommendArray addObject:isShowRecommend];
    [DBOperate insertDataWithnotAutoID:isShowRecommendArray tableName:T_SYSTEM_CONFIG];
    [isShowRecommendArray release];
    
    NSMutableArray *isShowSpecialOfferArray = [[NSMutableArray alloc]init];
    [isShowSpecialOfferArray addObject:@"isShowSpecialOffer"];
    [isShowSpecialOfferArray addObject:isShowSpecialOffer];
    [DBOperate insertDataWithnotAutoID:isShowSpecialOfferArray tableName:T_SYSTEM_CONFIG];
    [isShowSpecialOfferArray release];
	
	
	//更新版本广告号
    [self updateVersion:OPERAT_AD_REFRESH versionID:adVer desc:@"首页广告"];
    
    //更新版本标签号
    [self updateVersion:OPERAT_SPECIAL_TAGS_REFRESH versionID:tagsVer desc:@"首页icon标签"];
	
	return nil;
}

//商品分类
+(NSMutableArray*)parseProductCatList:(NSString*)jsonResult getVersion:(int*)ver
{
    *ver = NO_UPDATE;
	
	NSDictionary *resultDic = [jsonResult JSONValue];
	
	//版本号
	NSNumber *newVer = [resultDic objectForKey:@"ver"];
	
	//更新数据
	NSArray *listArray = [resultDic objectForKey:@"cats"];
	
	//删除的数据
	NSArray *delsArray = [resultDic objectForKey:@"dels"];
	
	//删除数据
	if ([delsArray count] > 0)
	{
		for(NSDictionary *delDic in delsArray)
		{
			NSNumber *delID = [NSNumber numberWithInteger:[[delDic objectForKey:@"id"] intValue]];
			[DBOperate deleteData:T_PRODUCT_CAT 
					  tableColumn:@"id" 
					  columnValue:delID];
            
			//这里还要删除缓存图片
            
			//删除对应的内容数据
			[DBOperate deleteData:T_PRODUCT
					  tableColumn:@"cat_id" 
					  columnValue:delID];
		}
		*ver = NEED_UPDATE;
	}
	
	//保存数据
	if ([listArray count] > 0) 
	{
		for (int i = 0; i < [listArray count];i++ ) 
		{
			NSDictionary *infoDic = [listArray objectAtIndex:i];
			NSMutableArray *infoArray = [[NSMutableArray alloc]init];
			[infoArray addObject:[infoDic objectForKey:@"id"]];
            [infoArray addObject:[infoDic objectForKey:@"parent_id"]];
			[infoArray addObject:[infoDic objectForKey:@"name"]];
            [infoArray addObject:[infoDic objectForKey:@"cat_pic"]];
			[infoArray addObject:[infoDic objectForKey:@"sort_order"]];
			[infoArray addObject:@"0"];
			//插入数据库
			[DBOperate insertDataWithnotAutoID:infoArray tableName:T_PRODUCT_CAT];
			[infoArray release];
		}
		*ver = NEED_UPDATE;
	}
	
	//更新版本号
	[self updateVersion:OPERAT_PRODUCT_CAT_REFRESH versionID:newVer desc:@"商品分类"];
	
	return nil;
}

//商品列表
+(NSMutableArray*)parseProductList:(NSString*)jsonResult getVersion:(int*)ver withParam:(NSMutableDictionary*)param
{
    *ver = NO_UPDATE;
	
	int catId = [[param objectForKey:@"cat_id"] intValue];
	
	NSDictionary *resultDic = [jsonResult JSONValue];
	
	//版本号
	NSNumber *newVer = [resultDic objectForKey:@"ver"];
	
	//更新数据
	NSArray *listArray = [resultDic objectForKey:@"products"];
	
	//删除的数据
	NSArray *delsArray = [resultDic objectForKey:@"dels"];
	
	//删除数据
	if ([delsArray count] > 0)
	{
		for(NSDictionary *delDic in delsArray)
		{
			NSNumber *delID = [NSNumber numberWithInteger:[[delDic objectForKey:@"id"] intValue]];
            
            [DBOperate deleteDataWithTwoConditions:T_PRODUCT 
                                         columnOne:@"id"
                                          valueOne:[NSString stringWithFormat:@"%@",delID]
                                         columnTwo:@"cat_id"
                                          valueTwo:[param objectForKey:@"cat_id"]];
            
            //这里还要删除缓存图片
            
			//删除对应的图片记录
            [DBOperate deleteDataWithTwoConditions:T_PRODUCT_PIC
                                         columnOne:@"product_id" 
                                          valueOne:[NSString stringWithFormat:@"%@",delID] 
                                         columnTwo:@"cat_id"
                                          valueTwo:[NSString stringWithFormat:@"%d",catId]];
			
			
		}
		*ver = NEED_UPDATE;
	}
	
	//保存数据
	if ([listArray count] > 0) 
	{
		for (int i = 0; i < [listArray count];i++ ) 
		{
			//非空判断 例子
			//[infoArray addObject:[infoDic objectForKey:@"xxx"] == [NSNull null] ? @"" : [infoDic objectForKey:@"xxx"]];
			
			NSDictionary *infoDic = [listArray objectAtIndex:i];
			NSMutableArray *infoArray = [[NSMutableArray alloc]init];
			[infoArray addObject:[infoDic objectForKey:@"id"]];
			//[infoArray addObject:[infoDic objectForKey:@"cate_id"]];
			[infoArray addObject:[NSNumber numberWithInt: catId]];
			[infoArray addObject:[infoDic objectForKey:@"title"]];
			[infoArray addObject:[infoDic objectForKey:@"content"]];
			[infoArray addObject:[infoDic objectForKey:@"promotion_price"]];
			[infoArray addObject:[infoDic objectForKey:@"price"]];
			[infoArray addObject:[infoDic objectForKey:@"likes"]];
			[infoArray addObject:[infoDic objectForKey:@"favorites"]];
			[infoArray addObject:[infoDic objectForKey:@"unit"]];
			[infoArray addObject:[infoDic objectForKey:@"salenum"]];
            [infoArray addObject:[infoDic objectForKey:@"comm_num"]];
			[infoArray addObject:[infoDic objectForKey:@"sort_order"]];
			[infoArray addObject:[infoDic objectForKey:@"is_big_pic"]];
            [infoArray addObject:[infoDic objectForKey:@"pic"]];
            [infoArray addObject:[infoDic objectForKey:@"sum"]];
            [infoArray addObject:[infoDic objectForKey:@"fre_type"]];
            [infoArray addObject:@""];
            
			//插入数据库
			[DBOperate insertDataWithnotAutoID:infoArray tableName:T_PRODUCT];
			
			//图片入库
			NSArray *picArray = [infoDic objectForKey:@"pics"];
			for (NSDictionary *picDic in picArray ) 
			{
				NSMutableArray *pic = [[NSMutableArray alloc] init];
				[pic addObject:[infoDic objectForKey:@"id"]];
				[pic addObject:[picDic objectForKey:@"img_path"]];
				[pic addObject:[picDic objectForKey:@"thumb_pic"]];
                [pic addObject:[NSNumber numberWithInt: catId]];
				[DBOperate insertData:pic tableName:T_PRODUCT_PIC];
				[pic release];
			}
			
			[infoArray release];
		}
		*ver = NEED_UPDATE;
	}
	
	//保证数据只有20条
	NSMutableArray *productItems = (NSMutableArray *)[DBOperate queryData:T_PRODUCT theColumn:@"cat_id" theColumnValue:[NSString stringWithFormat:@"%d",catId] orderBy:@"sort_order" orderType:@"desc" withAll:NO];
	
	for (int i = [productItems count] - 1; i > 19; i--)
	{
		NSArray *productArray = [productItems objectAtIndex:i];
		NSString *productId = [productArray objectAtIndex:product_id];
		[DBOperate deleteData:T_PRODUCT tableColumn:@"id" columnValue:productId];
        
        //这里还要删除缓存图片
        
        [DBOperate deleteDataWithTwoConditions:T_PRODUCT_PIC
                                     columnOne:@"product_id" 
                                      valueOne:[NSString stringWithFormat:@"%@",productId] 
                                     columnTwo:@"cat_id"
                                      valueTwo:[NSString stringWithFormat:@"%d",catId]];
        
	}
	
	
	//更新版本号
    [DBOperate updateData:T_PRODUCT_CAT 
              tableColumn:@"version" 
              columnValue:[NSString stringWithFormat:@"%@",newVer] 
          conditionColumn:@"id"
     conditionColumnValue:[NSString stringWithFormat:@"%d",catId]];
	
	return nil;
}

//商品更多
+(NSMutableArray*)parseProductMoreList:(NSString*)jsonResult getVersion:(int*)ver withParam:(NSMutableDictionary*)param
{
    *ver = NO_UPDATE;
	
	int catId = [[param objectForKey:@"cat_id"] intValue];
	
	NSDictionary *resultDic = [jsonResult JSONValue];
	
	//版本号
	//NSNumber *newVer = [resultDic objectForKey:@"ver"];
	
	//更新数据
	NSArray *listArray = [resultDic objectForKey:@"products"];
	
	
	//插入数据
	NSMutableArray *moreArray = [[NSMutableArray alloc]init];
	
	if ([listArray count] > 0) 
	{
		for (int i = 0; i < [listArray count]; i++ ) 
		{
			//非空判断 例子
			//[infoArray addObject:[infoDic objectForKey:@"xxx"] == [NSNull null] ? @"" : [infoDic objectForKey:@"xxx"]];
			
			NSDictionary *infoDic = [listArray objectAtIndex:i];
			NSMutableArray *infoArray = [[NSMutableArray alloc]init];
			[infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"id"]]];
			//[infoArray addObject:[infoDic objectForKey:@"cate_id"]];
			[infoArray addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt: catId]]];
			[infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"title"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"content"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"promotion_price"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"price"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"likes"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"favorites"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"unit"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"salenum"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"comm_num"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"sort_order"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"is_big_pic"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"pic"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"sum"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"fre_type"]]];
			
			//保存图片数据
			NSMutableArray *morePicArray = [[NSMutableArray alloc]init];
			NSArray *picArray = [infoDic objectForKey:@"pics"];
			for (int j = 0; j < [picArray count]; j++ ) 
			{
				NSDictionary *picDic = [picArray objectAtIndex:j];
				NSMutableArray *pic = [[NSMutableArray alloc] init];
				[pic addObject:@""];
				[pic addObject:[infoDic objectForKey:@"id"]];
				[pic addObject:[picDic objectForKey:@"img_path"]];
				[pic addObject:[picDic objectForKey:@"thumb_pic"]];
                [pic addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt: catId]]];
				[morePicArray insertObject:pic atIndex:j];
				[pic release];
			}
			[infoArray addObject:morePicArray];
			
			[moreArray insertObject:infoArray atIndex:i];
			[infoArray release];
		}
		*ver = NEED_UPDATE;
	}
	
	return [moreArray autorelease];
}

//搜索关键词
+(NSMutableArray*)parseKeywordList:(NSString*)jsonResult getVersion:(int*)ver
{
    *ver = NO_UPDATE;
	
	NSDictionary *resultDic = [jsonResult JSONValue];
	
	//数据
	NSArray *listArray = [resultDic objectForKey:@"keywords"];
	
	NSMutableArray *keyWordsArray = [[NSMutableArray alloc]init];
	
	if ([listArray count] > 0) 
	{
		for (int i = 0; i < [listArray count]; i++ ) 
		{
			//非空判断 例子
			NSDictionary *infoDic = [listArray objectAtIndex:i];
			[keyWordsArray insertObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"keyword"]] atIndex:i];
		}
		*ver = NEED_UPDATE;
        
        //记录 搜索最频繁的关键词
        [DBOperate deleteData:T_SYSTEM_CONFIG tableColumn:@"tag" columnValue:@"keyWord"];
        NSString *keyWord = [keyWordsArray objectAtIndex:0];
        NSMutableArray *keyWordArray = [[NSMutableArray alloc]init];
        [keyWordArray addObject:@"keyWord"];
        [keyWordArray addObject:keyWord];
        [DBOperate insertDataWithnotAutoID:keyWordArray tableName:T_SYSTEM_CONFIG];
        [keyWordArray release];
        
	}
    
	return [keyWordsArray autorelease];
}

//搜索
+(NSMutableArray*)parseSomeProductList:(NSString*)jsonResult getVersion:(int*)ver
{
    *ver = NO_UPDATE;
	
	NSDictionary *resultDic = [jsonResult JSONValue];
	
	//更新数据
	NSArray *listArray = [resultDic objectForKey:@"products"];
	
	//插入数据
	NSMutableArray *productArray = [[NSMutableArray alloc]init];
	
	if ([listArray count] > 0) 
	{
		for (int i = 0; i < [listArray count]; i++ ) 
		{
			//非空判断 例子
			//[infoArray addObject:[infoDic objectForKey:@"xxx"] == [NSNull null] ? @"" : [infoDic objectForKey:@"xxx"]];
			
			NSDictionary *infoDic = [listArray objectAtIndex:i];
			NSMutableArray *infoArray = [[NSMutableArray alloc]init];
			[infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"id"]]];
			[infoArray addObject:[infoDic objectForKey:@"cate_id"]];
			[infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"title"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"content"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"promotion_price"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"price"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"likes"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"favorites"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"unit"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"salenum"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"comm_num"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"sort_order"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"is_big_pic"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"pic"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"sum"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"fre_type"]]];
			
			//保存图片数据
			NSMutableArray *morePicArray = [[NSMutableArray alloc]init];
			NSArray *picArray = [infoDic objectForKey:@"pics"];
			for (int j = 0; j < [picArray count]; j++ ) 
			{
				NSDictionary *picDic = [picArray objectAtIndex:j];
				NSMutableArray *pic = [[NSMutableArray alloc] init];
				[pic addObject:@""];
				[pic addObject:[infoDic objectForKey:@"id"]];
				[pic addObject:[picDic objectForKey:@"img_path"]];
				[pic addObject:[picDic objectForKey:@"thumb_pic"]];
                [pic addObject:[infoDic objectForKey:@"cate_id"]];
				[morePicArray insertObject:pic atIndex:j];
				[pic release];
			}
			[infoArray addObject:morePicArray];
			
			[productArray insertObject:infoArray atIndex:i];
			[infoArray release];
		}
		*ver = NEED_UPDATE;
	}
    
    return [productArray autorelease];
}

//精品推荐
+(NSMutableArray*)parseRecommend:(NSString*)jsonResult getVersion:(int*)ver
{
    *ver = NO_UPDATE;
	
	NSDictionary *resultDic = [jsonResult JSONValue];
	
	//版本号
	NSNumber *newVer = [resultDic objectForKey:@"ver"];
	
	//更新数据
	NSArray *listArray = [resultDic objectForKey:@"products"];
	
	//删除的数据
	NSArray *delsArray = [resultDic objectForKey:@"dels"];
	
	//删除数据
	if ([delsArray count] > 0)
	{
		for(NSDictionary *delDic in delsArray)
		{
			NSNumber *delID = [NSNumber numberWithInteger:[[delDic objectForKey:@"id"] intValue]];
            
            //删除记录
			[DBOperate deleteData:T_RECOMMEND_PRODUCT
					  tableColumn:@"id" 
					  columnValue:delID];
            
            //这里还要删除缓存图片
            
			//删除对应的图片记录
            [DBOperate deleteData:T_RECOMMEND_PRODUCT_PIC
					  tableColumn:@"product_id" 
					  columnValue:delID];
			
		}
		*ver = NEED_UPDATE;
	}
	
	//保存数据
	if ([listArray count] > 0) 
	{
		for (int i = 0; i < [listArray count];i++ ) 
		{
			//非空判断 例子
			//[infoArray addObject:[infoDic objectForKey:@"xxx"] == [NSNull null] ? @"" : [infoDic objectForKey:@"xxx"]];
			
			NSDictionary *infoDic = [listArray objectAtIndex:i];
			NSMutableArray *infoArray = [[NSMutableArray alloc]init];
			[infoArray addObject:[infoDic objectForKey:@"id"]];
			[infoArray addObject:[infoDic objectForKey:@"cate_id"]];
			[infoArray addObject:[infoDic objectForKey:@"title"]];
			[infoArray addObject:[infoDic objectForKey:@"content"]];
			[infoArray addObject:[infoDic objectForKey:@"promotion_price"]];
			[infoArray addObject:[infoDic objectForKey:@"price"]];
			[infoArray addObject:[infoDic objectForKey:@"likes"]];
			[infoArray addObject:[infoDic objectForKey:@"favorites"]];
			[infoArray addObject:[infoDic objectForKey:@"unit"]];
			[infoArray addObject:[infoDic objectForKey:@"salenum"]];
            [infoArray addObject:[infoDic objectForKey:@"comm_num"]];
			[infoArray addObject:[infoDic objectForKey:@"sort_order"]];
			[infoArray addObject:[infoDic objectForKey:@"is_big_pic"]];
            [infoArray addObject:[infoDic objectForKey:@"pic"]];
            [infoArray addObject:[infoDic objectForKey:@"sum"]];
            [infoArray addObject:[infoDic objectForKey:@"fre_type"]];
            [infoArray addObject:@""];
            
			//插入数据库
			[DBOperate insertDataWithnotAutoID:infoArray tableName:T_RECOMMEND_PRODUCT];
			
			//图片入库
			NSArray *picArray = [infoDic objectForKey:@"pics"];
			for (NSDictionary *picDic in picArray ) 
			{
				NSMutableArray *pic = [[NSMutableArray alloc] init];
				[pic addObject:[infoDic objectForKey:@"id"]];
				[pic addObject:[picDic objectForKey:@"img_path"]];
				[pic addObject:[picDic objectForKey:@"thumb_pic"]];
                [pic addObject:[infoDic objectForKey:@"cate_id"]];
				[DBOperate insertData:pic tableName:T_RECOMMEND_PRODUCT_PIC];
				[pic release];
			}
			
			[infoArray release];
		}
		*ver = NEED_UPDATE;
	}
	
	//保证数据只有20条
	NSMutableArray *productItems = (NSMutableArray *)[DBOperate queryData:T_RECOMMEND_PRODUCT theColumn:@"" theColumnValue:@"" orderBy:@"sort_order" orderType:@"desc" withAll:YES];
	
	for (int i = [productItems count] - 1; i > 9; i--)
	{
		NSArray *productArray = [productItems objectAtIndex:i];
		NSString *productId = [productArray objectAtIndex:recommend_product_id];
		[DBOperate deleteData:T_RECOMMEND_PRODUCT tableColumn:@"id" columnValue:productId];
        
        //这里还要删除缓存图片
        
        //删除对应的图片记录
        [DBOperate deleteData:T_RECOMMEND_PRODUCT_PIC
                  tableColumn:@"product_id" 
                  columnValue:productId];
        
	}
	
	
	//更新版本号
    [self updateVersion:OPERAT_RECOMMEND_LIST_REFRESH versionID:newVer desc:@"精品推荐"];
	
	return nil;
}

//精品推荐更多
+(NSMutableArray*)parseRecommendMore:(NSString*)jsonResult getVersion:(int*)ver
{
    *ver = NO_UPDATE;
	
	NSDictionary *resultDic = [jsonResult JSONValue];
	
	//版本号
	//NSNumber *newVer = [resultDic objectForKey:@"ver"];
	
	//更新数据
	NSArray *listArray = [resultDic objectForKey:@"products"];
	
	
	//插入数据
	NSMutableArray *moreArray = [[NSMutableArray alloc]init];
	
	if ([listArray count] > 0) 
	{
		for (int i = 0; i < [listArray count]; i++ ) 
		{
			//非空判断 例子
			//[infoArray addObject:[infoDic objectForKey:@"xxx"] == [NSNull null] ? @"" : [infoDic objectForKey:@"xxx"]];
			
			NSDictionary *infoDic = [listArray objectAtIndex:i];
			NSMutableArray *infoArray = [[NSMutableArray alloc]init];
			[infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"id"]]];
			[infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"cate_id"]]];
			[infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"title"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"content"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"promotion_price"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"price"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"likes"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"favorites"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"unit"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"salenum"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"comm_num"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"sort_order"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"is_big_pic"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"pic"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"sum"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"fre_type"]]];
			
			//保存图片数据
			NSMutableArray *morePicArray = [[NSMutableArray alloc]init];
			NSArray *picArray = [infoDic objectForKey:@"pics"];
			for (int j = 0; j < [picArray count]; j++ ) 
			{
				NSDictionary *picDic = [picArray objectAtIndex:j];
				NSMutableArray *pic = [[NSMutableArray alloc] init];
				[pic addObject:@""];
				[pic addObject:[infoDic objectForKey:@"id"]];
				[pic addObject:[picDic objectForKey:@"img_path"]];
				[pic addObject:[picDic objectForKey:@"thumb_pic"]];
                [pic addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"cate_id"]]];
				[morePicArray insertObject:pic atIndex:j];
				[pic release];
			}
			[infoArray addObject:morePicArray];
			
			[moreArray insertObject:infoArray atIndex:i];
			[infoArray release];
		}
		*ver = NEED_UPDATE;
	}
	
	return [moreArray autorelease];
}

//特价专区
+(NSMutableArray*)parseSpecialOffer:(NSString*)jsonResult getVersion:(int*)ver
{
    *ver = NO_UPDATE;
	
	NSDictionary *resultDic = [jsonResult JSONValue];
	
	//版本号
	NSNumber *newVer = [resultDic objectForKey:@"ver"];
	
	//更新数据
	NSArray *listArray = [resultDic objectForKey:@"special_offers"];
	
	//删除的数据
	NSArray *delsArray = [resultDic objectForKey:@"dels"];
	
	//删除数据
	if ([delsArray count] > 0)
	{
		for(NSDictionary *delDic in delsArray)
		{
            NSNumber *delID = [NSNumber numberWithInteger:[[delDic objectForKey:@"id"] intValue]];
            
            //这里还要删除缓存图片
            
            //删除记录
			[DBOperate deleteData:T_SPECIAL_OFFER
					  tableColumn:@"id" 
					  columnValue:delID];
			
		}
		*ver = NEED_UPDATE;
	}
	
	//保存数据
	if ([listArray count] > 0) 
	{
		for (int i = 0; i < [listArray count];i++ ) 
		{
			//非空判断 例子
			//[infoArray addObject:[infoDic objectForKey:@"xxx"] == [NSNull null] ? @"" : [infoDic objectForKey:@"xxx"]];
			
			NSDictionary *infoDic = [listArray objectAtIndex:i];
			NSMutableArray *infoArray = [[NSMutableArray alloc]init];
			[infoArray addObject:[infoDic objectForKey:@"id"]];
			[infoArray addObject:[infoDic objectForKey:@"name"]];
			[infoArray addObject:[infoDic objectForKey:@"banner"]];
			[infoArray addObject:[infoDic objectForKey:@"info_id1"]];
			[infoArray addObject:[infoDic objectForKey:@"img1"]];
			[infoArray addObject:[infoDic objectForKey:@"info_id2"]];
			[infoArray addObject:[infoDic objectForKey:@"img2"]];
			[infoArray addObject:[infoDic objectForKey:@"info_id3"]];
			[infoArray addObject:[infoDic objectForKey:@"img3"]];
			[infoArray addObject:[infoDic objectForKey:@"sort_order"]];
            
			//插入数据库
			[DBOperate insertDataWithnotAutoID:infoArray tableName:T_SPECIAL_OFFER];
			
			[infoArray release];
		}
		*ver = NEED_UPDATE;
	}
	
	//保证数据只有10条
	NSMutableArray *specialOfferItems = (NSMutableArray *)[DBOperate queryData:T_SPECIAL_OFFER theColumn:@"" theColumnValue:@"" orderBy:@"sort_order" orderType:@"desc" withAll:YES];
	
	for (int i = [specialOfferItems count] - 1; i > 9; i--)
	{
		NSArray *specialOfferArray = [specialOfferItems objectAtIndex:i];
		NSString *specialOfferId = [specialOfferArray objectAtIndex:special_offer_id];
		[DBOperate deleteData:T_SPECIAL_OFFER tableColumn:@"id" columnValue:specialOfferId];

        //这里还要删除缓存图片
	}
	
	//更新版本号
    [self updateVersion:OPERAT_SPECIAL_OFFER_REFRESH versionID:newVer desc:@"特价专区"];
	
	return nil;
}

//特价专区更多
+(NSMutableArray*)parseSpecialOfferMore:(NSString*)jsonResult getVersion:(int*)ver
{
    *ver = NO_UPDATE;
	
	NSDictionary *resultDic = [jsonResult JSONValue];
	
	//版本号
	//NSNumber *newVer = [resultDic objectForKey:@"ver"];
	
	//更新数据
	NSArray *listArray = [resultDic objectForKey:@"special_offers"];
	
	//插入数据
	NSMutableArray *moreArray = [[NSMutableArray alloc]init];
	
	if ([listArray count] > 0) 
	{
		for (int i = 0; i < [listArray count]; i++ ) 
		{
			//非空判断 例子
			//[infoArray addObject:[infoDic objectForKey:@"xxx"] == [NSNull null] ? @"" : [infoDic objectForKey:@"xxx"]];
            
            NSDictionary *infoDic = [listArray objectAtIndex:i];
			NSMutableArray *infoArray = [[NSMutableArray alloc]init];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"id"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"name"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"banner"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"info_id1"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"img1"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"info_id2"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"img2"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"info_id3"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"img3"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"sort_order"]]];
			[moreArray insertObject:infoArray atIndex:i];
			[infoArray release];
		}
		*ver = NEED_UPDATE;
	}
	
	return [moreArray autorelease];
}

//活动资讯
+(NSMutableArray*)parseNews:(NSString*)jsonResult getVersion:(int*)ver
{
    *ver = NO_UPDATE;
	
	NSDictionary *resultDic = [jsonResult JSONValue];
	
	//版本号
	NSNumber *newVer = [resultDic objectForKey:@"ver"];
	
	//更新数据
	NSArray *listArray = [resultDic objectForKey:@"news"];
	
	//删除的数据
	NSArray *delsArray = [resultDic objectForKey:@"dels"];
	
	//删除数据
	if ([delsArray count] > 0)
	{
		for(NSDictionary *delDic in delsArray)
		{
            NSNumber *delID = [NSNumber numberWithInteger:[[delDic objectForKey:@"id"] intValue]];
            
            //这里还要删除缓存图片
            
            //删除记录
			[DBOperate deleteData:T_NEWS
					  tableColumn:@"id" 
					  columnValue:delID];
			
		}
		*ver = NEED_UPDATE;
	}
	
	//保存数据
	if ([listArray count] > 0) 
	{
		for (int i = 0; i < [listArray count];i++ ) 
		{
			//非空判断 例子
			//[infoArray addObject:[infoDic objectForKey:@"xxx"] == [NSNull null] ? @"" : [infoDic objectForKey:@"xxx"]];
            
			NSDictionary *infoDic = [listArray objectAtIndex:i];
			NSMutableArray *infoArray = [[NSMutableArray alloc]init];
			[infoArray addObject:[infoDic objectForKey:@"id"]];
			[infoArray addObject:[infoDic objectForKey:@"title"]];
			[infoArray addObject:[infoDic objectForKey:@"content"]];
			[infoArray addObject:[infoDic objectForKey:@"updatetime"]];
			[infoArray addObject:[infoDic objectForKey:@"comments"]];
			[infoArray addObject:[infoDic objectForKey:@"recommend"]];
			[infoArray addObject:[infoDic objectForKey:@"thumb_pic"]];
			[infoArray addObject:[infoDic objectForKey:@"recommend_img"]];
			[infoArray addObject:[infoDic objectForKey:@"sort_order"]];
            
			//插入数据库
			[DBOperate insertDataWithnotAutoID:infoArray tableName:T_NEWS];
			
			[infoArray release];
		}
		*ver = NEED_UPDATE;
	}
	
	//保证数据只有20条
	NSMutableArray *newsItems = (NSMutableArray *)[DBOperate queryData:T_NEWS theColumn:@"" theColumnValue:@"" orderBy:@"sort_order" orderType:@"desc" withAll:YES];
	
	for (int i = [newsItems count] - 1; i > 20; i--)
	{
		NSArray *newsArray = [newsItems objectAtIndex:i];
		NSString *newsId = [newsArray objectAtIndex:news_id];
		[DBOperate deleteData:T_NEWS tableColumn:@"id" columnValue:newsId];
        
        //这里还要删除缓存图片
	}
	
	//更新版本号
    [self updateVersion:OPERAT_NEWS_REFRESH versionID:newVer desc:@"活动资讯"];
	
	return nil;
}

//活动资讯更多
+(NSMutableArray*)parseNewsMore:(NSString*)jsonResult getVersion:(int*)ver
{
    *ver = NO_UPDATE;
	
	NSDictionary *resultDic = [jsonResult JSONValue];
	
	//版本号
	//NSNumber *newVer = [resultDic objectForKey:@"ver"];
	
	//更新数据
	NSArray *listArray = [resultDic objectForKey:@"news"];
	
	
	//插入数据
	NSMutableArray *moreArray = [[NSMutableArray alloc]init];
	
	if ([listArray count] > 0) 
	{
		for (int i = 0; i < [listArray count]; i++ ) 
		{
			//非空判断 例子
			//[infoArray addObject:[infoDic objectForKey:@"xxx"] == [NSNull null] ? @"" : [infoDic objectForKey:@"xxx"]];
            
            NSDictionary *infoDic = [listArray objectAtIndex:i];
			NSMutableArray *infoArray = [[NSMutableArray alloc]init];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"id"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"title"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"content"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"updatetime"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"comments"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"recommend"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"thumb_pic"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"recommend_img"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"sort_order"]]];
			[moreArray insertObject:infoArray atIndex:i];
			[infoArray release];
		}
		*ver = NEED_UPDATE;
	}
	
	return [moreArray autorelease];
}

//资讯评论
+(NSMutableArray*)parseNewsComment:(NSString*)jsonResult getVersion:(int*)ver
{
    *ver = NO_UPDATE;
	
	NSDictionary *resultDic = [jsonResult JSONValue];
	
	//版本号
	//NSNumber *newVer = [resultDic objectForKey:@"ver"];
	
	//更新数据
	NSArray *listArray = [resultDic objectForKey:@"comments"];
	
	
	//插入数据
	NSMutableArray *commentArray = [[NSMutableArray alloc]init];
	
	if ([listArray count] > 0)
	{
		for (int i = 0; i < [listArray count]; i++ )
		{
			//非空判断 例子
			//[infoArray addObject:[infoDic objectForKey:@"xxx"] == [NSNull null] ? @"" : [infoDic objectForKey:@"xxx"]];
            
            NSDictionary *infoDic = [listArray objectAtIndex:i];
			NSMutableArray *infoArray = [[NSMutableArray alloc]init];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"username"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"content"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"created"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"headImg"]]];
			[commentArray insertObject:infoArray atIndex:i];
			[infoArray release];
		}
		*ver = NEED_UPDATE;
	}
	
	return [commentArray autorelease];
}

//抽奖列表
+(NSMutableArray*)parseLotteryList:(NSString*)jsonResult getVersion:(int*)ver
{
    *ver = NO_UPDATE;

	NSDictionary *resultDic = [jsonResult JSONValue];
	
	//版本号
	NSNumber *newVer = [resultDic objectForKey:@"ver"];
	
	//更新数据
	NSArray *listArray = [resultDic objectForKey:@"luckdraws"];
	
	//删除的数据
	NSArray *delsArray = [resultDic objectForKey:@"dels"];
	
	//删除数据
	if ([delsArray count] > 0)
	{
		for(NSDictionary *delDic in delsArray)
		{
			NSNumber *delID = [NSNumber numberWithInteger:[[delDic objectForKey:@"id"] intValue]];
            [DBOperate deleteData:T_LOTTERY
					  tableColumn:@"id" 
					  columnValue:delID];
            
            //这里还要删除缓存图片
            
			//删除对应的图片记录
            [DBOperate deleteData:T_LOTTERY_PIC
					  tableColumn:@"lottery_id" 
					  columnValue:delID];
			
			
		}
		*ver = NEED_UPDATE;
	}
	
	//保存数据
	if ([listArray count] > 0) 
	{
		for (int i = 0; i < [listArray count];i++ ) 
		{
			//非空判断 例子
			//[infoArray addObject:[infoDic objectForKey:@"xxx"] == [NSNull null] ? @"" : [infoDic objectForKey:@"xxx"]];
			
			NSDictionary *infoDic = [listArray objectAtIndex:i];
			NSMutableArray *infoArray = [[NSMutableArray alloc]init];
			[infoArray addObject:[infoDic objectForKey:@"id"]];
            [infoArray addObject:[infoDic objectForKey:@"name"]];
            [infoArray addObject:[infoDic objectForKey:@"starttime"]];
            [infoArray addObject:[infoDic objectForKey:@"endtime"]];
            [infoArray addObject:[infoDic objectForKey:@"des"]];
            [infoArray addObject:[infoDic objectForKey:@"product_name"]];
            [infoArray addObject:[infoDic objectForKey:@"product_des"]];
            [infoArray addObject:[infoDic objectForKey:@"produc_price"]];
            [infoArray addObject:[infoDic objectForKey:@"product_sum"]];
            [infoArray addObject:[infoDic objectForKey:@"win_num"]];
            [infoArray addObject:[infoDic objectForKey:@"users"]];
            [infoArray addObject:[infoDic objectForKey:@"win_users_id"]];
            [infoArray addObject:[infoDic objectForKey:@"probability"]];
            [infoArray addObject:[infoDic objectForKey:@"status"]];
            [infoArray addObject:[infoDic objectForKey:@"sort_order"]];
            [infoArray addObject:[infoDic objectForKey:@"pic"]];
            [infoArray addObject:@""];

			//插入数据库
			[DBOperate insertDataWithnotAutoID:infoArray tableName:T_LOTTERY];
			
			//图片入库
			NSArray *picArray = [infoDic objectForKey:@"pics"];
			for (NSDictionary *picDic in picArray ) 
			{
				NSMutableArray *pic = [[NSMutableArray alloc] init];
				[pic addObject:[infoDic objectForKey:@"id"]];
				[pic addObject:[picDic objectForKey:@"img_path"]];
				[pic addObject:[picDic objectForKey:@"thumb_pic"]];
				[DBOperate insertData:pic tableName:T_LOTTERY_PIC];
				[pic release];
			}
			
			[infoArray release];
		}
		*ver = NEED_UPDATE;
	}
	
	//保证数据只有20条
	NSMutableArray *lotteryItems = (NSMutableArray *)[DBOperate queryData:T_LOTTERY theColumn:@"" theColumnValue:@"" orderBy:@"sort_order" orderType:@"desc" withAll:YES];
	
	for (int i = [lotteryItems count] - 1; i > 19; i--)
	{
		NSArray *lotteryArray = [lotteryItems objectAtIndex:i];
		NSString *lotteryId = [lotteryArray objectAtIndex:lottery_id];
		[DBOperate deleteData:T_LOTTERY tableColumn:@"id" columnValue:lotteryId];
        
        //这里还要删除缓存图片
        
        [DBOperate deleteData:T_LOTTERY_PIC
                  tableColumn:@"lottery_id" 
                  columnValue:lotteryId];
        
	}
	
	
	//更新版本号
    [self updateVersion:OPERAT_LOTTERY_LIST_REFRESH versionID:newVer desc:@"抽奖"];
	
	return nil;
}

//抽奖列表更多
+(NSMutableArray*)parseLotteryMore:(NSString*)jsonResult getVersion:(int*)ver
{
    *ver = NO_UPDATE;

	NSDictionary *resultDic = [jsonResult JSONValue];
	
	//版本号
	//NSNumber *newVer = [resultDic objectForKey:@"ver"];
	
	//更新数据
	NSArray *listArray = [resultDic objectForKey:@"luckdraws"];
	
	
	//插入数据
	NSMutableArray *moreArray = [[NSMutableArray alloc]init];
	
	if ([listArray count] > 0) 
	{
		for (int i = 0; i < [listArray count]; i++ ) 
		{
			//非空判断 例子
			//[infoArray addObject:[infoDic objectForKey:@"xxx"] == [NSNull null] ? @"" : [infoDic objectForKey:@"xxx"]];
			
			NSDictionary *infoDic = [listArray objectAtIndex:i];
			NSMutableArray *infoArray = [[NSMutableArray alloc]init];
			[infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"id"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"name"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"starttime"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"endtime"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"des"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"product_name"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"product_des"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"produc_price"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"product_sum"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"win_num"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"users"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"win_users_id"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"probability"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"status"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"sort_order"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"pic"]]];
			
			//保存图片数据
			NSMutableArray *morePicArray = [[NSMutableArray alloc]init];
			NSArray *picArray = [infoDic objectForKey:@"pics"];
			for (int j = 0; j < [picArray count]; j++ ) 
			{
				NSDictionary *picDic = [picArray objectAtIndex:j];
				NSMutableArray *pic = [[NSMutableArray alloc] init];
				[pic addObject:@""];
				[pic addObject:[infoDic objectForKey:@"id"]];
				[pic addObject:[picDic objectForKey:@"img_path"]];
				[pic addObject:[picDic objectForKey:@"thumb_pic"]];
				[morePicArray insertObject:pic atIndex:j];
				[pic release];
			}
			[infoArray addObject:morePicArray];
			
			[moreArray insertObject:infoArray atIndex:i];
			[infoArray release];
		}
		*ver = NEED_UPDATE;
	}
	
	return [moreArray autorelease];
}

//抽奖成功
+(NSMutableArray*)parseSendLotteryWin:(NSString*)jsonResult getVersion:(int*)ver
{
    return nil;
}

//会员登录
+ (NSMutableArray*)parseLogin:(NSString*)jsonResult getVersion:(int*)ver
{ 
    NSDictionary *resultDic = [jsonResult JSONValue];
	*ver = NO_UPDATE;
	NSMutableArray *resultArray =[[NSMutableArray alloc] init];
	NSMutableArray *strArray = [[NSMutableArray alloc] init];
	NSString *str = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"ret"]];
	[strArray addObject:str];
	[resultArray addObject:strArray];
	
	if ([str isEqualToString:@"1"]) {
		NSMutableArray *infoArray = [[NSMutableArray alloc] init];
		[infoArray addObject:[resultDic objectForKey:@"id"]];
		[infoArray addObject:[resultDic objectForKey:@"name"]];
		[infoArray addObject:@""];
		[infoArray addObject:[resultDic objectForKey:@"img"]];
		[infoArray addObject:@""];
		[resultArray addObject:infoArray];
        
        NSString *news_id = [resultDic objectForKey:@"news_id"];
        if (news_id.length > 0) {
            [DBOperate deleteData:T_FAVORITED_NEWS];
            if ([news_id rangeOfString:@"," options:NSCaseInsensitiveSearch].location == NSNotFound) {
                NSMutableArray *ay = [[NSMutableArray alloc] init];
                [ay addObject:[resultDic objectForKey:@"id"]];
                [ay addObject:news_id];
                
                [DBOperate insertDataWithnotAutoID:ay tableName:T_FAVORITED_NEWS];
                [ay release];

            }else {
                NSArray *newsIdArr = [news_id componentsSeparatedByString:@","];
                
                for (int i = 0; i < [newsIdArr count]; i ++) {
                    NSMutableArray *ay = [[NSMutableArray alloc] init];
                    [ay addObject:[resultDic objectForKey:@"id"]];
                    [ay addObject:[newsIdArr objectAtIndex:i]];
                    
                    [DBOperate insertDataWithnotAutoID:ay tableName:T_FAVORITED_NEWS];
                    [ay release];
                }
            }
        }
        
        NSString *products_id = [resultDic objectForKey:@"products_id"];
        if (products_id.length > 0) {
            [DBOperate deleteData:T_FAVORITED_PRODUCTS];
            if ([products_id rangeOfString:@"," options:NSCaseInsensitiveSearch].location == NSNotFound) {
                NSMutableArray *ay = [[NSMutableArray alloc] init];
                [ay addObject:[resultDic objectForKey:@"id"]];
                [ay addObject:products_id];
                
                [DBOperate insertDataWithnotAutoID:ay tableName:T_FAVORITED_PRODUCTS];
                [ay release];
            }else {
                NSArray *productsIdArr = [products_id componentsSeparatedByString:@","];
                
                for (int i = 0; i < [productsIdArr count]; i ++) {
                    NSMutableArray *ay = [[NSMutableArray alloc] init];
                    [ay addObject:[resultDic objectForKey:@"id"]];
                    [ay addObject:[productsIdArr objectAtIndex:i]];
                    
                    [DBOperate insertDataWithnotAutoID:ay tableName:T_FAVORITED_PRODUCTS];
                    [ay release];
                }
            }
        }
        
        NSString *likes_id = [resultDic objectForKey:@"likes_id"];
        if (likes_id.length > 0) {
            [DBOperate deleteData:T_FAVORITED_LIKES];
            if ([likes_id rangeOfString:@"," options:NSCaseInsensitiveSearch].location == NSNotFound) {
                NSMutableArray *ay = [[NSMutableArray alloc] init];
                [ay addObject:[resultDic objectForKey:@"id"]];
                [ay addObject:likes_id];
                
                [DBOperate insertDataWithnotAutoID:ay tableName:T_FAVORITED_LIKES];
                [ay release];
            }else {
                NSArray *likesIdArr = [likes_id componentsSeparatedByString:@","];
                
                for (int i = 0; i < [likesIdArr count]; i ++) {
                    NSMutableArray *ay = [[NSMutableArray alloc] init];
                    [ay addObject:[resultDic objectForKey:@"id"]];
                    [ay addObject:[likesIdArr objectAtIndex:i]];
                    
                    [DBOperate insertDataWithnotAutoID:ay tableName:T_FAVORITED_LIKES];
                    [ay release];
                }
            }
        }
        
        NSString *str = [NSString stringWithFormat:@"%d",[[resultDic objectForKey:@"is_easybuy"] intValue]];
        if (str.length > 0) {
            [DBOperate deleteData:T_SYSTEM_CONFIG tableColumn:@"tag" columnValue:@"isEasybuy"];
            
            NSMutableArray *isEasybuyArray = [[NSMutableArray alloc]init];
            [isEasybuyArray addObject:@"isEasybuy"];
            [isEasybuyArray addObject:[resultDic objectForKey:@"is_easybuy"]];
            [DBOperate insertDataWithnotAutoID:isEasybuyArray tableName:T_SYSTEM_CONFIG];
            [isEasybuyArray release];
        }
	}
    //NSLog(@"resultArray====%@",resultArray);
	return resultArray;
}

//会员注册
+ (NSMutableArray*)parseRegist:(NSString*)jsonResult getVersion:(int*)ver
{ 
	NSDictionary *resultDic = [jsonResult JSONValue];
	NSMutableArray *resultArray =[[NSMutableArray alloc] init];
	NSMutableArray *strArray = [[NSMutableArray alloc] init];
	NSString *str = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"ret"]];
	[strArray addObject:str];
	[resultArray addObject:strArray];
    
	if ([str isEqualToString:@"1"]) {
		NSMutableArray *infoArray = [[NSMutableArray alloc] init];
		[infoArray addObject:[resultDic objectForKey:@"id"]];
		[infoArray addObject:[resultDic objectForKey:@"login_name"]];
		[infoArray addObject:@""];
		[infoArray addObject:[resultDic objectForKey:@"img"]];
		[infoArray addObject:@""];
		[resultArray addObject:infoArray];
        
        NSString *news_id = [resultDic objectForKey:@"news_id"];
        if (news_id.length > 0) {
            [DBOperate deleteData:T_FAVORITED_NEWS];
            if ([news_id rangeOfString:@"," options:NSCaseInsensitiveSearch].location == NSNotFound) {
                NSMutableArray *ay = [[NSMutableArray alloc] init];
                [ay addObject:[resultDic objectForKey:@"id"]];
                [ay addObject:news_id];
                
                [DBOperate insertDataWithnotAutoID:ay tableName:T_FAVORITED_NEWS];
                [ay release];
                
            }else {
                NSArray *newsIdArr = [news_id componentsSeparatedByString:@","];
                
                for (int i = 0; i < [newsIdArr count]; i ++) {
                    NSMutableArray *ay = [[NSMutableArray alloc] init];
                    [ay addObject:[resultDic objectForKey:@"id"]];
                    [ay addObject:[newsIdArr objectAtIndex:i]];
                    
                    [DBOperate insertDataWithnotAutoID:ay tableName:T_FAVORITED_NEWS];
                    [ay release];
                }
            }
        }
        
        NSString *products_id = [resultDic objectForKey:@"products_id"];
        if (products_id.length > 0) {
            [DBOperate deleteData:T_FAVORITED_PRODUCTS];
            if ([products_id rangeOfString:@"," options:NSCaseInsensitiveSearch].location == NSNotFound) {
                NSMutableArray *ay = [[NSMutableArray alloc] init];
                [ay addObject:[resultDic objectForKey:@"id"]];
                [ay addObject:products_id];
                
                [DBOperate insertDataWithnotAutoID:ay tableName:T_FAVORITED_PRODUCTS];
                [ay release];
            }else {
                NSArray *productsIdArr = [products_id componentsSeparatedByString:@","];
                
                for (int i = 0; i < [productsIdArr count]; i ++) {
                    NSMutableArray *ay = [[NSMutableArray alloc] init];
                    [ay addObject:[resultDic objectForKey:@"id"]];
                    [ay addObject:[productsIdArr objectAtIndex:i]];
                    
                    [DBOperate insertDataWithnotAutoID:ay tableName:T_FAVORITED_PRODUCTS];
                    [ay release];
                }
            }
        }
        
        NSString *likes_id = [resultDic objectForKey:@"likes_id"];
        if (likes_id.length > 0) {
            [DBOperate deleteData:T_FAVORITED_LIKES];
            if ([likes_id rangeOfString:@"," options:NSCaseInsensitiveSearch].location == NSNotFound) {
                NSMutableArray *ay = [[NSMutableArray alloc] init];
                [ay addObject:[resultDic objectForKey:@"id"]];
                [ay addObject:likes_id];
                
                [DBOperate insertDataWithnotAutoID:ay tableName:T_FAVORITED_LIKES];
                [ay release];
            }else {
                NSArray *likesIdArr = [likes_id componentsSeparatedByString:@","];
                
                for (int i = 0; i < [likesIdArr count]; i ++) {
                    NSMutableArray *ay = [[NSMutableArray alloc] init];
                    [ay addObject:[resultDic objectForKey:@"id"]];
                    [ay addObject:[likesIdArr objectAtIndex:i]];
                    
                    [DBOperate insertDataWithnotAutoID:ay tableName:T_FAVORITED_LIKES];
                    [ay release];
                }
            }
        }
    }
    //NSLog(@"resultArray====%@",resultArray);
	return resultArray;
}

//新浪微博登录
+ (NSMutableArray*)parseSinaWeibo:(NSString*)jsonResult getVersion:(int*)ver
{ 
	NSDictionary *resultDic = [jsonResult JSONValue];
	NSMutableArray *resultArray =[[NSMutableArray alloc] init];
	NSMutableArray *strArray = [[NSMutableArray alloc] init];
	NSString *str = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"ret"]];
	[strArray addObject:str];
	[resultArray addObject:strArray];
	
	if ([str isEqualToString:@"1"] || [str isEqualToString:@"2"]) {
		NSMutableArray *infoArray = [[NSMutableArray alloc] init];
		[infoArray addObject:[resultDic objectForKey:@"id"]];
		[infoArray addObject:[resultDic objectForKey:@"login_name"]];
		[infoArray addObject:[resultDic objectForKey:@"login_pwd"]];
		[infoArray addObject:[resultDic objectForKey:@"img"]];
		[infoArray addObject:@""];
		
		[resultArray addObject:infoArray];
        
        NSString *news_id = [resultDic objectForKey:@"news_id"];
        if (news_id.length > 0) {
            [DBOperate deleteData:T_FAVORITED_NEWS];
            if ([news_id rangeOfString:@"," options:NSCaseInsensitiveSearch].location == NSNotFound) {
                NSMutableArray *ay = [[NSMutableArray alloc] init];
                [ay addObject:[resultDic objectForKey:@"id"]];
                [ay addObject:news_id];
                
                [DBOperate insertDataWithnotAutoID:ay tableName:T_FAVORITED_NEWS];
                [ay release];
                
            }else {
                NSArray *newsIdArr = [news_id componentsSeparatedByString:@","];
                
                for (int i = 0; i < [newsIdArr count]; i ++) {
                    NSMutableArray *ay = [[NSMutableArray alloc] init];
                    [ay addObject:[resultDic objectForKey:@"id"]];
                    [ay addObject:[newsIdArr objectAtIndex:i]];
                    
                    [DBOperate insertDataWithnotAutoID:ay tableName:T_FAVORITED_NEWS];
                    [ay release];
                }
            }
        }
        
        NSString *products_id = [resultDic objectForKey:@"products_id"];
        if (products_id.length > 0) {
            [DBOperate deleteData:T_FAVORITED_PRODUCTS];
            if ([products_id rangeOfString:@"," options:NSCaseInsensitiveSearch].location == NSNotFound) {
                NSMutableArray *ay = [[NSMutableArray alloc] init];
                [ay addObject:[resultDic objectForKey:@"id"]];
                [ay addObject:products_id];
                
                [DBOperate insertDataWithnotAutoID:ay tableName:T_FAVORITED_PRODUCTS];
                [ay release];
            }else {
                NSArray *productsIdArr = [products_id componentsSeparatedByString:@","];
                
                for (int i = 0; i < [productsIdArr count]; i ++) {
                    NSMutableArray *ay = [[NSMutableArray alloc] init];
                    [ay addObject:[resultDic objectForKey:@"id"]];
                    [ay addObject:[productsIdArr objectAtIndex:i]];
                    
                    [DBOperate insertDataWithnotAutoID:ay tableName:T_FAVORITED_PRODUCTS];
                    [ay release];
                }
            }
        }
        
        NSString *likes_id = [resultDic objectForKey:@"likes_id"];
        if (likes_id.length > 0) {
            [DBOperate deleteData:T_FAVORITED_LIKES];
            if ([likes_id rangeOfString:@"," options:NSCaseInsensitiveSearch].location == NSNotFound) {
                NSMutableArray *ay = [[NSMutableArray alloc] init];
                [ay addObject:[resultDic objectForKey:@"id"]];
                [ay addObject:likes_id];
                
                [DBOperate insertDataWithnotAutoID:ay tableName:T_FAVORITED_LIKES];
                [ay release];
            }else {
                NSArray *likesIdArr = [likes_id componentsSeparatedByString:@","];
                
                for (int i = 0; i < [likesIdArr count]; i ++) {
                    NSMutableArray *ay = [[NSMutableArray alloc] init];
                    [ay addObject:[resultDic objectForKey:@"id"]];
                    [ay addObject:[likesIdArr objectAtIndex:i]];
                    
                    [DBOperate insertDataWithnotAutoID:ay tableName:T_FAVORITED_LIKES];
                    [ay release];
                }
            }
        }
        
        if ([str isEqualToString:@"2"]) {
            NSString *str = [NSString stringWithFormat:@"%d",[[resultDic objectForKey:@"is_easybuy"] intValue]];
            if (str.length > 0) {
                [DBOperate deleteData:T_SYSTEM_CONFIG tableColumn:@"tag" columnValue:@"isEasybuy"];
                
                NSMutableArray *isEasybuyArray = [[NSMutableArray alloc]init];
                [isEasybuyArray addObject:@"isEasybuy"];
                [isEasybuyArray addObject:[resultDic objectForKey:@"is_easybuy"]];
                [DBOperate insertDataWithnotAutoID:isEasybuyArray tableName:T_SYSTEM_CONFIG];
                [isEasybuyArray release];
            }
        }
        
	}
	return resultArray;
}

//腾讯微博登录
+ (NSMutableArray*)parseTencentWeibo:(NSString*)jsonResult getVersion:(int*)ver
{ 
	NSDictionary *resultDic = [jsonResult JSONValue];
	NSMutableArray *resultArray =[[NSMutableArray alloc] init];
	NSMutableArray *strArray = [[NSMutableArray alloc] init];
	NSString *str = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"ret"]];
	[strArray addObject:str];
	[resultArray addObject:strArray];
	
	if ([str isEqualToString:@"1"] || [str isEqualToString:@"2"]) {
		NSMutableArray *infoArray = [[NSMutableArray alloc] init];
		[infoArray addObject:[resultDic objectForKey:@"id"]];
		[infoArray addObject:[resultDic objectForKey:@"login_name"]];
		[infoArray addObject:[resultDic objectForKey:@"login_pwd"]];
		[infoArray addObject:[resultDic objectForKey:@"img"]];
		[infoArray addObject:@""];
		
		[resultArray addObject:infoArray];
        
        NSString *news_id = [resultDic objectForKey:@"news_id"];
        if (news_id.length > 0) {
            [DBOperate deleteData:T_FAVORITED_NEWS];
            if ([news_id rangeOfString:@"," options:NSCaseInsensitiveSearch].location == NSNotFound) {
                NSMutableArray *ay = [[NSMutableArray alloc] init];
                [ay addObject:[resultDic objectForKey:@"id"]];
                [ay addObject:news_id];
                
                [DBOperate insertDataWithnotAutoID:ay tableName:T_FAVORITED_NEWS];
                [ay release];
                
            }else {
                NSArray *newsIdArr = [news_id componentsSeparatedByString:@","];
                
                for (int i = 0; i < [newsIdArr count]; i ++) {
                    NSMutableArray *ay = [[NSMutableArray alloc] init];
                    [ay addObject:[resultDic objectForKey:@"id"]];
                    [ay addObject:[newsIdArr objectAtIndex:i]];
                    
                    [DBOperate insertDataWithnotAutoID:ay tableName:T_FAVORITED_NEWS];
                    [ay release];
                }
            }
        }
        
        NSString *products_id = [resultDic objectForKey:@"products_id"];
        if (products_id.length > 0) {
            [DBOperate deleteData:T_FAVORITED_PRODUCTS];
            if ([products_id rangeOfString:@"," options:NSCaseInsensitiveSearch].location == NSNotFound) {
                NSMutableArray *ay = [[NSMutableArray alloc] init];
                [ay addObject:[resultDic objectForKey:@"id"]];
                [ay addObject:products_id];
                
                [DBOperate insertDataWithnotAutoID:ay tableName:T_FAVORITED_PRODUCTS];
                [ay release];
            }else {
                NSArray *productsIdArr = [products_id componentsSeparatedByString:@","];
                
                for (int i = 0; i < [productsIdArr count]; i ++) {
                    NSMutableArray *ay = [[NSMutableArray alloc] init];
                    [ay addObject:[resultDic objectForKey:@"id"]];
                    [ay addObject:[productsIdArr objectAtIndex:i]];
                    
                    [DBOperate insertDataWithnotAutoID:ay tableName:T_FAVORITED_PRODUCTS];
                    [ay release];
                }
            }
        }
        
        NSString *likes_id = [resultDic objectForKey:@"likes_id"];
        if (likes_id.length > 0) {
            [DBOperate deleteData:T_FAVORITED_LIKES];
            if ([likes_id rangeOfString:@"," options:NSCaseInsensitiveSearch].location == NSNotFound) {
                NSMutableArray *ay = [[NSMutableArray alloc] init];
                [ay addObject:[resultDic objectForKey:@"id"]];
                [ay addObject:likes_id];
                
                [DBOperate insertDataWithnotAutoID:ay tableName:T_FAVORITED_LIKES];
                [ay release];
            }else {
                NSArray *likesIdArr = [likes_id componentsSeparatedByString:@","];
                
                for (int i = 0; i < [likesIdArr count]; i ++) {
                    NSMutableArray *ay = [[NSMutableArray alloc] init];
                    [ay addObject:[resultDic objectForKey:@"id"]];
                    [ay addObject:[likesIdArr objectAtIndex:i]];
                    
                    [DBOperate insertDataWithnotAutoID:ay tableName:T_FAVORITED_LIKES];
                    [ay release];
                }
            }
        }
        
        if ([str isEqualToString:@"2"]) {
            NSString *str = [NSString stringWithFormat:@"%d",[[resultDic objectForKey:@"is_easybuy"] intValue]];
            NSLog(@"==%@",str);
            if (str.length > 0) {
                [DBOperate deleteData:T_SYSTEM_CONFIG tableColumn:@"tag" columnValue:@"isEasybuy"];
                
                NSMutableArray *isEasybuyArray = [[NSMutableArray alloc]init];
                [isEasybuyArray addObject:@"isEasybuy"];
                [isEasybuyArray addObject:[resultDic objectForKey:@"is_easybuy"]];
                [DBOperate insertDataWithnotAutoID:isEasybuyArray tableName:T_SYSTEM_CONFIG];
                [isEasybuyArray release];
            }
        }
	}
	return resultArray;
}

//我的喜欢列表
+ (NSMutableArray*)parseLikesList:(NSString*)jsonResult getVersion:(int*)ver withMemberId:(int)_memberId isInsert:(BOOL)yesORno
{ 
	NSDictionary *resultDic = [jsonResult JSONValue];
	NSArray *infoArray = [resultDic objectForKey:@"Likes"];
	
	NSMutableArray *resultArray =[[NSMutableArray alloc] init];
    if ([infoArray count] > 0) {
        for (int i = 0; i < [infoArray count]; i ++) {
            NSDictionary *infoDic = [infoArray objectAtIndex:i];
            NSMutableArray *infoList = [[NSMutableArray alloc]init];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"status"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"created"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"product_id"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"cate_id"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"title"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"content"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"promotion_price"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"price"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"likes"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"favorites"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"unit"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"salenum"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"comm_num"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"sort_order"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"is_big_pic"]]];
            [infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"pic"]]];
            [infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"sum"]]];
            [infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"fre_type"]]];
            
            NSMutableArray *morePicArray = [[NSMutableArray alloc]init];
			NSArray *picArray = [infoDic objectForKey:@"pics"];
			for (int j = 0; j < [picArray count]; j++ ) 
			{
				NSDictionary *picDic = [picArray objectAtIndex:j];
                NSMutableArray *pic = [[NSMutableArray alloc] init];
                [pic addObject:[NSString stringWithFormat:@"%d",j + 1]];
                [pic addObject:[infoDic objectForKey:@"product_id"]];
                [pic addObject:[picDic objectForKey:@"img_path"]];
                [pic addObject:[picDic objectForKey:@"thumb_pic"]];
                [pic addObject:[infoDic objectForKey:@"cate_id"]];
				[morePicArray insertObject:pic atIndex:j];
				[pic release];
			}
			[infoList addObject:morePicArray];
            
			[resultArray insertObject:infoList atIndex:i];
			[infoList release];
        }
    }
	return [resultArray autorelease];
}

//我的产品收藏列表
+ (NSMutableArray*)parseProductList:(NSString*)jsonResult getVersion:(int*)ver withMemberId:(int)_memberId isInsert:(BOOL)yesORno
{ 
	NSDictionary *resultDic = [jsonResult JSONValue];
	NSArray *infoArray = [resultDic objectForKey:@"favorites"];
	
	NSMutableArray *resultArray =[[NSMutableArray alloc] init];
   
    if ([infoArray count] > 0) {
        for (int i = 0; i < [infoArray count]; i ++) {
            NSDictionary *infoDic = [infoArray objectAtIndex:i];
            NSMutableArray *infoList = [[NSMutableArray alloc]init];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"status"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"created"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"product_id"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"cate_id"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"title"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"content"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"promotion_price"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"price"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"likes"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"favorites"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"unit"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"salenum"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"comm_num"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"sort_order"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"is_big_pic"]]];
            [infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"pic"]]];
            [infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"sum"]]];
            [infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"fre_type"]]];
            NSArray *picArray = [infoDic objectForKey:@"pics"];
            NSMutableArray *morePicArray = [[NSMutableArray alloc]init];
            for (int j = 0; j < [picArray count]; j++ ) 
			{
				NSDictionary *picDic = [picArray objectAtIndex:j];
                NSMutableArray *pic = [[NSMutableArray alloc] init];
                [pic addObject:[NSString stringWithFormat:@"%d",j + 1]];
                [pic addObject:[infoDic objectForKey:@"product_id"]];
                [pic addObject:[picDic objectForKey:@"img_path"]];
                [pic addObject:[picDic objectForKey:@"thumb_pic"]];
                [pic addObject:[infoDic objectForKey:@"cate_id"]];
				[morePicArray insertObject:pic atIndex:j];
				[pic release];
			}
			[infoList addObject:morePicArray];
            
			[resultArray insertObject:infoList atIndex:i];
			[infoList release];
        }
    }
	return [resultArray autorelease];
}

//我的资讯收藏列表
+ (NSMutableArray*)parseNewsList:(NSString*)jsonResult getVersion:(int*)ver withMemberId:(int)_memberId isInsert:(BOOL)yesORno
{ 
	NSDictionary *resultDic = [jsonResult JSONValue];
	//NSLog(@"resultDic===%@",resultDic);
	NSArray *infoArray = [resultDic objectForKey:@"favorites"];
	
	NSMutableArray *resultArray =[[NSMutableArray alloc] init];
    if (yesORno == YES) {
        [DBOperate deleteData:T_FAVORITE_NEWS];
    }
	if (infoArray != nil) {
		for (NSDictionary *infoDic in infoArray) {
			NSMutableArray *infoList = [[NSMutableArray alloc]init];
			[infoList addObject:[infoDic objectForKey:@"new_id"]];
			[infoList addObject:[infoDic objectForKey:@"title"]];
			[infoList addObject:[infoDic objectForKey:@"content"]];
			[infoList addObject:[infoDic objectForKey:@"created"]];
			[infoList addObject:[infoDic objectForKey:@"comments"]];
			[infoList addObject:[infoDic objectForKey:@"recommend"]];
			[infoList addObject:[infoDic objectForKey:@"thumb_pic"]];
			[infoList addObject:[infoDic objectForKey:@"recommend_img"]];
			[infoList addObject:[infoDic objectForKey:@"sort_order"]];
			[infoList addObject:[infoDic objectForKey:@"status"]];
			
			if (yesORno == YES) {
                [DBOperate insertDataWithnotAutoID:infoList tableName:T_FAVORITE_NEWS];
			}
			[resultArray addObject:infoList];
			[infoList release];
        }
	}	

	return [resultArray autorelease];
}

//轻松订列表 
+ (NSMutableArray*)parseEasyList:(NSString*)jsonResult getVersion:(int*)ver withUserId:(int)_userId isInsert:(BOOL)yesORno
{ 
	NSDictionary *resultDic = [jsonResult JSONValue];
    
	NSArray *infoArray = [resultDic objectForKey:@"infos"];
    NSArray *delsArray = [resultDic objectForKey:@"dels"];
	*ver = NEED_UPDATE;
	
    if (delsArray != nil) {
        for (int i = 0;i < [delsArray count] ;i++ ) {
            NSDictionary *dic = [delsArray objectAtIndex:i];
            NSString *temp = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"id"] intValue]];
            [DBOperate deleteDataWithTwoConditions:T_EASYBOOK_LIST columnOne:@"id" valueOne:temp columnTwo:@"memberId" valueTwo:[NSString stringWithFormat:@"%d",_userId]];
        }
    }
    
	NSMutableArray *resultArray =[[NSMutableArray alloc] init];
	if (infoArray != nil) {
		for (NSDictionary *infoDic in infoArray) {
			NSMutableArray *infoList = [[NSMutableArray alloc]init];
			[infoList addObject:[infoDic objectForKey:@"id"]];
            [DBOperate deleteDataWithTwoConditions:T_EASYBOOK_LIST columnOne:@"id" valueOne:[infoDic objectForKey:@"id"] columnTwo:@"memberId" valueTwo:[NSString stringWithFormat:@"%d",_userId]];
            
			[infoList addObject:[NSString stringWithFormat:@"%d",_userId]];
			[infoList addObject:[infoDic objectForKey:@"easyname"]];
			[infoList addObject:[infoDic objectForKey:@"consignee"]];
            [infoList addObject:[infoDic objectForKey:@"mobile"]];
			[infoList addObject:[infoDic objectForKey:@"address"]];
			[infoList addObject:[infoDic objectForKey:@"province"]];
			[infoList addObject:[infoDic objectForKey:@"city"]];
			[infoList addObject:[infoDic objectForKey:@"area"]];
            [infoList addObject:[infoDic objectForKey:@"zip_code"]];
			[infoList addObject:[infoDic objectForKey:@"payway"]];
			[infoList addObject:[infoDic objectForKey:@"payment"]];
			[infoList addObject:[infoDic objectForKey:@"post_id"]];
			[infoList addObject:[infoDic objectForKey:@"send_time"]];
            [infoList addObject:[infoDic objectForKey:@"issure"]];
            [infoList addObject:[infoDic objectForKey:@"invoice_type"]];
            [infoList addObject:[infoDic objectForKey:@"invoice_title_type"]];
            [infoList addObject:[infoDic objectForKey:@"invoice_title_cont"]];
            [infoList addObject:@""];
            [infoList addObject:[infoDic objectForKey:@"is_default"]];
            [infoList addObject:[infoDic objectForKey:@"updatetime"]];
            
            [resultArray addObject:infoList];
            if (yesORno == YES) {
                [DBOperate insertDataWithnotAutoID:infoList tableName:T_EASYBOOK_LIST];
            }
		}
	}	
    
    //保证数据只有20条
	NSMutableArray *commentItems = (NSMutableArray *)[DBOperate queryData:T_EASYBOOK_LIST theColumn:@"memberId" theColumnValue:[NSString stringWithFormat:@"%d",_userId] withAll:NO];	
	for (int i = [commentItems count] - 1; i > 19; i--)
	{
		NSArray *commentArray = [commentItems objectAtIndex:i];
		NSString *commentId = [commentArray objectAtIndex:easybook_list_id];
		//[DBOperate deleteData:T_EASYBOOK_LIST tableColumn:@"id" columnValue:commentId];
        [DBOperate deleteDataWithTwoConditions:T_EASYBOOK_LIST columnOne:@"id" valueOne:commentId columnTwo:@"memberId" valueTwo:[NSString stringWithFormat:@"%d",_userId]];
	}
    
    [self updateMemberVersion:EASYLIST_COMMAND_ID withUserId:_userId versionID:[resultDic objectForKey:@"ver"] desc:@"轻松订列表"];
    
	return resultArray;
}

//设置轻松购的默认  删除 
+ (NSMutableArray*)parseResult:(NSString*)jsonResult getVersion:(int*)ver
{
    NSDictionary *resultDic = [jsonResult JSONValue];
    NSString *retStr = [resultDic objectForKey:@"ret"];
    
    NSMutableArray *resultArray =[[NSMutableArray alloc] init];
    [resultArray addObject:retStr];
    
    return resultArray;
}

//编辑、增加轻松购
+ (NSMutableArray*)parseAddorEditReservationResult:(NSString*)jsonResult getVersion:(int*)ver
{
    NSDictionary *resultDic = [jsonResult JSONValue];
    NSString *str = [NSString stringWithFormat:@"%d",[[resultDic objectForKey:@"ret"] intValue]];
    NSMutableArray *resultArray =[[NSMutableArray alloc] init];
    [resultArray addObject:str];
    
//    NSString *bookId = [NSString stringWithFormat:@"%d",[[resultDic objectForKey:@"book_id"] intValue]];
//    NSLog(@"===%@",bookId);
//    if (bookId.length > 0) {
//        [resultArray addObject:bookId];
//    }
    return resultArray;
}

//编辑、增加地址
+ (NSMutableArray*)parseAddorEditAddressResult:(NSString*)jsonResult getVersion:(int*)ver
{
    NSDictionary *resultDic = [jsonResult JSONValue];
    NSString *str = [NSString stringWithFormat:@"%d",[[resultDic objectForKey:@"ret"] intValue]];
    NSMutableArray *resultArray =[[NSMutableArray alloc] init];
    [resultArray addObject:str];
    
    NSString *bookId = [NSString stringWithFormat:@"%d",[[resultDic objectForKey:@"id"] intValue]];
    //NSLog(@"===%@",bookId);
    NSString *time = [NSString stringWithFormat:@"%d",[[resultDic objectForKey:@"updatetime"] intValue]];
    if (bookId.length > 0 && time.length > 0) {
        [resultArray addObject:bookId];
        [resultArray addObject:time];
    }
    return resultArray;
}

//我的地址列表
+ (NSMutableArray*)parseAddressList:(NSString*)jsonResult getVersion:(int*)ver withMemberId:(int)_memberId isInsert:(BOOL)yesORno
{
    NSDictionary *resultDic = [jsonResult JSONValue];
    
	NSArray *infoArray = [resultDic objectForKey:@"infos"];
    	
	NSMutableArray *resultArray =[[NSMutableArray alloc] init];
	if (infoArray != nil) {
		for (NSDictionary *infoDic in infoArray) {
			NSMutableArray *infoList = [[NSMutableArray alloc]init];
			[infoList addObject:[infoDic objectForKey:@"id"]];
            [DBOperate deleteDataWithTwoConditions:T_ADDRESS_LIST columnOne:@"id" valueOne:[infoDic objectForKey:@"id"] columnTwo:@"memberId" valueTwo:[NSString stringWithFormat:@"%d",_memberId]];
			[infoList addObject:[NSString stringWithFormat:@"%d",_memberId]];
			[infoList addObject:[infoDic objectForKey:@"name"]];
            [infoList addObject:[infoDic objectForKey:@"mobile"]];
            [infoList addObject:[infoDic objectForKey:@"province"]];
			[infoList addObject:[infoDic objectForKey:@"city"]];
			[infoList addObject:[infoDic objectForKey:@"area"]];
			[infoList addObject:[infoDic objectForKey:@"adress"]];
			[infoList addObject:[infoDic objectForKey:@"zip_code"]];
            [infoList addObject:[infoDic objectForKey:@"updatetime"]];
            [infoList addObject:@""];
            [infoList addObject:@""];
            
            [resultArray addObject:infoList];
            if (yesORno == YES) {
                [DBOperate insertDataWithnotAutoID:infoList tableName:T_ADDRESS_LIST];
            }
		}
	}	
    
    //保证数据只有20条
	NSMutableArray *commentItems = (NSMutableArray *)[DBOperate queryData:T_ADDRESS_LIST theColumn:@"memberId" theColumnValue:[NSString stringWithFormat:@"%d",_memberId] withAll:NO];	
	for (int i = [commentItems count] - 1; i > 19; i--)
	{
		NSArray *commentArray = [commentItems objectAtIndex:i];
		NSString *commentId = [commentArray objectAtIndex:address_list_id];
		[DBOperate deleteDataWithTwoConditions:T_ADDRESS_LIST columnOne:@"id" valueOne:commentId columnTwo:@"memberId" valueTwo:[NSString stringWithFormat:@"%d",_memberId]];
	}
    
	return resultArray;
}

//我的奖品列表
+ (NSMutableArray*)parseMyPrizeList:(NSString*)jsonResult getVersion:(int*)ver withMemberId:(int)_memberId isInsert:(BOOL)yesORno
{
    NSDictionary *resultDic = [jsonResult JSONValue];
    
	NSArray *infoArray = [resultDic objectForKey:@"luckdraw_details"];
    
	NSMutableArray *resultArray =[[NSMutableArray alloc] init];
	if (infoArray != nil) {
		for (NSDictionary *infoDic in infoArray) {
			NSMutableArray *infoList = [[NSMutableArray alloc]init];
			[infoList addObject:[infoDic objectForKey:@"id"]];
            [DBOperate deleteDataWithTwoConditions:T_MY_PRIZES columnOne:@"id" valueOne:[infoDic objectForKey:@"id"] columnTwo:@"memberId" valueTwo:[NSString stringWithFormat:@"%d",_memberId]];
			[infoList addObject:[NSString stringWithFormat:@"%d",_memberId]];
			[infoList addObject:[infoDic objectForKey:@"name"]];
            [infoList addObject:[infoDic objectForKey:@"starttime"]];
            [infoList addObject:[infoDic objectForKey:@"endtime"]];
			[infoList addObject:[infoDic objectForKey:@"pic"]];
			[infoList addObject:[infoDic objectForKey:@"des"]];
			[infoList addObject:[infoDic objectForKey:@"isreceive"]];
			[infoList addObject:[infoDic objectForKey:@"created"]];
            [infoList addObject:[infoDic objectForKey:@"product_name"]];
            [infoList addObject:[infoDic objectForKey:@"product_des"]];
            [infoList addObject:[infoDic objectForKey:@"product_price"]];
            [infoList addObject:[infoDic objectForKey:@"product_sum"]];
            [infoList addObject:@""];
            
            [resultArray addObject:infoList];
            if (yesORno == YES) {
                [DBOperate insertDataWithnotAutoID:infoList tableName:T_MY_PRIZES];
            }
            [infoList release];
            
            NSArray *picArray = [infoDic objectForKey:@"pics"];
            if (picArray != nil) {
                for (NSDictionary *picDic in picArray ) {
                    NSMutableArray *pic = [[NSMutableArray alloc] init];
                    [pic addObject:[infoDic objectForKey:@"id"]];
                    [pic addObject:[picDic objectForKey:@"img_path"]];
                    [pic addObject:[picDic objectForKey:@"thumb_pic"]];
                    
                    [DBOperate insertData:pic tableName:T_MY_PRIZES_PIC];
                    [pic release];
                }
            }
		}
	}	
    
    //保证数据只有20条
	NSMutableArray *commentItems = (NSMutableArray *)[DBOperate queryData:T_MY_PRIZES theColumn:@"memberId" theColumnValue:[NSString stringWithFormat:@"%d",_memberId] withAll:NO];	
	for (int i = [commentItems count] - 1; i > 19; i--)
	{
		NSArray *commentArray = [commentItems objectAtIndex:i];
		NSString *commentId = [commentArray objectAtIndex:my_prizes_id];
		[DBOperate deleteDataWithTwoConditions:T_MY_PRIZES columnOne:@"id" valueOne:commentId columnTwo:@"memberId" valueTwo:[NSString stringWithFormat:@"%d",_memberId]];
        
        //删除对应的图片记录
        [DBOperate deleteData:T_MY_PRIZES_PIC
                  tableColumn:@"prizeId" 
                  columnValue:commentId];
	}
    
    [self updateMemberVersion:MEMBER_PRIZELIST_COMMAND_ID withUserId:_memberId versionID:[resultDic objectForKey:@"ver"] desc:@"我的奖品列表"];
	return resultArray;
}

//我的奖品 更多
+ (NSMutableArray*)parseMyPrizeListMore:(NSString*)jsonResult getVersion:(int*)ver withMemberId:(int)_memberId
{
    *ver = NO_UPDATE;
	
	NSDictionary *resultDic = [jsonResult JSONValue];

	NSArray *listArray = [resultDic objectForKey:@"luckdraw_details"];
	//插入数据
	NSMutableArray *moreArray = [[NSMutableArray alloc]init];
	
	if ([listArray count] > 0) 
	{
		for (int i = 0; i < [listArray count]; i++ ) 
		{
			NSDictionary *infoDic = [listArray objectAtIndex:i];
			NSMutableArray *infoArray = [[NSMutableArray alloc]init];

			[infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"id"]]];
			[infoArray addObject:[NSString stringWithFormat:@"%d",_memberId]];
			[infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"name"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"starttime"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"endtime"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"pic"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"des"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"isreceive"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"created"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"product_name"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"product_des"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"product_price"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"product_sum"]]];
			
			//保存图片数据
			NSMutableArray *morePicArray = [[NSMutableArray alloc]init];
			NSArray *picArray = [infoDic objectForKey:@"pics"];
			for (int j = 0; j < [picArray count]; j++ ) 
			{
				NSDictionary *picDic = [picArray objectAtIndex:j];
				NSMutableArray *pic = [[NSMutableArray alloc] init];
                [pic addObject:[NSString stringWithFormat:@"%d",j+1]];
				[pic addObject:[infoDic objectForKey:@"id"]];
				[pic addObject:[picDic objectForKey:@"img_path"]];
				[pic addObject:[picDic objectForKey:@"thumb_pic"]];
				[morePicArray insertObject:pic atIndex:j];
				[pic release];
			}
			[infoArray addObject:morePicArray];
			
			[moreArray insertObject:infoArray atIndex:i];
			[infoArray release];
		}
		*ver = NEED_UPDATE;
	}
	
	return [moreArray autorelease];
}

//我的订单列表
+ (NSMutableArray*)parseMyOrdersList:(NSString*)jsonResult getVersion:(int*)ver withUserId:(int)_userId withType:(int)_type isInsert:(BOOL)yesORno
{ 
	NSDictionary *resultDic = [jsonResult JSONValue];
    
    NSArray *orderArray = [resultDic objectForKey:@"orders"];
	NSArray *infoArray = [resultDic objectForKey:@"products"];
    
    NSMutableArray *resultArray =[[NSMutableArray alloc] init];
    
    if (orderArray != nil) {
		for (NSDictionary *infoDic in orderArray) {
			NSMutableArray *infoList = [[NSMutableArray alloc]init];
			[infoList addObject:[infoDic objectForKey:@"id"]];
            [DBOperate deleteDataWithTwoConditions:T_MYORDERS_LIST columnOne:@"id" valueOne:[infoDic objectForKey:@"id"] columnTwo:@"memberId" valueTwo:[NSString stringWithFormat:@"%d",_userId]];
			[infoList addObject:[NSNumber numberWithInt:_userId]];
			[infoList addObject:[NSNumber numberWithInt:_type]];
            [infoList addObject:[resultDic objectForKey:@"telephone"]];
            [infoList addObject:[resultDic objectForKey:@"closetime"]];
			[infoList addObject:[infoDic objectForKey:@"billno"]];
            [infoList addObject:[infoDic objectForKey:@"transaction_id"]];
            [infoList addObject:[infoDic objectForKey:@"payresult"]];
            [infoList addObject:[infoDic objectForKey:@"price"]];
			[infoList addObject:[infoDic objectForKey:@"contact_remark"]];
			[infoList addObject:[infoDic objectForKey:@"createtime"]];
			[infoList addObject:[infoDic objectForKey:@"paytime"]];
			[infoList addObject:[infoDic objectForKey:@"confirmtime"]];
			[infoList addObject:[infoDic objectForKey:@"contact_address"]];
			[infoList addObject:[infoDic objectForKey:@"zip_code"]];
			[infoList addObject:[infoDic objectForKey:@"contact_mobile"]];
            [infoList addObject:[infoDic objectForKey:@"contact_name"]];
            [infoList addObject:[infoDic objectForKey:@"updatetime"]];
            [infoList addObject:[infoDic objectForKey:@"logistics"]];
            [infoList addObject:[infoDic objectForKey:@"logistics_num"]];
            [infoList addObject:[infoDic objectForKey:@"url"]];
            [infoList addObject:[infoDic objectForKey:@"product_sum"]];
            [infoList addObject:[infoDic objectForKey:@"logistics_price"]];
            [infoList addObject:[infoDic objectForKey:@"pri_price"]];
            [infoList addObject:[infoDic objectForKey:@"full_price"]];
            [infoList addObject:[infoDic objectForKey:@"pic"]];
            
            if (yesORno == YES) {
                [DBOperate insertDataWithnotAutoID:infoList tableName:T_MYORDERS_LIST];
            }
            
            [resultArray addObject:infoList];
		}
	}	

	if (infoArray != nil) {
		for (NSDictionary *infoDic in infoArray) {
			NSMutableArray *infoList = [[NSMutableArray alloc]init];
            [infoList addObject:[infoDic objectForKey:@"order_id"]];
            [infoList addObject:[NSNumber numberWithInt:_userId]];
			[infoList addObject:[infoDic objectForKey:@"product_num"]];
            [infoList addObject:[infoDic objectForKey:@"status"]];
			[infoList addObject:[infoDic objectForKey:@"id"]];
            [DBOperate deleteDataWithTwoConditions:T_ORDER_PRODUCTS_LIST columnOne:@"product_id" valueOne:[infoDic objectForKey:@"id"] columnTwo:@"order_id" valueTwo:[infoDic objectForKey:@"order_id"]];
            [infoList addObject:[infoDic objectForKey:@"cate_id"]];
			[infoList addObject:[infoDic objectForKey:@"title"]];
            [infoList addObject:[infoDic objectForKey:@"content"]];
            [infoList addObject:[infoDic objectForKey:@"promotion_price"]];
            [infoList addObject:[infoDic objectForKey:@"price"]];
			[infoList addObject:[infoDic objectForKey:@"likes"]];
            [infoList addObject:[infoDic objectForKey:@"favorites"]];
            [infoList addObject:[infoDic objectForKey:@"unit"]];
            [infoList addObject:[infoDic objectForKey:@"salenum"]];
            [infoList addObject:[infoDic objectForKey:@"comm_num"]];
            [infoList addObject:[infoDic objectForKey:@"sort_order"]];
            [infoList addObject:[infoDic objectForKey:@"is_big_pic"]];
            [infoList addObject:[infoDic objectForKey:@"pic"]];
            [infoList addObject:[infoDic objectForKey:@"sum"]];
            [infoList addObject:[infoDic objectForKey:@"fre_type"]];
            [infoList addObject:[infoDic objectForKey:@"is_comment"]];
            
            [DBOperate insertDataWithnotAutoID:infoList tableName:T_ORDER_PRODUCTS_LIST];
            
            NSArray *picArray = [infoDic objectForKey:@"pics"];    
            
            for (NSDictionary *picDic in picArray) {
                NSMutableArray *ar_pic = [[NSMutableArray alloc]init];
                [ar_pic addObject:[infoDic objectForKey:@"order_id"]];
//                [DBOperate deleteData:T_ORDER_PRODUCTS_PICS tableColumn:@"order_id" columnValue:[infoDic objectForKey:@"id"]];
                [ar_pic addObject:[infoDic objectForKey:@"id"]];
                [ar_pic addObject:[NSNumber numberWithInt:_userId]];
                [ar_pic addObject:[picDic objectForKey:@"img_path"]];
                [ar_pic addObject:[picDic objectForKey:@"thumb_pic"]];
                
                [DBOperate insertDataWithnotAutoID:ar_pic tableName:T_ORDER_PRODUCTS_PICS];
                [ar_pic release];
            }
		}
	}
    
    //保证数据只有20条
	NSMutableArray *commentItems = (NSMutableArray *)[DBOperate queryData:T_MYORDERS_LIST theColumn:@"memberId" theColumnValue:[NSString stringWithFormat:@"%d",_userId] withAll:NO];	
	for (int i = [commentItems count] - 1; i > 19; i--)
	{
		NSArray *commentArray = [commentItems objectAtIndex:i];
		NSString *commentId = [commentArray objectAtIndex:myorders_list_id];
        [DBOperate deleteDataWithTwoConditions:T_MYORDERS_LIST columnOne:@"id" valueOne:commentId columnTwo:@"memberId" valueTwo:[NSString stringWithFormat:@"%d",_userId]];
		[DBOperate deleteDataWithTwoConditions:T_ORDER_PRODUCTS_LIST columnOne:@"order_id" valueOne:commentId columnTwo:@"memberId" valueTwo:[NSString stringWithFormat:@"%d",_userId]];
        [DBOperate deleteDataWithTwoConditions:T_ORDER_PRODUCTS_PICS columnOne:@"order_id" valueOne:commentId columnTwo:@"memberId" valueTwo:[NSString stringWithFormat:@"%d",_userId]];
	}

    [self updateMemberVersion:MEMBER_ORDERSLIST_COMMAND_ID withUserId:_userId versionID:[resultDic objectForKey:@"ver"] desc:@"我的订单列表"];
    
	return resultArray;
}

//我的优惠卷列表
+ (NSMutableArray*)parseMyDiscountListResult:(NSString*)jsonResult getVersion:(int*)ver withUserId:(int)_userId isInsert:(BOOL)yesORno
{
    NSDictionary *resultDic = [jsonResult JSONValue];
    
	NSArray *infoArray = [resultDic objectForKey:@"privileges"];
	
    NSMutableArray *resultArray =[[NSMutableArray alloc] init];
    
	if (infoArray != nil) {
        if (yesORno == YES) {
            [DBOperate deleteData:T_MYDISCOUNT_LIST tableColumn:@"memberId" columnValue:[NSString stringWithFormat:@"%d",_userId]];
        }
		for (NSDictionary *infoDic in infoArray) {
			NSMutableArray *infoList = [[NSMutableArray alloc]init];
			[infoList addObject:[infoDic objectForKey:@"id"]];
//            [DBOperate deleteDataWithTwoConditions:T_MYDISCOUNT_LIST columnOne:@"memberId" valueOne:[NSString stringWithFormat:@"%d",_userId] columnTwo:@"billno" valueTwo:[infoDic objectForKey:@"billno"]];
            [infoList addObject:[NSNumber numberWithInt:_userId]];
			[infoList addObject:[infoDic objectForKey:@"billno"]];
			[infoList addObject:[infoDic objectForKey:@"name"]];
            [infoList addObject:[infoDic objectForKey:@"tip"]];
			[infoList addObject:[infoDic objectForKey:@"price"]];
            [infoList addObject:[infoDic objectForKey:@"unit_name"]];
            [infoList addObject:[infoDic objectForKey:@"starttime"]];
            [infoList addObject:[infoDic objectForKey:@"endtime"]];
            [infoList addObject:[infoDic objectForKey:@"img"]];
			[infoList addObject:[infoDic objectForKey:@"desc"]];
            [infoList addObject:[infoDic objectForKey:@"status"]];
            [infoList addObject:@""];
            [infoList addObject:[infoDic objectForKey:@"updatetime"]];
            [infoList addObject:[infoDic objectForKey:@"use_price"]];
            
            [resultArray addObject:infoList];
            if (yesORno == YES) {
                [DBOperate insertDataWithnotAutoID:infoList tableName:T_MYDISCOUNT_LIST];
            }
        }
	}
    
    //保证数据只有20条
	NSMutableArray *commentItems = (NSMutableArray *)[DBOperate queryData:T_MYDISCOUNT_LIST theColumn:@"memberId" theColumnValue:[NSString stringWithFormat:@"%d",_userId] withAll:NO];	
	for (int i = [commentItems count] - 1; i > 19; i--)
	{
		NSArray *commentArray = [commentItems objectAtIndex:i];
		NSString *commentId = [commentArray objectAtIndex:mydiscountlist_id];
		
        [DBOperate deleteDataWithTwoConditions:T_MYDISCOUNT_LIST columnOne:@"id" valueOne:commentId columnTwo:@"memberId" valueTwo:[NSString stringWithFormat:@"%d",_userId]];
	}
    
//    [self updateMemberVersion:MEMBER_DISCOUNTLIST_COMMAND_ID withUserId:_userId versionID:[resultDic objectForKey:@"ver"] desc:@"我的优惠卷列表"];
	return resultArray;
}

//我的评价列表
+ (NSMutableArray*)parseMyCommentList:(NSString*)jsonResult getVersion:(int*)ver withUserId:(int)_userId withType:(int)_type isInsert:(BOOL)yesORno
{
    NSDictionary *resultDic = [jsonResult JSONValue];
    
	NSArray *infoArray = [resultDic objectForKey:@"products"];
    
	NSMutableArray *resultArray =[[NSMutableArray alloc] init];
    
    if ([infoArray count] > 0) {
        for (int i = 0; i < [infoArray count]; i ++) {
            NSDictionary *infoDic = [infoArray objectAtIndex:i];
            NSMutableArray *infoList = [[NSMutableArray alloc]init];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"status"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"id"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"cate_id"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"title"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"content"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"promotion_price"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"price"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"likes"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"favorites"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"unit"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"salenum"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"comm_num"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"sort_order"]]];
			[infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"is_big_pic"]]];
            [infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"pic"]]];
            [infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"sum"]]];
            [infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"fre_type"]]];
            [infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"info_id"]]];
            if (_type == 0) {
                [infoList addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"order_id"]]];
                [infoList addObject:@""];
                [infoList addObject:@""];
            }else {
                [infoList addObject:@""];
                
                NSDictionary *commentDic = [infoDic objectForKey:@"comments"];
                if (commentDic != nil) {
                    [infoList addObject:[NSString stringWithFormat:@"%@",[commentDic objectForKey:@"content"]]];
                    [infoList addObject:[NSString stringWithFormat:@"%@",[commentDic objectForKey:@"created"]]];
                }else {
                    [infoList addObject:@""];
                    [infoList addObject:@""];
                }
            }
            
            NSMutableArray *morePicArray = [[NSMutableArray alloc]init];
			NSArray *picArray = [infoDic objectForKey:@"pics"];
			for (int j = 0; j < [picArray count]; j++ ) 
			{
				NSDictionary *picDic = [picArray objectAtIndex:j];
                NSMutableArray *pic = [[NSMutableArray alloc] init];
                [pic addObject:[infoDic objectForKey:@"id"]];
                [pic addObject:[picDic objectForKey:@"img_path"]];
                [pic addObject:[picDic objectForKey:@"thumb_pic"]];
				[morePicArray insertObject:pic atIndex:j];
				[pic release];
			}
			[infoList addObject:morePicArray];
            
			[resultArray insertObject:infoList atIndex:i];
			[infoList release];
        }
    }
    
    return [resultArray autorelease];
}

//更多
+ (NSMutableArray*)parseMoreCat:(NSString*)jsonResult getVersion:(int*)ver
{
    NSDictionary *resultDic = [jsonResult JSONValue];
    NSLog(@"resultDic===%@",resultDic);
    
    NSArray *infoArray = [resultDic objectForKey:@"introducesCats"];
	NSArray *delsArray = [resultDic objectForKey:@"dels"];
	*ver = NEED_UPDATE;
	
	if (delsArray != nil) {
		for (int i = 0;i < [delsArray count] ;i++ ) {
			NSDictionary *dic = [delsArray objectAtIndex:i];
			NSNumber *temp = [dic objectForKey:@"id"];
			[DBOperate deleteData:T_MORE_CAT tableColumn:@"catId" columnValue:temp];
		}
	}
    
	NSMutableArray *resultArray =[[NSMutableArray alloc] init];
	if (infoArray != nil) {
		for (NSDictionary *infoDic in infoArray) {
			NSMutableArray *infoList = [[NSMutableArray alloc]init];
			//[infoList addObject:@""];
			[infoList addObject:[infoDic objectForKey:@"id"]];
			[DBOperate deleteData:T_MORE_CAT tableColumn:@"catId" columnValue:[infoDic objectForKey:@"id"]];
			[infoList addObject:[infoDic objectForKey:@"name"]];
			[infoList addObject:[infoDic objectForKey:@"icon"]];
			[infoList addObject:@""];
            [infoList addObject:@"0"];
            [infoList addObject:[infoDic objectForKey:@"sort_order"]];
            
			[resultArray addObject:infoList];
            //[DBOperate insertDataWithnotAutoID:infoList tableName:T_MORE_CAT];
            [DBOperate insertData:infoList tableName:T_MORE_CAT];
			[infoList release];
        }
	}	
    
    [self updateVersion:MORE_CAT_COMMAND_ID versionID:[resultDic objectForKey:@"ver"] desc:@"更多"];
    
    return [resultArray autorelease];
}

+ (NSMutableArray*)parseMoreCatInfo:(NSString*)jsonResult getVersion:(int*)ver withCatId:(int)_catId
{
    NSDictionary *resultDic = [jsonResult JSONValue];
    
    NSArray *infoArray = [resultDic objectForKey:@"introduces"];
    NSArray *delsArray = [resultDic objectForKey:@"dels"];
    *ver = NEED_UPDATE;
    
    if (delsArray != nil) {
        for (int i = 0;i < [delsArray count] ;i++ ) {
            NSDictionary *dic = [delsArray objectAtIndex:i];
            NSNumber *temp = [dic objectForKey:@"id"];
            [DBOperate deleteData:T_MORE_CATINFO tableColumn:@"cat_Id" columnValue:temp];
        }
    }
    
    NSMutableArray *resultArray =[[NSMutableArray alloc] init];
    if (infoArray != nil) {
        for (NSDictionary *infoDic in infoArray) {
            NSMutableArray *infoList = [[NSMutableArray alloc]init];
            [infoList addObject:[infoDic objectForKey:@"id"]];
            [DBOperate deleteData:T_MORE_CATINFO tableColumn:@"cat_Id" columnValue:[infoDic objectForKey:@"id"]];
            [infoList addObject:[NSNumber numberWithInt:_catId]];
            [infoList addObject:[infoDic objectForKey:@"image"]];
            [infoList addObject:@""];
            [infoList addObject:[infoDic objectForKey:@"description"]];
            [infoList addObject:[infoDic objectForKey:@"sort_order"]];
            [infoList addObject:@""];
            
            [resultArray addObject:infoList];
            //[DBOperate insertDataWithnotAutoID:infoList tableName:T_MORE_CAT];
            [DBOperate insertData:infoList tableName:T_MORE_CATINFO];
            [infoList release];
        }
    }	
    
    [DBOperate updateData:T_MORE_CAT tableColumn:@"version" columnValue:[resultDic objectForKey:@"ver"] conditionColumn:@"catId" conditionColumnValue:[NSString stringWithFormat:@"%d",_catId]];
    return [resultArray autorelease];
}

//关于我们
+(NSMutableArray*)parseAboutUsList:(NSString*)jsonResult getVersion:(int*)ver
{
	*ver = NO_UPDATE;
	
	NSDictionary *resultDic = [jsonResult JSONValue];
	
	//版本号
	NSNumber *newVer;
	if ([[Common getVersion:OPERAT_ABOUTUS_INFO] intValue] != [[resultDic objectForKey:@"ver"] intValue])
    {
        //删除原来数据
        [DBOperate deleteData:T_ABOUTUS_INFO];
        
        NSMutableArray *infoArray = [[NSMutableArray alloc]init];
        [infoArray addObject:[resultDic objectForKey:@"logo"]];
        [infoArray addObject:@""];
        [infoArray addObject:[resultDic objectForKey:@"telephone"]];
        [infoArray addObject:[resultDic objectForKey:@"mobile_phone"]];
        [infoArray addObject:[resultDic objectForKey:@"fax"]];
        [infoArray addObject:[resultDic objectForKey:@"email"]];
        [infoArray addObject:[resultDic objectForKey:@"description"]];
        
        //插入数据库
        [DBOperate insertDataWithnotAutoID:infoArray tableName:T_ABOUTUS_INFO];
        
        [infoArray release];
        
        *ver = NEED_UPDATE;
        
        //更新版本号
        newVer = [resultDic objectForKey:@"ver"];
        [self updateVersion:OPERAT_ABOUTUS_INFO versionID:newVer desc:@"关于我们"];
    }
	
	return nil;
}

//推荐应用
+ (NSMutableArray*)parseRecommendApp:(NSString*)jsonResult getVersion:(int*)ver
{
    *ver = NO_UPDATE;
	
	NSDictionary *resultDic = [jsonResult JSONValue];
    
    //广告版本号
	NSNumber *adNewVer = [resultDic objectForKey:@"ad_ver"];
	
	//应用版本号
	NSNumber *appNewVer = [resultDic objectForKey:@"app_ver"];
    
    //广告
    NSDictionary *adDic = [resultDic objectForKey:@"ad"];
	
    //删除的广告数据
	NSDictionary *adDelsDic = [resultDic objectForKey:@"ad_dels"];
    
    if ([adDelsDic count] > 0)
    {
        //清空数据
        //[DBOperate deleteData:T_RECOMMEND_APP_AD];
        
        NSNumber *adDelID = [NSNumber numberWithInteger:[[adDelsDic objectForKey:@"id"] intValue]];
        [DBOperate deleteData:T_RECOMMEND_APP_AD
                  tableColumn:@"id" 
                  columnValue:adDelID];
    }
	
    //更新广告
    if ([adDic count] > 0)
    {

        //入库
        NSMutableArray *adInfoArray = [[NSMutableArray alloc]init];
        [adInfoArray addObject:[adDic objectForKey:@"id"]];
        [adInfoArray addObject:[NSString stringWithFormat:@"%@",[adDic objectForKey:@"url"]]];
        [adInfoArray addObject:[NSString stringWithFormat:@"%@",[adDic objectForKey:@"img"]]];
        
        //插入数据库
        [DBOperate insertDataWithnotAutoID:adInfoArray tableName:T_RECOMMEND_APP_AD];
        [adInfoArray release];
        
        *ver = NEED_UPDATE;
    }
    
    //更新数据
	NSArray *listArray = [resultDic objectForKey:@"appcenters"];
	
	//删除的应用数据
	NSArray *delsArray = [resultDic objectForKey:@"dels"];
	
	//删除数据
	if ([delsArray count] > 0)
	{
		for(NSDictionary *delDic in delsArray)
		{
			NSNumber *delID = [NSNumber numberWithInteger:[[delDic objectForKey:@"id"] intValue]];
			[DBOperate deleteData:T_RECOMMEND_APP
					  tableColumn:@"id" 
					  columnValue:delID];
			
		}
		*ver = NEED_UPDATE;
	}
	
	//保存数据
	if ([listArray count] > 0) 
	{
		for (int i = 0; i < [listArray count];i++ ) 
		{
			//非空判断 例子
			//[infoArray addObject:[infoDic objectForKey:@"xxx"] == [NSNull null] ? @"" : [infoDic objectForKey:@"xxx"]];
            
            NSDictionary *infoDic = [listArray objectAtIndex:i];
            NSMutableArray *infoArray = [[NSMutableArray alloc]init];
            [infoArray addObject:[infoDic objectForKey:@"id"]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"app_name"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"url"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"app_icon"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"desc"]]];
            [infoArray addObject:[infoDic objectForKey:@"sort_order"]];
            
			//插入数据库
			[DBOperate insertDataWithnotAutoID:infoArray tableName:T_RECOMMEND_APP];
			[infoArray release];
		}
		*ver = NEED_UPDATE;
	}
	
	//保证数据只有20条
	NSMutableArray *recommendAppItems = (NSMutableArray *)[DBOperate queryData:T_RECOMMEND_APP theColumn:@"" theColumnValue:@"" orderBy:@"sort_order" orderType:@"desc" withAll:YES];
	
	for (int i = [recommendAppItems count] - 1; i > 19; i--)
	{
		NSArray *recommendAppArray = [recommendAppItems objectAtIndex:i];
		NSString *recommendAppId = [recommendAppArray objectAtIndex:recommand_app_id];
		[DBOperate deleteData:T_RECOMMEND_APP tableColumn:@"id" columnValue:recommendAppId];
	}
	
	//更新版本号
    [self updateVersion:OPERAT_RECOMMEND_APP_AD_REFRESH versionID:adNewVer desc:@"推荐应用广告"];
    [self updateVersion:OPERAT_RECOMMEND_APP_REFRESH versionID:appNewVer desc:@"推荐应用"];
	
	return nil;
}

//推荐应用更多
+ (NSMutableArray*)parseRecommendAppMore:(NSString*)jsonResult getVersion:(int*)ver
{
    *ver = NO_UPDATE;
	
	NSDictionary *resultDic = [jsonResult JSONValue];
	
	//版本号
	//NSNumber *newVer = [resultDic objectForKey:@"ver"];
	
	//更新数据
	NSArray *listArray = [resultDic objectForKey:@"appcenters"];
	
	
	//插入数据
	NSMutableArray *moreArray = [[NSMutableArray alloc]init];
	
	if ([listArray count] > 0) 
	{
		for (int i = 0; i < [listArray count]; i++ ) 
		{
			//非空判断 例子
			//[infoArray addObject:[infoDic objectForKey:@"xxx"] == [NSNull null] ? @"" : [infoDic objectForKey:@"xxx"]];
			
			NSDictionary *infoDic = [listArray objectAtIndex:i];
			NSMutableArray *infoArray = [[NSMutableArray alloc]init];
            [infoArray addObject:[infoDic objectForKey:@"id"]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"app_name"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"url"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"app_icon"]]];
            [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"desc"]]];
            [infoArray addObject:[infoDic objectForKey:@"sort_order"]];
			[moreArray insertObject:infoArray atIndex:i];
			[infoArray release];
		}
		*ver = NEED_UPDATE;
	}
	
	return [moreArray autorelease];
	
}


//发送评论 以及收藏 
+(NSMutableArray*)parseSendCommentAndFavorite:(NSString*)jsonResult getVersion:(int*)ver
{
	*ver = NEED_UPDATE;
	
	NSDictionary *resultDic = [jsonResult JSONValue];
	NSString *numStr = [resultDic objectForKey:@"num"];
	NSMutableArray *array = [[NSMutableArray alloc]init];
	[array addObject:[resultDic objectForKey:@"ret"]];
    if (numStr != nil) {
        [array addObject:numStr];
    }
	return array;
	
}

//设备令牌接口
+ (NSMutableArray*)parseApns:(NSString*)jsonResult getVersion:(int*)ver
{
    *ver = NO_UPDATE;
    
	NSDictionary *dic = [jsonResult JSONValue];
	//int issuccess = [[dic objectForKey:@"isSuccess"]intValue];
    
	//付款方式
    [DBOperate deleteData:T_SYSTEM_CONFIG tableColumn:@"tag" columnValue:@"isAlipay"];
    [DBOperate deleteData:T_SYSTEM_CONFIG tableColumn:@"tag" columnValue:@"isDeliverypay"];
    
    NSMutableArray *isAlipayArray = [[NSMutableArray alloc]init];
    [isAlipayArray addObject:@"isAlipay"];
    [isAlipayArray addObject:[dic objectForKey:@" is_alipay"]];
    [DBOperate insertDataWithnotAutoID:isAlipayArray tableName:T_SYSTEM_CONFIG];
    [isAlipayArray release];
    
    NSMutableArray *isDeliverypayArray = [[NSMutableArray alloc]init];
    [isDeliverypayArray addObject:@"isDeliverypay"];
    [isDeliverypayArray addObject:[dic objectForKey:@"is_deliverypay"]];
    [DBOperate insertDataWithnotAutoID:isDeliverypayArray tableName:T_SYSTEM_CONFIG];
    [isDeliverypayArray release];
    
    //本地存储活动版本号
    int pri1_ver = [[Common getVersion:SHARE_CLIENT_PROMOTION_ID] intValue];
    int pri2_ver = [[Common getVersion:SHARE_PRODUCT_PROMOTION_ID] intValue];
    int full_ver = [[Common getVersion:FULL_PROMOTION_ID] intValue];
    //服务端下发版本号
    int pri1s_ver = [[dic objectForKey:@"pri_ver1"] intValue];
    int pri2s_ver = [[dic objectForKey:@"pri_ver2"] intValue];
    int fulls_ver = [[dic objectForKey:@"ful_ver"] intValue];
    if (pri1_ver != pri1s_ver) {
        [DBOperate deleteData:T_SHARE_CLIENT_PROMOTION];
    }
    if (pri2_ver != pri2s_ver) {
        [DBOperate deleteData:T_SHARE_PRODUCT_PROMOTION];
    }
    if (full_ver != fulls_ver) {
        [DBOperate deleteData:T_FULL_PROMOTION];
    }
    
    NSDictionary *cpObjectDic = [dic objectForKey:@"pri_activity1"];
    NSDictionary *ppObjectDic = [dic objectForKey:@"pri_activity2"];
    NSDictionary *fpObjectDic = [dic objectForKey:@"ful_activity"];
    if (cpObjectDic != nil && [cpObjectDic count] > 0) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [array addObject:[cpObjectDic objectForKey:@"id"]];
        [array addObject:[cpObjectDic objectForKey:@"name"]];
        [array addObject:[cpObjectDic objectForKey:@"tip"]];
        [array addObject:[cpObjectDic objectForKey:@"price"]];
        [array addObject:[cpObjectDic objectForKey:@"starttime"]];
        [array addObject:[cpObjectDic objectForKey:@"endtime"]];
        [array addObject:[cpObjectDic objectForKey:@"img"]];
        [array addObject:@""];
        [array addObject:[cpObjectDic objectForKey:@"desc"]];
        [array addObject:[cpObjectDic objectForKey:@"share_content"]];
        [array addObject:[cpObjectDic objectForKey:@"share_img"]];
        [array addObject:@""];
        [array addObject:[cpObjectDic objectForKey:@"unit_name"]];
        [array addObject:@"0"];
        [DBOperate deleteData:T_SHARE_CLIENT_PROMOTION];
        [DBOperate insertDataWithnotAutoID:array tableName:T_SHARE_CLIENT_PROMOTION];
        [array release];
        [self updateVersion:SHARE_CLIENT_PROMOTION_ID versionID:[dic objectForKey:@"pri_ver1"] desc:@""];
    }
    if (ppObjectDic != nil && [ppObjectDic count] > 0) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        [array addObject:[ppObjectDic objectForKey:@"id"]];
        [array addObject:[ppObjectDic objectForKey:@"name"]];
        [array addObject:[ppObjectDic objectForKey:@"price"]];
        [array addObject:[ppObjectDic objectForKey:@"starttime"]];
        [array addObject:[ppObjectDic objectForKey:@"endtime"]];
        [array addObject:[ppObjectDic objectForKey:@"img"]];
        [array addObject:@""];
        [array addObject:[ppObjectDic objectForKey:@"desc"]];
        [array addObject:[ppObjectDic objectForKey:@"unit_name"]];
        [array addObject:[ppObjectDic objectForKey:@"use_price"]];
        [DBOperate deleteData:T_SHARE_PRODUCT_PROMOTION];
        [DBOperate insertDataWithnotAutoID:array tableName:T_SHARE_PRODUCT_PROMOTION];
        [array release];
        [self updateVersion:SHARE_PRODUCT_PROMOTION_ID versionID:[dic objectForKey:@"pri_ver2"] desc:@""];
    }
    if (fpObjectDic != nil && [fpObjectDic count] > 0) {
        
        [DBOperate deleteData:T_FULL_PROMOTION];
        
        if ([[fpObjectDic objectForKey:@"type"] intValue] == 0){
            NSArray *reduceArray = [fpObjectDic objectForKey:@"reduces"];
            if ([reduceArray count] > 0) {
                for (int i = 0; i < [reduceArray count]; i ++) {
                    NSMutableArray *array = [[NSMutableArray alloc] init];
                    [array addObject:[fpObjectDic objectForKey:@"id"]];
                    [array addObject:[fpObjectDic objectForKey:@"name"]];
                    [array addObject:[fpObjectDic objectForKey:@"type"]];
                    NSDictionary *postDic = [reduceArray objectAtIndex:i];
                    [array addObject:[postDic objectForKey:@"price"]];
                    [array addObject:[postDic objectForKey:@"reduce"]];
                    [array addObject:[fpObjectDic objectForKey:@"starttime"]];
                    [array addObject:[fpObjectDic objectForKey:@"endtime"]];
                    
                    [DBOperate insertDataWithnotAutoID:array tableName:T_FULL_PROMOTION];
                    [array release];
                }
            }
        }else {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:[fpObjectDic objectForKey:@"id"]];
            [array addObject:[fpObjectDic objectForKey:@"name"]];
            [array addObject:[fpObjectDic objectForKey:@"type"]];
            [array addObject:[fpObjectDic objectForKey:@"total"]];
            [array addObject:[fpObjectDic objectForKey:@"discount"]];
            [array addObject:[fpObjectDic objectForKey:@"starttime"]];
            [array addObject:[fpObjectDic objectForKey:@"endtime"]];
            [DBOperate insertDataWithnotAutoID:array tableName:T_FULL_PROMOTION];
            [array release];
        }
        
        [self updateVersion:FULL_PROMOTION_ID versionID:[dic objectForKey:@"ful_ver"] desc:@"满就送版本号"];
    }
    
    //物流方式--------
    NSMutableArray *postArray = [dic objectForKey:@"posts"];
    if (postArray != nil && [postArray count] > 0) {
        [DBOperate deleteData:T_SENDSTYLE];
        for (int i = 0; i < [postArray count]; i ++) {
            NSDictionary *postDic = [postArray objectAtIndex:i];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:[postDic objectForKey:@"id"]];
            [array addObject:[postDic objectForKey:@"name"]];
            [array addObject:@""];
            [array addObject:@""];
            [array addObject:@""];
            
            [DBOperate insertDataWithnotAutoID:array tableName:T_SENDSTYLE];
            [array release];
            
        }
    }
    
    [self updateVersion:POST_VER versionID:[dic objectForKey:@"post_ver"] desc:@"物流版本号"];
    
    //--------- 自定义引导页 ----
    int guideVerNew = [[dic objectForKey:@"guide_ver"] intValue];
    //NSLog(@"guideVerNew====%d",guideVerNew);
    if (guideVerNew == -1) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"noShow"];
    }else {
        int guideVer = [[Common getVersion:GUIDE_COMMAND_ID] intValue];
        //NSLog(@"guideVer====%d",guideVer);
        if (guideVerNew > guideVer) {
            *ver = NEED_UPDATE;
            [DBOperate deleteData:T_GUIDE_IMAGES];
            [self updateVersion:GUIDE_COMMAND_ID versionID:[dic objectForKey:@"guide_ver"] desc:@"引导页版本号"];
        }
    }

    //----- 自动升级 ----
    NSDictionary *autoObjectDic = [dic objectForKey:@"autopromotion"];
    if (autoObjectDic != nil && [autoObjectDic count] > 0) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [array addObject:[NSNumber numberWithInt:0]];
        [array addObject:[autoObjectDic objectForKey:@"promote_ver"]];
        [array addObject:[autoObjectDic objectForKey:@"url"]];
        [array addObject:[NSNumber numberWithInt:0]];
        [array addObject:[autoObjectDic objectForKey:@"remark"]];

        [DBOperate deleteData:T_APP_INFO tableColumn:@"type" columnValue:[NSNumber numberWithInt:0]];
        [DBOperate insertDataWithnotAutoID:array tableName:T_APP_INFO];
        [array release];
    }
    //---- 评分提醒 ----
    NSDictionary *commentObjectDic = [dic objectForKey:@"grade"];
    if (commentObjectDic != nil && [commentObjectDic count] > 0) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [array addObject:[NSNumber numberWithInt:1]];
        [array addObject:[commentObjectDic objectForKey:@"grade_ver"]];
        [array addObject:[commentObjectDic objectForKey:@"url"]];
        [array addObject:[NSNumber numberWithInt:0]];
        [array addObject:@""];
        
        [DBOperate deleteData:T_APP_INFO tableColumn:@"type" columnValue:[NSNumber numberWithInt:1]];
        [DBOperate insertDataWithnotAutoID:array tableName:T_APP_INFO];
        [array release];
    }
    
    return nil;
}

//解析引导页的图片
+ (NSMutableArray*)parseGuideImagesResult:(NSString*)jsonResult getVersion:(int*)ver
{
    NSDictionary *resultDic = [jsonResult JSONValue];
    NSArray *imagesArr = [resultDic objectForKey:@"imgs"];
    //NSLog(@"imagesArr====%@",imagesArr);
    if ([imagesArr count] > 0) {
        for (int i = 0; i < [imagesArr count]; i ++) {
            NSDictionary *infoDic = [imagesArr objectAtIndex:i];
            
            NSMutableArray *infoList = [[NSMutableArray alloc]init];
			[infoList addObject:[infoDic objectForKey:@"img_path"]];
            [infoList addObject:@""];
            
            [DBOperate insertData:infoList tableName:T_GUIDE_IMAGES];
        }
    }
    return nil;
}

//解析分店地图
+ (NSMutableArray*)parseShopMapResult:(NSString*)jsonResult getVersion:(int*)ver
{
    NSDictionary *resultDic = [jsonResult JSONValue];
    NSArray *delsArray = [resultDic objectForKey:@"dels"];
    if (delsArray != nil) {
        for (int i = 0;i < [delsArray count] ;i++ ) {
            NSDictionary *dic = [delsArray objectAtIndex:i];
            NSNumber *temp = [dic objectForKey:@"id"];
            [DBOperate deleteData:T_SUBBRANCH tableColumn:@"id" columnValue:temp];
        }
    }
    
    NSArray *shopsArr = [resultDic objectForKey:@"branchs"];
    if ([shopsArr count] > 0) {
        for (int i = 0; i < [shopsArr count]; i ++) {
            NSDictionary *infoDic = [shopsArr objectAtIndex:i];
            
            NSMutableArray *infoList = [[NSMutableArray alloc]init];
			[infoList addObject:[infoDic objectForKey:@"id"]];
            [infoList addObject:[infoDic objectForKey:@"name"]];
            [infoList addObject:[infoDic objectForKey:@"contact_way"]];
            [infoList addObject:[infoDic objectForKey:@"address"]];
            [infoList addObject:[infoDic objectForKey:@"coordinate"]];
            
            [DBOperate insertDataWithnotAutoID:infoList tableName:T_SUBBRANCH];
        }
    }
    
    [self updateVersion:MAP_COMMAND_ID versionID:[resultDic objectForKey:@"ver"] desc:@"分店地图"];
    return nil;
}

//获取产品评论列表
+(NSMutableArray*)parseProductCommentList:(NSString*)jsonResult getVersion:(int*)ver{
    
//    @synchronized(jsonResult){
//        
//    }
    *ver = NEED_UPDATE;
	
	NSDictionary *resultDic = [jsonResult JSONValue];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    NSArray *infoArray = [resultDic objectForKey:@"comments"];
	
	if (infoArray != nil) {
		for (NSDictionary *infoDic in infoArray) {
            NSMutableArray *array = [[NSMutableArray alloc]init];
            [array addObject:[infoDic objectForKey:@"created"]];
            [array addObject:[infoDic objectForKey:@"content"]];
            [array addObject:[infoDic objectForKey:@"username"]];
            [array addObject:[infoDic objectForKey:@"headImg"]];
            [resultArray addObject:array];
            [array release];
        }
        
    }
    NSLog(@"resultArray:%@",resultArray);
    return resultArray;
}

+(NSMutableArray*)parseSubmitOrder:(NSString*)jsonResult getVersion:(int*)ver{
    *ver = NEED_UPDATE;
	NSDictionary *resultDic = [jsonResult JSONValue];
    NSMutableArray *array = [[NSMutableArray alloc]init];
	NSNumber *ret = [resultDic objectForKey:@"ret"];
    [array addObject:ret];
    if ([ret intValue] == 1) {
        NSString *billno = [resultDic objectForKey:@"billno"];
        NSNumber *price = [resultDic objectForKey:@"price"];
        [array addObject:billno];
        [array addObject:price];
    }
    if ([ret intValue] == 2) {  //产品库存不足时
        [array addObject:[resultDic objectForKey:@"not_enoughs"]];
    }
    if ([ret intValue] == 3) {  //购物车中的商品下架
        [array addObject:[resultDic objectForKey:@"dels"]];
    }
    
	return [array autorelease];
}

+(NSMutableArray*)parseProductDetail:(NSString*)jsonResult getVersion:(int*)ver withParam:(NSMutableDictionary*)param{
    
    *ver = NO_UPDATE;
	int catId = [[param objectForKey:@"cat_id"] intValue];
	NSDictionary *infoDic = [jsonResult JSONValue];
    int status = [[infoDic objectForKey:@"status"] intValue];
    if (status == 0) {
        return nil;
    }else{
        //插入数据
        NSMutableArray *productArray = [[NSMutableArray alloc]init];
        
        NSMutableArray *infoArray = [[NSMutableArray alloc]init];
        [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"id"]]];
        [infoArray addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt: catId]]];
        [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"title"]]];
        [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"content"]]];
        [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"promotion_price"]]];
        [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"price"]]];
        [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"likes"]]];
        [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"favorites"]]];
        [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"unit"]]];
        [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"salenum"]]];
        [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"comm_num"]]];
        [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"sort_order"]]];
        [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"is_big_pic"]]];
        [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"pic"]]];
        [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"sum"]]];
        [infoArray addObject:[NSString stringWithFormat:@"%@",[infoDic objectForKey:@"fre_type"]]];
        
        //保存图片数据
        NSMutableArray *morePicArray = [[NSMutableArray alloc]init];
        NSArray *picArray = [infoDic objectForKey:@"pics"];
        for (int j = 0; j < [picArray count]; j++ )
        {
            NSDictionary *picDic = [picArray objectAtIndex:j];
            NSMutableArray *pic = [[NSMutableArray alloc] init];
            [pic addObject:@""];
            [pic addObject:[infoDic objectForKey:@"id"]];
            [pic addObject:[picDic objectForKey:@"img_path"]];
            [pic addObject:[picDic objectForKey:@"thumb_pic"]];
            [pic addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt: catId]]];
            [morePicArray insertObject:pic atIndex:j];
            [pic release];
        }
        [infoArray addObject:morePicArray];
        
        [productArray addObject:infoArray];
        [infoArray release];
        return [productArray autorelease];
    }
}
#pragma mark 领取优惠券结果解析
+ (NSMutableArray*)parseGetPromotionCode:(NSString*)jsonResult getVersion:(int*)ver
{
    NSDictionary *resultDic = [jsonResult JSONValue];
    NSMutableArray *resultArray =[[NSMutableArray alloc] init];
    [resultArray addObject:[resultDic objectForKey:@"ret"]];
    //    [resultArray addObject:[resultDic objectForKey:@"billno"]];
    
    return [resultArray autorelease];
}

+ (NSMutableArray*)parseGetDeliveryFare:(NSString*)jsonResult getVersion:(int*)ver{
    
    NSDictionary *resultDic = [jsonResult JSONValue];
    NSMutableArray *resultArray =[[NSMutableArray alloc] init];
    [resultArray addObject:[resultDic objectForKey:@"prices"]];
    
    return [resultArray autorelease];
}

+ (NSMutableArray*)parsePayOrder:(NSString*)jsonResult getVersion:(int*)ver{
    NSDictionary *resultDic = [jsonResult JSONValue];
    NSMutableArray *resultArray =[[NSMutableArray alloc] init];
    [resultArray addObject:[resultDic objectForKey:@"ret"]];
    
    return [resultArray autorelease];
}

//资讯详情页面
+ (NSMutableArray*)parseNewDetail:(NSString*)jsonResult withNewId:(int)_newId
{
    NSDictionary *resultDic = [jsonResult JSONValue];
    
    NSMutableArray *resultArray =[[NSMutableArray alloc] init];
    [resultArray addObject:[NSNumber numberWithInt:_newId]];
    [resultArray addObject:[resultDic objectForKey:@"title"]];
    [resultArray addObject:[resultDic objectForKey:@"content"]];
    [resultArray addObject:@""];
    [resultArray addObject:[resultDic objectForKey:@"comments"]];
    [resultArray addObject:@""];
    [resultArray addObject:@""];
    [resultArray addObject:[resultDic objectForKey:@"recommend_img"]];
    [resultArray addObject:@""];
    
    return resultArray;
}
@end
