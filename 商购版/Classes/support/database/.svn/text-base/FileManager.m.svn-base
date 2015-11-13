//
//  FileManager.m
//  anyVideo
//
//  Created by  apple on 10-10-27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FileManager.h"
#import "Common.h"

@implementation FileManager

+ (BOOL)isExistsFile:(NSString *)filepath{
	NSFileManager *filemanage = [NSFileManager defaultManager];
	return [filemanage fileExistsAtPath:filepath];
}

+ (void) removeFile:(NSString *)filename {
	NSFileManager *filemanage = [NSFileManager defaultManager];
	NSError *error;
	if (filename.length > 4) {
	
		if ([self isExistsFile:[self getFilePath:filename]]) {
			if ([filemanage removeItemAtPath:[self getFilePath:filename] error:&error] != YES)
			{
				NSLog(@"Unable to delete file: %@", [error localizedDescription]);
				return;
			}
		}
		
	}
}

+ (NSString *)getFilePath:(NSString *)filename{
	NSArray *paths = [[NSArray alloc] initWithArray:NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)];
	NSString *documentsDirectory = [[NSString alloc] initWithString:[paths objectAtIndex:0]];
	NSString *filepath = [documentsDirectory stringByAppendingPathComponent:filename];
	[paths release];
	[documentsDirectory release];
	return filepath;
}

+ (BOOL) writeFileString:(NSString *)string fileName:(NSString *)filename{
	[string writeToFile: [self getFilePath:filename] atomically: YES];
	return YES;
}


+ (void) createFile:(NSString *) filename {
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取路径
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    //更改到待操作的目录下
    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
	
    //创建文件fileName文件名称，contents文件的内容，如果开始没有内容可以设置为nil，attributes文件的属性，初始为nil
    [fileManager createFileAtPath:filename contents:nil attributes:nil];
	
}

+ (void) writeFileData:(NSString *)filename writeData:(NSString *)data {
	//写入数据：
	//获取文件路径
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
	NSString *path = [documentsDirectory stringByAppendingPathComponent:filename];
    
    //待写入的数据
    NSString *temp = @"Hello friend";
    int data0 = 100000;
    float data1 = 23.45f;
    
    //创建数据缓冲
    NSMutableData *writer = [[NSMutableData alloc] init];
    
    //将字符串添加到缓冲中
    [writer appendData:[temp dataUsingEncoding:NSUTF8StringEncoding]];
	
    //将其他数据添加到缓冲中
    [writer appendBytes:&data0 length:sizeof(data0)];
    [writer appendBytes:&data1 length:sizeof(data1)];
	
    //将缓冲的数据写入到文件中
    [writer writeToFile:path atomically:YES];
    [writer release];
}

+ (NSString *) readResFileData:(NSString *)filename {
	NSString *filepath = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
	NSString *string = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
	return string;
}

+ (NSString *) readLocalFileData:(NSString *)filename {
	//读取数据：
    int gData0;
    float gData1;
    NSString *gData2;
    NSString *temp;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
	NSString *path = [documentsDirectory stringByAppendingPathComponent:filename];
    NSData *reader = [NSData dataWithContentsOfFile:path];
    gData2 = [[NSString alloc] initWithData:[reader subdataWithRange:NSMakeRange(0, [temp length])]
								   encoding:NSUTF8StringEncoding];
    [reader getBytes:&gData0 range:NSMakeRange([temp length], sizeof(gData0))];
    [reader getBytes:&gData2 range:NSMakeRange([temp length] + sizeof(gData0), sizeof(gData1))];
    
    NSLog(@"gData0:%@  gData1:%i gData2:%f", gData0, gData1, gData2);
	
	return [gData2 autorelease];//changed by zhanghao
}	

+ (UIImage *) saveImageFromURL:(NSString *)strUrl imageName:(NSString*)aName{
	NSURL *url = [NSURL URLWithString:strUrl];
	NSData *data = [NSData dataWithContentsOfURL:url];//载入数据
	UIImage *img = [UIImage imageWithData:data];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"pic/"];	
	NSFileManager *NSFm= [NSFileManager defaultManager]; 
	BOOL isDir=YES;
	
	if(![NSFm fileExistsAtPath:documentsDirectory isDirectory:&isDir])
		if(![NSFm createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil])
			NSLog(@"Error: Create folder failed");
	
	NSString *imagePath1 = [documentsDirectory stringByAppendingPathComponent:aName];//最终路径	
	NSData *imageData1 = UIImagePNGRepresentation(img);
	[imageData1 writeToFile:imagePath1 atomically:YES];//写入文件
	return img;
}

//add by zhanhao
+(UIImage *)getImageFromInfo:(NSString *)imageInfo
{		
		UIImage *refImage;
		NSArray  *array=[imageInfo componentsSeparatedByString:@"/"];
		NSString *imageName=[array lastObject];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *documentsDirectory1 =[documentsDirectory stringByAppendingString:@"/pic/"];		
		NSString *imagePath = [documentsDirectory1 stringByAppendingPathComponent:imageName];//最终路径				
		if ([self isExistsFile:imagePath]) {
			NSData *reader = [NSData dataWithContentsOfFile:imagePath];
			refImage = [UIImage imageWithData:reader];
		}
		else {
			refImage = [self saveImageFromURL:imageInfo imageName:imageName];
		}	
		return refImage;
}
//==========
/*+ (NSString *)getDBFilePath{
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];
	NSString *writableDBPath=[documentsDirectory stringByAppendingPathComponent:@"ShoppingDB.db"];
	return writableDBPath;
}*/
+(bool)savePhoto:(NSString*)photoName withImage:(UIImage*)image{
	NSData *imageData = UIImagePNGRepresentation(image); 
	if([imageData writeToFile:[self getFilePath:photoName]atomically:YES] == NO){
		NSLog(@"save image fail");
		return NO;
	}
	return YES;
}
+(UIImage*)getPhoto:(NSString*)photoName{
	NSData*imagedata = [NSData dataWithContentsOfFile:[self getFilePath:photoName]];
	return [UIImage imageWithData:imagedata];
}


@end
