

#import "CurrentLocationAnnotation.h"


@implementation CurrentLocationAnnotation

@synthesize coordinate, title, subtitle,index;

- (id) initWithCoordinate:(CLLocationCoordinate2D)coord andTitle:(NSString *)atitle andSubtitle:(NSString *)subTitle {
	self.coordinate = coord;
	self.title = atitle;
	self.subtitle = subTitle;
    
	return self;
}

- (void) dealloc {
	[title release],title = nil;
	[subtitle release],subtitle = nil;
		
	[super dealloc];
}


@end
