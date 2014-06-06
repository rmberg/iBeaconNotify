//
//  ViewController.h
//  iBeaconNotify
//
//  Created by Ryan Berg on 6/6/14.
//  Copyright (c) 2014 Ryan Berg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *beaconDetectedLabel;
@property (weak, nonatomic) IBOutlet UILabel *beaconUUIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *beaconDistanceLabel;

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;


@end
