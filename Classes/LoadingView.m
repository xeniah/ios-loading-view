//
//  LoadingView.m
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

#define LOADING_VIEW_SQUARE_WIDTH   150
#define LOADING_VIEW_SQUARE_HEIGHT  130

#import "LoadingView.h"
#import <QuartzCore/QuartzCore.h>

//
// NewPathWithRoundRect
//
// Creates a CGPathRect with a round rect of the given radius.
//
CGPathRef NewPathWithRoundRect(CGRect rect, CGFloat cornerRadius)
{
	//
	// Create the boundary path
	//
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL,
                      rect.origin.x,
                      rect.origin.y + rect.size.height - cornerRadius);
    
	// Top left corner
	CGPathAddArcToPoint(path, NULL,
                        rect.origin.x,
                        rect.origin.y,
                        rect.origin.x + rect.size.width,
                        rect.origin.y,
                        cornerRadius);
    
	// Top right corner
	CGPathAddArcToPoint(path, NULL,
                        rect.origin.x + rect.size.width,
                        rect.origin.y,
                        rect.origin.x + rect.size.width,
                        rect.origin.y + rect.size.height,
                        cornerRadius);
    
	// Bottom right corner
	CGPathAddArcToPoint(path, NULL,
                        rect.origin.x + rect.size.width,
                        rect.origin.y + rect.size.height,
                        rect.origin.x,
                        rect.origin.y + rect.size.height,
                        cornerRadius);
    
	// Bottom left corner
	CGPathAddArcToPoint(path, NULL,
                        rect.origin.x,
                        rect.origin.y + rect.size.height,
                        rect.origin.x,
                        rect.origin.y,
                        cornerRadius);
    
	// Close the path at the rounded rect
	CGPathCloseSubpath(path);
	
	return path;
}

@implementation LoadingView

@synthesize xPosition, yPosition, positionExplicitlySpecified, loadingViewRect;
//
// loadingViewInView:
//
// Constructor for this view. Creates and adds a loading view for covering the
// provided aSuperview.
//
// Parameters:
//    aSuperview - the superview that will be covered by the loading view
//
// returns the constructed view, already added as a subview of the aSuperview
//	(and hence retained by the superview)
//
+ (id)loadingViewInView:(UIView *)aSuperview withTitle:(NSString *)title
{
	LoadingView *loadingView =
    [[LoadingView alloc] initWithFrame:[aSuperview bounds]];
	if (!loadingView)
	{
		return nil;
	}
    
    [aSuperview addSubview:loadingView];
    loadingView = [loadingView configureLoadingViewWithTitle:title inLoadingViewRect:CGRectMake(0, 0, 0, 0)];
    
    return loadingView;
    
    /*
	loadingView.positionExplicitlySpecified = NO;
	loadingView.opaque = NO;
	loadingView.autoresizingMask =
    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[aSuperview addSubview:loadingView];
    
	const CGFloat DEFAULT_LABEL_WIDTH = 280.0;
	const CGFloat DEFAULT_LABEL_HEIGHT = 50.0;
	CGRect labelFrame = CGRectMake(0, 0, DEFAULT_LABEL_WIDTH, DEFAULT_LABEL_HEIGHT);
 	UILabel *loadingLabel = [[UILabel alloc] initWithFrame:labelFrame];
    
   	loadingLabel.text = title;
	loadingLabel.textColor = [UIColor whiteColor];
	loadingLabel.backgroundColor = [UIColor clearColor];
	loadingLabel.textAlignment = NSTextAlignmentCenter;
	loadingLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
	loadingLabel.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
	
	[loadingView addSubview:loadingLabel];
	UIActivityIndicatorView *activityIndicatorView =
    [[UIActivityIndicatorView alloc]
     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[loadingView addSubview:activityIndicatorView];
	activityIndicatorView.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
	[activityIndicatorView startAnimating];
	
    
	CGFloat totalHeight = loadingLabel.frame.size.height + activityIndicatorView.frame.size.height;
	labelFrame.origin.x = floor(0.5 * (loadingView.frame.size.width - DEFAULT_LABEL_WIDTH));
	labelFrame.origin.y = floor(0.5 * (loadingView.frame.size.height - totalHeight));
	loadingLabel.frame = labelFrame;
    
    
	CGRect activityIndicatorRect = activityIndicatorView.frame;
	activityIndicatorRect.origin.x = 0.5 * (loadingView.frame.size.width - activityIndicatorRect.size.width);
	activityIndicatorRect.origin.y = loadingLabel.frame.origin.y + loadingLabel.frame.size.height-loadingView.yPosition;
	activityIndicatorView.frame = activityIndicatorRect;
    
    labelFrame.origin.y -= loadingView.yPosition;
    loadingLabel.frame = labelFrame;
    
	// Set up the fade-in animation
	CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionFade];
	[[aSuperview layer] addAnimation:animation forKey:@"layerAnimation"];
	
	return loadingView;
     */
     
}

//
// removeView
//
// Animates the view out from the superview. As the view is removed from the
// superview, it will be released.
//
- (void)removeView
{
	UIView *aSuperview = [self superview];
	[super removeFromSuperview];
    
	// Set up the animation
	CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionFade];
	
	[[aSuperview layer] addAnimation:animation forKey:@"layerAnimation"];
}

//
// drawRect:
//
// Draw the view.
//
- (void)drawRect:(CGRect)rect
{
    rect = self.loadingViewRect;    
    //set rounded corner
	const CGFloat ROUND_RECT_CORNER_RADIUS = 5.0;
	CGPathRef roundRectPath = NewPathWithRoundRect(rect, ROUND_RECT_CORNER_RADIUS);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    //set grey transclucent background
	const CGFloat BACKGROUND_OPACITY = 0.5;
	CGContextSetRGBFillColor(context, 0, 0, 0, BACKGROUND_OPACITY);
	CGContextAddPath(context, roundRectPath);
	CGContextFillPath(context);
    
    //set transclucent white border line
	const CGFloat STROKE_OPACITY = 0.9;
	CGContextSetRGBStrokeColor(context, 1, 1, 1, STROKE_OPACITY);
	CGContextAddPath(context, roundRectPath);
	CGContextStrokePath(context);
	
	CGPathRelease(roundRectPath);
}


+ (id)loadingViewInView:(UIView *)aSuperview withTitle:(NSString *)title inLoadingViewRect:(CGRect)loadingViewRect
{
    
	LoadingView *loadingView = [[LoadingView alloc]initWithFrame:[aSuperview bounds]];
    if (!loadingView)
	{
		return nil;
	}
    [aSuperview addSubview:loadingView];
    [loadingView configureLoadingViewWithTitle:title inLoadingViewRect:loadingViewRect];

    // Set up the fade-in animation
	CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionFade];
	[[aSuperview layer] addAnimation:animation forKey:@"layerAnimation"];
    
	return loadingView;
}

-(LoadingView *)configureLoadingViewWithTitle:(NSString *)title inLoadingViewRect:(CGRect)rect
{
    
	if ((rect.size.width == rect.size.height) && rect.size.height == 0.0f) {
        
        CGRect superViewRect = self.superview.frame;
        self.loadingViewRect = CGRectMake(CGRectGetMidX(superViewRect)-75, CGRectGetMidY(superViewRect)-50, 150, 130);//CGRectMake(0, 0, LOADING_VIEW_SQUARE_WIDTH, LOADING_VIEW_SQUARE_HEIGHT);
        self.positionExplicitlySpecified = NO;
    }else{
        self.loadingViewRect = rect;
        self.positionExplicitlySpecified = YES;
    }
    
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
	self.autoresizingMask =
    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    
	const CGFloat DEFAULT_LABEL_WIDTH = self.loadingViewRect.size.width;
	const CGFloat DEFAULT_LABEL_HEIGHT = 40.0;
	CGRect labelFrame = CGRectMake(0, 0, DEFAULT_LABEL_WIDTH, DEFAULT_LABEL_HEIGHT);
 	UILabel *loadingLabel = [[UILabel alloc] initWithFrame:labelFrame];
    
   	loadingLabel.text = title;
	loadingLabel.textColor = [UIColor whiteColor];
	loadingLabel.backgroundColor = [UIColor clearColor];
	loadingLabel.textAlignment = NSTextAlignmentCenter;
	loadingLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
	loadingLabel.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
	//[self sizeToFit];
   	[self addSubview:loadingLabel];
    
	UIActivityIndicatorView *activityIndicatorView =
    [[UIActivityIndicatorView alloc]
     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[self addSubview:activityIndicatorView];
	activityIndicatorView.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
	[activityIndicatorView startAnimating];
    
	labelFrame.origin.x = self.loadingViewRect.origin.x;
	labelFrame.origin.y = self.loadingViewRect.origin.y;
    loadingLabel.frame = labelFrame;
    
	CGRect activityIndicatorRect = activityIndicatorView.frame;
	activityIndicatorRect.origin.x = self.loadingViewRect.origin.x  + 0.5*(self.loadingViewRect.size.width - activityIndicatorRect.size.width);
	activityIndicatorRect.origin.y = loadingLabel.frame.origin.y + 0.5 * (self.loadingViewRect.size.height - activityIndicatorRect.size.height);
	activityIndicatorView.frame = activityIndicatorRect;
    
    loadingLabel.frame = labelFrame;
    
	return self;
}

@end
