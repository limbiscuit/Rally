//
//  MapViewController.m
//  Rally
//
//  Created by Brian Lim on 11/30/15.
//  Copyright (c) 2015 Brian Lim. All rights reserved.
//

#import "MapViewController.h"
#import "FavoritesAnnotation.h"
#import "RallyPointsModel.h"

@interface MapViewController () <CLLocationManagerDelegate>

@property (strong, nonatomic) RallyPointsModel *model;
@property (nonatomic, retain) CLLocation *currentLocation;
@property NSString *latitudeString;
@property NSString *longitudeString;

@end

@implementation MapViewController

- (void)viewDidLoad {
    
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"Documents Directory: %@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
#endif
    
    [super viewDidLoad];
    
    // Change color of navigation bar and text
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(21/255.0) green:(176/255.0) blue:(191/255.0) alpha:(1)];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    
    // Use singleton
    _model = [RallyPointsModel sharedModel];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.mapView removeAnnotations: self.mapView.annotations]; // Remove old annotations of favorite locations to refresh
    
    self.mapView.showsUserLocation = YES;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    [[self locationManager] requestWhenInUseAuthorization];  // App requests to use user's location
    self.locationManager.desiredAccuracy =kCLLocationAccuracyBest;
    [[self locationManager] startUpdatingLocation]; // Begin tracking location
    
    //Annotations
    if ([self.model numberOfFavorites] > 0) {  // If favorites are present, then add annotations for each onto mapView
        
        NSMutableArray *myFavoriteLocations = [[NSMutableArray alloc] init]; // Create array to hold annotations for favorite locations
        
        for (NSUInteger i = 0; i < [self.model numberOfFavorites]; i++) {  // Iterate through array of favorites and get their coordinates
            NSDictionary *favorite = [self.model favoriteAtIndex: i];
            CLLocationCoordinate2D favoriteLocation;
            favoriteLocation.latitude = [favorite[kLatitude] doubleValue];
            favoriteLocation.longitude = [favorite[kLongitude] doubleValue];
            
            FavoritesAnnotation * myAnnotation = [FavoritesAnnotation alloc];  // Allocate custom annotation for each favorite
            myAnnotation.coordinate = favoriteLocation;
            myAnnotation.title = favorite[kName];
            
            [myFavoriteLocations addObject:myAnnotation];  // Add current annotation to annotation array
        }
        
        [self.mapView addAnnotations:myFavoriteLocations]; // Show annotations on mapView
    }
    
}


- (void) viewDidDisappear:(BOOL)animated { // Stop tracking location once user leaves the map tab
    [super viewDidDisappear:animated];
    [[self locationManager] stopUpdatingLocation];
    self.mapView.showsUserLocation = NO;
}



- (void) locationManager:(CLLocationManager *)manager
      didUpdateLocations:(NSArray *)locations {
    
    if (locations.lastObject != nil){  // Set current location if valid
        self.currentLocation = locations.lastObject;
    }
    
    // Format strings for current location
    self.latitudeString = [NSString stringWithFormat:@"%g\u00B0", self.currentLocation.coordinate.latitude];
    self.longitudeString = [NSString stringWithFormat:@"%g\u00B0", self.currentLocation.coordinate.longitude];
    
    // Set mapView to zoom in to a 1000m x 1000m area centered on current location
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.currentLocation.coordinate, 1000, 1000);
    [[self mapView] setRegion:viewRegion animated:YES];
    
    
}

- (void) locationManager: (CLLocationManager *)manager
        didFailWithError:(NSError *)error {
    
    // Display error alert if location cannot be obtained
    NSString *errorType = nil;
    if (error.code == kCLErrorDenied) {
        errorType = @"Access Denied";
    }
    else {
        errorType = @"Unknown Error";
    }
    
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error Getting Location"
                               message:errorType
                               delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
    [errorAlert show];
}

- (IBAction)setRallyButtonTouched:(id)sender {
    
    // Create action sheet to confirm setting of current location as rally point or as favorite
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Set Rally Point"
                                                                             message:@"Are you sure you want to set your rally point to your current location?"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action)
                                                        {
                                                             NSLog(@"Cancel tapped");
                                                         }];
    
    UIAlertAction *setAction = [UIAlertAction actionWithTitle:@"Set Only"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action)
                                                    {
                                                        NSLog(@"Set only tapped");
                                                        // Set rally point
                                                        [self.model setRallyPoint: self.latitudeString longitude:self.longitudeString];
                                                        NSLog(@"Rally point set to %@,%@", self.latitudeString, self.longitudeString);
                                                     }];
    UIAlertAction *setAndFavAction = [UIAlertAction actionWithTitle:@"Set and Add Favorite"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action)
                                {
                                    NSLog(@"Set and add tapped");
                                    
                                    // Set rally point
                                    [self.model setRallyPoint: self.latitudeString longitude:self.longitudeString];
                                    NSLog(@"Rally point set to %@,%@", self.latitudeString, self.longitudeString);
                                    
                                    // Create text field alert to get name of new favorite location
                                    UIAlertController *favoriteAlert = [UIAlertController alertControllerWithTitle:@"Add Favorite" message:@"Name this new favorite location!" preferredStyle:UIAlertControllerStyleAlert];
                                    
                                    [favoriteAlert addTextFieldWithConfigurationHandler:^(UITextField *textField)
                                     {
                                         textField.placeholder = @"Name";
                                         textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
                                     }];
                                    
                                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                                           style:UIAlertActionStyleCancel
                                                                                         handler:^(UIAlertAction *action)
                                                                   {
                                                                       NSLog(@"Cancel tapped");
                                                                   }];
                                    
                                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                                                        style:UIAlertActionStyleDefault
                                                                                      handler:^(UIAlertAction *action)
                                                                {
                                                                    
                                                                    // Obtain user-supplied name
                                                                    UITextField *textInput = favoriteAlert.textFields.lastObject;
                                                                    NSString *name = textInput.text;
                                                                    NSLog(@"%f, %f",self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude);
                                                                    
                                                                    // Add current location as new favorite with the user-supplied name
                                                                    NSDictionary *newFav =[[NSDictionary alloc] initWithObjectsAndKeys:name, kName, [NSNumber numberWithDouble: self.currentLocation.coordinate.latitude], kLatitude, [NSNumber numberWithDouble: self.currentLocation.coordinate.longitude], kLongitude, nil];
                                                                    
                                                                    [self.model insertFavorite: newFav]; // Add to favorites array
                                                                    
                                                                    // Get coordinates to create annotation
                                                                    CLLocationCoordinate2D newFavLocation;
                                                                    newFavLocation.latitude = [newFav[kLatitude] doubleValue];
                                                                    newFavLocation.longitude = [newFav[kLongitude] doubleValue];
                                                                    
                                                                    // Add new favorite's annotation to mapView
                                                                    FavoritesAnnotation* myAnnotation = [FavoritesAnnotation alloc];
                                                                    myAnnotation.coordinate = newFavLocation;
                                                                    myAnnotation.title = newFav[kName];
                                                                    [self.mapView addAnnotation: myAnnotation];
                                                                }];
                                    
                                    // Add options to text field alert
                                    [favoriteAlert addAction:cancelAction];
                                    [favoriteAlert addAction:okAction];
                                    [self presentViewController:favoriteAlert animated:YES completion:nil];
                                    
                                }];
    
    // Add options to action sheet
    [actionSheet addAction:cancelAction];
    [actionSheet addAction:setAction];
    [actionSheet addAction:setAndFavAction];
    [self presentViewController:actionSheet animated:YES completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
