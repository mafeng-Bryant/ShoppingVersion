#import <Foundation/Foundation.h>
#import "BMapKit.h"

@interface CalloutMapAnnotation : NSObject <BMKAnnotation> {
	CLLocationDegrees _latitude;
	CLLocationDegrees _longitude;
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate; 

-(id)initWithCoordinate:(CLLocationCoordinate2D)inCoord;
- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude;

@end
