//
//  PCWebServiceLocationManager.m
//  Glenigan
//
//  Created by Phillip Caudell on 23/08/2012.
//  Copyright (c) 2012 madebyphill.co.uk. All rights reserved.
//

#import "PCSingleRequestLocationManager.h"
#import <CoreLocation/CoreLocation.h>

#define kPCWebServiceLocationManagerDebug NO
#define kPCWebServiceLocationManagerMaxWaitTime 10.0
#define kPCWebServiceLocationManagerMinWaitTime 2.0

@interface PCSingleRequestLocationManager() <CLLocationManagerDelegate>
{
    BOOL _maxWaitTimeReached;
    BOOL _minWaitTimeReached;
    BOOL _locationSettledUpon;
    NSTimer *_maxWaitTimeTimer;
    NSTimer *_minWaitTimeTimer;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, copy) void (^PCSingleRequestLocationCompletion)(CLLocation *location, NSError *error);

- (void)maxWaitTimeReached;
- (void)minWaitTimeReached;
- (void)settleUponCurrentLocation;
- (void)cleanUp;

@end;

@implementation PCSingleRequestLocationManager

- (void)dealloc
{
    
}

/**
 Creates new instance of PCSingleRequestLocationManager.
 */
- (id)init
{
    self = [super init];
    if (self){
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        self.locationManager.delegate = self;
        
    }
    return self;
}

/**
 Begins requesting the users current location. Completion will be fired once all location criteria are satisified.
 */
- (void)requestCurrentLocationWithCompletion:(PCSingleRequestLocationCompletion)completion
{
    //Copy completion block for firing later
    self.PCSingleRequestLocationCompletion = completion;
    
    // Start location manager
    [self.locationManager startUpdatingLocation];
    
    // Start timers
    _maxWaitTimeTimer = [NSTimer scheduledTimerWithTimeInterval:kPCWebServiceLocationManagerMaxWaitTime target:self selector:@selector(maxWaitTimeReached) userInfo:nil repeats:NO];
    _minWaitTimeTimer = [NSTimer scheduledTimerWithTimeInterval:kPCWebServiceLocationManagerMinWaitTime target:self selector:@selector(minWaitTimeReached) userInfo:nil repeats:NO];
}

#pragma mark CLLocationManager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // Debug info
    if (kPCWebServiceLocationManagerDebug) {
        NSLog(@"PCWebServiceLocationManager: New location: %@", newLocation);
        NSLog(@"PCWebServiceLocationManager: Horizontal accuracy: %f", newLocation.horizontalAccuracy);
        NSLog(@"PCWebServiceLocationManager: Vertical accuracy: %f", newLocation.verticalAccuracy);
    }

    // If accuracy greater than 100 meters, it's probably crap
    if(newLocation.horizontalAccuracy > 100 && newLocation.verticalAccuracy > 100){
        if (kPCWebServiceLocationManagerDebug) {
            NSLog(@"PCWebServiceLocationManager: Accuracy poor, aborting...");
        }
        return;
    }
    
    // If location is older than 10 seconds, it's probably crap
    NSInteger locationTimeIntervalSinceNow = abs([newLocation.timestamp timeIntervalSinceNow]);
    if (locationTimeIntervalSinceNow > 10) {
        if (kPCWebServiceLocationManagerDebug) {
            NSLog(@"PCWebServiceLocationManager: Location old, aborting...");
        }
        return;
    }
    
    // If we haven't exceeded our min wait time, it's probably crap
    if (!_minWaitTimeReached) {
        if (kPCWebServiceLocationManagerDebug) {
            NSLog(@"PCWebServiceLocationManager: Min wait time not yet reached, aborting...");
        }
        return;
    }
    
    [self settleUponCurrentLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([_delegate respondsToSelector:@selector(singleRequestLocationManager:didFailToGetLocationWithError:)]) {
        
        if (kPCWebServiceLocationManagerDebug) {
            NSLog(@"PCWebServiceLocationManager: Did fail with error: %@", error);
        }
        
        [_delegate singleRequestLocationManager:self didFailToGetLocationWithError:error];
        
    }
    [self cleanUp];
}

#pragma mark Private helper methods

- (void)maxWaitTimeReached
{
    _maxWaitTimeReached = YES;
    _maxWaitTimeTimer = nil;
    [self settleUponCurrentLocation];
}

- (void)minWaitTimeReached
{
    _minWaitTimeReached = YES;
    _minWaitTimeTimer = nil;
}

/**
 Once all location crtiera has been met
 */
- (void)settleUponCurrentLocation
{
    // If we've already settled upon a location, don't fire again
    if (_locationSettledUpon) {
        return;
    }
    
    if (kPCWebServiceLocationManagerDebug) {
        NSLog(@"PCWebServiceLocationManager: Settling on location: %@", self.locationManager.location);
    }
    
    // Location settled upon!
    _locationSettledUpon = YES;
    
    if ([_delegate respondsToSelector:@selector(singleRequestLocationManager:didGetLocation:)]) {
        [_delegate singleRequestLocationManager:self didGetLocation:_locationManager.location];
    }
    
    [self cleanUp];
    
}

- (void)cleanUp
{
    [_maxWaitTimeTimer invalidate];
    [_minWaitTimeTimer invalidate];
    [_locationManager stopUpdatingLocation];
    
}

@end
