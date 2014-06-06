//
//  ViewController.m
//  iBeaconNotify
//
//  Created by Ryan Berg on 6/6/14.
//  Copyright (c) 2014 Ryan Berg. All rights reserved.
//

#import "ViewController.h"

static NSString *APP_UUID = @"24D50DC8-7299-4A20-951D-22A74376247B";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self initRegion];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initRegion {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:APP_UUID];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"com.ryanberg.iBeaconNotify"];
    self.beaconRegion.notifyEntryStateOnDisplay = NO; // notify even if app is closed!
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
}



/*
 *  CLLocationManagerDelegate Implementations
 */


- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
    [self sendLocalNotificationForBeaconRegion:(CLBeaconRegion *)region entered:YES];
    // Start monitoring beacon range
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    
}


- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    
    [self sendLocalNotificationForBeaconRegion:(CLBeaconRegion *)region entered:NO];
    
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    self.beaconDetectedLabel.text = @"No";
    self.beaconUUIDLabel.text = @"None";
    self.beaconDistanceLabel.text = @"None";
    
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    
    CLBeacon *beacon = [[CLBeacon alloc] init];
    beacon = [beacons lastObject];
    
    self.beaconDetectedLabel.text = @"Yes";
    self.beaconUUIDLabel.text = beacon.proximityUUID.UUIDString;
    
    if (beacon.proximity == CLProximityUnknown) {
        self.beaconDistanceLabel.text = @"Unknown Proximity";
    } else if (beacon.proximity == CLProximityImmediate) {
        self.beaconDistanceLabel.text = @"Immediate";
    } else if (beacon.proximity == CLProximityNear) {
        self.beaconDistanceLabel.text = @"Near";
    } else if (beacon.proximity == CLProximityFar) {
        self.beaconDistanceLabel.text = @"Far";
    }
    
    
    
}

- (void)sendLocalNotificationForBeaconRegion:(CLBeaconRegion *)region entered:(BOOL) entered
{
    UILocalNotification *notification = [UILocalNotification new];
    
    NSString *message;
    
    if(entered)
    {
        message = [NSString stringWithFormat:@"You are near beacon for UUID: %@", region.proximityUUID.UUIDString];
    }
    else {
        message = [NSString stringWithFormat:@"You have left beacon for UUID: %@", region.proximityUUID.UUIDString];
    }
    
    notification.alertBody = message;
    notification.alertAction = NSLocalizedString(@"View Details", nil);
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}



@end
