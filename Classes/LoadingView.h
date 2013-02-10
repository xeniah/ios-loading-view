//
//  LoadingView.h
//  LoadingView
//
//  Created by Matt Gallagher on 12/04/09.
//  Modified by Rohith Nandakumar on 18/06/2012.
//  Modified by Xenia H on 01/30/2013.
//  Copyright Matt Gallagher 2009. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView
{
    float xPosition;
    float yPosition;
    bool positionExplicitlySpecified;
    
    CGRect loadingViewRect;
}

@property (nonatomic, assign) float  xPosition;
@property (nonatomic, assign) float  yPosition;
@property (nonatomic, assign) CGRect loadingViewRect;
@property (nonatomic, assign) bool positionExplicitlySpecified;

+ (id)loadingViewInView:(UIView *)aSuperview withTitle:(NSString *)title;
+ (id)loadingViewInView:(UIView *)aSuperview withTitle:(NSString *)title inLoadingViewRect:(CGRect)loadingViewRect;

- (void)removeView;

@end
