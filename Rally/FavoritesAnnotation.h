//
//  FavoritesAnnotation.h
//  Rally
//
//  Created by Brian Lim on 11/30/15.
//  Copyright (c) 2015 Brian Lim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FavoritesAnnotation : NSObject <MKAnnotation>

// Properties following the MKAnnotation protocol
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
