//
//  ViewController.h
//  MapViewPractice
//
//  Created by Jimish Soni on 12/09/16.
//  Copyright © 2016 Jimish Soni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<MKMapViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSMutableArray * searchResult;
@property (strong, nonatomic) CLLocationManager * locationManager;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;

- (IBAction)zoomIn:(id)sender;
- (IBAction)changeMapType:(id)sender;
- (IBAction)performLocalSearch:(id)sender;


@end

