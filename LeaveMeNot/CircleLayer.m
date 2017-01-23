//
//  CircleLayer.m
//  LeaveMeNot
//
//  Created by Zark on 2017/1/7.
//  Copyright © 2017年 imzark. All rights reserved.
//

#import "CircleLayer.h"

@implementation CircleLayer

- (void)drawInContext:(CGContextRef)context {
    
    CGPoint center;
    center.x = self.bounds.origin.x + self.bounds.size.width/2.0;
    center.y = self.bounds.origin.y + self.bounds.size.height/2.0;
    
    // 绘制圆形
    
    
    CGContextAddArc(context, center.x, center.y, self.bounds.size.width, 0, M_PI*2, 1);
    
    CGContextDrawPath(context, kCGPathEOFill);
}
@end
