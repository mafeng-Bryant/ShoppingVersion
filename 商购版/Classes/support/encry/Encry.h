//
//  Encry.h
//  Profession
//
//  Created by MC374 on 12-8-13.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Encry : NSObject {

}
+(NSString *)md5:(NSString *)str;
+(NSString*)MD5EncryString:(NSString*)beEncryString;
+(NSString*) Md5EncrySign:(NSString*)rd withTimeStamp:(NSString*)timestamp withImei:(NSString*)imei;
+(BOOL) EncrySignValidator:(NSString*)rd withTimeStamp:(NSString*)timestamp withImei:(NSString*)imei withSig:(NSString*)sig;
@end
