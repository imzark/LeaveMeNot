//
//  LocationViewUsingSubLayers.h
//  LeaveMeNot
//
//  Created by Zark on 2017/1/7.
//  Copyright © 2017年 imzark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationViewUsingSubLayers : UIView
@property (nonatomic, strong) UIColor *minColor;
@property (nonatomic, strong) UIColor *midColor;
@property (nonatomic, strong) UIColor *maxColor;
@property (nonatomic, assign) CGFloat radius;
- (void)defaultColor;
@end
