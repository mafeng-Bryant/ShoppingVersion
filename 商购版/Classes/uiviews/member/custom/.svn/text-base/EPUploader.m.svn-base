 

#import "EPUploader.h"

static NSString * const BOUNDRY = @"0xKhTmLbOuNdArY";

#define ASSERT(x) NSAssert(x, @"")

@implementation EPUploader
@synthesize serverURL;
@synthesize fileData;
@synthesize delegate;
@synthesize uploaderDelegate;

- (id)initWithURL: (NSURL *)aServerURL   // IN
         filePath: (NSData *)aFilePath // IN
         delegate: (id)aDelegate         // IN
     doneSelector: (SEL)aDoneSelector    // IN
    errorSelector: (SEL)anErrorSelector  // IN
{
 
    if ((self = [super init])) {
		//上传的地址
        self.serverURL =aServerURL;
		//上传的数据
		self.fileData =aFilePath;
        //上个界面的对象
		self.delegate = aDelegate;
        //上传成功回调的方法名
		doneSelector = aDoneSelector;
        //上传失败回调的方法名
		errorSelector = anErrorSelector;
        //执行上传
		[self upload];
    }
    return self;
}

//上传
- (void)upload
{
	//自定义方法构建请求，字典数据作为参数
    NSURLRequest *urlRequest = [self postRequestWithURL:serverURL
												  data :fileData
										       dict:nil];

	//执行连接服务器，并实现上传任务
  connect=[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
}


//返回“创建好的请求方式对象”
- (NSURLRequest *)postRequestWithURL: (NSURL *)url         
								data: (NSData *)myData
                                dict:(NSMutableDictionary *)dict
{
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	[request setHTTPMethod:@"POST"];
	
	NSString *boundary = @"---------------------------14737809831466499882746641449";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	NSString *temp = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"png\"; filename=\"headImage.png\"\r\n"];
	[body appendData:[[NSString stringWithString:temp] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:self.fileData]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[request setHTTPBody:body];
	return request;
}

//============================ start ====================================

- (id)initWithURL1: (NSURL *)aServerURL   // IN
         filePath: (NSData *)aFilePath // IN
         delegate: (id)aDelegate         // IN
     doneSelector: (SEL)aDoneSelector    // IN
    errorSelector: (SEL)anErrorSelector  // IN
{
    
    if ((self = [super init])) {
		//上传的地址
        self.serverURL =aServerURL;
		//上传的数据
		self.fileData =aFilePath;
        //上个界面的对象
		self.delegate = aDelegate;
        //上传成功回调的方法名
		doneSelector = aDoneSelector;
        //上传失败回调的方法名
		errorSelector = anErrorSelector;
        //执行上传
		[self upload1];
    }
    return self;
}

//上传
- (void)upload1
{
	//自定义方法构建请求，字典数据作为参数
    NSURLRequest *urlRequest = [self postRequestWithURL1:serverURL
												  data :fileData
                                                   dict:nil];
    
	//执行连接服务器，并实现上传任务
    connect=[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
}

- (NSURLRequest *)postRequestWithURL1: (NSURL *)url
                                 data: (NSData *)myData
                                 dict:(NSMutableDictionary *)dict
{
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
	[request setHTTPMethod:@"POST"];
    //	NSString *contentType = [NSString stringWithFormat:@"application/x-www-form-urlencoded"];
    //	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //得到提交数据的长度
    //NSString* len = [NSString stringWithFormat:@"%d", [postString length]];
    
    //添加一个http包头告诉服务器数据长度是多少
    //[request setValue:len forHTTPHeaderField:@"Content-Length"];
    
	[request setHTTPBody:fileData];
	return request;
}

//============================ end ====================================

- (void)uploadSucceeded: (BOOL)success
{
    [delegate performSelector:success ? doneSelector : errorSelector
				   withObject:self];
	
}

//接受响应时调用
-(void)connection:(NSURLConnection *)connection // IN
didReceiveResponse:(NSURLResponse *)response     // IN
{
	NSLog(@"接受响应时调用....");
    
}

//结束上传时调用
- (void)connectionDidFinishLoading:(NSURLConnection *)connection // IN
{
	NSLog(@"结束上传时调用调用....");
    [connection release];
    //[self uploadSucceeded:YES];
}

//接收服务器数据时候调用
- (void)connection:(NSURLConnection *)connection // IN
    didReceiveData:(NSData *)data                // IN
{
	NSLog(@"接受服务返回数据时候调用....");
	NSString *dataStr = [[NSString alloc]initWithData:data encoding: NSUTF8StringEncoding];
    
    NSLog(@"dataStr====%@",dataStr);
	
    NSDictionary *resultDic = [dataStr JSONValue];
    if ([resultDic count] > 0) {
        [self uploadSucceeded:YES];
        [uploaderDelegate receiveResult:dataStr];
    }else {
        [self uploadSucceeded:NO];
    }
}

//上传失败时调用
- (void)connection:(NSURLConnection *)connection // IN
  didFailWithError:(NSError *)error              // IN
{
	NSLog(@"上传失败时调用....");
    [connection release];
    [self uploadSucceeded:NO];
}


- (void)dealloc
{
	NSLog(@"上传对象释放掉....");
	[connect release];connect=nil;
    [serverURL release];serverURL = nil;
    [fileData release];fileData = nil;
    [delegate release];delegate = nil;
    doneSelector = NULL;
    errorSelector = NULL;
	
    [super dealloc];
}
@end
