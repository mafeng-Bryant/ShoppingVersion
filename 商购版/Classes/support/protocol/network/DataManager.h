//
//  DataManager.h
//  Profession
//
//  Created by MC374 on 12-8-9.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommandOperation.h"

@interface DataManager : NSObject
{
	NSOperationQueue *netWorkQueue;
}

+ (DataManager*)sharedManager;
- (void) accessService:(NSDictionary*)reqdic 
			   command:(int)commandID 
		  accessAdress:(NSString*)accAddr 
			  delegate:(id <CommandOperationDelegate>)theDelegate 
			 withParam:(NSMutableDictionary*)param;
@end
