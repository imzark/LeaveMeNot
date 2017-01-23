//
//  StatusView.m
//  LeaveMeNot
//
//  Created by Zark on 2016/12/24.
//  Copyright © 2016年 imzark. All rights reserved.
//

#import "StatusView.h"
#import <Masonry/Masonry.h>

@implementation StatusView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.text = @"UnknownBeacon";
        _nameLabel.font = [UIFont systemFontOfSize:20];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        //    _nameLabel.layer.borderColor = [UIColor colorWithRed:200/255 green:200/255 blue:205/255 alpha:1].CGColor;
        //    _nameLabel.layer.cornerRadius = 10;
        //    _nameLabel.layer.borderWidth = 0.5;
        
        _proximityLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _proximityLabel.text = @"Proximity:Unknown";
        _proximityLabel.font = [UIFont systemFontOfSize:15];
        _proximityLabel.textAlignment = NSTextAlignmentCenter;
        
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _distanceLabel.text = @"Distance:Unknown";
        _distanceLabel.font = [UIFont systemFontOfSize:15];
        _distanceLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_nameLabel];
        [self addSubview:_proximityLabel];
        [self addSubview:_distanceLabel];
    }
    return self;
}

- (void)layoutSubviews {
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset(-30);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [_proximityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.proximityLabel.mas_bottom);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
