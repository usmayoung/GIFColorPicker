//
//  GIFAngleGestorRecognizer.m
//  GIFColorPickerApp
//
//  Created by Eric Young on 3/20/16.
//  Copyright © 2016 gifit. All rights reserved.
//

#import "GIFAngleGestorRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface GIFAngleGestorRecognizer ()
@property (nonatomic, assign) CGFloat gestureStartAngle;
@property (nonatomic, assign) CGFloat touchAngle;
@end

@implementation GIFAngleGestorRecognizer

-(id)init
{
    if (self = [super init]) {
        _touchAngle = 0;
        self.maximumNumberOfTouches = 1;
        self.minimumNumberOfTouches = 1;
    }
    return self;

}

-(void)setTouchAngle:(CGFloat)touchAngle
{
    _touchAngle = touchAngle;
    self.angleDelta = touchAngle - self.gestureStartAngle;
}

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [super touchesBegan:touches withEvent:event];
    [self updateTouchAngleWithTouches:touches];
    self.gestureStartAngle = _touchAngle;
}

-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    [super touchesMoved:touches withEvent:event];
    [self updateTouchAngleWithTouches:touches];
}

-(void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event
{
    [super touchesCancelled:touches withEvent:event];
    self.touchAngle = 0;
    self.gestureStartAngle = 0;
}

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    [super touchesEnded:touches withEvent:event];
    self.touchAngle = 0;
    self.gestureStartAngle = 0;
}

-(void)updateTouchAngleWithTouches:(NSSet *)touches
{
    UITouch *touch = touches.anyObject;
    
    if (touch) {
        CGPoint touchPoint = [touch locationInView:self.view];
        self.touchAngle = [self calculateAngleToPoint:touchPoint];
    }
    
}

-(CGFloat)calculateAngleToPoint:(CGPoint)point
{
    CGRect bounds = self.view.bounds;
    
    CGPoint centerOffset = CGPointMake(point.x - bounds.size.width/2, point.y - bounds.size.height/2 );
    
    return atan2(centerOffset.y, centerOffset.x);
}

@end
