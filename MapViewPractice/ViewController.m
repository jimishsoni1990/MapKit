//
//  ViewController.m
//  MapViewPractice
//
//  Created by Jimish Soni on 12/09/16.
//  Copyright © 2016 Jimish Soni. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize locationManager, mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //1. set show user location to yes
    
    [mapView setShowsUserLocation:YES];
    
    
    // set the deleget to use the deleget methods
    mapView.delegate = self;
    
    
    
    // 1. Take user's permission
    locationManager = [[CLLocationManager alloc]init];
    
    
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
        //NSLog(@"You're allowed to use my location.");
    } else {
        [locationManager requestWhenInUseAuthorization];
        //NSLog(@"Get the hell out of here!");
    }
    
    UILongPressGestureRecognizer * longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longpressToGetLocation:)];
    
    longPressGestureRecognizer.minimumPressDuration = 0.5;
    longPressGestureRecognizer.delegate = self;
    [mapView addGestureRecognizer:longPressGestureRecognizer];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)zoomIn:(id)sender {
    
    MKUserLocation * userLocation  = mapView.userLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 20000, 20000);
    [mapView setRegion:region];
    
}

- (IBAction)changeMapType:(id)sender{
    
    if(mapView.mapType == MKMapTypeStandard){
        mapView.mapType = MKMapTypeHybrid;
    } else {
        mapView.mapType = MKMapTypeStandard;
    }
    
}

- (IBAction)performLocalSearch:(id)sender {
    
    //1. Hide Keyboard
    [sender resignFirstResponder];
    
    //2. Remove any previous anotations
    //[mapView removeAnnotation:[mapView annotations]];
    
    // 3. perfrom Search
    [self performSearch];
    
    
}

-(void) performSearch{
    
    // 1. get the textField's text
    NSString * searchQuery = self.searchTextField.text;
    
    // 2. Make MKLocalSearchRequest
    MKLocalSearchRequest * request = [[MKLocalSearchRequest alloc]init];
    
    // 2.1 it Request requires two parameters, Natural Language query and region for search
    request.naturalLanguageQuery = searchQuery;
    request.region = mapView.region;
    
    //3. Make MKLocalSearch now.
    MKLocalSearch * search = [[MKLocalSearch alloc] initWithRequest:request];
    
    //3.1 Define mutable array to store result
    self.searchResult = [[NSMutableArray alloc] init];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError * error){
        
        if(response.mapItems.count == 0){
            
            NSLog(@"No results found!");
            
        } else {
            for (MKMapItem * mapItem in response.mapItems){
                
                [self.searchResult addObject:mapItem];
                
                MKPointAnnotation * annotation = [[MKPointAnnotation alloc] init];
                annotation.coordinate = mapItem.placemark.coordinate;
                annotation.title = mapItem.name;
                CLPlacemark *address = [[CLPlacemark alloc]initWithPlacemark:mapItem.placemark];
                NSDictionary * storeAddress =  address.addressDictionary;
                annotation.subtitle = [storeAddress valueForKey:@"Street"];
                NSLog(@"%@", storeAddress);
                
                [mapView addAnnotation:annotation];
            }
        }
        
    }];
    
}

- (void)longpressToGetLocation:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:mapView];
    CLLocationCoordinate2D location =
    [mapView convertPoint:touchPoint toCoordinateFromView:mapView];
    
    NSLog(@"Location found from Map: %f %f",location.latitude,location.longitude);
    
    MKPointAnnotation * annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = location;
    [mapView addAnnotation:annotation];
    
}

#pragma - MapView Deleget Methods

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    self.mapView.centerCoordinate = userLocation.location.coordinate;
}

@end
