//
//  DataManager.m
//  Profession
//
//  Created by MC374 on 12-8-9.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DataManager.h"
#import "CommandOperation.h"
#import "Common.h"

@implementation DataManager

static DataManager *sharedDataManager = nil;

- (void) accessService:(NSMutableDictionary*)reqdic command:(int)commandID 
		  accessAdress:(NSString*)accAddr 
			  delegate:(id <CommandOperationDelegate>)theDelegate withParam:(NSMutableDictionary*)param
{    
	NSString *reqstr;
	reqstr = [Common TransformJson:reqdic withLinkStr: [ACCESS_SERVER_LINK stringByAppendingString:accAddr]];
    
    if ([netWorkQueueArray indexOfObject:reqstr] == NSNotFound)
    {
        [netWorkQueueArray addObject:reqstr];
        CommandOperation *operation = [[[CommandOperation alloc] 
								   initWithReqStr:reqstr command:commandID delegate:theDelegate params:param] autorelease];
        [netWorkQueue addOperation:operation];
    }

}


- (id)init{
	netWorkQueue = [[NSOperationQueue alloc] init];
	[netWorkQueue setMaxConcurrentOperationCount:2];
	return self;
}

- (void) dealloc{	
	[netWorkQueue release];
	netWorkQueue = nil;
	[super dealloc];
}

//单例编写

+ (DataManager*)sharedManager
{
    @synchronized(self) {
        if (sharedDataManager == nil) {
            [[self alloc] init]; 
        }
    }
    return sharedDataManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (sharedDataManager == nil) {
            sharedDataManager = [super allocWithZone:zone];
            return sharedDataManager;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id) retain
{
	return self;
}

- (NSUInteger) retainCount
{
	return NSUIntegerMax; // denotes an object that cannot be released
}

- (void) release
{
	// do nothing
}

- (id) autorelease
{
	return self;
}

@end
