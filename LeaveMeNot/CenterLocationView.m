//
//  CenterLocationView.m
//  LeaveMeNot
//
//  Created by Zark on 2016/12/21.
//  Copyright © 2016年 imzark. All rights reserved.
//

#import "CenterLocationView.h"

@implementation CenterLocationView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGRect bounds = self.bounds;
    
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width/2.0;
    center.y = bounds.origin.y + bounds.size.height/2.0;
    
    float radius = 6.0;
    float radius_outside = 8;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextSetRGBFillColor(context, 176/255.0, 224/255.0, 230/255.0, 0.9);
    CGContextAddArc(context, center.x, center.y, radius, 0, M_PI*2, 1);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextSetLineWidth(context, 1);
    CGContextSetRGBFillColor(context, 176/255.0, 224/255.0, 230/255.0, 0.9);
    CGContextSetRGBStrokeColor(context, 255/255.0, 215/255.0, 0, 0.9);
    CGContextAddArc(context, center.x, center.y, radius_outside, -M_PI/2 - M_PI/6, -M_PI/2 + M_PI/6, 0);

    CGContextMoveToPoint(context, center.x, center.y - 12);
    CGContextAddLineToPoint(context, center.x - sin(M_PI/6)*radius_outside, center.y - cos(M_PI/6)*radius_outside);
    CGContextAddLineToPoint(context, center.x + sin(M_PI/6)*radius_outside, center.y - cos(M_PI/6)*radius_outside);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
}


@end
