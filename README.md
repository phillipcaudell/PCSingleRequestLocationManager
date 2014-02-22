# PCSingleRequestLocationManager
===
PCSingleRequestLocationManager is an alternative for CLLocationManager which only returns a single location once it meets a set number of criteria. 

## The problem
---
Many apps and web services today use current location to provide customised responses; however if you've ever used CLLocationManager to obtain a location to send to a web service you know it's not a straight forward process. Location accuracy can vary widely and you have no guarantee you won't receive another location later. This means either multiple web requests are being made or inaccurate results are being returned.

## The solution
---
I created PCSingleRequestLocationManager to act as a simple way to obtain an accurate CLLocation object of a users current location once the following criteria has been met:

1. Vertical & horizontal accuracy is less than 100m.
1. The location was generated less than 10 seconds ago.
1. We have waited a minimum amount of time (to obtain a decent reading from location manager).
1. We haven't exceeded a maximum amount of time in trying to obtain the location.

## How to use
---
* Add PCSingleRequestLocationManager.h and PCSingleRequestLocationManager.m to your Xcode project.
* Import the header file 
```#import <PCSingleRequestLocationManager.h>```
* Initialise a new instance of PCSingleRequestLocationManager.

```objc
PCSingleRequestLocationManager *manager = [PCSingleRequestLocationManager new];
    [singleRequest requestCurrentLocationWithCompletion:^(CLLocation *location, NSError *error) {
        
        if(!error){
            NSLog(@"Got current location:%@", location);
        } else {
           NSLog(@"Didn't get location:%@", error.localizedDescription);
        }
        
    }];
```