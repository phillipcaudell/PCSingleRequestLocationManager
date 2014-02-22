//
//  PCWebServiceLocationManager.h
//  Glenigan
//
//  Created by Phillip Caudell on 23/08/2012.
//  Copyright (c) 2012 madebyphill.co.uk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;
@class PCSingleRequestLocationManager;

@interface PCSingleRequestLocationManager : NSObject

typedef void (^PCSingleRequestLocationCompletion)(CLLocation *location, NSError *error);

- (void)requestCurrentLocationWithCompletion:(PCSingleRequestLocationCompletion)completion;

@end
