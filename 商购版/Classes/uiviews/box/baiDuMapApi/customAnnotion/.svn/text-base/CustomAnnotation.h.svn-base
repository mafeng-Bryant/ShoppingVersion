//
//  CustomAnnotation.h
//  hkh1229
//
//  Created by yun lai on 13-1-6.
//
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"

@interface CustomAnnotation : NSObject<BMKAnnotation>{
    CLLocationCoordinate2D coordinate;
	NSString *title;
	NSString *subtitle;
    int index;
}
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, assign) int index;

- (id) initWithCoordinate:(CLLocationCoordinate2D)coord andTitle:(NSString *)title andSubtitle:(NSString *)subTitle;
@end
