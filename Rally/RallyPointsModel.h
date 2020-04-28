//
//  RallyPointsModel.h
//  Rally
//
//  Created by Brian Lim on 11/30/15.
//  Copyright (c) 2015 Brian Lim. All rights reserved.
//

#import <Foundation/Foundation.h>

// Key names for dictionary
static NSString * const kName = @"name";
static NSString * const kLatitude = @"latitude";
static NSString * const kLongitude = @"longitude";

@interface RallyPointsModel : NSObject

+ (instancetype) sharedModel;
- (void) setRallyPoint: (NSString *) latitude
             longitude: (NSString *) longitude;
- (NSString *) getRallyLatitude;
- (NSString *) getRallyLongitude;
- (NSUInteger) numberOfFavorites;
- (NSDictionary *) favoriteAtIndex: (NSUInteger) index;
- (void) insertFavorite: (NSDictionary *) rallyPoint;
- (void) removeFavoriteAtIndex: (NSUInteger) index;

@end
