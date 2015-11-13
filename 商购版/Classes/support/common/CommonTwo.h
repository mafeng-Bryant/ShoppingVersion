//
//  CommonTwo.h
//  shopping
//
//  Created by LuoHui on 13-2-28.
//
//

#import <Foundation/Foundation.h>
#import "SBJson.h"
#import "DBOperate.h"
#import "base64.h"
#import <SystemConfiguration/SystemConfiguration.h>
#include <netdb.h>
#import <CoreLocation/CoreLocation.h>

#define SITE_ID 2

#define kAPPName @"华中企业家俱乐部"

//loading提示
#define LOADING_TIPS @"云端同步中..."

//加密key
#define SignSecureKey  @"SGAPP9I0I6IyunlaiINTERFACE"

#define PI 3.1415926

#define NEED_UPDATE 1
#define NO_UPDATE 0

//一天抽奖最多的次数
#define ONE_DATE_LOTTERY_TIMES 10

#define MAP_COMMAND_ID                     242   //分店地图

@interface CommonTwo : NSObject
{
    
}

+(BOOL)connectedToNetwork;
+(NSString*)TransformJson:(NSMutableDictionary*)sourceDic withLinkStr:(NSString*)strurl;
//+(NSString*)encodeBase64:(NSMutableData*)data;
+(NSString*)URLEncodedString:(NSString*)input;
+(NSString*)URLDecodedString:(NSString*)input;
+(NSNumber*)getVersion:(int)commandId;
+ (NSNumber*)getMemberVersion:(int)memberId commandID:(int)_commandId;
+(NSString*)getSecureString;
+(NSString*)getLotteryLogs:(NSString *)dateString;
+ (NSString*)getMacAddress;
+(double)lantitudeLongitudeToDist:(double)lon1 Latitude1:(double)lat1 long2:(double)lon2 Latitude2:(double)lat2;
@end
