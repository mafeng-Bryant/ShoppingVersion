//
//  Encry.m
//  Profession
//
//  Created by MC374 on 12-8-13.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Encry.h"
#import "Common.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Encry


+(NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[32];
    CC_MD5( cStr, strlen(cStr), result );
    return [[NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3],
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			] lowercaseString];
}

+(NSString*) Md5EncrySign:(NSString*)rd withTimeStamp:(NSString*)timestamp withImei:(NSString*)imei{
	NSString *str = [[NSString alloc]initWithString:rd];
	NSString *str1 = [[[str stringByAppendingString: timestamp] stringByAppendingString:imei] stringByAppendingString:SignSecureKey];
	//[[str stringByAppendingString:imei] stringByAppendingString:SignSecureKey];
	
	//NSString* str = [[[rd stringByAppendingString: timestamp] stringByAppendingString:imei] stringByAppendingString:SignSecureKey];
	//NSLog(@"str %@",str);
	//NSString* strOut = [self md5:str];
	NSString* strOut = [self md5:str1];
	[str release];
	return [strOut uppercaseString];
}
+(NSString*)MD5EncryString:(NSString*)beEncryString{
	if (beEncryString != nil) {
		return [[self md5:beEncryString]uppercaseString];
	}
    return nil;
}
+(BOOL) EncrySignValidator:(NSString*)rd withTimeStamp:(NSString*)timestamp withImei:(NSString*)imei withSig:(NSString*)sig{
	
	//NetworkController *ntc=[[NetworkController sharedInstance] autorelease];
	//NSString *imeistring = [self createUUID];//[ntc IMEI];
	NSString *newsig = [self Md5EncrySign:rd withTimeStamp:timestamp withImei:imei];
	return [newsig isEqualToString:sig];
}


@end
