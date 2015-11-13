//
//  TableFooterView.h
//  shopping
//
//  Created by yunlai on 13-2-25.
//
//

#import <Foundation/Foundation.h>

@interface TableFooterView : UIView{
    UIActivityIndicatorView *activityIndicator;
    UILabel *infoLabel;
}

@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UILabel *infoLabel;
@end
