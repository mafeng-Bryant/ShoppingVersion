//
//  FileManager.h
//  anyVideo
//
//  Created by  apple on 10-10-27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FileManager : NSObject {
	
}

+ (BOOL) writeFileString:(NSString *)string fileName:(NSString *)filename;
+ (BOOL) isExistsFile:(NSString *) filepath;
+ (void) createFile:(NSString *) filename;
+ (void) writeFileData:(NSString *)filename writeData:(NSString *)data;
+ (void) removeFile:(NSString *)filename;
+ (UIImage *) saveImageFromURL:(NSString *)strUrl imageName:(NSString*)aName;
+ (UIImage *)getImageFromInfo:(NSString *)imageInfo;//add by zhanghao

+ (NSString *)getFilePath:(NSString *)filename;
+ (NSString *) readResFileData:(NSString *)filename;
+ (NSString *) readLocalFileData:(NSString *)filename;
//+ (NSString *)getDBFilePath;//直接返回本工程数据库文件读写目录 ...\documents\ShoppingDB.db   add by zc 

+(bool)savePhoto:(NSString*)photoName withImage:(UIImage*)image;
+(UIImage*)getPhoto:(NSString*)photoName;

@end
