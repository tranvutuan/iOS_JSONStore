//
//  BusinessLocationViewController.h
//  Discovery
//
//  Created by VuTuan Tran on 2014-10-07.
//  Copyright (c) 2014 com.tnamobilesolutions. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@interface BusinessLocationViewController : UIViewController
@property(assign) double lattitude;
@property(assign) double longitude;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSString *location;
@end
