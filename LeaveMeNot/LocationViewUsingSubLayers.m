//
//  LocationViewUsingSubLayers.m
//  LeaveMeNot
//
//  Created by Zark on 2017/1/7.
//  Copyright © 2017年 imzark. All rights reserved.
//

#import "LocationViewUsingSubLayers.h"

@interface LocationViewUsingSubLayers()
{
    CALayer *minLayer;
    CALayer *midLayer;
    CALayer *maxLayer;
}
@end

@implementation LocationViewUsingSubLayers

#pragma mark -
#pragma mark 初始化

- (void)commonInit
{
    minLayer = [CALayer layer];
    midLayer = [CALayer layer];
    maxLayer = [CALayer layer];
    self.radius = [UIScreen mainScreen].bounds.size.width/2.0 - 50; // 最大半径
    [self defaultColor];
    [self.layer addSublayer:maxLayer];
    [self.layer addSublayer:midLayer];
    [self.layer addSublayer:minLayer];
    [self setNeedsLayout];
}

- (void)defaultColor
{
    UIColor *color_max = [UIColor colorWithRed:44/255.0 green:44/255.0 blue:44/255.0 alpha:0.9];
    UIColor *color_mid = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:0.9];
    UIColor *color_min = [UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:0.9];
    
    self.minColor = color_min;
    self.midColor = color_mid;
    self.maxColor = color_max;
    self.backgroundColor = [UIColor colorWithRed:35/255.0 green:35/255.0 blue:35/255.0 alpha:1.0];
}

- (id)initWithFrame:(CGRect)aRect
{
    if ((self = [super initWithFrame:aRect])) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
    if ((self = [super initWithCoder:coder])) {
        [self commonInit];
    }
    return self;
}

#pragma mark -
#pragma mark 属性改写

- (UIColor *)minColor {
    return [UIColor colorWithCGColor:[minLayer backgroundColor]];
}
- (UIColor *)midColor {
    return [UIColor colorWithCGColor:[midLayer backgroundColor]];
}
- (UIColor *)maxColor {
    return [UIColor colorWithCGColor:[maxLayer backgroundColor]];
}
- (void)setMinColor:(UIColor *)minColor {
    minLayer.backgroundColor = minColor.CGColor;
}
- (void)setMidColor:(UIColor *)midColor {
    midLayer.backgroundColor = midColor.CGColor;
}
- (void)setMaxColor:(UIColor *)maxColor {
    maxLayer.backgroundColor = maxColor.CGColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat r_max = _radius;
    CGFloat r_mid = _radius *13/20.0;
    CGFloat r_min = _radius *2.8/10.0;
    
    CGPoint center;
    center.x = self.bounds.origin.x + self.bounds.size.width/2.0;
    center.y = self.bounds.origin.y + self.bounds.size.height/2.0;
    
    maxLayer.frame = CGRectMake(0, 0, r_max*2.0, r_max*2.0);
    midLayer.frame = CGRectMake(0, 0, r_mid*2.0, r_mid*2.0);
    minLayer.frame = CGRectMake(0, 0, r_min*2.0, r_min*2.0);
    
    maxLayer.position = center;
    midLayer.position = center;
    minLayer.position = center;
    
    maxLayer.cornerRadius = r_max;
    midLayer.cornerRadius = r_mid;
    minLayer.cornerRadius = r_min;
    
    maxLayer.masksToBounds = YES;
    midLayer.masksToBounds = YES;
    minLayer.masksToBounds = YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
