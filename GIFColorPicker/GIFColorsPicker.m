//
//  GIFColorPicker.m
//  GIFColorPickerApp
//
//  Created by Eric Young on 3/20/16.
//  Copyright © 2016 gifit. All rights reserved.
//

#import "GIFColorsPicker.h"
#import "GIFColorRing.h"
#import "GIFAngleGestorRecognizer.h"

@interface GIFColorsPicker ()
@property (nonatomic, strong) GIFColorRing *colorRing;
@property (nonatomic, strong) GIFAngleGestorRecognizer *gestureRecognizer;
@property (nonatomic, assign) CGAffineTransform transformAtStartOfGesture;

@property (nonatomic, assign) CGPoint selectedColorPoint;

@end

@implementation GIFColorsPicker

-(id)init{
    if (self = [super init]) {
        [self sharedInitialization];
    }
    return self;
}


- (id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder]) {
       [self sharedInitialization];
    }
    return self;
}

-(void)sharedInitialization
{
    _colorRing = [GIFColorRing new];
    _colorRing.backgroundColor = [UIColor clearColor];
    _ringWidth = 2.0;
    _selectedColorPoint = CGPointMake(self.frame.size.width/2, 20);
    
    [self addSubview:_colorRing];
    
    _colorRing.translatesAutoresizingMaskIntoConstraints = false;
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-3-[_colorRing]-3-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_colorRing)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_colorRing]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_colorRing)]];
    
    
    _gestureRecognizer = [[GIFAngleGestorRecognizer alloc] init];
    [_gestureRecognizer addTarget:self action:@selector(handleAngleGestureChange)];
    
    [self addGestureRecognizer:_gestureRecognizer];
    
}

-(void)setRingWidth:(CGFloat)ringWidth
{
    _ringWidth = ringWidth;
    _colorRing.ringWidth = ringWidth;
    
    UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 5, 0, 10, self.ringWidth + 6)];
    selectedView.backgroundColor = [UIColor clearColor];
    selectedView.layer.borderColor = [UIColor colorWithWhite:0 alpha:.3].CGColor;
    selectedView.layer.borderWidth = 2.0;
    selectedView.layer.cornerRadius = 2.0;
    [self addSubview:selectedView];
}

-(void)handleAngleGestureChange
{
    if (_gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.transformAtStartOfGesture = self.colorRing.transform;
        //self.backgroundColor = self.selectedColor;
    } else if (_gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        //NSLog(@"sdfds %f", self.gestureRecognizer.angleDelta);
        self.colorRing.transform = CGAffineTransformRotate(self.transformAtStartOfGesture, self.gestureRecognizer.angleDelta);
        //self.backgroundColor = self.selectedColor;
    } else {
        self.transformAtStartOfGesture = CGAffineTransformIdentity;
    }
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
}


-(UIColor*)selectedColor
{
    return  [self colorOfPoint:self.selectedColorPoint];
}


-(UIColor*)colorForAngle:(CGFloat)angle
{
    CGFloat normalized = ((3.0 / 2.0 * M_PI) - angle) / 2.0 * M_PI;
    normalized = normalized - floor(normalized);
    if (normalized < 0) {
        normalized +=1;
    }
    NSLog(@"sadf %f", normalized);
    return [UIColor colorWithHue:normalized saturation:1.0 brightness:1.0 alpha:1.0];
}

- (UIColor *)colorOfPoint:(CGPoint)point
{
    unsigned char pixel[4] = {0};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    //NSLog(@"pixel: %d %d %d %d", pixel[0], pixel[1], pixel[2], pixel[3]);
    
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
    return color;
}


@end
