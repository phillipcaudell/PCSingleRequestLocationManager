//
//  PCWebServiceLocationManager.h
//  Glenigan
//
//  Created by Phillip Caudell on 23/08/2012.
//  Copyright (c) 2012 madebyphill.co.uk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define kPCWebServiceLocationManagerDebug NO
#define kPCWebServiceLocationManagerMaxWaitTime 10.0
#define kPCWebServiceLocationManagerMinWaitTime 2.0

@class PCSingleRequestLocationManager;

@protocol PCSingleRequestLocationManagerDelegate <NSObject>

@optional
- (void)singleRequestLocationManager:(PCSingleRequestLocationManager *)manager didGetLocation:(CLLocation *)location;
- (void)singleRequestLocationManager:(PCSingleRequestLocationManager *)manager didFailToGetLocationWithError:(NSError *)error;

@end

@interface PCSingleRequestLocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, assign) id <PCSingleRequestLocationManagerDelegate> delegate;

typedef void (^PCSingleRequestLocationCompletion)(CLLocation *location, NSError *error);

- (void)requestCurrentLocation;

@end
