//
//  ViewController.m
//  LeaveMeNot
//
//  Created by Zark on 2016/12/16.
//  Copyright © 2016年 imzark. All rights reserved.
//

#import "ViewController.h"
#import "StatusView.h"
#import "CenterLocationView.h"
#import "LocationViewUsingSubLayers.h"
#import <Masonry/Masonry.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

#define Screen_Bounds [UIScreen mainScreen].bounds
#define Screen_Height [UIScreen mainScreen].bounds.size.height
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Status_Height [[UIApplication sharedApplication] statusBarFrame].size.height

@import CoreLocation;

NSString * const BeaconUUIDKey = @"ABCD1234-ABCD-ABCD-ABCD-ABCD12341234";

@interface ViewController () <CLLocationManagerDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CALayer *headingLayer; //CenterLocationView的layer
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) MAMapView *mapView;
@property (strong, nonatomic) LocationViewUsingSubLayers *locationView;
@property (strong, nonatomic) StatusView* statusView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"ViewFrame, x:%f, y:%f, width:%f, height:%f", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
    [self setupScrollView];
    [self setupMainViews];
    [self setupBeacon];
    [self setupLocationManager];
    
    NSLog(@"ScrollViewFrame, x:%f, y:%f, width:%f, height:%f", self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    NSLog(@"offsetY: %f", self.scrollView.contentOffset.y);
    self.title = @"LeaveMeNot";

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    
    [self.view addSubview:_scrollView];
   
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.width.equalTo(self.view.mas_width);
    }];
    
   
    self.scrollView.contentSize = CGSizeMake(Screen_Width, self.view.bounds.size.height+Screen_Width-44-Status_Height);

}

- (void)setupMainViews {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //_locationView = [[LocationView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Width) andMaxCircleRadius:Screen_Width/2.0 - 50];
    
    _locationView = [[LocationViewUsingSubLayers alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Width)];
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Width)];
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    [_mapView setZoomLevel:15 animated:YES]; //缩放级别为[3-19]
    
    _statusView = [[StatusView alloc] initWithFrame:CGRectZero];
    [_statusView setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1.0]];
    
    //添加中间的箭头
    CenterLocationView *centerLocationView = [[CenterLocationView alloc] initWithFrame:CGRectZero];
    [centerLocationView setBackgroundColor:[UIColor clearColor]];
    
    [self.scrollView addSubview:_locationView];
    [self.scrollView addSubview:_statusView];
    [self.scrollView addSubview:_mapView];
    [self.scrollView addSubview:centerLocationView];
    
    _headingLayer = centerLocationView.layer;
    
    [_locationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_top); //navigationBar setTranslucent = NO , frame (0,0,0,0) 即是导航栏下面开始
        make.centerX.equalTo(self.scrollView.mas_centerX);
        make.width.equalTo(self.scrollView.mas_width);
        make.height.equalTo(self.scrollView.mas_width);
    }];
    
    [_statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_locationView.mas_bottom);
//        make.bottom.equalTo(self.view.mas_bottom);
//        make.left.equalTo(self.scrollView.mas_left);
//        make.right.equalTo(self.scrollView.mas_right);
        make.centerX.equalTo(self.scrollView.mas_centerX);
        make.width.equalTo(self.scrollView.mas_width);
        make.height.equalTo(self.scrollView.mas_height).offset(-Screen_Width-44-Status_Height);
    }];
    
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_statusView.mas_bottom);
        make.centerX.equalTo(self.scrollView.mas_centerX);
        make.width.equalTo(self.scrollView.mas_width);
        make.height.equalTo(self.scrollView.mas_width);
    }];
    
    [centerLocationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_locationView.mas_centerX);
        make.centerY.equalTo(_locationView.mas_centerY);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
}

- (void)setupBeacon {
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:BeaconUUIDKey];
    _beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"com.imzark.LeaveMeNot"];
    
}

- (void)setupLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    [self.locationManager startMonitoringForRegion:_beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:_beaconRegion];
    [self.locationManager startUpdatingLocation];
    
    if ([CLLocationManager headingAvailable]){
        [self.locationManager startUpdatingHeading];
    } else {
//        [UIAlertController todo]
        NSLog(@"磁力计不可用");
    }
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    float offsetY = self.scrollView.contentOffset.y + 44 + Status_Height;
    if (offsetY < Screen_Width/2.0) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.scrollView setContentOffset:CGPointMake(0, -44-Status_Height)];
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            [self.scrollView setContentOffset:CGPointMake(0, Screen_Width - Status_Height - 44)];
        }];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        float offsetY = self.scrollView.contentOffset.y + 44 + Status_Height;
        if (offsetY < Screen_Width/2.0) {
            [UIView animateWithDuration:0.5 animations:^{
                [self.scrollView setContentOffset:CGPointMake(0, -44-Status_Height)];
            }];
        } else {
            [UIView animateWithDuration:0.5 animations:^{
                [self.scrollView setContentOffset:CGPointMake(0, Screen_Width - Status_Height - 44)];
            }];
        }
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"Failed monitoring region: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager failed: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region{
    
    if (beacons == nil || [beacons count] == 0) {
        return;
    }

    for (CLBeacon *beacon in beacons) {
        
        _statusView.nameLabel.text = @"TheBeacon";
        
        switch (beacon.proximity) {
            case CLProximityUnknown:
                _statusView.proximityLabel.text = @"Proximity:Unkonwn";
                NSLog(@"Distance:Unkonwn");
                break;
            case CLProximityFar:
                _statusView.proximityLabel.text = @"Proximity:Far";
                NSLog(@"Distance:Far");
                break;
            case CLProximityNear:
                _statusView.proximityLabel.text = @"Proximity:Near";
                NSLog(@"Distance:Near");
                break;
            case CLProximityImmediate:
                _statusView.proximityLabel.text = @"Proximity:Immediate";
                NSLog(@"Distance:Immediate");
                break;
                
            default:
                break;
            
        }
        _statusView.distanceLabel.text = [@"Distance:" stringByAppendingString:[NSString stringWithFormat:@"%f", beacon.accuracy]];
        if (beacon.accuracy>0) {
            [self changeCircleColorWithAccuracy:beacon.accuracy];
        } else {
            [self.locationView defaultColor];
        }
    }
}

// 根据距离改变颜色
- (void)changeCircleColorWithAccuracy:(CGFloat)accuracy {
    UIColor *color_ranged = [UIColor greenColor];
    UIColor *color_max = [UIColor colorWithRed:44/255.0 green:44/255.0 blue:44/255.0 alpha:0.9];
    UIColor *color_mid = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:0.9];
    UIColor *color_min = [UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:0.9];
    if (accuracy <= 5) {
        self.locationView.minColor = color_ranged;
        self.locationView.midColor = color_mid;
        self.locationView.maxColor = color_max;
    } else if (accuracy <= 10) {
        self.locationView.minColor = color_min;
        self.locationView.midColor = color_ranged;
        self.locationView.maxColor = color_max;
    } else if (accuracy <= 20) {
        self.locationView.minColor = color_min;
        self.locationView.midColor = color_mid;
        self.locationView.maxColor = color_ranged;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    CGFloat headings = -1.0f * M_PI *newHeading.trueHeading / 180.0f;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D fromValue = _headingLayer.transform;
    animation.fromValue = [NSValue valueWithCATransform3D:fromValue];
    CATransform3D toValue = CATransform3DMakeRotation(headings, 0, 0, 1);
    animation.toValue = [NSValue valueWithCATransform3D:toValue];
    animation.duration = 0.5;
    animation.removedOnCompletion = YES;
    _headingLayer.transform = toValue;
    
//    [_headingLayer addAnimation:animation forKey:nil];
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
    return YES;
}

@end
