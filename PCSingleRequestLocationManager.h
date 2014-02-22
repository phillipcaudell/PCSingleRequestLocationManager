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

@interface PCSingleRequestLocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, retain) CLLocationManager *locationManager;

typedef void (^PCSingleRequestLocationCompletion)(CLLocation *location, NSError *error);

- (void)requestCurrentLocationWithCompletion:(PCSingleRequestLocationCompletion)completion;

@end
