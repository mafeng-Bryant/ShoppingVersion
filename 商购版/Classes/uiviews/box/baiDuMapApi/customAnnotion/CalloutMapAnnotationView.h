#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface CalloutMapAnnotationView : BMKAnnotationView {
	BMKAnnotationView *_parentAnnotationView;
	BMKMapView *_mapView;
	CGRect _endFrame;
	UIView *_contentView;
	CGFloat _yShadowOffset;
	CGPoint _offsetFromParent;
	CGFloat _contentHeight;
}

@property (nonatomic, retain) BMKAnnotationView *parentAnnotationView;
@property (nonatomic, retain) BMKMapView *mapView;
@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic) CGPoint offsetFromParent;
@property (nonatomic) CGFloat contentHeight;

- (void)animateIn;
- (void)animateInStepTwo;
- (void)animateInStepThree;
- (void)setAnnotationBitch:(id <BMKAnnotation>)annotation;

@end
