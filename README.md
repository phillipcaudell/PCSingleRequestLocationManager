# PCSingleRequestLocationManager
===
PCSingleRequestLocationManager is an alternative for CLLocationManager which only returns a single location once it meets a set number of criteria. 

## The problem
---
Many apps and webservices today use current location to provide customised responses; however if you've ever used CLLocationManager to obtain a location to send to a webservice you know it's not a straight forward process. Location accuracy can vary widely and you have no guarentee you won't revieve another location later. This means either multiple web requests are being made or inaccurate results are being returned.

## The solution
---
I created PCSingleRequestLocationManager to act as a simple way to obtain an accurate CLLocation object of a users current location once the following criteria has been met:

1. Vertical & horizintonol accuracy is less than 100m.
1. The location was generated less than 10 seconds a go.
1. We have waited a minimum amount of time (to obtain a decent reading from location manager).
1. We haven't exceeded a maxium ammount of time.

## How to use
---
* Add PCSingleRequestLocationManager.h and PCSingleRequestLocationManager.m to your Xcode project.
* Import the header file 
```objc
	#import <PCSingleRequestLocationManager.h>
```
* Initilise a new instance of PCSingleRequestLocationManager.

```objc
PCSingleRequestLocationManager *manager = [[PCSingleRequestLocationManager alloc] init];
[manager setDelegate:self];
[manager requestCurrentLocation];
[manager release];
```

* Implement the PCSingleRequestLocationManagerDelegate protocol.

```objc
- (void)singleRequestLocationManager:(PCSingleRequestLocationManager *)manager didGetLocation:(CLLocation *)location
{
	NSLog(@"Do stuff with the location: %@", location);
}
```

```objc
- (void)singleRequestLocationManager:(PCSingleRequestLocationManager *)manager didFailToGetLocationWithError:(NSError *)error
{
    NSLog(@"Something went wrong with the location: %@", error);
}
```