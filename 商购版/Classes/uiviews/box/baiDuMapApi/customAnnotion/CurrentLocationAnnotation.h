

#import <Foundation/Foundation.h>
#import "BMapKit.h"

@interface CurrentLocationAnnotation : NSObject <BMKAnnotation> {
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
