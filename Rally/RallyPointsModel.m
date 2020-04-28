//
//  RallyPointsModel.m
//  Rally
//
//  Created by Brian Lim on 11/30/15.
//  Copyright (c) 2015 Brian Lim. All rights reserved.
//

#import "RallyPointsModel.h"

@interface RallyPointsModel ()

@property (strong, nonatomic) NSString *rallyLatitude;
@property (strong, nonatomic) NSString *rallyLongitude;
@property (strong, nonatomic) NSMutableArray *favorites;
@property (strong, nonatomic) NSString *filepath;

@end

@implementation RallyPointsModel

+ (instancetype) sharedModel {
    // Initialize and return singleton
    static RallyPointsModel *_sharedModel = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // Enable data persistence
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        _filepath = [documentsDirectory stringByAppendingPathComponent: @"Favorites.plist"];
        _favorites = [NSMutableArray arrayWithContentsOfFile:_filepath];
        
        // Initial values for favorites array if not already created
        
        if (!_favorites) {
            
            NSDictionary *favorite1 = [[NSDictionary alloc] initWithObjectsAndKeys: @"Pizza", kName, [NSNumber numberWithDouble:37.790714], kLatitude, [NSNumber numberWithDouble:-122.409010], kLongitude, nil];
            NSDictionary *favorite2 = [[NSDictionary alloc] initWithObjectsAndKeys: @"Coffee", kName, [NSNumber numberWithDouble:37.789310], kLatitude, [NSNumber numberWithDouble:-122.406764], kLongitude, nil];
            NSDictionary *favorite3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Home", kName, [NSNumber numberWithDouble: 37.791348], kLatitude, [NSNumber numberWithDouble:-122.409374], kLongitude, nil];
            NSDictionary *favorite4 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Church", kName, [NSNumber numberWithDouble: 37.792925], kLatitude, [NSNumber numberWithDouble: -122.405479], kLongitude, nil];
            NSDictionary *favorite5 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Hotel", kName, [NSNumber numberWithDouble: 37.785800], kLatitude, [NSNumber numberWithDouble: -122.408701], kLongitude, nil];
            _favorites = [[NSMutableArray alloc] initWithObjects: favorite1, favorite2, favorite3, favorite4, favorite5, nil];
        }
        
        [self save];
    }
    
    return self;
}

- (void) save {  // Write edited favorites to file for data persistence
    [self.favorites writeToFile: self.filepath atomically: YES];
}

- (void) setRallyPoint: (NSString *) latitude
             longitude: (NSString *) longitude { // Set rally point using the supplied coordinate
    
    self.rallyLatitude = latitude;
    self.rallyLongitude = longitude;
}

- (NSString *) getRallyLatitude {  // Return latitude coordinate of rally point
    return self.rallyLatitude;
}

- (NSString *) getRallyLongitude {  // Return longitude coordinate of rally point
    return self.rallyLongitude;
}

- (NSUInteger) numberOfFavorites { // Return number of favorite locations saved in array
    return [self.favorites count];
}

- (NSDictionary *) favoriteAtIndex: (NSUInteger) index { // Return favorite location at specified index in array
    return self.favorites[index];
}

- (void) insertFavorite: (NSDictionary *) rallyPoint {  // Insert a favorite location into favorites array
    [self.favorites addObject: rallyPoint];
    [self save];  // Save updated favorites array
}

- (void) removeFavoriteAtIndex: (NSUInteger) index {  // Delete favorite location from favorites array
    if (index <= [self numberOfFavorites]) {
        [self.favorites removeObjectAtIndex:index];
    }
    [self save];  // Save updated favorites array
}
@end
