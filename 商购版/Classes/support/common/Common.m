//
//  Common.m
//  Profession
//
//  Created by MC374 on 12-8-7.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Common.h"
#import "Encry.h"

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>  
#include <net/if.h>
#include <net/if_dl.h>
#import "SvUDIDTools.h"

//这里面 要写在这里才可以（调试各种方法，另几个项目也可以但这个不行一直报invaild in C99问题，目前只能用这种笨方法了）devin
const UInt8 kBase64EncodeTable[64] = {
    /*  0 */ 'A',	/*  1 */ 'B',	/*  2 */ 'C',	/*  3 */ 'D',
    /*  4 */ 'E',	/*  5 */ 'F',	/*  6 */ 'G',	/*  7 */ 'H',
    /*  8 */ 'I',	/*  9 */ 'J',	/* 10 */ 'K',	/* 11 */ 'L',
    /* 12 */ 'M',	/* 13 */ 'N',	/* 14 */ 'O',	/* 15 */ 'P',
    /* 16 */ 'Q',	/* 17 */ 'R',	/* 18 */ 'S',	/* 19 */ 'T',
    /* 20 */ 'U',	/* 21 */ 'V',	/* 22 */ 'W',	/* 23 */ 'X',
    /* 24 */ 'Y',	/* 25 */ 'Z',	/* 26 */ 'a',	/* 27 */ 'b',
    /* 28 */ 'c',	/* 29 */ 'd',	/* 30 */ 'e',	/* 31 */ 'f',
    /* 32 */ 'g',	/* 33 */ 'h',	/* 34 */ 'i',	/* 35 */ 'j',
    /* 36 */ 'k',	/* 37 */ 'l',	/* 38 */ 'm',	/* 39 */ 'n',
    /* 40 */ 'o',	/* 41 */ 'p',	/* 42 */ 'q',	/* 43 */ 'r',
    /* 44 */ 's',	/* 45 */ 't',	/* 46 */ 'u',	/* 47 */ 'v',
    /* 48 */ 'w',	/* 49 */ 'x',	/* 50 */ 'y',	/* 51 */ 'z',
    /* 52 */ '0',	/* 53 */ '1',	/* 54 */ '2',	/* 55 */ '3',
    /* 56 */ '4',	/* 57 */ '5',	/* 58 */ '6',	/* 59 */ '7',
    /* 60 */ '8',	/* 61 */ '9',	/* 62 */ '+',	/* 63 */ '/'
};

const UInt8 kBits_00000011 = 0x03;
const UInt8 kBits_00001111 = 0x0F;
const UInt8 kBits_00110000 = 0x30;
const UInt8 kBits_00111100 = 0x3C;
const UInt8 kBits_00111111 = 0x3F;
const UInt8 kBits_11000000 = 0xC0;
const UInt8 kBits_11110000 = 0xF0;
const UInt8 kBits_11111100 = 0xFC;

size_t EstimateBas64EncodedDataSize(size_t inDataSize)
{
    size_t theEncodedDataSize = (int)ceil(inDataSize / 3.0) * 4;
    theEncodedDataSize = theEncodedDataSize / 72 * 74 + theEncodedDataSize % 72;
    return(theEncodedDataSize);
}

bool Base64EncodeData(const void *inInputData, size_t inInputDataSize, char *outOutputData, size_t *ioOutputDataSize, BOOL wrapped)
{
    size_t theEncodedDataSize = EstimateBas64EncodedDataSize(inInputDataSize);
    if (*ioOutputDataSize < theEncodedDataSize)
        return(false);
    *ioOutputDataSize = theEncodedDataSize;
    const UInt8 *theInPtr = (const UInt8 *)inInputData;
    UInt32 theInIndex = 0, theOutIndex = 0;
    for (; theInIndex < (inInputDataSize / 3) * 3; theInIndex += 3)
    {
        outOutputData[theOutIndex++] = kBase64EncodeTable[(theInPtr[theInIndex] & kBits_11111100) >> 2];
        outOutputData[theOutIndex++] = kBase64EncodeTable[(theInPtr[theInIndex] & kBits_00000011) << 4 | (theInPtr[theInIndex + 1] & kBits_11110000) >> 4];
        outOutputData[theOutIndex++] = kBase64EncodeTable[(theInPtr[theInIndex + 1] & kBits_00001111) << 2 | (theInPtr[theInIndex + 2] & kBits_11000000) >> 6];
        outOutputData[theOutIndex++] = kBase64EncodeTable[(theInPtr[theInIndex + 2] & kBits_00111111) >> 0];
        if (wrapped && (theOutIndex % 74 == 72))
        {
            outOutputData[theOutIndex++] = '\r';
            outOutputData[theOutIndex++] = '\n';
        }
    }
    const size_t theRemainingBytes = inInputDataSize - theInIndex;
    if (theRemainingBytes == 1)
    {
        outOutputData[theOutIndex++] = kBase64EncodeTable[(theInPtr[theInIndex] & kBits_11111100) >> 2];
        outOutputData[theOutIndex++] = kBase64EncodeTable[(theInPtr[theInIndex] & kBits_00000011) << 4 | (0 & kBits_11110000) >> 4];
        outOutputData[theOutIndex++] = '=';
        outOutputData[theOutIndex++] = '=';
        if (wrapped && (theOutIndex % 74 == 72))
        {
            outOutputData[theOutIndex++] = '\r';
            outOutputData[theOutIndex++] = '\n';
        }
    }
    else if (theRemainingBytes == 2)
    {
        outOutputData[theOutIndex++] = kBase64EncodeTable[(theInPtr[theInIndex] & kBits_11111100) >> 2];
        outOutputData[theOutIndex++] = kBase64EncodeTable[(theInPtr[theInIndex] & kBits_00000011) << 4 | (theInPtr[theInIndex + 1] & kBits_11110000) >> 4];
        outOutputData[theOutIndex++] = kBase64EncodeTable[(theInPtr[theInIndex + 1] & kBits_00001111) << 2 | (0 & kBits_11000000) >> 6];
        outOutputData[theOutIndex++] = '=';
        if (wrapped && (theOutIndex % 74 == 72))
        {
            outOutputData[theOutIndex++] = '\r';
            outOutputData[theOutIndex++] = '\n';
        }
    }
    return(true);
}


@implementation Common

+(BOOL)connectedToNetwork{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        NSLog(@"Error. Could not recover network reachability flags");
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	
    return (isReachable && !needsConnection) ? YES : NO;
}

+(NSString*)TransformJson:(NSMutableDictionary*)sourceDic withLinkStr:(NSString*)strurl{
	SBJsonWriter *writer = [[SBJsonWriter alloc]init];
	NSString *jsonConvertedObj = [writer stringWithObject:sourceDic];
	//NSLog(@"jsonConvertedObj:%@",jsonConvertedObj);
    [writer release];
	NSString *b64 = [Common encodeBase64:(NSMutableData *)[jsonConvertedObj dataUsingEncoding: NSUTF8StringEncoding]];
	NSString *urlEncode = [Common URLEncodedString:b64];
	NSString *reqStr = [NSString stringWithFormat:strurl,urlEncode];
	//NSLog(@"req_string:%@",reqStr);
	return reqStr;
}
+(NSString*)encodeBase64:(NSMutableData*)data{
	size_t outputDataSize = EstimateBas64EncodedDataSize([data length]);
	Byte outputData[outputDataSize];
	Base64EncodeData([data bytes], [data length], outputData,&outputDataSize, YES);
	NSData *theData = [[NSData alloc]initWithBytes:outputData length:outputDataSize];//create a NSData object from the decoded data
	NSString *stringValue1 = [[NSString alloc]initWithData:theData encoding:NSUTF8StringEncoding];
	//NSLog(@"reqdata string base64 %@",stringValue1);
	[theData release];
	return [stringValue1 autorelease];
}
+ (NSString*)URLEncodedString:(NSString*)input  
{  
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,  
                                                                           (CFStringRef)input,  
                                                                           NULL,  
                                                                           CFSTR("!*'();:@&=+$,/?%#[]"),  
                                                                           kCFStringEncodingUTF8);  
    [result autorelease];  
    return result;  
}  
+ (NSString*)URLDecodedString:(NSString*)input  
{  
    NSString *result = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,  
                                                                                           (CFStringRef)input,  
                                                                                           CFSTR(""),  
                                                                                           kCFStringEncodingUTF8);  
    [result autorelease];  
    return result;    
}  

+(NSNumber*)getVersion:(int)commandId{
	NSArray *ar_version = [DBOperate queryData:T_VERSION theColumn:@"command_id" 
								theColumnValue:[NSString stringWithFormat:@"%d",commandId] withAll:NO];
	
	if ([ar_version count]>0) {
		NSArray *arr_version = [ar_version objectAtIndex:0];
		return [arr_version objectAtIndex:version_ver];
	}
	else {
		return [NSNumber numberWithInt:0];
	}
}

+ (NSNumber*)getMemberVersion:(int)memberId commandID:(int)_commandId
{
	NSArray *ar_version = [DBOperate queryData:T_MEMBER_VERSION theColumn:@"memberId" equalValue:[NSNumber numberWithInt:memberId] theColumn:@"id" equalValue:[NSNumber numberWithInt:_commandId]];
	if ([ar_version count]>0) {
		NSArray *arr_version = [ar_version objectAtIndex:0];
		return [arr_version objectAtIndex:member_version_ver];
        NSLog(@"%d",[[arr_version objectAtIndex:member_version_ver] intValue]);
	}
	else {
		return [NSNumber numberWithInt:0];
	}
}

+(NSString*)getSecureString{
	NSString *keystring = [NSString stringWithFormat:@"%d%@",SITE_ID,SignSecureKey];
	NSString *securekey = [Encry md5:keystring];
	return securekey;
}

+(NSString*)getLotteryLogs:(NSString *)dateString{
    
	NSArray *lotteryLogsArray = [DBOperate queryData:T_LOTTERY_LOGS theColumn:@"date" 
								theColumnValue:dateString withAll:NO];
	
	if ([lotteryLogsArray count]>0) 
    {
		NSArray *array = [lotteryLogsArray objectAtIndex:0];
		return [array objectAtIndex:lottery_logs_count];
	}
	else
    {
		return [NSString stringWithFormat:@"%d",ONE_DATE_LOTTERY_TIMES];
	}
}

#define	CTL_NET		4		/* network, see socket.h */
+ (NSString*)getMacAddress{
	return [SvUDIDTools UDID];
}


//判断是否为新会员 前7天到现在注册的会员
+(BOOL)isNewMember:(int)time
{
    long long int created = (long long int)time;
    NSDate* cDate = [NSDate date];   //当前日期
    NSDateFormatter *outputFormat = [[NSDateFormatter alloc] init];
    //[outputFormat setTimeZone:[NSTimeZone timeZoneWithName:@"H"]]; 
    [outputFormat setDateFormat:@"YYYY-MM-dd YYYY-MM-dd HH:mm:ss"];
    NSString *dateString = [outputFormat stringFromDate:cDate];
    NSDate *currentDate = [outputFormat dateFromString:dateString];     //当天凌晨 00:00:00 时间格式
    [outputFormat release];
    
    NSTimeInterval cTime = [currentDate timeIntervalSince1970];   //转化为时间戳
    long long int currentTime = (long long int)cTime;       //转成long long
    created = created + (7 * 24 * 60 * 60) - 1;
    
    if (currentTime > created)
    {
        return NO;
    }else
    {
        return YES;
    }
}

@end
