//
//  CommonOperation.h
//  Profession
//
//  Created by MC374 on 12-8-9.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CommandOperationDelegate
- (void)didFinishCommand:(NSMutableArray*)resultArray cmd:(int)commandid withVersion:(int)ver;
@end


@interface CommandOperation : NSOperation {
	
	NSString *reqStr;
	id <CommandOperationDelegate> delegate;
    Class _originalClass;
	NSMutableDictionary* requestParam;
	int commandid;
}
@property(nonatomic,retain)NSString *reqStr;
@property(nonatomic,assign)id <CommandOperationDelegate> delegate;
@property(nonatomic,assign)int commandid;
@property(nonatomic,retain) NSMutableDictionary* requestParam;
- (id)initWithReqStr:(NSString*)rstr command:(int)cmd delegate:(id <CommandOperationDelegate>)theDelegate params:(NSDictionary*)param;
-(NSData*)AccessService;
@end
