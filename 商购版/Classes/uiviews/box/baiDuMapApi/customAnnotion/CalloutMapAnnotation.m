#import "CalloutMapAnnotation.h"

@interface CalloutMapAnnotation()


@end

@implementation CalloutMapAnnotation

@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize coordinate;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude {
	if ((self = [super init])) {
		self.latitude = latitude;
		self.longitude = longitude;
	}
	return self;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D)inCoord
{
	coordinate = inCoord;
	return self;
}

- (CLLocationCoordinate2D)coordinate {
	CLLocationCoordinate2D coord;
	coord.latitude = self.latitude;
	coord.longitude = self.longitude;
	return coord;
}

@end
