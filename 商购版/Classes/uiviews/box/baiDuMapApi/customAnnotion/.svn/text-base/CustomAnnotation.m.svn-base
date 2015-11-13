//
//  CustomAnnotation.m
//  hkh1229
//
//  Created by yun lai on 13-1-6.
//
//

#import "CustomAnnotation.h"

@implementation CustomAnnotation
@synthesize coordinate, title, subtitle,index;

- (id) initWithCoordinate:(CLLocationCoordinate2D)coord andTitle:(NSString *)aTitle andSubtitle:(NSString *)subTitle {
	self.coordinate = coord;
	self.title = aTitle;
	self.subtitle = subTitle;
    
	return self;
}

- (void) dealloc {
	[title release],title = nil;
	[subtitle release],subtitle = nil;
    
	[super dealloc];
}
@end
