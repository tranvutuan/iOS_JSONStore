//
//  BusinessLocationViewController.m
//  Discovery
//
//  Created by VuTuan Tran on 2014-10-07.
//  Copyright (c) 2014 com.tnamobilesolutions. All rights reserved.
//

#import "BusinessLocationViewController.h"

@interface BusinessLocationViewController ()

@end

@implementation BusinessLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self displayMap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)displayMap {
    [self.mapView removeAnnotation:[self.mapView.annotations lastObject]];
    
    MKCoordinateRegion region;
    region.center.latitude = self.lattitude;
    region.center.longitude = self.longitude;
    region.span.latitudeDelta = .005f;
    region.span.longitudeDelta = .005f;

    MKPointAnnotation *mkAnnotation = [[MKPointAnnotation alloc]init];
    mkAnnotation.title = self.location;
    
    mkAnnotation.coordinate = CLLocationCoordinate2DMake(region.center.latitude,region.center.longitude);
    
    [self.mapView addAnnotation:mkAnnotation];
    [self.mapView setRegion:region animated:YES];
    [self.mapView selectAnnotation:[[self.mapView annotations] lastObject] animated:YES];

}

@end
