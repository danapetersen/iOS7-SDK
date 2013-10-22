//
//  ESTViewController.m
//  DinstanceDemo
//
//  Created by Marcin Klimek on 9/26/13.
//  Copyright (c) 2013 Estimote. All rights reserved.
//

#import "ESTViewController.h"
#import <ESTBeaconManager.h>

#define DOT_MIN_POS 150
#define DOT_MAX_POS screenHeight - 70;

@interface ESTViewController () <CLLocationManagerDelegate>

//@property (nonatomic, strong) ESTBeaconManager* beaconManager;

@property (nonatomic, strong) CLLocationManager* locationManager;

@property (nonatomic, strong) UIImageView*      positionDot;

@property (nonatomic) float dotMinPos;
@property (nonatomic) float dotRange;
@property (weak, nonatomic) IBOutlet UILabel *uiRssi;

@end

@implementation ESTViewController
@synthesize uiRssi = _uiRssi;

- (void)viewDidLoad
{
    [super viewDidLoad];

    /////////////////////////////////////////////////////////////
    // setup Estimote beacon manager
    
    // create manager instance
   // self.beaconManager = [[ESTBeaconManager alloc] init];
   // self.beaconManager.delegate = self;
  //  self.beaconManager.avoidUnknownStateBeacons = YES;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // create sample region object (you can additionaly pass major / minor values)
   // ESTBeaconRegion* region = [[ESTBeaconRegion alloc] initRegionWithIdentifier:@"EstimoteSampleRegion"];
  //  NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:@"7BD3E324-D9CE-1518-EC79-5823A34E73A1"];
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6F"];
    CLBeaconRegion* region = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:@"Dana Region"];

    
    // start looking for estimtoe beacons in region
    // when beacon ranged beaconManager:didRangeBeacons:inRegion: invoked
  //  [self.beaconManager startRangingBeaconsInRegion:region];
    
    [self.locationManager startRangingBeaconsInRegion:region];
    
    
    /////////////////////////////////////////////////////////////
    // setup Estimote beacon manager
    
    [self setupView];
}

-(void)setupView
{
    /////////////////////////////////////////////////////////////
    // setup background image
    
//    CGRect          screenRect          = [[UIScreen mainScreen] bounds];
//    CGFloat         screenHeight        = screenRect.size.height;
//    UIImageView*    backgroundImage;
//    
//  //  if (screenHeight > 480)
//  //      backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundBig"]];
//  //  else
//  //      backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundSmall"]];
//    
//  //  [self.view addSubview:backgroundImage];
//    
//    /////////////////////////////////////////////////////////////
//    // setup dot image
//    
//    self.positionDot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dotImage"]];
//    [self.positionDot setCenter:self.view.center];
//    [self.positionDot setAlpha:1.];
//    
//    [self.view addSubview:self.positionDot];
//    
//    self.dotMinPos = 150;
//    self.dotRange = self.view.bounds.size.height  - 220;
}


-(void)beaconManager:(ESTBeaconManager *)manager
     didRangeBeacons:(NSArray *)beacons
            inRegion:(ESTBeaconRegion *)region
{
    ESTBeacon* closestBeacon;

    if([beacons count] > 0)
    {
        // beacon array is sorted based on distance
        // closest beacon is the first one
        closestBeacon = [beacons objectAtIndex:0];
        
        // calculate and set new y position
        float newYPos = self.dotMinPos + ((float)closestBeacon.ibeacon.rssi / -100.) * self.dotRange;
        self.positionDot.center = CGPointMake(self.view.bounds.size.width / 2, newYPos);
    }
}

//- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
//
//    CLBeacon *closestBeacon = [locations objectAtIndex:0];
//
//}

- (void) locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    
    if([beacons count] > 0)
    {
        CLBeacon *closestBeacon = [beacons objectAtIndex:0];
        // beacon array is sorted based on distance
        // closest beacon is the first one
        
        // calculate and set new y position
        float newYPos = self.dotMinPos + ((float)closestBeacon.rssi / -100.) * self.dotRange;
        self.positionDot.center = CGPointMake(self.view.bounds.size.width / 2, newYPos);
        
        //NSLog (@"Current date: %@", [NSDate date]);
        self.uiRssi.text = [NSString stringWithFormat:@"%d", closestBeacon.rssi ];

        NSLog(@"Beacon: %@", closestBeacon);
    }
}

- (void) locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
{
    NSLog(@"Got error");
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
