//
//  GIFColorRing.m
//  GIFColorPickerApp
//
//  Created by Eric Young on 3/20/16.
//  Copyright © 2016 gifit. All rights reserved.
//

#import "GIFColorRing.h"

@interface GIFColorRing ()
@property (nonatomic, assign) int numberOfSegments;
@end

@implementation GIFColorRing

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef cxt = UIGraphicsGetCurrentContext();
    [self drawRainbowWheel:cxt withRect:rect];
}

-(void)drawRainbowWheel:(CGContextRef)context withRect:(CGRect)rect
{
    _numberOfSegments = 360;
    CGContextSaveGState(context);
    CGFloat ringRadius = (MIN(rect.size.width, rect.size.height) - self.ringWidth) / 2;
    CGContextSetLineWidth(context, self.ringWidth);
    CGContextSetLineCap(context, kCGLineCapButt);

    for (CGFloat i = 1.0; i < self.numberOfSegments; i++) {
        CGFloat proportion = i / self.numberOfSegments;
        CGFloat startAngle = proportion * 2 * (CGFloat)M_PI;
        CGFloat endAngle = (i + 1) / (self.numberOfSegments * 2 * (CGFloat)M_PI);
        [[UIColor colorWithWhite:proportion alpha:1.0] setStroke];
        //[[UIColor colorWithHue:proportion saturation:1.0 brightness:1.0 alpha:1.0] setStroke];
        CGContextAddArc(context, rect.size.width/2, rect.size.height/2, ringRadius, startAngle, endAngle, 0);
        CGContextStrokePath(context);
    }
    CGContextRestoreGState(context);
    
}


@end
